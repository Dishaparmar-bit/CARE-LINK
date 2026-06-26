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

@WebServlet("/ProcessDonationServlet")
public class ProcessDonationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int donorUserId = (int) session.getAttribute("userId");
        String donorName = (String) session.getAttribute("userName");
        String donorEmail = (String) session.getAttribute("email");
        
        int campaignId = Integer.parseInt(request.getParameter("campaignId"));
        String campaignTitle = request.getParameter("campaignTitle");
        
        String amountParam = request.getParameter("amount");
        String materialDetails = request.getParameter("materialDetails");
        
        double amount = 0.0;
        String donationType = "MONEY";
        String logisticsStatus = "PROCESSED"; 

        if (amountParam != null && !amountParam.trim().isEmpty()) {
            amount = Double.parseDouble(amountParam);
        }

        if (materialDetails != null && !materialDetails.trim().isEmpty()) {
            donationType = "MATERIAL";
            logisticsStatus = "PLEDGED"; 
            amount = 0.0; 
        }

        try (Connection con = DBConnection.getConnection()) {
            con.setAutoCommit(false);

            //Check the material request limit
            if ("MATERIAL".equals(donationType)) {
                String checkQuery = "SELECT COUNT(*) AS total_pledges FROM donations WHERE campaign_id = ? AND donation_type = 'MATERIAL' AND material_details = ?";
                try (PreparedStatement psCheck = con.prepareStatement(checkQuery)) {
                    psCheck.setInt(1, campaignId);
                    psCheck.setString(2, materialDetails);
                    try (ResultSet rsCheck = psCheck.executeQuery()) {
                        if (rsCheck.next() && rsCheck.getInt("total_pledges") >= 3) {
                            con.rollback();
                            response.sendRedirect("donorDashboard.jsp?error=limit_reached");
                            return;
                        }
                    }
                }
            }

            
            String insertQuery = "INSERT INTO donations (campaign_id, donor_user_id, amount, donation_type, material_details, logistics_status, donated_at) VALUES (?, ?, ?, ?, ?, ?, NOW())";
            try (PreparedStatement ps = con.prepareStatement(insertQuery)) {
                ps.setInt(1, campaignId);
                ps.setInt(2, donorUserId);
                ps.setDouble(3, amount);
                ps.setString(4, donationType);
                ps.setString(5, materialDetails);
                ps.setString(6, logisticsStatus);
                ps.executeUpdate();
            }

       
            double fundingWeight = 0.0;
            
            if ("MONEY".equals(donationType)) {
                fundingWeight = amount;
            } else {
                String itemLower = (materialDetails != null) ? materialDetails.toLowerCase() : "";
                if (itemLower.contains("blanket")) {
                    fundingWeight = 500.00; 
                } else if (itemLower.contains("kit") || itemLower.contains("medical") || itemLower.contains("box")) {
                    fundingWeight = 1200.00; 
                } else if (itemLower.contains("food") || itemLower.contains("ration")) {
                    fundingWeight = 450.00; 
                } else {
                    fundingWeight = 300.00; 
                }
            }
            
            String updateDonorLedger = "UPDATE Donor_details SET total_donated = total_donated + ? WHERE user_id = ?";
            try (PreparedStatement psDonorScale = con.prepareStatement(updateDonorLedger)) {
                psDonorScale.setDouble(1, fundingWeight);
                psDonorScale.setInt(2, donorUserId);
                psDonorScale.executeUpdate();
            }
            
            String updateCampaignQuery = "UPDATE campaigns SET collected_amount = collected_amount + ? WHERE id = ?";
            try (PreparedStatement psCamp = con.prepareStatement(updateCampaignQuery)) {
                psCamp.setDouble(1, fundingWeight);
                psCamp.setInt(2, campaignId);
                psCamp.executeUpdate();
            }

            // 3. Fetch NGO metadata details
            String ngoEmail = "";
            String ngoOrgName = "";
            String fetchNgoDetailsQuery = "SELECT u.email, n.org_name FROM campaigns c "
                                       + "JOIN users u ON c.ngo_user_id = u.id "
                                       + "JOIN ngo_details n ON u.id = n.user_id "
                                       + "WHERE c.id = ?";
            try (PreparedStatement psNgo = con.prepareStatement(fetchNgoDetailsQuery)) {
                psNgo.setInt(1, campaignId);
                try (ResultSet rsNgo = psNgo.executeQuery()) {
                    if (rsNgo.next()) {
                        ngoEmail = rsNgo.getString("email");
                        ngoOrgName = rsNgo.getString("org_name");
                    }
                }
            }
            
   
            con.commit();

            // 4. Dual Email Trigger Pipeline
            try {
                String allocationDetails = "MONEY".equals(donationType) ? "₹" + amount : "📦 " + materialDetails;
                if ("MONEY".equals(donationType)) {
                    EmailUtil.sendDonationReceipt(donorEmail, donorName, amount, campaignTitle);
                } else {
                    EmailUtil.sendMaterialPledgeAlert(donorEmail, donorName, materialDetails, campaignTitle);
                }
                if (ngoEmail != null && !ngoEmail.isEmpty()) {
                    EmailUtil.sendNGODonationAlert(ngoEmail, ngoOrgName, donorName, allocationDetails, campaignTitle);
                }
            } catch (Exception emailEx) {
                emailEx.printStackTrace();
            }

            response.sendRedirect("donorDashboard.jsp?success=1");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("donorDashboard.jsp?error=1");
        }
    }
}