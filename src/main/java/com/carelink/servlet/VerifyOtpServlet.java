package com.carelink.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;

import com.carelink.db.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/VerifyOtpServlet")
public class VerifyOtpServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String otp = request.getParameter("otp");

        try {

            Connection con = DBConnection.getConnection();

            PreparedStatement ps =
                    con.prepareStatement(
                            "SELECT * FROM otp_verifications WHERE email=? AND otp=? AND is_used=0");

            ps.setString(1, email);
            ps.setString(2, otp);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                Timestamp expiry = rs.getTimestamp("expires_at");

                if (expiry.after(new Timestamp(System.currentTimeMillis()))) {

                    PreparedStatement update =
                            con.prepareStatement(
                                    "UPDATE otp_verifications SET is_used=1 WHERE id=?");

                    update.setInt(1, rs.getInt("id"));
                    update.executeUpdate();

                    response.getWriter().print("VERIFIED");

                } else {

                    response.getWriter().print("EXPIRED");
                }

            } else {

                response.getWriter().print("INVALID");
            }

        } catch (Exception e) {

            e.printStackTrace();
            response.getWriter().print("ERROR");
        }
    }
}