package com.carelink.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.Timestamp;

import com.carelink.db.DBConnection;
import com.carelink.util.EmailUtil;
import com.carelink.util.OTPGenerator;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/SendOtpServlet")
public class SendOtpServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");

        try {

            String otp = OTPGenerator.generateOTP();

            Connection con = DBConnection.getConnection();

            PreparedStatement deleteOld =
                    con.prepareStatement(
                            "DELETE FROM otp_verifications WHERE email=?");

            deleteOld.setString(1, email);
            deleteOld.executeUpdate();

            PreparedStatement ps =
                    con.prepareStatement(
                            "INSERT INTO otp_verifications(email, otp, expires_at) VALUES(?,?,?)");

            ps.setString(1, email);
            ps.setString(2, otp);

            Timestamp expiry =
                    new Timestamp(
                            System.currentTimeMillis()
                                    + (5 * 60 * 1000));

            ps.setTimestamp(3, expiry);

            ps.executeUpdate();

            boolean sent =
                    EmailUtil.sendOTP(email, otp);

            if (sent) {

                response.getWriter().print("OTP_SENT");

            } else {

                response.getWriter().print("EMAIL_FAILED");
            }

        } catch (Exception e) {

            e.printStackTrace();

            response.getWriter().print("ERROR");
        }
    }
}