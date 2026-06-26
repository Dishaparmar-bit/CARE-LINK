package com.carelink.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.carelink.db.DBConnection;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps =
                    con.prepareStatement(
                            "SELECT * FROM users WHERE email=? AND password=?"
                    );

            ps.setString(1, email);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                int userId = rs.getInt("id");
                String role = rs.getString("role");
                String userName = rs.getString("full_name");
                String userEmail = rs.getString("email");

               
                HttpSession session = request.getSession();
                session.setAttribute("userId", userId);
                session.setAttribute("userName", userName);
                session.setAttribute("email", userEmail);
                session.setAttribute("role", role);

                if ("ngo".equalsIgnoreCase(role)) {
                    String statusQuery = "SELECT * FROM ngo_details WHERE user_id = ?";
                    try (PreparedStatement psStatus = con.prepareStatement(statusQuery)) {
                        psStatus.setInt(1, userId);
                        try (ResultSet rsStatus = psStatus.executeQuery()) {
                            if (rsStatus.next()) {
                                String status = rsStatus.getString("status");
                                
                                if ("pending".equalsIgnoreCase(status)) {
                                    response.sendRedirect("login.jsp?error=pending_approval");
                                    return;
                                }
                                
                                session.setAttribute("orgName", rsStatus.getString("org_name"));
                                session.setAttribute("regNumber", rsStatus.getString("registration_number"));
                                session.setAttribute("ngoStatus", status); // 'approved'
                                
                            } else {
                                response.sendRedirect("login.jsp?error=pending_approval");
                                return;
                            }
                        }
                    }
                }

                // --- Redirection Logic Base System ---
                if ("ngo".equalsIgnoreCase(role)) {
                    response.sendRedirect("NGODashboardServlet");
                }
                else if ("volunteer".equalsIgnoreCase(role)) {
                    response.sendRedirect("VolunteerDashboardServlet");
                }
                else if ("donor".equalsIgnoreCase(role)) {
                    response.sendRedirect("donorDashboard.jsp");
                }
                else if ("admin".equalsIgnoreCase(role)) {
                    response.sendRedirect("adminDashboard.jsp");
                }
                else {
                    response.sendRedirect("login.jsp?error=invalid_role");
                }
            } else {
         
                response.sendRedirect("login.jsp?error=invalid");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp?error=server");
        }
    }
}