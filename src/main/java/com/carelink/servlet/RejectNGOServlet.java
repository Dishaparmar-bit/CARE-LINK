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
import com.carelink.util.EmailUtil;

@WebServlet("/RejectNGOServlet")
public class RejectNGOServlet extends HttpServlet {

private static final long serialVersionUID = 1L;

protected void doGet(HttpServletRequest request,
                     HttpServletResponse response)
        throws ServletException, IOException {

    int ngoId = Integer.parseInt(
            request.getParameter("id")
    );

    try {

        Connection con =
                DBConnection.getConnection();

        PreparedStatement ps =
                con.prepareStatement(
                        "UPDATE ngo_details SET status='rejected' WHERE id=?"
                );

        ps.setInt(1, ngoId);

        ps.executeUpdate();

        PreparedStatement emailPs =
                con.prepareStatement(
                        "SELECT u.email, nd.org_name " +
                        "FROM ngo_details nd " +
                        "JOIN users u ON nd.user_id=u.id " +
                        "WHERE nd.id=?"
                );

        emailPs.setInt(1, ngoId);

        ResultSet rs =
                emailPs.executeQuery();

        if(rs.next()) {

            String email =
                    rs.getString("email");

            String ngoName =
                    rs.getString("org_name");

            EmailUtil.sendNGORejectionEmail(
                    email,
                    ngoName
            );
        }

        response.sendRedirect(
                "adminDashboard.jsp?page=ngo-approvals&success=rejected"
        );

    } catch(Exception e) {

        e.printStackTrace();

        response.sendRedirect(
                "adminDashboard.jsp?page=ngo-approvals&error=true"
        );
    }
}


}
