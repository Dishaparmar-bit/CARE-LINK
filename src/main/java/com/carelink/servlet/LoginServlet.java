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

            HttpSession session =
                    request.getSession();

            session.setAttribute(
                    "userId",
                    rs.getInt("id")
            );

            session.setAttribute(
                    "userName",
                    rs.getString("full_name")
            );

            session.setAttribute(
                    "email",
                    rs.getString("email")
            );

            session.setAttribute(
                    "role",
                    rs.getString("role")
            );

            String role =
                    rs.getString("role");

            if ("ngo".equalsIgnoreCase(role)) {

                response.sendRedirect(
                        "ngoDashboard.jsp"
                );

            }
            else if ("volunteer".equalsIgnoreCase(role)) {

                response.sendRedirect(
                        "volunteer.jsp"
                );

            }
            else if ("donor".equalsIgnoreCase(role)) {

                response.sendRedirect(
                        "donor.jsp"
                );

            }
            
            else if ("admin".equalsIgnoreCase(role)) {

                response.sendRedirect(
                        "adminDashboard.jsp"
                );
            }
            
            else {

                response.sendRedirect(
                        "login.jsp?error=invalid_role"
                );
            }

        } else {

            response.sendRedirect(
                    "login.jsp?error=invalid"
            );
        }

    } catch (Exception e) {

        e.printStackTrace();

        response.sendRedirect(
                "login.jsp?error=server"
        );
    }
}


}
