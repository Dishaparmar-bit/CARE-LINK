package com.carelink.servlet; // Apne actual package name se replace karein

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

// Wapas javax imports par switch kiya
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.carelink.db.DBConnection; 

@WebServlet("/FeedServlet")
public class FeedServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
  
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp?error=session_expired");
            return;
        }

        int ngoUserId = (int) session.getAttribute("userId");

        String content = request.getParameter("content");
        String urgency = request.getParameter("urgency");

        if (content == null || content.trim().isEmpty() || urgency == null || urgency.trim().isEmpty()) {
            response.sendRedirect("NGODashboardServlet?error=invalid_feed_data");
            return;
        }


        urgency = urgency.trim().toLowerCase();
        if (!urgency.equals("low") && !urgency.equals("medium") && !urgency.equals("high")) {
            urgency = "high"; // Fallback for critical/other values
        }

        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBConnection.getConnection();
            
            String query = "INSERT INTO feed_posts (ngo_user_id, content, urgency) VALUES (?, ?, ?)";
            ps = con.prepareStatement(query);
            ps.setInt(1, ngoUserId);
            ps.setString(2, content.trim());
            ps.setString(3, urgency);

            int result = ps.executeUpdate();

            if (result > 0) {
                response.sendRedirect("NGODashboardServlet?success=feed_posted");
            } else {
                response.sendRedirect("NGODashboardServlet?error=feed_failed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("NGODashboardServlet?error=db_exception");
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendRedirect("NGODashboardServlet");
    }
}