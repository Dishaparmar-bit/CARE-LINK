package com.carelink.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import com.carelink.db.DBConnection;

public class VolunteerDao {

    // 1. VOLUNTEER 
    public Map<String, Object> getVolunteerStats(int volunteerUserId) {
        Map<String, Object> stats = new HashMap<>();
        
        
        stats.put("totalHours", 0);
        stats.put("rewardPoints", 0);
        stats.put("pendingRequests", 0);
        stats.put("attendedCampaigns", 0);

        try (Connection con = DBConnection.getConnection()) {
            
            //  hours and points 
            String queryDetails = "SELECT total_hours, points FROM volunteer_details WHERE user_id = ?";
            try (PreparedStatement ps = con.prepareStatement(queryDetails)) {
                ps.setInt(1, volunteerUserId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        stats.put("totalHours", rs.getInt("total_hours"));
                        stats.put("rewardPoints", rs.getInt("points"));
                    }
                }
            }

            // counts of pending requests
            String queryPending = "SELECT COUNT(*) FROM campaign_requests WHERE volunteer_user_id = ? AND status = 'pending'";
            try (PreparedStatement ps = con.prepareStatement(queryPending)) {
                ps.setInt(1, volunteerUserId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        stats.put("pendingRequests", rs.getInt(1));
                    }
                }
            }

            //counts of accepted OR completed campaigns 
            String queryAttended = "SELECT COUNT(*) FROM campaign_requests WHERE volunteer_user_id = ? AND status IN ('accepted', 'completed')";
            try (PreparedStatement ps = con.prepareStatement(queryAttended)) {
                ps.setInt(1, volunteerUserId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        stats.put("attendedCampaigns", rs.getInt(1));
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return stats;
    }

    // APPLICATION HISTORY 
    public List<Map<String, String>> getMyApplications(int volunteerUserId) {
        List<Map<String, String>> list = new ArrayList<>();
        String query = "SELECT cr.campaign_id, cr.status, cr.requested_at, c.title AS campaignTitle, u.full_name AS ngoName " +
                       "FROM campaign_requests cr " +
                       "JOIN campaigns c ON cr.campaign_id = c.id " +
                       "JOIN users u ON c.ngo_user_id = u.id " +
                       "WHERE cr.volunteer_user_id = ? ORDER BY cr.requested_at DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            
            ps.setInt(1, volunteerUserId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, String> row = new HashMap<>();
                    row.put("campaignTitle", rs.getString("campaignTitle"));
                    row.put("ngoName",       rs.getString("ngoName"));
                    row.put("status",        rs.getString("status"));
                    row.put("requestedAt",   rs.getString("requested_at"));
                    list.add(row);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    // GLOBAL CAMPAIGNS 
    public List<Map<String, String>> getAllActiveCampaigns() {
        List<Map<String, String>> list = new ArrayList<>();
        String query = "SELECT c.id, c.title, c.description, c.category, c.target_amount, " +
                       "u.full_name AS ngoName, u.city " +
                       "FROM campaigns c " +
                       "JOIN users u ON c.ngo_user_id = u.id " +
                       "ORDER BY c.id DESC";

        try (java.sql.Connection con = com.carelink.db.DBConnection.getConnection();
             java.sql.PreparedStatement ps = con.prepareStatement(query);
             java.sql.ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Map<String, String> row = new HashMap<>();
                row.put("id",           rs.getString("id"));
                row.put("title",        rs.getString("title"));
                row.put("description",  rs.getString("description"));
                row.put("category",     rs.getString("category"));
                row.put("targetAmount", rs.getString("target_amount"));
                row.put("ngoName",      rs.getString("ngoName"));
                row.put("city",         rs.getString("city"));
                list.add(row);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}