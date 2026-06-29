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

import com.carelink.db.DBConnection;
import com.carelink.util.PasswordUtil; 
@WebServlet("/ResetPasswordServlet")
public class ResetPasswordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String email    = request.getParameter("email");
        String token    = request.getParameter("token"); 
        String password = request.getParameter("password");

        if (email == null || password == null || token == null
                || email.trim().isEmpty() || password.trim().isEmpty()) {
            response.sendRedirect("resetPassword.jsp?status=invalid&email=" + email);
            return;
        }

        try (Connection con = DBConnection.getConnection()) {

            boolean tokenValid = false;
            try (PreparedStatement psCheck = con.prepareStatement(
                    "SELECT id FROM otp_verifications WHERE email=? AND otp=? AND is_used=0 AND expires_at > NOW()")) {
                psCheck.setString(1, email.trim());
                psCheck.setString(2, token.trim());
                try (ResultSet rs = psCheck.executeQuery()) {
                    if (rs.next()) {
                        tokenValid = true;
                        int otpId = rs.getInt("id");
                        try (PreparedStatement psUsed = con.prepareStatement(
                                "UPDATE otp_verifications SET is_used=1 WHERE id=?")) {
                            psUsed.setInt(1, otpId);
                            psUsed.executeUpdate();
                        }
                    }
                }
            }

            if (!tokenValid) {
                response.sendRedirect("resetPassword.jsp?status=expired&email=" + email);
                return;
            }

            String hashedPassword = PasswordUtil.hash(password);

            try (PreparedStatement ps = con.prepareStatement(
                    "UPDATE users SET password = ? WHERE email = ?")) {
                ps.setString(1, hashedPassword);
                ps.setString(2, email.trim());
                int rowsUpdated = ps.executeUpdate();

                if (rowsUpdated > 0) {
                    response.sendRedirect("resetPassword.jsp?status=synchronized&email=" + email);
                } else {
                    response.sendRedirect("resetPassword.jsp?status=notfound&email=" + email);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("resetPassword.jsp?status=error&email=" + email);
        }
    }
}