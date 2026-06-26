package com.carelink.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.carelink.db.DBConnection;

@WebServlet("/ResetPasswordServlet")
public class ResetPasswordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || password == null || email.trim().isEmpty() || password.trim().isEmpty()) {
            response.sendRedirect("resetPassword.jsp?status=invalid&email=" + email);
            return;
        }

        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBConnection.getConnection();
           String query = "UPDATE users SET password = ? WHERE email = ?"; 
            
            ps = con.prepareStatement(query);
            ps.setString(1, password); 
            ps.setString(2, email.trim());

            int rowsUpdated = ps.executeUpdate();

            if (rowsUpdated > 0) {
                response.sendRedirect("resetPassword.jsp?status=synchronized&email=" + email);
            } else {
                response.sendRedirect("resetPassword.jsp?status=notfound&email=" + email);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("resetPassword.jsp?status=error&email=" + email);
        } finally {
        	
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }
}