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
import com.carelink.util.PasswordUtil; 

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String email    = request.getParameter("email");
        String password = request.getParameter("password");

        // FIX: Basic null check
        if (email == null || password == null
                || email.trim().isEmpty() || password.trim().isEmpty()) {
            response.sendRedirect("login.jsp?error=invalid");
            return;
        }

        try (Connection con = DBConnection.getConnection()) {

            PreparedStatement ps = con.prepareStatement(
                "SELECT id, full_name, email, password, role FROM users WHERE email=?"
            );
            ps.setString(1, email.trim());
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String storedHash = rs.getString("password");

            
                if (!PasswordUtil.verify(password, storedHash)) {
                    response.sendRedirect("login.jsp?error=invalid");
                    return;
                }

                int    userId    = rs.getInt("id");
                String role      = rs.getString("role");
                String userName  = rs.getString("full_name");
                String userEmail = rs.getString("email");

                HttpSession session = request.getSession();
                session.setAttribute("userId",   userId);
                session.setAttribute("userName", userName);
                session.setAttribute("email",    userEmail);
                session.setAttribute("role",     role);

                if ("ngo".equalsIgnoreCase(role)) {
                    try (PreparedStatement psStatus = con.prepareStatement(
                            "SELECT * FROM ngo_details WHERE user_id = ?")) {
                        psStatus.setInt(1, userId);
                        try (ResultSet rsStatus = psStatus.executeQuery()) {
                            if (rsStatus.next()) {
                                String status = rsStatus.getString("status");
                                if ("pending".equalsIgnoreCase(status)) {
                                    session.invalidate();
                                    response.sendRedirect("login.jsp?error=pending_approval");
                                    return;
                                }
                                session.setAttribute("orgName",    rsStatus.getString("org_name"));
                                session.setAttribute("regNumber",  rsStatus.getString("registration_number"));
                                session.setAttribute("ngoStatus",  status);
                            } else {
                                session.invalidate();
                                response.sendRedirect("login.jsp?error=pending_approval");
                                return;
                            }
                        }
                    }
                }

                if ("ngo".equalsIgnoreCase(role)) {
                    response.sendRedirect("NGODashboardServlet");
                } else if ("volunteer".equalsIgnoreCase(role)) {
                    response.sendRedirect("VolunteerDashboardServlet");
                } else if ("donor".equalsIgnoreCase(role)) {
                    response.sendRedirect("donorDashboard.jsp");
                } else if ("admin".equalsIgnoreCase(role)) {
                    response.sendRedirect("adminDashboard.jsp");
                } else {
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