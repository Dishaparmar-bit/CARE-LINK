package com.carelink.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.carelink.db.DBConnection;
import com.carelink.util.EmailUtil;
import com.carelink.util.OTPGenerator;

@WebServlet("/ForgotPasswordServlet")
public class ForgotPasswordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");

        if (email == null || email.trim().isEmpty()) {
            response.sendRedirect("forgotPassword.jsp?status=invalid");
            return;
        }

        email = email.trim();

        try (Connection con = DBConnection.getConnection()) {

            boolean emailExists = false;
            try (PreparedStatement psCheck = con.prepareStatement(
                    "SELECT id FROM users WHERE email = ?")) {
                psCheck.setString(1, email);
                try (ResultSet rs = psCheck.executeQuery()) {
                    emailExists = rs.next();
                }
            }

           if (emailExists) {
                String token = OTPGenerator.generateOTP(); 

                try (PreparedStatement psDel = con.prepareStatement(
                        "DELETE FROM otp_verifications WHERE email=?")) {
                    psDel.setString(1, email);
                    psDel.executeUpdate();
                }

                Timestamp expiry = new Timestamp(
                        System.currentTimeMillis() + (15 * 60 * 1000)); 

                try (PreparedStatement psIns = con.prepareStatement(
                        "INSERT INTO otp_verifications(email, otp, expires_at) VALUES(?,?,?)")) {
                    psIns.setString(1, email);
                    psIns.setString(2, token);
                    psIns.setTimestamp(3, expiry);
                    psIns.executeUpdate();
                }

                String baseUrl = request.getScheme() + "://" + request.getServerName()
                        + ":" + request.getServerPort()
                        + request.getContextPath();
                String resetLink = baseUrl + "/resetPassword.jsp?email=" + email + "&token=" + token;

                EmailUtil.sendPasswordResetEmail(email, resetLink);
            }

             response.sendRedirect("forgotPassword.jsp?status=success&target=" + email);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("forgotPassword.jsp?status=error");
        }
    }
}