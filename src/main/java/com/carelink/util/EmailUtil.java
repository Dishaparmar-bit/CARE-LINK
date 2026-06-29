package com.carelink.util;

import java.util.Properties;
import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public class EmailUtil {

    private static final String FROM_EMAIL = "carelinksupportteam@gmail.com";
    // NOTE: Put your 16-character Google App Password inside this string variable
    private static final String APP_PASSWORD = "xxxp tlfn dwbu hofw"; 

    private static Session getSession() {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.starttls.required", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.ssl.trust", "smtp.gmail.com");
        props.put("mail.smtp.ssl.protocols", "TLSv1.2");
        props.put("mail.debug", "true");

        return Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(FROM_EMAIL, APP_PASSWORD);
            }
        });
    }

    // Email Layout
    private static String getHtmlTemplate(String title, String contentBody) {
        return "<div style='font-family:\"Plus Jakarta Sans\",sans-serif;max-width:550px;margin:20px auto;border:1px solid #E2E8F0;border-radius:12px;overflow:hidden;box-shadow:0 4px 12px rgba(0,0,0,0.03);'>"
            + "  <div style='background:linear-gradient(135deg, #093E2A, #10B981);padding:24px;text-align:center;color:#FFFFFF;'>"
            + "    <h2 style='margin:0;font-size:22px;font-weight:800;letter-spacing:1px;'>💚 CARE LINK</h2>"
            + "    <p style='margin:4px 0 0 0;font-size:12px;opacity:0.85;'>" + title + "</p>"
            + "  </div>"
            + "  <div style='padding:32px;color:#334155;line-height:1.6;font-size:14.5px;background:#FFFFFF;'>"
            +       contentBody
            + "    <hr style='border:0;border-top:1px solid #F1F5F9;margin:24px 0;'>"
            + "    <p style='font-size:12px;color:#64748B;margin:0;'>This is an automated system email. Please do not reply directly to this message.</p>"
            + "  </div>"
            + "  <div style='background:#F8FAFC;padding:16px;text-align:center;font-size:11px;color:#94A3B8;border-top:1px solid #E2E8F0;'>"
            + "    &copy; 2026 CARE LINK. Building Stronger Communities Together."
            + "  </div>"
            + "</div>";
    }

    // OTP
    public static boolean sendOTP(String toEmail, String otp) {
        try {
            Message message = new MimeMessage(getSession());
            message.setFrom(new InternetAddress(FROM_EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("CARE LINK | OTP Verification Code");

            String body = "<p>Hello User,</p>"
                    + "<p>We received a request to verify your identity for your CARE LINK account.</p>"
                    + "<div style='background:#F1F5F9;border-radius:8px;padding:16px;text-align:center;margin:20px 0;'>"
                    + "  <span style='font-size:28px;font-weight:800;letter-spacing:4px;color:#093E2A;'> " + otp + "</span>"
                    + "</div>"
                    + "<p style='color:#EF4444;font-size:13px;'><b>Note:</b> This security code is valid for 5 minutes only. Please do not share this code with anyone.</p>";

            message.setContent(getHtmlTemplate("Identity Verification Token", body), "text/html; charset=utf-8");
            Transport.send(message);
            return true;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public static boolean sendWelcomeEmail(String toEmail, String fullName, String role) {
        try {
            Message message = new MimeMessage(getSession());
            message.setFrom(new InternetAddress(FROM_EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            
            String subject = "Welcome to CARE LINK";
            String body = "<p>Hello " + fullName + ",</p>";

            if ("ngo".equalsIgnoreCase(role)) {
                subject = "CARE LINK | NGO Registration Received";
                body += "<p>Thank you for registering your NGO profile with us.</p>"
                     + "<p>Your account status is currently marked as: <b style='color:#EA580C;'>PENDING REVIEW</b>.</p>"
                     + "<p>Our administration team will verify your organization details within 24 hours. Once approved, you will be able to create and launch social campaigns directly from your dashboard.</p>";
            } else if ("volunteer".equalsIgnoreCase(role)) {
                subject = "CARE LINK | Welcome to the Volunteer Team!";
                body += "<p>You are officially verified as a volunteer on our platform!</p>"
                     + "<p>Your dashboard is completely ready. You can now explore live campaigns, monitor nearby emergency feeds, and track your reward milestones as you help our community.</p>";
            } else {
                subject = "CARE LINK | Donor Account Registered";
                body += "<p>Your donor profile has been successfully set up in our system.</p>"
                     + "<p>Thank you for joining our network to support regional emergency recovery campaigns and community drives.</p>";
            }

            message.setSubject(subject);
            message.setContent(getHtmlTemplate("Account Successfully Registered", body), "text/html; charset=utf-8");
            Transport.send(message);
            return true;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    // NGO
    public static boolean sendNGOApprovalEmail(String toEmail, String ngoName) {
        try {
            Message message = new MimeMessage(getSession());
            message.setFrom(new InternetAddress(FROM_EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("CARE LINK | Account Approved Successfully");

            String body = "<p>Hello " + ngoName + ",</p>"
                    + "<p style='color:#16A34A;font-weight:700;font-size:16px;'>🎉 Congratulations! Your Account is Approved!</p>"
                    + "<p>Your organization credentials have been successfully verified. Your NGO dashboard operations are now fully active.</p>"
                    + "<ul>"
                    + "  <li>Launch real-time local campaigns</li>"
                    + "  <li>Post immediate community needs directly to live volunteer feeds</li>"
                    + "  <li>Manage incoming donor resource packages smoothly</li>"
                    + "</ul>";

            message.setContent(getHtmlTemplate("NGO Console Activated", body), "text/html; charset=utf-8");
            Transport.send(message);
            return true;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public static boolean sendNGORejectionEmail(String toEmail, String ngoName) {
        try {
            Message message = new MimeMessage(getSession());
            message.setFrom(new InternetAddress(FROM_EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("CARE LINK | Account Verification Update");

            String body = "<p>Hello " + ngoName + ",</p>"
                    + "<p style='color:#DC2626;font-weight:700;'>Verification Review Update</p>"
                    + "<p>Unfortunately, our team found some structural mismatches during the validation of your organization credentials. This usually happens due to missing registration files or unverified addresses.</p>"
                    + "<p>Please re-verify your registration details inside your dashboard and try re-submitting your profile for review.</p>";

            message.setContent(getHtmlTemplate("Account Review Mismatch", body), "text/html; charset=utf-8");
            Transport.send(message);
            return true;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    // VOLUNTEER 
    public static boolean sendNewCampaignAlert(String toEmail, String campaignTitle, String ngoName, String category, String city) {
        try {
            Message message = new MimeMessage(getSession());
            message.setFrom(new InternetAddress(FROM_EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("🚨 CARE LINK | New Active Drive Launched: " + campaignTitle);

            String body = "<p>Hello Changemaker,</p>"
                    + "<p>A new volunteering drive has just been started near your location. They need your support:</p>"
                    + "<div style='border-left:4px solid #10B981;padding-left:16px;margin:16px 0;background:#F8FAFC;padding-top:8px;padding-bottom:8px;'>"
                    + "  <b>Campaign Name:</b> " + campaignTitle + "<br>"
                    + "  <b>Organized By:</b> " + ngoName + "<br>"
                    + "  <b>Category:</b> " + category + "<br>"
                    + "  <b>City:</b> " + city + ""
                    + "</div>"
                    + "<p>Please login to your CARE LINK Volunteer Hub to view details and apply to this campaign immediately.</p>";

            message.setContent(getHtmlTemplate("New Campaign Alert", body), "text/html; charset=utf-8");
            Transport.send(message);
            return true;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public static boolean sendApplicationReceipt(String toEmail, String campaignTitle) {
        try {
            Message message = new MimeMessage(getSession());
            message.setFrom(new InternetAddress(FROM_EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("🔒 CARE LINK | Application Successfully Received");

            String body = "<p>Hello Volunteer,</p>"
                    + "<p>Your application to join the campaign <b>" + campaignTitle + "</b> has been successfully recorded in our system.</p>"
                    + "<p>The organizing NGO has been notified. You can track the progress and status of your application under the <b>Applications Log</b> tab on your dashboard window.</p>";

            message.setContent(getHtmlTemplate("Application Submitted", body), "text/html; charset=utf-8");
            Transport.send(message);
            return true;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public static boolean sendApplicationStatusUpdate(String toEmail, String campaignTitle, String status) {
        try {
            Message message = new MimeMessage(getSession());
            message.setFrom(new InternetAddress(FROM_EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("📋 CARE LINK | Application Status Update");

            String statusColor = "#64748B"; 
            String statusUpper = status.toUpperCase();
            
            if ("accepted".equalsIgnoreCase(status)) {
                statusColor = "#10B981"; 
            } else if ("completed".equalsIgnoreCase(status)) {
                statusColor = "#0284C7"; 
            } else if ("rejected".equalsIgnoreCase(status)) {
                statusColor = "#EF4444"; 
            }
            
            String body = "<p>Hello Volunteer,</p>"
                    + "<p>There is an update on your request to join the campaign: <b>" + campaignTitle + "</b>.</p>"
                    + "<p style='font-size:16px;font-weight:700;'>New Status: <span style='color:" + statusColor + ";'>" + statusUpper + "</span></p>";

            if ("accepted".equalsIgnoreCase(status)) {
                body += "<p>🎉 <b>Congratulations!</b> Your request has been accepted by the NGO. Your skills match perfectly with the campaign requirements.</p>"
                     + "<p>Please login to your CARE LINK dashboard to check the location details and connect with your NGO team leader.</p>";
            } else if ("completed".equalsIgnoreCase(status)) {
                body += "<p>🌟 🏆 <b>Mission Accomplished!</b> Thank you so much for your active help and hard work on the field. Your contribution made a real difference.</p>"
                     + "<p><b>Great News:</b> Your <b>Reward Points</b> and <b>Impact Hours</b> have been successfully credited to your profile.</p> "
                     + "<p>Also, your official <b>Campaign Completion Certificate</b> is now unlocked! You can download it anytime from the <b>Applications Log</b> tab on your dashboard.</p>";
            } else {
                body += "<p>Unfortunately, your request could not be accommodated for this specific drive due to full volunteer slots. "
                     + "Don't worry, there are many other open opportunities near you. Please check your live dashboard feed for new drives!</p>";
            }

            message.setContent(getHtmlTemplate("Application Status Alert", body), "text/html; charset=utf-8");
            Transport.send(message);
            return true;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    // DONOR 
    public static boolean sendDonationReceipt(String toEmail, String donorName, double amount, String campaignTitle) {
        try {
            Message message = new MimeMessage(getSession());
            message.setFrom(new InternetAddress(FROM_EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("💳 CARE LINK | Donation Receipt Confirmed");

            String body = "<p>Hello " + donorName + ",</p>"
                    + "<p>Thank you so much for your generous financial contribution through our platform.</p>"
                    + "<div style='background:#F8FAFC;border:1px dashed #CBD5E1;padding:16px;border-radius:8px;font-size:14px;line-height:1.7;'>"
                    + "  <b>Amount Contributed:</b> <span style='color:#16A34A;font-weight:700;'>₹" + amount + "</span><br>"
                    + "  <b>Campaign Supported:</b> " + campaignTitle + "<br>"
                    + "  <b>Transaction Status:</b> SUCCESSFUL & VERIFIED"
                    + "</div>"
                    + "<p>This email serves as an official reference for your dynamic 80G tax benefits records.</p>";

            message.setContent(getHtmlTemplate("Donation Receipt Acknowledged", body), "text/html; charset=utf-8");
            Transport.send(message);
            return true;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public static boolean sendMaterialPledgeAlert(String toEmail, String donorName, String materialDetails, String campaignTitle) {
        try {
            Message message = new MimeMessage(getSession());
            message.setFrom(new InternetAddress(FROM_EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("📦 CARE LINK | Material Supply Pledge Confirmed");

            String body = "<p>Hello " + donorName + ",</p>"
                    + "<p>Thank you so much for pledging essential physical supplies to support our on-field operations.</p>"
                    + "<div style='background:#F8FAFC;border:1px dashed #CBD5E1;padding:16px;border-radius:8px;font-size:14px;line-height:1.7;'>"
                    + "  <b>Pledged Item(s):</b> <span style='color:#0284C7;font-weight:700;'>" + materialDetails + "</span><br>"
                    + "  <b>Campaign Supported:</b> " + campaignTitle + "<br>"
                    + "  <b>Logistics Status:</b> PLEDGED & WAITING FOR COORDINATION"
                    + "</div>"
                    + "<p>Our volunteer squad and the organizing NGO have been alerted. They will get in touch with you shortly to coordinate the pickup/delivery logistics.</p>"
                    + "<p>You can track the live lifecycle status of your package directly under the <b>Contributions Log</b> tab on your dashboard panel.</p>";

            message.setContent(getHtmlTemplate("Material Pledge Acknowledged", body), "text/html; charset=utf-8");
            Transport.send(message);
            return true;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public static boolean sendCampaignMilestoneAlert(String toEmail, String donorName, String campaignTitle, double currentRaised, double targetGoal) {
        try {
            Message message = new MimeMessage(getSession());
            message.setFrom(new InternetAddress(FROM_EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("🚀 CARE LINK | A Campaign You Supported is Reaching Its Goal!");

            double percentage = (currentRaised / targetGoal) * 100;
            String body = "<p>Hello " + donorName + ",</p>"
                    + "<p>We have incredible news! The community drive you generously backed is on the verge of full success:</p>"
                    + "<div style='border-left:4px solid #F59E0B; padding-left:16px; margin:16px 0; background:#F8FAFC; padding-top:8px; padding-bottom:8px;'>"
                    + "  <b>Campaign:</b> " + campaignTitle + "<br>"
                    + "  <b>Current Funding Progress:</b> <span style='color:#F59E0B; font-weight:700;'>" + String.format("%.1f", percentage) + "% Met</span> (₹" + currentRaised + " raised of ₹" + targetGoal + ")"
                    + "</div>"
                    + "<p>Your contribution played a key role in making this happen. Thank you for standing with the community!</p>";

            message.setContent(getHtmlTemplate("Campaign Progress Alert", body), "text/html; charset=utf-8");
            Transport.send(message);
            return true;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public static boolean sendLogisticsStatusUpdate(String toEmail, String donorName, String materialDetails, String campaignTitle, String newStatus) {
        try {
            Message message = new MimeMessage(getSession());
            message.setFrom(new InternetAddress(FROM_EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("📦 CARE LINK | Supply Chain Shipment Update");

            String statusColor = "#64748B";
            String deliveryMessage = "";

            if ("DELIVERED".equalsIgnoreCase(newStatus)) {
                statusColor = "#10B981"; // Fresh Emerald Green
                deliveryMessage = "🎉 <b>Successfully Delivered:</b> Great news! Your pledged items have been successfully received and verified by the NGO management team. Thank you for your incredible support!";
            } else if ("ARRIVED".equalsIgnoreCase(newStatus)) {
                statusColor = "#F59E0B"; 
                deliveryMessage = "🏢 <b>Received by NGO:</b> Your material supplies have safely arrived at the NGO warehouse hub and are being prepared for on-field allocation.";
            } else if ("DISTRIBUTED".equalsIgnoreCase(newStatus)) {
                statusColor = "#10B981"; 
                deliveryMessage = "🎉 <b>Mission Accomplished!</b> Your donated supplies have been officially distributed to families on the ground by our active volunteer squad.";
            }

            String body = "<p>Hello " + donorName + ",</p>"
                    + "<p>There is a real-time tracking update regarding the physical supplies you pledged for <b>" + campaignTitle + "</b>:</p>"
                    + "<div style='background:#F8FAFC; border:1px solid #E2E8F0; padding:16px; border-radius:8px; margin:20px 0;'>"
                    + "  <b>Item Details:</b> " + materialDetails + "<br>"
                    + "  <b>Current Logistics Phase:</b> <span style='color:" + statusColor + "; font-weight:700;'>" + newStatus.toUpperCase() + "</span>"
                    + "</div>"
                    + "<p>" + deliveryMessage + "</p>"
                    + "<p>Thank you for your transparent support in building a reliable community stack.</p>";

            message.setContent(getHtmlTemplate("Material Logistics Tracker", body), "text/html; charset=utf-8");
            Transport.send(message);
            return true;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public static boolean sendDonorRankUpgradeEmail(String toEmail, String donorName, String newBadgeName) {
        try {
            Message message = new MimeMessage(getSession());
            message.setFrom(new InternetAddress(FROM_EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("🎉 🏆 CARE LINK | Congratulations! Your Kindness Rank Upgraded!");

            String body = "<p>Hello " + donorName + ",</p>"
                    + "<p>The community is cheering for you! Your continuous support and resource contributions have officially unlocked a new level on our platform:</p>"
                    + "<div style='background:linear-gradient(135deg, #EFF6FF, #DBEAFE); border:1px solid #3B82F6; padding:20px; border-radius:12px; text-align:center; margin:20px 0;'>"
                    + "  <span style='font-size:12px; font-weight:700; text-transform:uppercase; color:#1D4ED8; letter-spacing:1px;'>New Milestone Unlocked</span>"
                    + "  <h3 style='margin:8px 0 0 0; font-size:24px; font-weight:800; color:#1E3A8A;'>" + newBadgeName + " Status</h3>"
                    + "</div>"
                    + "<p>Your new structural status rank and premium tracking perks are now fully updated and visible on your sidebar console.</p>"
                    + "<p>Thank you for being a reliable pillar of our ecosystem network!</p>";

            message.setContent(getHtmlTemplate("Ecosystem Level Up", body), "text/html; charset=utf-8");
            Transport.send(message);
            return true;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }
    
 //  NGO 
    public static boolean sendNGODonationAlert(String ngoEmail, String ngoName, String donorName, String donationDetails, String campaignTitle) {
        try {
            Message message = new MimeMessage(getSession());
            message.setFrom(new InternetAddress(FROM_EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(ngoEmail));
            message.setSubject("❤️ CARE LINK | New Contribution Received for: " + campaignTitle);

            String body = "<p>Hello " + ngoName + ",</p>"
                    + "<p>Great news! A donor has just contributed resources to your active drive:</p>"
                    + "<div style='border-left:4px solid #10B981;padding-left:16px;margin:16px 0;background:#F8FAFC;padding-top:8px;padding-bottom:8px;'>"
                    + "  <b>Campaign Name:</b> " + campaignTitle + "<br>"
                    + "  <b>Donor Name:</b> " + donorName + "<br>"
                    + "  <b>Contribution Volume:</b> <span style='color:#093E2A;font-weight:700;'>" + donationDetails + "</span>"
                    + "</div>"
                    + "<p>Please login to your CARE LINK NGO Console to manage this allocation and coordinate logistics workflows.</p>";

            message.setContent(getHtmlTemplate("Incoming Contribution Alert", body), "text/html; charset=utf-8");
            Transport.send(message);
            return true;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }
    
 // PASSWORD RECOVERY 
    public static boolean sendPasswordResetEmail(String toEmail, String resetLink) {
        try {
            Message message = new MimeMessage(getSession());
            message.setFrom(new InternetAddress(FROM_EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("🔑 CARE LINK | Identity Recovery Subsystem Token");

            String body = "<p>Hello User,</p>"
                    + "<p>We received a request to reset your CARE LINK system platform password gateway access node.</p>"
                    + "<p>Please click the secure action node button below to clear identity parameters and override credentials:</p>"
                    + "<div style='text-align:center; margin:24px 0;'>"
                    + "  <a href='" + resetLink + "' target='_blank' style='background-color:#10B981; color:#FFFFFF; padding:12px 24px; border-radius:6px; font-size:14px; font-weight:700; text-decoration:none; display:inline-block; box-shadow:0 4px 6px rgba(16,185,129,0.2);'>Reset Account Password</a>"
                    + "</div>"
                    + "<p style='font-size:12px; color:#64748B;'>If you did not execute this validation request, you can safely ignore this automated transmission thread. Your parameters remain secure.</p>";

            message.setContent(getHtmlTemplate("Account Security Clearance Node", body), "text/html; charset=utf-8");
            Transport.send(message);
            return true;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }
    
 //  1. ADMIN CONFIRMATION FOR NGO APPROVAL/REJECTION
    public static boolean sendAdminActionConfirmation(String adminEmail, String ngoName, String actionStatus) {
        try {
            Message message = new MimeMessage(getSession());
            message.setFrom(new InternetAddress(FROM_EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(adminEmail));
            message.setSubject("🔒 CARE LINK | Admin Action Protocol Logged");

            String body = "<p>System Administrator,</p>"
                    + "<p>Your security action override has been successfully executed inside the core platform matrix:</p>"
                    + "<div style='background:#F1F5F9; border-left:4px solid #1E293B; padding:12px; margin:15px 0;'>"
                    + "  <b>Organization Name:</b> " + ngoName + "<br>"
                    + "  <b>Action Executed:</b> Status set to <span style='font-weight:700;'>" + actionStatus + "</span><br>"
                    + "  <b>Timestamp:</b> 2026-06-25 Dynamic System Clock"
                    + "</div>"
                    + "<p>Corresponding system emails have been automatically dispatched to the NGO's registered terminal gateway.</p>";

            message.setContent(getHtmlTemplate("Admin Operational Ledger", body), "text/html; charset=utf-8");
            Transport.send(message);
            return true;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    //  2. NGO OWN CONFIRMATION FOR CAMPAIGN CREATION
    public static boolean sendNGOCampaignConfirmation(String ngoEmail, String ngoName, String campaignTitle) {
        try {
            Message message = new MimeMessage(getSession());
            message.setFrom(new InternetAddress(FROM_EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(ngoEmail));
            message.setSubject("🌱 CARE LINK | Campaign Successfully Broadcaster Node");

            String body = "<p>Hello " + ngoName + ",</p>"
                    + "<p>Your new community support campaign has been successfully integrated onto the live network matrix:</p>"
                    + "<div style='border-left:4px solid #059669; padding-left:14px; margin:15px 0; background:#ECFDF5; padding-top:6px; padding-bottom:6px;'>"
                    + "  <b>Campaign Node:</b> " + campaignTitle + "<br>"
                    + "  <b>Operational Status:</b> ACTIVE / ACCEPTING DISPATCHES"
                    + "</div>"
                    + "<p>Global volunteers nearby have been notified, and tracking progress indicators have initialized on the main dashboard grid.</p>";

            message.setContent(getHtmlTemplate("Campaign Broadcast Sync", body), "text/html; charset=utf-8");
            Transport.send(message);
            return true;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    // 3. CAMPAIGN MILESTONE PROGRESS ALERT (50% / 100%)
    public static boolean sendCampaignMilestoneAlert(String ngoEmail, String campaignTitle, String milestonePercentage) {
        try {
            Message message = new MimeMessage(getSession());
            message.setFrom(new InternetAddress(FROM_EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(ngoEmail));
            message.setSubject("🚀 CARE LINK | Critical Campaign Milestone Reached!");

            String body = "<p>Attention Organizing Core,</p>"
                    + "<p>Your active community support campaign has achieved a significant milestone structural tier on the public ledger:</p>"
                    + "<div style='background:#FFFBEB; border:1px solid #FCD34D; padding:16px; border-radius:8px; margin:20px 0; text-align:center;'>"
                    + "  <h2 style='color:#D97706; margin:0 0 10px 0;'>" + milestonePercentage + " Funded/Supplied!</h2>"
                    + "  <p style='margin:0; font-weight:600; color:#92400E;'>" + campaignTitle + "</p>"
                    + "</div>"
                    + "<p>Progress graphics bars have synchronized to reflect this live impact metric update across public and volunteer grids.</p>";

            message.setContent(getHtmlTemplate("Ecosystem Milestone Node", body), "text/html; charset=utf-8");
            Transport.send(message);
            return true;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }


 //NEW VOLUNTEER JOIN ALERT TO NGO 
    public static boolean sendNGOVolunteerApplyAlert(String ngoEmail, String ngoName, String volunteerName, String campaignTitle) {
        try {
            Message message = new MimeMessage(getSession());
            message.setFrom(new InternetAddress(FROM_EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(ngoEmail));
            message.setSubject("🚨 CARE LINK | New Volunteer Application Received");

            String body = "<p>Hello " + ngoName + ",</p>"
                    + "<p>Great news! A certified changemaker has just applied to join your on-field operations team:</p>"
                    + "<div style='border-left:4px solid #10B981; padding-left:16px; margin:16px 0; background:#F8FAFC; padding-top:8px; padding-bottom:8px;'>"
                    + "  <b>Campaign Name:</b> " + campaignTitle + "<br>"
                    + "  <b>Volunteer Name:</b> " + volunteerName + "<br>"
                    + "  <b>Application Status:</b> PENDING REVIEW"
                    + "</div>"
                    + "<p>Please login to your CARE LINK NGO Dashboard Console to review their skills profile and approve the deployment allocation.</p>";

            message.setContent(getHtmlTemplate("New Field Resource Alert", body), "text/html; charset=utf-8");
            Transport.send(message);
            return true;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    //  NEW MATERIAL TRANSITION VERIFICATION TO DONOR 
    public static boolean sendDonorMaterialReceivedAlert(String donorEmail, String donorName, String materialDetails, String campaignTitle) {
        try {
            Message message = new MimeMessage(getSession());
            message.setFrom(new InternetAddress(FROM_EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(donorEmail));
            message.setSubject("📦 CARE LINK | Material Package Successfully Verified");

            String body = "<p>Hello " + donorName + ",</p>"
                    + "<p>We are pleased to inform you that your physical logistics contribution has safely arrived at the designated field station:</p>"
                    + "<div style='background:#F8FAFC; border:1px solid #E2E8F0; padding:16px; border-radius:8px; margin:20px 0;'>"
                    + "  <b>Supplies Verified:</b> <span style='color:#10B981; font-weight:700;'>" + materialDetails + "</span><br>"
                    + "  <b>Campaign Supported:</b> " + campaignTitle + "<br>"
                    + "  <b>Current Phase Status:</b> DELIVERED & COMPLETED"
                    + "</div>"
                    + "<p>The organizing NGO team has successfully logged these items inside their live registry. Thank you for your transparency and support!</p>";

            message.setContent(getHtmlTemplate("Supply Chain Verified Delivery", body), "text/html; charset=utf-8");
            Transport.send(message);
            return true;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }
}