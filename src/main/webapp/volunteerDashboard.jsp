<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    // Security check: Session validation to prevent direct URL sniffing
    if (session == null || session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp?msg=session_expired");
        return;
    }
    
    // Core data mappings fetched via VolunteerDashboardServlet
    Map<String, Object> stats = (Map<String, Object>) request.getAttribute("stats");
    List<Map<String, String>> myApplications = (List<Map<String, String>>) request.getAttribute("myApplications");
    List<Map<String, String>> feedPosts = (List<Map<String, String>>) request.getAttribute("feedPosts");
    List<Map<String, String>> allCampaigns = (List<Map<String, String>>) request.getAttribute("allCampaigns");
    
    // Safe-side null checks to avoid JSP runtime rendering exceptions
    int totalHours = (stats != null && stats.get("totalHours") != null) ? (int) stats.get("totalHours") : 0;
    int rewardPoints = (stats != null && stats.get("rewardPoints") != null) ? (int) stats.get("rewardPoints") : 0;
    int pendingRequests = (stats != null && stats.get("pendingRequests") != null) ? (int) stats.get("pendingRequests") : 0;
    int attendedCampaigns = (stats != null && stats.get("attendedCampaigns") != null) ? (int) stats.get("attendedCampaigns") : 0;
    
    String userName = (String) session.getAttribute("userName");
    // Tier validation rules based on points criteria
    String tierName = "Bronze Tier";
    String tierClass = "tier-bronze";
    String badgeTitle = "Community Novice";
    int pointsTarget = 500;
    
    if(rewardPoints > 500) {
        tierName = "Gold Tier";
        tierClass = "tier-gold";
        badgeTitle = "CARE LINK Champion";
        pointsTarget = 1000;
    } else if(rewardPoints > 100) {
        tierName = "Silver Tier";
        tierClass = "tier-silver";
        badgeTitle = "Impact Maker";
        pointsTarget = 500;
    }
    int progressPercent = (int)((rewardPoints / (double)pointsTarget) * 100);
    if(progressPercent > 100) progressPercent = 100;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CARE LINK | Volunteer Hub</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght=400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
    <link rel="stylesheet" href="css/volunteer.css">
</head>
<body>

<div class="v-dashboard-container">
    <aside class="v-sidebar">
        <div class="v-brand">
            <i class="fa-solid fa-heart-pulse"></i>
            <span class="v-brand-name">CARE LINK</span>
        </div>
        <nav class="v-nav-menu">
            <a href="#overview" class="v-nav-item active"><i class="fa-solid fa-chart-pie"></i> Overview</a>
            <a href="#feed-section" class="v-nav-item"><i class="fa-solid fa-rss"></i> Emergency Feed</a>
            <a href="#campaigns-section" class="v-nav-item"><i class="fa-solid fa-bullseye"></i> Explore Campaigns</a>
            <a href="#history-section" class="v-nav-item"><i class="fa-solid fa-list-check"></i> Applications Log</a>
            
            <a href="#profile-section" class="v-nav-item" style="color: #A7F3D0;"><i class="fa-solid fa-user-gear"></i> Account Settings</a>
            
            <a href="LogoutServlet" class="v-nav-item v-logout"><i class="fa-solid fa-right-from-bracket"></i> Sign Out</a>
        </nav>
    </aside>

    <main class="v-main-content">
      
        <header class="v-topbar">
            <div class="v-greeting">
                <h2>Welcome back, <%= userName != null ? userName : "Changemaker" %>! 👋</h2>
                <p>Your real-time dedication drives measurable neighborhood social impact.</p>
            </div>
            <div class="v-user-profile">
                <div class="v-avatar"><%= userName != null ? userName.substring(0,1).toUpperCase() : "V" %></div>
                <div class="v-meta">
                    <span class="v-username"><%= userName != null ? userName : "Volunteer" %></span>
                    <span class="v-role-badge">Verified Volunteer</span>
                </div>
            </div>
        </header>

        <div class="v-scroll-area">
            <div class="v-tab-content-container">
                
                <div id="tab-overview" class="spa-tab tab-active">
                    <div class="v-top-grid">
                        <div class="v-metrics-cards">
                            <div class="v-card">
                               <div class="v-card-icon c-blue"><i class="fa-solid fa-clock"></i></div>
                                <div class="v-card-info"><h3><%= totalHours %></h3><p>Impact Hours</p></div>
                            </div>
                             <div class="v-card">
                                <div class="v-card-icon c-green"><i class="fa-solid fa-circle-check"></i></div>
                                <div class="v-card-info"><h3><%= attendedCampaigns %></h3><p>Attended Campaigns</p></div>
                             </div>
                            <div class="v-card">
                                <div class="v-card-icon c-amber"><i class="fa-solid fa-spinner fa-spin-hover"></i></div>
                                <div class="v-card-info"><h3><%= pendingRequests %></h3><p>Pending Actions</p></div>
                            </div>
                            <div class="v-card">
                                <div class="v-card-icon c-purple"><i class="fa-solid fa-star"></i></div>
                                <div class="v-card-info"><h3><%= rewardPoints %></h3><p>Total Reward Points</p></div>
                            </div>
                        </div>

                        <div class="v-rewards-card">
                            <div class="v-rewards-header">
                                <h4>Rewards & Badges Pipeline</h4>
                               <span class="v-badge-tier <%= tierClass %>"><%= tierName %></span>
                            </div>
                            <div class="v-badge-showcase">
                                 <i class="fa-solid fa-shield-halved badge-graphic <%= tierClass %>-text"></i>
                                <div><h5><%= badgeTitle %></h5><p class="small-text">Current Achieved Social Rank</p></div>
                            </div>
                             <div class="v-progress-container">
                                <div class="v-progress-meta"><span>Progress Milestone</span><span><%= progressPercent %>%</span></div>
                                <div class="v-bar-track"><div class="v-bar-fill" style="width: <%= progressPercent %>%;"></div></div>
                             </div>
                            <button class="v-btn-download" <%= rewardPoints < 20 ? "disabled" : "" %> onclick="downloadBadgeCert();">
                                <i class="fa-solid fa-trophy"></i> Download Milestone Certificate
                            </button>
                        </div>
                     </div>
                    
                    <div class="v-right-pane" style="width: 100%;">
                        <div class="v-section">
                             <div class="v-section-header"><h3><i class="fa-solid fa-map-location-dot"></i> Regional Tactical Impact Map</h3></div>
                            <div id="volunteerMap"></div>
                        </div>
                    </div>
                 </div>

                <div id="tab-feed" class="spa-tab">
                    <section class="v-section">
                        <div class="v-section-header">
                            <h3><i class="fa-solid fa-fire-flame-curved text-danger"></i> Live Nearby Emergency Feed</h3>
                            <span class="pulse-indicator">● Live Parsing</span>
                        </div>
                        <div class="v-feed-list">
                             <% if(feedPosts == null || feedPosts.isEmpty()) { %>
                                <div class="v-empty"><i class="fa-solid fa-folder-open"></i><p>No immediate requirements in your range.</p></div>
                            <% } else { 
                               for(Map<String, String> post : feedPosts) { 
                                    String urgency = post.getOrDefault("urgency", "medium").toLowerCase();
                                    String urgencyBadge = "🔴 High";
                                    String borderHex = "#EF4444";
                                    
                                    if("medium".equals(urgency)) {
                                        urgencyBadge = "🟡 Medium";
                                        borderHex = "#F59E0B";
                                    } else if("low".equals(urgency)) {
                                        urgencyBadge = "🟢 Low";
                                        borderHex = "#10B981";
                                    }
                            %>
                                    <div class="v-feed-item" style="border-left: 4px solid <%= borderHex %>; background: #FFF; padding: 16px; border-radius: 8px; margin-bottom: 12px; box-shadow: 0 2px 4px rgba(0,0,0,0.02);">
                                         <div style="display:flex; justify-content:space-between; margin-bottom: 8px; font-size:11.5px; font-weight:700;">
                                            <span style="padding: 2px 8px; border-radius: 4px; background: #F1F5F9; color:#334155;"><%= urgencyBadge %> Priority</span>
                                             <span style="color: #94A3B8; font-weight: 500;"><i class="fa-solid fa-clock"></i> <%= post.getOrDefault("postedAt", post.get("createdAt")) %></span>
                                        </div>
                                         <p class="feed-content-body" style="margin: 0; font-size: 13.5px; color: #1E293B; font-weight: 500;"><%= post.get("content") %></p>
                                        <div style="margin-top: 10px; font-size: 11px; color: #64748B; font-weight: 600;">
										    <i class="fa-solid fa-building-ngo" style="color: var(--v-primary); margin-right: 4px;"></i> Broadcast By: <span style="color: #334155;"><%= post.get("ngoName") != null ? post.get("ngoName") : "Care Link Central" %></span>
										</div>
                                    </div>
                            <% } } %>
                         </div>
                    </section>
                </div>

                <div id="tab-campaigns" class="spa-tab">
                    <section class="v-section">
                         <div class="v-section-header">
                            <h3><i class="fa-solid fa-bullseye"></i> Explore Active Social Campaigns</h3>
                        </div>
                        
                         <div class="v-campaigns-container-grid" style="display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 20px;">
                            <% 
                                if (allCampaigns == null || allCampaigns.isEmpty()) { 
                             %>
                                <div class="v-empty" style="grid-column: 1/-1;">
                                    <i class="fa-solid fa-mountain"></i>
                                     <p>No active campaigns available at the moment. Check back soon!</p>
                                </div>
                            <% 
                                } else { 
                                    for (Map<String, String> camp : allCampaigns) { 
                                        String currentCampId = camp.get("id");
                                        boolean alreadyApplied = false;
                                         String applicationStatus = "";
                                        if (myApplications != null) {
                                             for (Map<String, String> myApp : myApplications) {
                                                if (currentCampId != null && currentCampId.equals(myApp.get("campaignId"))) {
                                                     alreadyApplied = true;
                                                     applicationStatus = myApp.getOrDefault("status", "PENDING").toUpperCase();
                                                    break;
                                                }
                                             }
                                        }
                             %>
                                <div class="v-campaign-card" style="background: #F8FAFC; border: 1px solid var(--v-border); padding: 18px; border-radius: 10px; display: flex; flex-direction: column; gap: 12px;">
                                     <div style="display: flex; justify-content: space-between; align-items: start;">
                                        <span style="font-size: 11px; background: var(--v-primary-light); color: var(--v-primary-dark); padding: 3px 8px; border-radius: 20px; font-weight: 700;"><%= camp.get("category") %></span>
                                         <span style="font-size: 11px; color: var(--v-slate-400); font-weight: 600;"><i class="fa-solid fa-location-dot"></i> <%= camp.get("city") %></span>
                                    </div>
                                    <h4 style="font-size: 15px; font-weight: 700; color: var(--v-slate-900); margin: 4px 0;"><%= camp.get("title") %></h4>
                                    <p style="font-size: 12.5px; color: var(--v-slate-700); line-height: 1.45; flex: 1;"><%= camp.get("description") %></p>
                                    <div style="font-size: 12px; color: var(--v-slate-400);">Organized by: <strong style="color: var(--v-slate-700);"><%= camp.get("ngoName")!= null ? camp.get("ngoName") : "CARE LINK Verified Partner" %></strong></div>
                                    <hr style="border: 0; border-top: 1px solid var(--v-border); margin: 8px 0;">
                                    
                                    <% if (alreadyApplied) { %>
                                         <div style="text-align: center; padding: 10px; border-radius: 6px; font-size: 12px; font-weight: 700; background: #F0FDF4; color: #16A34A; border: 1px dashed #BBF7D0;">
                                            <i class="fa-solid fa-circle-check"></i> Already Joined (<%= applicationStatus %>)
                                        </div>
                                     <% } else { %>
                                        <form method="post" action="JoinCampaignServlet" style="margin-top: 4px;" onsubmit="this.querySelector('button').disabled=true; this.querySelector('button').innerHTML='<i class=\'fa-solid fa-spinner fa-spin\'></i> Processing...';">
                                            <input type="hidden" name="campaignId" value="<%= currentCampId %>">
                                            <button type="submit" class="v-btn-download" style="width: 100%; background: var(--v-primary); font-size: 12px; padding: 10px; border-radius: 6px; border: none; color: white; font-weight: 600; cursor: pointer;">
                                                <i class="fa-solid fa-hand-holding-heart"></i> Join This Campaign
                                            </button>
                                         </form>
                                    <% } %>
                                 </div>
                            <% 
                                    } 
                                 } 
                            %>
                        </div>
                    </section>
                </div>

                <div id="tab-history" class="spa-tab">
                    <section class="v-section">
                        <div class="v-section-header"><h3><i class="fa-solid fa-clipboard-list"></i> Personal Application Verification Logs</h3></div>
                        <div class="v-table-wrapper">
                             <table class="v-data-table">
                                <thead>
                                    <tr><th>Targeted Campaign</th><th>Organizing NGO</th><th>Submission Date</th><th>Verification Status</th></tr>
                                 </thead>
                                <tbody>
                                    <% if(myApplications == null || myApplications.isEmpty()) { %>
                                        <tr><td colspan="4" class="text-center-empty">You haven't applied to any social campaigns yet.</td></tr>
                                    <% } else {
                                         for(Map<String, String> app : myApplications) { %>
                                       <tr>
									    <td><strong><%= app.get("campaignTitle") %></strong></td>
									    <td><%= app.get("ngoName") %></td>
									    <td><%= app.get("requestedAt") %></td>
									    <td>
									         <div style="display: flex; align-items: center; gap: 8px;">
									            <span class="status-pill status-<%= app.get("status").toLowerCase() %>"><%= app.get("status").toUpperCase() %></span>
									            
									            <% if ("completed".equalsIgnoreCase(app.get("status"))) { %>
									                <button class="v-btn-download" style="padding: 4px 8px; font-size: 11px; margin: 0; background: #0284C7;" onclick="downloadCampaignCert('<%= app.get("campaignTitle").replace("'", "\\'") %>')">
													    <i class="fa-solid fa-file-pdf"></i> Certificate
													</button>
									            <% } %>
									        </div>
									    </td>
									</tr>
                                    <% } } %>
                                 </tbody>
                            </table>
                        </div>
                    </section>
                 </div>

                <div id="tab-profile" class="spa-tab">
                    <section class="v-section" style="max-w: 600px; margin: 0 auto;">
                        <div class="v-section-header" style="border-bottom: 2px solid var(--v-border); padding-bottom: 12px; margin-bottom: 24px;">
                            <h3><i class="fa-solid fa-id-card" style="color: var(--v-primary);"></i> Modify Core Profile Node</h3>
                        </div>
                        
                        <form action="UpdateProfileServlet" method="POST" style="background: #FFFFFF; border: 1px solid var(--v-border); padding: 28px; border-radius: 12px; display: flex; flex-direction: column; gap: 20px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.02);">
                            <div>
                                <label style="display: block; text-transform: uppercase; font-size: 11px; font-weight: 700; color: #64748B; margin-bottom: 8px; letter-spacing: 0.5px;">Full Display Name</label>
                                <input type="text" name="fullName" value="<%= userName != null ? userName : "" %>" required style="width: 100%; border: 1px solid #CBD5E1; border-radius: 8px; padding: 12px 14px; font-size: 14px; color: #334155; outline: none; font-family: inherit;">
                            </div>
                            <div>
                                <label style="display: block; text-transform: uppercase; font-size: 11px; font-weight: 700; color: #64748B; margin-bottom: 8px; letter-spacing: 0.5px;">Contact Terminal (Phone)</label>
                                <input type="text" name="phone" placeholder="e.g. +91 9988776655" style="width: 100%; border: 1px solid #CBD5E1; border-radius: 8px; padding: 12px 14px; font-size: 14px; color: #334155; outline: none; font-family: inherit;">
                            </div>
                            <div>
                                <label style="display: block; text-transform: uppercase; font-size: 11px; font-weight: 700; color: #64748B; margin-bottom: 8px; letter-spacing: 0.5px;">City Jurisdiction Node</label>
                                <input type="text" name="city" placeholder="e.g. Indore" style="width: 100%; border: 1px solid #CBD5E1; border-radius: 8px; padding: 12px 14px; font-size: 14px; color: #334155; outline: none; font-family: inherit;">
                            </div>
                            
                            <div style="background: #F0FDF4; border: 1px solid #BBF7D0; border-radius: 8px; padding: 14px; font-size: 12px; color: #16A34A; line-height: 1.5; display: flex; gap: 10px; align-items: start; font-weight: 500;">
                                <i class="fa-solid fa-shield-halved" style="margin-top: 3px; font-size: 14px;"></i>
                                <span>Data syncs dynamically onto certificates and global platform registries upon transaction deployment commit.</span>
                            </div>
                            
                            <button type="submit" class="v-btn-download" style="width: 100%; background: var(--v-primary); border: none; font-size: 14px; padding: 12px; border-radius: 8px; color: white; font-weight: 700; cursor: pointer; text-align: center;">
                                <i class="fa-solid fa-circle-check"></i> Save Structural Profile Changes
                            </button>
                        </form>
                    </section>
                </div>

            </div>

            <footer class="footer" id="contact">
                <div style="display: grid; grid-template-columns: 2fr 1fr 1fr 1.5fr; gap: 32px;">
                    <div>
                        <h4><i class="fa-solid fa-heart-pulse"></i> CARE LINK</h4>
                        <p class="text-secondary">Connecting NGOs, Volunteers and Donors to build stronger communities together.</p>
                         <div class="social-icons">
                            <a href="#"><i class="fa-brands fa-facebook-f"></i></a>
                            <a href="#"><i class="fa-brands fa-x-twitter"></i></a>
                             <a href="#"><i class="fa-brands fa-instagram"></i></a>
                            <a href="#"><i class="fa-brands fa-linkedin-in"></i></a>
                        </div>
                    </div>
                     <div>
                        <h4>Quick Links</h4>
                        <ul class="list-unstyled footer-links">
                            <li><a href="index.jsp">Home</a></li>
                             <li><a href="index.jsp#features">Features</a></li>
                            <li><a href="index.jsp#community">Community</a></li>
                        </ul>
                    </div>
                     <div>
                        <h4>Get Involved</h4>
                        <ul class="list-unstyled footer-links">
                            <li><a href="register.jsp?role=volunteer">Become a Volunteer</a></li>
                             <li><a href="register.jsp?role=ngo">Register NGO</a></li>
                        </ul>
                    </div>
                    <div>
                         <h4>Contact Us</h4>
                        <ul class="list-unstyled footer-links" style="color: #D1FAE5; font-size: 13px;">
                            <li><i class="fa-solid fa-envelope"></i> support@carelink.org</li>
                            <li><i class="fa-solid fa-phone"></i> +91 98765 43210</li>
                            <li><i class="fa-solid fa-location-dot"></i> Indore, India</li>
                         </ul>
                    </div>
                </div>
                <hr class="footer-hr">
                <p class="text-center text-secondary">&copy; 2026 CARE LINK. All Rights Reserved.</p>
             </footer>
        </div> 
    </main> 
</div> 

<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
<script>
    function downloadCampaignCert(campaignName) {
      document.getElementById('cert-camp-title').textContent = campaignName;
      const element = document.getElementById('campaign-certificate-template');
      const opt = {
        margin:       0,
        filename:     'Campaign_Completion_Certificate_' + campaignName.replace(/\s+/g, '_') + '.pdf',
        image:        { type: 'jpeg', quality: 0.98 },
        html2canvas:  { scale: 2, useCORS: true, logging: false },
        jsPDF:        { unit: 'px', format: [842, 595], orientation: 'landscape' }
      };

      element.parentElement.style.display = 'block';
      html2pdf().set(opt).from(element).save().then(() => {
        element.parentElement.style.display = 'none';
      });
    }

    function downloadBadgeCert() {
      const element = document.getElementById('badge-certificate-template');
      const opt = {
        margin:       0,
        filename:     'CARE_LINK_Ecosystem_Milestone_Badge.pdf',
        image:        { type: 'jpeg', quality: 0.98 },
        html2canvas:  { scale: 2, useCORS: true, logging: false },
        jsPDF:        { unit: 'px', format: [842, 595], orientation: 'landscape' }
      };
      element.parentElement.style.display = 'block';
      html2pdf().set(opt).from(element).save().then(() => {
        element.parentElement.style.display = 'none';
      });
    }

    document.addEventListener("DOMContentLoaded", function() {
        var map = L.map('volunteerMap').setView([22.7196, 75.8577], 12);
        L.tileLayer('https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png').addTo(map);
        L.circleMarker([22.7196, 75.8577], { color: '#10B981', radius: 8 }).addTo(map);

        const navItems = document.querySelectorAll('.v-nav-item:not(.v-logout)');
        const tabs = document.querySelectorAll('.spa-tab');

        const targets = {
            '#overview': 'tab-overview',
            '#feed-section': 'tab-feed',
            '#campaigns-section': 'tab-campaigns',
            '#history-section': 'tab-history',
            '#profile-section': 'tab-profile' // ✅ TAB TARGET MAPPED CORRECTLY
        };

        navItems.forEach(item => {
            item.addEventListener('click', function(e) {
                const href = this.getAttribute('href');
                if(!targets[href]) return;
                 
                e.preventDefault();
                navItems.forEach(i => i.classList.remove('active'));
                this.classList.add('active');

                tabs.forEach(t => t.classList.remove('tab-active'));
                document.getElementById(targets[href]).classList.add('tab-active');
                
                if(href === '#overview') {
                    setTimeout(() => { map.invalidateSize(); }, 200);
                }
            });
        });

        // ─── URL PARAM ALERT MANAGER ───
        const urlParams = new URLSearchParams(window.location.search);
        if (urlParams.get('success') === 'applied') {
            alert("Success! Your application to join the campaign has been recorded dynamically. 🚀");
            navItems.forEach(i => i.classList.remove('active'));
            tabs.forEach(t => t.classList.remove('tab-active'));
            
            const historyLink = document.querySelector('a[href="#history-section"]');
            if(historyLink) historyLink.classList.add('active');
            
            const historyTab = document.getElementById('tab-history');
            if(historyTab) historyTab.classList.add('tab-active');
            window.history.replaceState({}, document.title, window.location.pathname);
        }
        
        // ✅ REFRESH INTERCEPTOR FOR SUCCESSFUL PROFILE SAVES
        if (urlParams.get('profile') === 'updated') {
            alert("🎉 Account Settings synchronized and saved successfully!");
            window.history.replaceState({}, document.title, window.location.pathname);
        }
    });
</script>

<div style="display: none;">
    <div id="campaign-certificate-template" style="width: 842px; height: 595px; padding: 45px; background: #FFFFFF; font-family: 'Plus Jakarta Sans', sans-serif; border: 12px solid #0284C7; box-sizing: border-box; position: relative;">
        <div style="border: 1px solid #E2E8F0; width: 100%; height: 100%; padding: 35px; box-sizing: border-box; position: relative; text-align: center; background: #FAFCFF;">
            <div style="color: #0C4A6E; font-weight: 700; font-size: 22px; letter-spacing: 1px; display: flex; align-items: center; justify-content: center; gap: 8px; margin-bottom: 5px;">
                <span style="color: #0284C7;"><i class="fa-solid fa-heart-pulse"></i></span> CARE LINK
            </div>
            <div style="font-size: 11px; text-transform: uppercase; letter-spacing: 2px; color: #64748B; font-weight: 600; margin-bottom: 30px;">Official Certificate of Service</div>
            <h1 style="font-family: 'Georgia', serif; font-size: 36px; font-weight: 500; color: #1E293B; margin: 0 0 20px 0;">Certificate of Appreciation</h1>
            <p style="font-size: 15px; color: #475569; margin-bottom: 30px;">This certificate is proudly presented to</p>
            <div style="font-size: 28px; font-weight: 700; color: #0C4A6E; border-bottom: 2px solid #0284C7; display: inline-block; padding: 0 20px 6px 20px; margin-bottom: 30px;">
                <%= userName != null ? userName : "Verified Volunteer" %>
            </div>
            <p style="font-size: 15px; color: #334155; line-height: 1.6; max-width: 620px; margin: 0 auto 40px auto;">
                in recognition of their dedicated voluntary service and valuable contribution to the community drive:
                <br><strong style="color: #0284C7; font-size: 18px; display: block; margin-top: 10px;" id="cert-camp-title">Social Welfare Drive</strong>
            </p>
            <div style="display: flex; justify-content: space-between; align-items: flex-end; padding: 0 20px; position: absolute; bottom: 35px; left: 35px; right: 35px;">
                <div style="text-align: left;">
                    <div style="font-size: 10px; color: #94A3B8; font-weight: 600; letter-spacing: 0.5px;">VERIFICATION ID</div>
                    <div style="font-family: monospace; font-size: 11px; color: #0C4A6E; font-weight: 700;">CL-CAMP-<%= new Random().nextInt(90000) + 10000 %></div>
                </div>
                <div style="text-align: center; border-top: 1px solid #CBD5E1; width: 180px; padding-top: 6px;">
                    <div style="font-size: 13px; font-weight: 600; color: #1E293B;">NGO Project Leader</div>
                    <div style="font-size: 11px; color: #64748B; margin-top: 2px;">CARE LINK Verified Partner</div>
                </div>
            </div>
        </div>
    </div>
</div>

<div style="display: none;">
    <div id="badge-certificate-template" style="width: 842px; height: 595px; padding: 45px; background: #FFFFFF; font-family: 'Plus Jakarta Sans', sans-serif; border: 12px solid #10B981; box-sizing: border-box; position: relative;">
        <div style="border: 1px solid #E2E8F0; width: 100%; height: 100%; padding: 35px; box-sizing: border-box; position: relative; text-align: center; background: #FAFFF8;">
            <div style="color: #093E2A; font-weight: 700; font-size: 22px; letter-spacing: 1px; display: flex; align-items: center; justify-content: center; gap: 8px; margin-bottom: 5px;">
                <span style="color: #10B981;"><i class="fa-solid fa-heart-pulse"></i></span> CARE LINK
            </div>
            <div style="font-size: 11px; text-transform: uppercase; letter-spacing: 2px; color: #64748B; font-weight: 600; margin-bottom: 15px;">Official Milestone Achievement</div>
            <div style="margin-bottom: 15px;">
                <i class="fa-solid fa-shield-halved <%= tierClass %>-text" style="font-size: 48px; filter: drop-shadow(0 4px 6px rgba(0,0,0,0.06));"></i>
                <div style="font-size: 13px; font-weight: 700; color: #093E2A; text-transform: uppercase; margin-top: 5px; letter-spacing: 1px;"><%= tierName %></div>
            </div>
            <h1 style="font-family: 'Georgia', serif; font-size: 34px; font-weight: 500; color: #1E293B; margin: 0 0 15px 0;">Milestone Achievement Award</h1>
            <p style="font-size: 14px; color: #475569; margin-bottom: 20px;">This honor is proudly awarded to</p>
            <div style="font-size: 28px; font-weight: 700; color: #093E2A; border-bottom: 2px solid #10B981; display: inline-block; padding: 0 20px 6px 20px; margin-bottom: 25px;">
                <%= userName != null ? userName : "Verified Volunteer" %>
            </div>
            <p style="font-size: 15px; color: #334155; line-height: 1.6; max-width: 600px; margin: 0 auto 35px auto;">
                for outstanding community support, completing a total of <strong><%= totalHours %> Service Hours</strong> and reaching the recognized rank standing of 
                <br><span style="color: #10B981; font-weight: 700; font-size: 18px; text-transform: uppercase; display: block; margin-top: 8px;"><%= badgeTitle %></span>
            </p>
            <div style="display: flex; justify-content: space-between; align-items: flex-end; padding: 0 20px; position: absolute; bottom: 35px; left: 35px; right: 35px;">
                <div style="text-align: left;">
                    <div style="font-size: 10px; color: #94A3B8; font-weight: 600; letter-spacing: 0.5px;">VERIFICATION ID</div>
                    <div style="font-family: monospace; font-size: 11px; color: #093E2A; font-weight: 700;">CL-RANK-<%= tierClass.substring(5).toUpperCase() %>-2026</div>
                </div>
                <div style="text-align: center; border-top: 1px solid #CBD5E1; width: 180px; padding-top: 6px;">
                    <div style="font-size: 13px; font-weight: 600; color: #1E293B;">Platform Administrator</div>
                    <div style="font-size: 11px; color: #64748B; margin-top: 2px;">CARE LINK Operations Team</div>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>