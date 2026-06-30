package com.carelink.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import com.carelink.db.DBConnection;

public class USERDao {

    // Recommendation ke results ko wrap karne ke liye Data Object
    public static class RecommendationMatch implements Comparable<RecommendationMatch> {
        public int id;
        public String name;
        public String role;
        public double matchScore;
        public String city;

        public RecommendationMatch(int id, String name, String role, double matchScore, String city) {
            this.id = id;
            this.name = name;
            this.role = role;
            this.matchScore = matchScore;
            this.city = city;
        }

        @Override
        public int compareTo(RecommendationMatch other) {
            // High score wale ko sabse upar rakhne ke liye descending sort rule
            return Double.compare(other.matchScore, this.matchScore);
        }
    }

    /**
     * CORE RECOMMENDATION ENGINE METHOD
     * Automatically calculates scores based on Location, Resources, Skills, Availability, and Capacity.
     * Restricts output to Top 5 and blocks duplicates.
     */
    public List<RecommendationMatch> getIntelligentRecommendations(int emergencyRequestId, String reqCity, String reqSkills, String reqResources) {
        List<RecommendationMatch> candidates = new ArrayList<>();
        
        String cleanSkills = (reqSkills != null) ? reqSkills.toLowerCase().trim() : "";
        String cleanResources = (reqResources != null) ? reqResources.toLowerCase().trim() : "";
        String cleanCity = (reqCity != null) ? reqCity.toLowerCase().trim() : "";

        // NOT IN subquery lagayi hai taaki duplicate assignments completely block ho sakein
        String query = "SELECT u.id, u.full_name, u.role, u.city, " +
                       "vd.skills, vd.availability, " +
                       "nd.description, nd.status AS ngo_status " +
                       "FROM users u " +
                       "LEFT JOIN volunteer_details vd ON u.id = vd.user_id " +
                       "LEFT JOIN ngo_details nd ON u.id = nd.user_id " +
                       "WHERE u.role IN ('volunteer', 'ngo') AND u.is_verified = 1 " +
                       "AND u.id NOT IN (SELECT assigned_entity_id FROM emergency_assignments WHERE request_id = ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            
            ps.setInt(1, emergencyRequestId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int id = rs.getInt("id");
                    String name = rs.getString("full_name");
                    String role = rs.getString("role");
                    String city = rs.getString("city");
                    String userCity = (city != null) ? city.toLowerCase().trim() : "";
                    
                    double score = 0.0;

                    // 1. LOCATION CONDITION (Weight: 50 Points)
                    if (userCity.equals(cleanCity) && !cleanCity.isEmpty()) {
                        score += 50.0;
                    }

                    // 2. VOLUNTEER SPECIFIC SKILLS & AVAILABILITY
                    if ("volunteer".equalsIgnoreCase(role)) {
                        String volSkills = (rs.getString("skills") != null) ? rs.getString("skills").toLowerCase() : "";
                        String availability = (rs.getString("availability") != null) ? rs.getString("availability").toLowerCase() : "";

                        // Availability Check (Weight: 25 Points)
                        if (availability.contains("immediate") || availability.contains("active") || availability.contains("yes")) {
                            score += 25.0;
                        }

                        // Required Skills Check (Weight: 25 Points)
                        if (!cleanSkills.isEmpty() && volSkills.contains(cleanSkills)) {
                            score += 25.0;
                        }
                    } 
                    // 3. NGO CAPACITY & RESOURCES
                    else if ("ngo".equalsIgnoreCase(role)) {
                        String ngoStatus = (rs.getString("ngo_status") != null) ? rs.getString("ngo_status").toLowerCase() : "";
                        String description = (rs.getString("description") != null) ? rs.getString("description").toLowerCase() : "";

                        if ("pending".equalsIgnoreCase(ngoStatus)) {
                            continue; // Banned/Pending NGOs bypass ho jayengi
                        }
                        score += 20.0; // Approved NGO base status score

                        // Capacity/Resource Match Check (Weight: 30 Points)
                        if (!cleanResources.isEmpty() && description.contains(cleanResources)) {
                            score += 30.0;
                        }
                    }

                    // Candidates pool me wahi aayenge jinka score 0 se zyada ho
                    if (score > 0) {
                        candidates.add(new RecommendationMatch(id, name, role, score, city));
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Score network ke basis par auto-ranking mechanics
        Collections.sort(candidates);

        // Sublist optimization to return strictly TOP 5 matches
        if (candidates.size() > 5) {
            return candidates.subList(0, 5);
        }
        return candidates;
    }
}