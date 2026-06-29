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

@WebServlet("/RejectNGOServlet")
public class RejectNGOServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");

        if (idStr == null) {
            response.sendRedirect("adminDashboard.jsp?status=failed");
            return;
        }

   
        int id;
        try {
            id = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            response.sendRedirect("adminDashboard.jsp?status=failed");
            return;
        }

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                     "UPDATE ngo_details SET status = 'Rejected' WHERE id = ?")) {
            ps.setInt(1, id);
            int updated = ps.executeUpdate();

            if (updated > 0) {
       
                response.sendRedirect("adminDashboard.jsp?status=rejected");
            } else {
                response.sendRedirect("adminDashboard.jsp?status=failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("adminDashboard.jsp?status=failed");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
    }
}