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
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp?msg=session_expired");
            return;
        }

        int volunteerUserId = (int) session.getAttribute("userId");

       
        int campaignId;
        try {
            campaignId = Integer.parseInt(request.getParameter("campaignId"));
        } catch (NumberFormatException e) {
            response.sendRedirect("VolunteerDashboardServlet?error=invalid_campaign");
            return;
        }

        String volunteerEmail = "";
        String campaignTitle  = "";
        String ngoEmail       = "";
        String ngoName        = "";

        try (Connection con = DBConnection.getConnection()) {

           
            try (PreparedStatement psCheck = con.prepareStatement(
                    "SELECT id FROM campaign_requests WHERE campaign_id = ? AND volunteer_user_id = ?")) {
                psCheck.setInt(1, campaignId);
                psCheck.setInt(2, volunteerUserId);
                try (ResultSet rsCheck = psCheck.executeQuery()) {
                    if (rsCheck.next()) {
                        response.sendRedirect("VolunteerDashboardServlet?error=already_applied");
                        return;
                    }
                }
            }

       
            try (PreparedStatement psFetch = con.prepareStatement(
                    "SELECT c.title, u.email AS ngo_email, n.org_name "
                    + "FROM campaigns c "
                    + "JOIN users u ON c.ngo_user_id = u.id "
                    + "JOIN ngo_details n ON u.id = n.user_id "
                    + "WHERE c.id = ?")) {
                psFetch.setInt(1, campaignId);
                try (ResultSet rsFetch = psFetch.executeQuery()) {
                    if (rsFetch.next()) {
                        volunteerEmail = (String) session.getAttribute("email");
                        campaignTitle  = rsFetch.getString("title");
                        ngoEmail       = rsFetch.getString("ngo_email");
                        ngoName        = rsFetch.getString("org_name");
                    }
                }
            }

           
            try (PreparedStatement ps = con.prepareStatement(
                    "INSERT INTO campaign_requests (campaign_id, volunteer_user_id, status, requested_at) "
                    + "VALUES (?, ?, 'pending', NOW())")) {
                ps.setInt(1, campaignId);
                ps.setInt(2, volunteerUserId);
                ps.executeUpdate();
            }

          
            if (volunteerEmail != null && !volunteerEmail.isEmpty()
                    && campaignTitle != null && !campaignTitle.isEmpty()) {
                EmailUtil.sendApplicationReceipt(volunteerEmail, campaignTitle);
                if (ngoEmail != null && !ngoEmail.isEmpty()) {
                    String currentVolunteerName = (String) session.getAttribute("userName");
                    EmailUtil.sendNGOVolunteerApplyAlert(ngoEmail, ngoName,
                            (currentVolunteerName != null ? currentVolunteerName : "A Volunteer"),
                            campaignTitle);
                }
            }

            response.sendRedirect("VolunteerDashboardServlet?success=applied");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("VolunteerDashboardServlet?error=failed");
        }
    }
}