package com.carelink.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.carelink.dao.NGODao;
import com.carelink.util.EmailUtil;

@WebServlet("/NGODashboardServlet")
public class NGODashboardServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Session check
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp?error=session_expired");
            return;
        }

        String role = (String) session.getAttribute("role");
        if (!"ngo".equalsIgnoreCase(role)) {
            response.sendRedirect("login.jsp?error=unauthorized");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        NGODao dao = new NGODao();

        
        Map<String, String>        profile           = dao.getNGOProfile(userId);
        Map<String, Object>        stats             = dao.getOverviewStats(userId);
        List<Map<String, String>>  campaigns         = dao.getCampaigns(userId);
        List<Map<String, String>>  volunteerRequests = dao.getVolunteerRequestsForNGO(userId);
        List<Map<String, String>>  donations         = dao.getDonations(userId); // 👈 DAO iterates map maps inside here
        List<Map<String, String>>  nearbyVolunteers  = dao.getNearbyVolunteers();
        List<Map<String, String>>  allNGOs           = dao.getAllNGOsWithLocation();
        List<Map<String, String>>  feedPosts         = dao.getFeedPosts(userId);
        
      
        request.setAttribute("profile",           profile);
        request.setAttribute("stats",              stats);
        request.setAttribute("campaigns",         campaigns);
        request.setAttribute("volunteerRequests", volunteerRequests);
        request.setAttribute("donations",         donations);
        request.setAttribute("nearbyVolunteers",  nearbyVolunteers);
        request.setAttribute("allNGOs",           allNGOs);
        request.setAttribute("feedPosts",          feedPosts);
        
        request.getRequestDispatcher("ngoDashboard.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp?error=session_expired");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        String action = request.getParameter("action");
        NGODao dao = new NGODao();

        if ("addCampaign".equals(action)) {
            String title            = request.getParameter("title");
            String description      = request.getParameter("description");
            String category         = request.getParameter("category");
            double targetAmount     = Double.parseDouble(request.getParameter("targetAmount"));
            int    volunteersNeeded = Integer.parseInt(request.getParameter("volunteersNeeded"));
            
         
            String allowedType      = request.getParameter("allowedType"); 
            String materialRequirements = request.getParameter("materialRequirements");

            // 1. Save campaign into database 
            boolean isInserted = dao.addCampaign(userId, title, description, category, targetAmount, volunteersNeeded, allowedType, materialRequirements);

            // 2. Email Broadcast to all Registered Volunteers 
            if (isInserted) {
                List<String> volunteerEmails = new ArrayList<>();
                String ngoName = "CARE LINK Verified NGO";
                String city = "Indore"; 

                String broadcastQuery = "SELECT email, role, full_name, city, id FROM users";
                
                try (Connection con = com.carelink.db.DBConnection.getConnection();
                     PreparedStatement psBroadcast = con.prepareStatement(broadcastQuery);
                     ResultSet rs = psBroadcast.executeQuery()) {
                    
                    while (rs.next()) {
                        String userRole = rs.getString("role");
                        if ("volunteer".equalsIgnoreCase(userRole)) {
                            volunteerEmails.add(rs.getString("email"));
                        }
                        if (userId == rs.getInt("id")) {
                            ngoName = rs.getString("full_name");
                            city = rs.getString("city");
                        }
                    }
                } catch (Exception e) { 
                    e.printStackTrace(); 
                }

                for (String email : volunteerEmails) {
                    EmailUtil.sendNewCampaignAlert(email, title, ngoName, category, city);
                }
                
                response.sendRedirect("NGODashboardServlet?success=campaign");
                return;
            } else {
                response.sendRedirect("NGODashboardServlet?error=failed_to_insert");
                return;
            }

        } 
        
        //  ACCEPT SUPPLY TRANSACTION 
        else if ("acceptSupply".equals(action)) {
            int donationId = Integer.parseInt(request.getParameter("donationId"));
            
            boolean isAccepted = dao.acceptMaterialSupply(donationId);
            
            if (isAccepted) {
                response.sendRedirect("NGODashboardServlet?success=supply_accepted");
            } else {
                response.sendRedirect("NGODashboardServlet?error=failed_supply");
            }
            return;
        }

        else if ("updateRequest".equals(action)) {
            int    requestId = Integer.parseInt(request.getParameter("requestId"));
            String status    = request.getParameter("status");
            dao.updateRequestStatus(requestId, status);
            String volunteerEmail = "";
            String campaignTitle = "";
            
            String fetchQuery = "SELECT u.email, c.title FROM campaign_requests cr " +
                                "JOIN users u ON cr.volunteer_user_id = u.id " +
                                "JOIN campaigns c ON cr.campaign_id = c.id " +
                                "WHERE cr.id = ?";
                                
            try (Connection con = com.carelink.db.DBConnection.getConnection();
                 PreparedStatement psFetch = con.prepareStatement(fetchQuery)) {
                psFetch.setInt(1, requestId);
                try (ResultSet rs = psFetch.executeQuery()) {
                    if (rs.next()) {
                        volunteerEmail = rs.getString("email");
                        campaignTitle  = rs.getString("title");
                    }
                }
            } catch (Exception e) { e.printStackTrace(); }
            
            if (volunteerEmail != null && !volunteerEmail.isEmpty() && campaignTitle != null && !campaignTitle.isEmpty()) {
                EmailUtil.sendApplicationStatusUpdate(volunteerEmail, campaignTitle, status);
            }
            
            response.sendRedirect("NGODashboardServlet?success=request");
            return;
        } 

        else if ("closeCampaign".equals(action)) {
            int campaignId = Integer.parseInt(request.getParameter("campaignId"));
            boolean isClosed = dao.closeCampaign(campaignId);
            if (isClosed) {
                response.sendRedirect("NGODashboardServlet?success=campaign_closed");
            } else {
                response.sendRedirect("NGODashboardServlet?error=failed_to_close");
            }
            return;
        }
        
        else if ("updateLocation".equals(action)) {
            double lat = Double.parseDouble(request.getParameter("lat"));
            double lng = Double.parseDouble(request.getParameter("lng"));
            dao.updateLocation(userId, lat, lng);
            response.sendRedirect("NGODashboardServlet?success=location");
            return;
        }

        response.sendRedirect("NGODashboardServlet");
    }
}