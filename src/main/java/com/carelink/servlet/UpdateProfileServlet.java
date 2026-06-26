package com.carelink.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.carelink.db.DBConnection;

@WebServlet("/UpdateProfileServlet")
public class UpdateProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp?msg=session_expired");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        String role = (String) session.getAttribute("role");
        
        // Universal form fields
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String city = request.getParameter("city");

        try (Connection con = DBConnection.getConnection()) {
            con.setAutoCommit(false); // Transaction validation safety lock

            // 1. Update Core 'users' table elements
            String updateUsersSql = "UPDATE users SET full_name = ?, phone = ?, city = ? WHERE id = ?";
            try (PreparedStatement psUser = con.prepareStatement(updateUsersSql)) {
                psUser.setString(1, fullName);
                psUser.setString(2, phone);
                psUser.setString(3, city);
                psUser.setInt(4, userId);
                psUser.executeUpdate();
            }

            // 2. Role-specific structural extensions updates
            if ("ngo".equalsIgnoreCase(role)) {
                String orgName = request.getParameter("orgName");
                String updateNgoSql = "UPDATE ngo_details SET org_name = ? WHERE user_id = ?";
                try (PreparedStatement psNgo = con.prepareStatement(updateNgoSql)) {
                    psNgo.setString(1, orgName);
                    psNgo.setInt(2, userId);
                    psNgo.executeUpdate();
                }
                session.setAttribute("userName", orgName); 
            } else {
                session.setAttribute("userName", fullName); 
            }

            con.commit();
            
            // Redirect back to respective dashboard with success token node
            if ("admin".equalsIgnoreCase(role)) {
                response.sendRedirect("adminDashboard.jsp?profile=updated");
            } else if ("ngo".equalsIgnoreCase(role)) {
                response.sendRedirect("ngoDashboard.jsp?profile=updated");
            } else if ("donor".equalsIgnoreCase(role)) {
                response.sendRedirect("donorDashboard.jsp?profile=updated");
            } else {
                response.sendRedirect("VolunteerDashboardServlet?profile=updated");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp?error=profile_failed");
        }
    }
}