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
import com.carelink.util.EmailUtil;


@WebServlet("/ApproveNGOServlet")
public class ApproveNGOServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String idStr = request.getParameter("id");
        String email = request.getParameter("email");
        String ngoName = request.getParameter("ngoName");

        if (idStr == null) {
            response.sendRedirect("adminDashboard.jsp?status=failed");
            return;
        }

        int id = Integer.parseInt(idStr);

        try (Connection con = DBConnection.getConnection()) {
           
            String sql = "UPDATE ngo_details SET status = 'Approved' WHERE id = ?";
            
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, id);
                int updated = ps.executeUpdate();
                
                if (updated > 0) {
            
                    try {
                        EmailUtil.sendWelcomeEmail(email, ngoName, "ngo"); 
                    } catch (Exception ex) {
                        System.out.println("[EMAIL WARNING] Email server unreachable, skipping message send but keeping state approved.");
                        ex.printStackTrace();
                    }
                    response.sendRedirect("adminDashboard.jsp?status=approved");
                } else {
                    response.sendRedirect("adminDashboard.jsp?status=failed");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("adminDashboard.jsp?status=failed");
        }
    }
}