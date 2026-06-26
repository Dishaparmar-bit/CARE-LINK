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
import com.carelink.util.EmailUtil;

@WebServlet("/JoinCampaignServlet")
public class JoinCampaignServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Session check to get current Volunteer's User ID
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp?msg=session_expired");
            return;
        }

        int volunteerUserId = (int) session.getAttribute("userId");
        int campaignId = Integer.parseInt(request.getParameter("campaignId"));

        String volunteerEmail = "";
        String campaignTitle = "";
        String ngoEmail = "";
        String ngoName = "";
        
        try (Connection con = DBConnection.getConnection()) {
            
            // Duplicate apply check
            String checkQuery = "SELECT id FROM campaign_requests WHERE campaign_id = ? AND volunteer_user_id = ?";
            try (PreparedStatement psCheck = con.prepareStatement(checkQuery)) {
                psCheck.setInt(1, campaignId);
                psCheck.setInt(2, volunteerUserId);
                try (ResultSet rsCheck = psCheck.executeQuery()) {
                    if (rsCheck.next()) {
                        response.sendRedirect("VolunteerDashboardServlet?error=already_applied");
                        return;
                    }
                }
            }

            String fetchQuery = "SELECT c.title, u.email AS ngo_email, n.org_name " +
                                "FROM campaigns c " +
                                "JOIN users u ON c.ngo_user_id = u.id " +
                                "JOIN ngo_details n ON u.id = n.user_id " +
                                "WHERE c.id = ?";
            try (PreparedStatement psFetch = con.prepareStatement(fetchQuery)) {
                psFetch.setInt(1, campaignId);
                try (ResultSet rsFetch = psFetch.executeQuery()) {
                    if (rsFetch.next()) {
                        volunteerEmail = (String) session.getAttribute("email");
                        campaignTitle = rsFetch.getString("title");
                        ngoEmail = rsFetch.getString("ngo_email");
                        ngoName = rsFetch.getString("org_name");
                    }
                }
            }

            // Insert application
            String query = "INSERT INTO campaign_requests (campaign_id, volunteer_user_id, status, requested_at) VALUES (?, ?, 'pending', NOW())";
            try (PreparedStatement ps = con.prepareStatement(query)) {
                ps.setInt(1, campaignId);
                ps.setInt(2, volunteerUserId);
                ps.executeUpdate();
            }
            
            // Dual Email Notification Pipeline
            if (volunteerEmail != null && !volunteerEmail.isEmpty() && campaignTitle != null && !campaignTitle.isEmpty()) {
                // 1. Sends receipt to the Volunteer
                EmailUtil.sendApplicationReceipt(volunteerEmail, campaignTitle);
                
                // Sends real-time application alert directly to the Organizing NGO
                if (ngoEmail != null && !ngoEmail.isEmpty()) {
                    String currentVolunteerName = (String) session.getAttribute("userName");
                    EmailUtil.sendNGOVolunteerApplyAlert(ngoEmail, ngoName, (currentVolunteerName != null ? currentVolunteerName : "A Volunteer"), campaignTitle);
                }
            }
            
            response.sendRedirect("VolunteerDashboardServlet?success=applied");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("VolunteerDashboardServlet?error=failed");
        }
    }
}