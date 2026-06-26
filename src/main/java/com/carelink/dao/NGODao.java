package com.carelink.dao;

import com.carelink.db.DBConnection;
import java.sql.*;
import java.util.*;

public class NGODao {

    // ── Get NGO Profile Info ──
    public Map<String, String> getNGOProfile(int userId) {
        Map<String, String> profile = new HashMap<>();
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(
                "SELECT u.full_name, u.email, u.phone, u.city, u.state, u.latitude, u.longitude, n.org_name, n.description, n.website, n.status FROM users u JOIN ngo_details n ON u.id = n.user_id WHERE u.id = ?"
            );
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                profile.put("fullName",    rs.getString("full_name"));
                profile.put("email",       rs.getString("email"));
                profile.put("phone",       rs.getString("phone"));
                profile.put("city",        rs.getString("city"));
                profile.put("state",       rs.getString("state"));
                String lat = rs.getString("latitude");
                String lng = rs.getString("longitude");
                profile.put("latitude",  (lat != null) ? lat : "");
                profile.put("longitude", (lng != null) ? lng : "");
                profile.put("orgName",     rs.getString("org_name"));
                profile.put("description", rs.getString("description"));
                profile.put("website",     rs.getString("website"));
                profile.put("ngoStatus",   rs.getString("status"));
            }
            rs.close(); ps.close(); con.close();
        } catch (Exception e) { e.printStackTrace(); }
        return profile;
    }

    // ── Overview Card Counts ──
    public Map<String, Object> getOverviewStats(int userId) {
        Map<String, Object> stats = new HashMap<>();
        int totalRequests = 0; int acceptedRequests = 0; int completedRequests = 0;
        try (Connection con = DBConnection.getConnection()) {
            try (PreparedStatement ps1 = con.prepareStatement("SELECT COUNT(*) FROM campaigns WHERE ngo_user_id = ?")) {
                ps1.setInt(1, userId);
                try (ResultSet rs1 = ps1.executeQuery()) { stats.put("totalCampaigns", rs1.next() ? rs1.getInt(1) : 0); }
            }
            try (PreparedStatement ps2 = con.prepareStatement("SELECT COUNT(*) FROM campaigns WHERE ngo_user_id = ? AND status = 'active'")) {
                ps2.setInt(1, userId);
                try (ResultSet rs2 = ps2.executeQuery()) { stats.put("activeCampaigns", rs2.next() ? rs2.getInt(1) : 0); }
            }
            try (PreparedStatement ps3 = con.prepareStatement("SELECT COALESCE(SUM(d.amount), 0) FROM donations d JOIN campaigns c ON d.campaign_id = c.id WHERE c.ngo_user_id = ?")) {
                ps3.setInt(1, userId);
                try (ResultSet rs3 = ps3.executeQuery()) { stats.put("totalDonations", rs3.next() ? rs3.getDouble(1) : 0.0); }
            }
            try (PreparedStatement ps4 = con.prepareStatement("SELECT COUNT(DISTINCT cr.volunteer_user_id) FROM campaign_requests cr JOIN campaigns c ON cr.campaign_id = c.id WHERE c.ngo_user_id = ? AND cr.status = 'accepted'")) {
                ps4.setInt(1, userId);
                try (ResultSet rs4 = ps4.executeQuery()) { stats.put("volunteersJoined", rs4.next() ? rs4.getInt(1) : 0); }
            }
            String queryBreakdown = "SELECT cr.status, COUNT(*) FROM campaign_requests cr JOIN campaigns c ON cr.campaign_id = c.id WHERE c.ngo_user_id = ? GROUP BY cr.status";
            try (PreparedStatement psStats = con.prepareStatement(queryBreakdown)) {
                psStats.setInt(1, userId);
                try (ResultSet rsStats = psStats.executeQuery()) {
                    while (rsStats.next()) {
                        String status = rsStats.getString(1); int count = rsStats.getInt(2);
                        totalRequests += count;
                        if ("accepted".equalsIgnoreCase(status)) { acceptedRequests = count; } 
                        else if ("completed".equalsIgnoreCase(status)) { completedRequests = count; }
                    }
                }
            }
            int totalApproved = acceptedRequests + completedRequests;
            int acceptanceRate = (totalRequests > 0) ? (totalApproved * 100 / totalRequests) : 0;
            int completionRate = (totalApproved > 0) ? (completedRequests * 100 / totalApproved) : 0;
            stats.put("acceptanceRate", acceptanceRate); stats.put("completionRate", completionRate);
        } catch (Exception e) { e.printStackTrace(); stats.put("acceptanceRate", 0); stats.put("completionRate", 0); }
        return stats;
    }

    // ── Get All Campaigns ──
    public List<Map<String, String>> getCampaigns(int userId) {
        List<Map<String, String>> list = new ArrayList<>();
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT id, title, category, status, target_amount, collected_amount, volunteers_needed, created_at FROM campaigns WHERE ngo_user_id = ? ORDER BY created_at DESC");
            ps.setInt(1, userId); ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, String> row = new HashMap<>();
                row.put("id", rs.getString("id")); row.put("title", rs.getString("title"));
                row.put("category", rs.getString("category")); row.put("status", rs.getString("status"));
                row.put("targetAmount", rs.getString("target_amount")); row.put("collectedAmount", rs.getString("collected_amount"));
                row.put("volunteersNeeded", rs.getString("volunteers_needed")); row.put("createdAt", rs.getString("created_at"));
                list.add(row);
            }
            rs.close(); ps.close(); con.close();
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // Donations Received 
    public List<Map<String, String>> getDonations(int userId) {
        List<Map<String, String>> list = new ArrayList<>();
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(
                "SELECT d.id AS donationId, u.full_name AS donorName, u.phone AS donorPhone, d.amount, d.donation_type, d.material_details, d.logistics_status, c.title AS campaignTitle, d.donated_at FROM donations d JOIN users u ON d.donor_user_id = u.id JOIN campaigns c ON d.campaign_id = c.id WHERE c.ngo_user_id = ? ORDER BY d.donated_at DESC"
            );
            ps.setInt(1, userId); ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, String> row = new HashMap<>();
                row.put("id",               rs.getString("donationId"));
                row.put("donorName",        rs.getString("donorName"));
                row.put("donorPhone",       rs.getString("donorPhone") != null ? rs.getString("donorPhone") : "9100000000");
                row.put("amount",           String.format("%.2f", rs.getDouble("amount")));
                row.put("donation_type",    rs.getString("donation_type"));    
                row.put("material_details", rs.getString("material_details")); 
                row.put("logistics_status", rs.getString("logistics_status")); 
                row.put("campaignTitle",    rs.getString("campaignTitle"));
                row.put("donatedAt",        rs.getString("donated_at"));
                list.add(row);
            }
            rs.close(); ps.close(); con.close();
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // Material Supply Method
    public boolean acceptMaterialSupply(int donationId) {
        String updateLogisticsQuery = "UPDATE donations SET logistics_status = 'DELIVERED' WHERE id = ?";
        String fetchDonorQuery = "SELECT donor_user_id FROM donations WHERE id = ?";
        try (Connection con = DBConnection.getConnection()) {
            con.setAutoCommit(false); 
            try (PreparedStatement ps1 = con.prepareStatement(updateLogisticsQuery)) {
                ps1.setInt(1, donationId); ps1.executeUpdate();
            }
            int donorUserId = 0;
            try (PreparedStatement ps2 = con.prepareStatement(fetchDonorQuery)) {
                ps2.setInt(1, donationId);
                try (ResultSet rs = ps2.executeQuery()) { if (rs.next()) { donorUserId = rs.getInt("donor_user_id"); } }
            }
            if (donorUserId != 0) {
                String updateDonorProfile = "UPDATE Donor_details SET total_donated = total_donated + 250.00 WHERE user_id = ?"; 
                try (PreparedStatement ps3 = con.prepareStatement(updateDonorProfile)) {
                    ps3.setInt(1, donorUserId); ps3.executeUpdate();
                }
            }
            con.commit(); return true;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    // Add Campaign Method 
    public boolean addCampaign(int userId, String title, String description, String category, double targetAmount, int volunteersNeeded, String allowedType, String materialRequirements) {
        String query = "INSERT INTO campaigns (ngo_user_id, title, description, category, target_amount, volunteers_needed, allowed_type, material_requirements, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'active')";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(query)) {
            ps.setInt(1, userId); ps.setString(2, title); ps.setString(3, description); ps.setString(4, category);
            ps.setDouble(5, targetAmount); ps.setInt(6, volunteersNeeded); ps.setString(7, allowedType); ps.setString(8, materialRequirements);
            ps.executeUpdate(); return true;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    
    public List<Map<String, String>> getNearbyVolunteers() {
        List<Map<String, String>> list = new ArrayList<>();
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT u.id, u.full_name, u.city, u.state, u.latitude, u.longitude, vd.skills FROM users u JOIN volunteer_details vd ON u.id = vd.user_id WHERE u.latitude IS NOT NULL AND u.longitude IS NOT NULL");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, String> row = new HashMap<>();
                row.put("id", rs.getString("id")); row.put("name", rs.getString("full_name"));
                row.put("city", rs.getString("city")); row.put("state", rs.getString("state"));
                row.put("latitude", rs.getString("latitude")); row.put("longitude", rs.getString("longitude"));
                row.put("skills", rs.getString("skills")); list.add(row);
            }
            rs.close(); ps.close(); con.close();
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<Map<String, String>> getAllNGOsWithLocation() {
        List<Map<String, String>> list = new ArrayList<>();
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT u.id, u.full_name, u.city, u.latitude, u.longitude, n.org_name, n.description, (SELECT COUNT(*) FROM campaigns c WHERE c.ngo_user_id = u.id AND c.status='active') AS activeCampaigns FROM users u JOIN ngo_details n ON u.id = n.user_id WHERE u.latitude IS NOT NULL AND u.longitude IS NOT NULL AND n.status = 'approved'");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, String> row = new HashMap<>();
                row.put("id", rs.getString("id")); row.put("fullName", rs.getString("full_name"));
                row.put("city", rs.getString("city")); row.put("latitude", rs.getString("latitude"));
                row.put("longitude", rs.getString("longitude")); row.put("orgName", rs.getString("org_name"));
                row.put("description", rs.getString("description")); row.put("activeCampaigns", rs.getString("activeCampaigns"));
                list.add(row);
            }
            rs.close(); ps.close(); con.close();
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public void updateRequestStatus(int requestId, String status) {
        String updateStatusQuery = "UPDATE campaign_requests SET status = ? WHERE id = ?";
        try (Connection con = DBConnection.getConnection()) {
            con.setAutoCommit(false);
            try (PreparedStatement ps1 = con.prepareStatement(updateStatusQuery)) { ps1.setString(1, status); ps1.setInt(2, requestId); ps1.executeUpdate(); }
            if ("completed".equalsIgnoreCase(status)) {
                String fetchDetailsQuery = "SELECT cr.volunteer_user_id, c.urgency FROM campaign_requests cr JOIN campaigns c ON cr.campaign_id = c.id WHERE cr.id = ?";
                int volunteerUserId = 0; String urgency = "low";
                try (PreparedStatement ps2 = con.prepareStatement(fetchDetailsQuery)) {
                    ps2.setInt(1, requestId);
                    try (ResultSet rs = ps2.executeQuery()) { if (rs.next()) { volunteerUserId = rs.getInt("volunteer_user_id"); urgency = rs.getString("urgency"); } }
                }
                if (volunteerUserId != 0) {
                    int pointsToAdd = 20; int hoursToAdd = 5;
                    if ("medium".equalsIgnoreCase(urgency)) { pointsToAdd = 30; } else if ("high".equalsIgnoreCase(urgency)) { pointsToAdd = 50; }
                    String updateRewardsQuery = "UPDATE volunteer_details SET points = COALESCE(points, 0) + ?, total_hours = COALESCE(total_hours, 0) + ? WHERE user_id = ?";
                    try (PreparedStatement ps3 = con.prepareStatement(updateRewardsQuery)) { ps3.setInt(1, pointsToAdd); ps3.setInt(2, hoursToAdd); ps3.setInt(3, volunteerUserId); ps3.executeUpdate(); }
                }
            }
            con.commit();
        } catch (Exception e) { e.printStackTrace(); }
    }

    public boolean updateLocation(int userId, double lat, double lng) {
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("UPDATE users SET latitude = ?, longitude = ? WHERE id = ?");
            ps.setDouble(1, lat); ps.setDouble(2, lng); ps.setInt(3, userId); ps.executeUpdate();
            ps.close(); con.close(); return true;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public List<Map<String, String>> getFeedPosts(int ngoUserId) {
        List<Map<String, String>> list = new ArrayList<>();
        String query = "SELECT id, content, urgency, posted_at FROM feed_posts WHERE ngo_user_id = ? ORDER BY posted_at DESC";
        try {
            Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, ngoUserId); ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, String> row = new HashMap<>();
                row.put("id", rs.getString("id")); row.put("content", rs.getString("content"));
                row.put("urgency", rs.getString("urgency")); row.put("createdAt", rs.getString("posted_at"));
                list.add(row);
            }
            rs.close(); ps.close(); con.close();
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

 //Global Feeds Method 
    public List<Map<String, String>> getAllGlobalFeeds() {
        List<Map<String, String>> list = new ArrayList<>();
        // ✅ JOIN SQL QUERY TO FETCH REAL NGO NAME PARAMETERS
        String query = "SELECT f.id, f.content, f.urgency, f.posted_at, n.org_name " +
                       "FROM feed_posts f " +
                       "JOIN ngo_details n ON f.ngo_user_id = n.user_id " +
                       "ORDER BY f.posted_at DESC";
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(query);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, String> row = new HashMap<>();
                row.put("id", rs.getString("id"));
                row.put("content", rs.getString("content"));
                row.put("urgency", rs.getString("urgency"));
                row.put("createdAt", rs.getString("posted_at")); 
                
                // ✅ ADDED: Injecting real NGO Name parameter into the map string block
                row.put("ngoName", rs.getString("org_name") != null ? rs.getString("org_name") : "Unknown NGO");
                
                list.add(row);
            }
            rs.close(); ps.close(); con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public boolean closeCampaign(int campaignId) {
        String query = "UPDATE campaigns SET status = 'closed' WHERE id = ?";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(query)) {
            ps.setInt(1, campaignId); int rowsAffected = ps.executeUpdate(); return rowsAffected > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public List<Map<String, String>> getVolunteerRequestsForNGO(int ngoUserId) {
        List<Map<String, String>> list = new ArrayList<>();
        try {
            Connection con = DBConnection.getConnection();
            String query = "SELECT cr.id AS requestId, cr.status, cr.requested_at, c.title AS campaignTitle, u.full_name AS volunteerName, u.city FROM campaign_requests cr JOIN campaigns c ON cr.campaign_id = c.id JOIN users u ON cr.volunteer_user_id = u.id WHERE c.ngo_user_id = ? ORDER BY cr.requested_at DESC";
            PreparedStatement ps = con.prepareStatement(query); ps.setInt(1, ngoUserId); ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, String> row = new HashMap<>();
                row.put("requestId",     rs.getString("requestId")); row.put("status",        rs.getString("status"));
                row.put("requestedAt",   rs.getString("requested_at")); row.put("campaignTitle", rs.getString("campaignTitle"));
                row.put("volunteerName", rs.getString("volunteerName")); row.put("city",          rs.getString("city"));
                list.add(row);
            }
            rs.close(); ps.close(); con.close();
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }
}