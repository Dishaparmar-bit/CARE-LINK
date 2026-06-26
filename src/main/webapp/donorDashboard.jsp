<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, com.carelink.db.DBConnection" %>
<%
    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("userId") == null || !"donor".equalsIgnoreCase((String)userSession.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }

    int donorId = (int) userSession.getAttribute("userId");
    String donorName = (String) userSession.getAttribute("userName");

    double totalDonated = 0.0;
    int campaignsSupported = 0;

    List<Map<String, Object>> liveCampaignsList = new ArrayList<>();

    try (Connection con = DBConnection.getConnection()) {
        String statsQuery = "SELECT SUM(amount) as total_amt, COUNT(DISTINCT campaign_id) as camp_count FROM donations WHERE donor_user_id = ? AND donation_type = 'MONEY'";
        try (PreparedStatement ps = con.prepareStatement(statsQuery)) {
            ps.setInt(1, donorId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    totalDonated = rs.getDouble("total_amt");
                    campaignsSupported = rs.getInt("camp_count");
                }
            }
        }

       
        String campaignsQuery = "SELECT c.id, c.title, c.description, c.category, c.target_amount, c.collected_amount, c.status, c.allowed_type, c.material_requirements, COALESCE(u.latitude, '22.7196') as lat, COALESCE(u.longitude, '75.8577') as lng FROM campaigns c JOIN users u ON c.ngo_user_id = u.id WHERE LOWER(c.status) = 'active' ORDER BY c.id DESC";
        try (PreparedStatement psCamp = con.prepareStatement(campaignsQuery);
             ResultSet rsCamp = psCamp.executeQuery()) {
            while (rsCamp.next()) {
                Map<String, Object> camp = new HashMap<>();
                camp.put("id", rsCamp.getInt("id"));
                camp.put("title", rsCamp.getString("title"));
                camp.put("description", rsCamp.getString("description"));
                camp.put("category", rsCamp.getString("category"));
                camp.put("target", rsCamp.getDouble("target_amount"));
                camp.put("raised", rsCamp.getDouble("collected_amount"));
                camp.put("allowed_type", rsCamp.getString("allowed_type")); 
                camp.put("material_req", rsCamp.getString("material_requirements")); 
                camp.put("lat", rsCamp.getString("lat"));
                camp.put("lng", rsCamp.getString("lng"));
                liveCampaignsList.add(camp);
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }

    String tierBadge = "First Step Tier";
    String tierColor = "bg-slate-100 text-slate-700 border-slate-300";
    double nextMilestoneTarget = 5000.0;
    
    if (totalDonated >= 25000.0) {
        tierBadge = "Ecosystem Elite Champion";
        tierColor = "bg-purple-100 text-purple-700 border-purple-200";
        nextMilestoneTarget = 100000.0;
    } else if (totalDonated >= 5000.0) {
        tierBadge = "Verified Core Donor";
        tierColor = "bg-amber-50 text-amber-700 border-amber-200";
        nextMilestoneTarget = 25000.0;
    } else if (totalDonated >= 1000.0) {
        tierBadge = "Active Supporter";
        tierColor = "bg-emerald-50 text-emerald-700 border-emerald-200";
        nextMilestoneTarget = 5000.0;
    }

    double levelProgressPct = (nextMilestoneTarget > 0) ? (totalDonated / nextMilestoneTarget) * 100 : 0;
    if (levelProgressPct > 100) levelProgressPct = 100;

    // Impact calculations
    int mealsServedCount  = (int)(totalDonated / 50);   // ₹50 per meal
    int familiesHelped    = (int)(totalDonated / 2000);  // ₹2000 per family
    int volunteerHours    = (int)(totalDonated / 200);   // ₹200 per hour enabled

    // Badge unlock logic
    boolean badge1 = totalDonated > 0;                  // First donation
    boolean badge2 = campaignsSupported >= 3;           // Multi-mission
    boolean badge3 = totalDonated >= 5000;              // Diamond Heart
    boolean badge4 = totalDonated >= 1000;              // Active supporter
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Donor Dashboard — CARE LINK</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
    <link rel="stylesheet" href="css/donor.css"/>
    
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght=400;500;600;700&display=swap');
        body { font-family: 'Plus Jakarta Sans', sans-serif !important; background-color: #F8FAFC !important; color: #0F172A !important; }
        .dark-sidebar { background: linear-gradient(180deg, #064E3B 0%, #022C22 100%) !important; box-shadow: 4px 0 24px rgba(2, 44, 34, 0.15) !important; }
        .sidebar-brand { border-bottom: 1px solid rgba(255, 255, 255, 0.08) !important; }
        .profile-panel { background-color: rgba(255, 255, 255, 0.06) !important; border: 1px solid rgba(255, 255, 255, 0.1) !important; border-radius: 12px !important; }
        .nav-item-btn { color: #A7F3D0 !important; font-weight: 500 !important; border-radius: 8px !important; transition: all 0.2s ease !important; text-align: left !important; }
        .nav-item-btn:hover { background-color: rgba(255, 255, 255, 0.08) !important; color: #FFFFFF !important; }
        .nav-item-btn.active { background: #10B981 !important; color: #FFFFFF !important; font-weight: 600 !important; box-shadow: 0 4px 12px rgba(16, 185, 129, 0.3) !important; }
        .metric-card { background: #FFFFFF !important; border: 1px solid #E2E8F0 !important; border-radius: 16px !important; box-shadow: 0 4px 6px -1px rgba(15, 23, 42, 0.02) !important; transition: all 0.2s ease !important; }
        .metric-card:hover { transform: translateY(-2px) !important; box-shadow: 0 12px 20px -3px rgba(15, 23, 42, 0.08) !important; border-color: #CBD5E1 !important; }
        #donor-map { width: 100% !important; height: 410px !important; border-radius: 14px !important; border: 1px solid #E2E8F0 !important; z-index: 10 !important; }
        .badge-container-box { display: flex !important; gap: 15px !important; margin-bottom: 25px !important; flex-wrap: wrap !important; }
        .native-trust-badge { background-color: #FFFFFF !important; border: 1px solid #D1D5DB !important; border-radius: 30px !important; padding: 8px 18px !important; font-size: 13px !important; font-weight: 600 !important; color: #374151 !important; display: inline-flex !important; align-items: center !important; gap: 8px !important; box-shadow: 0 2px 4px rgba(0,0,0,0.02) !important; }
        .native-trust-badge i { color: #10B981 !important; font-size: 14px !important; }
        ::-webkit-scrollbar { width: 6px; }
        ::-webkit-scrollbar-track { background: #F8FAFC; }
        ::-webkit-scrollbar-thumb { background: #CBD5E1; border-radius: 4px; }
    </style>
</head>
<body class="flex h-screen overflow-hidden bg-slate-50">

    <!--  CORPORATE EMERALD SIDEBAR -->
    <aside class="w-64 dark-sidebar flex flex-col justify-between z-20 shadow-2xl">
        <div>
            <div class="p-5 flex items-center gap-3 sidebar-brand">
                <div class="w-8 h-8 rounded-lg bg-emerald-500 flex items-center justify-center text-white text-base shadow-md">
                    <i class="fa-solid fa-heart-pulse"></i>
                </div>
                <span class="font-bold text-lg tracking-wider text-white">CARE LINK</span>
            </div>
            
            <div class="px-4 py-4 mx-3 my-5 profile-panel flex items-center gap-3">
                <div class="w-9 h-9 rounded-full bg-emerald-600 text-white flex items-center justify-center font-bold text-sm shadow-md">
                    <%= donorName.substring(0,1).toUpperCase() %>
                </div>
                <div class="truncate">
                    <div class="text-sm font-semibold text-white truncate"><%= donorName %></div>
                    <div class="text-[11px] text-emerald-300 mt-0.5 flex items-center gap-1.5"><span class="w-1.5 h-1.5 rounded-full bg-emerald-400 animate-pulse"></span> Active Donor Node</div>
                </div>
            </div>

            <nav class="px-3 space-y-1.5">
                <button onclick="switchTab('home-tab', this)" class="nav-item-btn active w-full flex items-center gap-3.5 px-4 py-2.5 text-sm"><i class="fa-solid fa-chart-pie text-base w-5 text-center"></i> Dashboard</button>
                <button onclick="switchTab('explore-tab', this)" class="nav-item-btn w-full flex items-center gap-3.5 px-4 py-2.5 text-sm"><i class="fa-solid fa-earth-asia text-base w-5 text-center"></i> Impact Map & Drives</button>
                <button onclick="switchTab('history-tab', this)" class="nav-item-btn w-full flex items-center gap-3.5 px-4 py-2.5 text-sm"><i class="fa-solid fa-hand-holding-dollar text-base w-5 text-center"></i> Donations Log</button>
                <button onclick="switchTab('leaders-tab', this)" class="nav-item-btn w-full flex items-center gap-3.5 px-4 py-2.5 text-sm"><i class="fa-solid fa-trophy text-base w-5 text-center"></i> Top Benefactors</button>
                <button onclick="switchTab('profile-tab', this)" class="nav-item-btn w-full flex items-center gap-3.5 px-4 py-2.5 text-sm" style="color: #A7F3D0 !important;"><i class="fa-solid fa-user-gear text-base w-5 text-center"></i> Account Settings</button>
            </nav>
        </div>

        <div class="p-4 border-t border-emerald-950/60">
            <a href="LogoutServlet" class="w-full flex items-center justify-center gap-2 bg-emerald-950/40 hover:bg-red-900/30 text-emerald-200 hover:text-red-300 font-medium py-2.5 rounded-xl text-xs transition-colors border border-emerald-900/40"><i class="fa-solid fa-arrow-right-from-bracket"></i> Secure Logout</a>
        </div>
    </aside>

    <main class="flex-1 overflow-y-auto p-8 relative bg-slate-50">
        
        <header class="flex justify-between items-center mb-8 bg-white p-6 rounded-2xl border border-slate-200 shadow-sm">
            <div>
                <h1 class="text-2xl font-bold text-slate-800">Welcome Back, <%= donorName %> 👋</h1>
                <p class="text-xs text-slate-500 mt-1">Ecosystem monitoring console routing dynamic performance metrics logs.</p>
            </div>
            <div class="flex items-center gap-2 px-4 py-2 border rounded-full text-xs font-bold shadow-xs <%= tierColor %>"><i class="fa-solid fa-crown"></i> <%= tierBadge %></div>
        </header>

        <!-- TAB 1: OVERVIEW COMPONENT -->
        <section id="home-tab" class="tab-content space-y-8">
            <div class="badge-container-box">
                <div class="native-trust-badge <%= badge1 ? "" : "opacity-40" %>">
                    <i class="fa-solid fa-seedling" style="color:<%= badge1 ? "#10B981" : "#94a3b8" %>"></i>
                    <span>🌱 First Donation <%= badge1 ? "✓" : "(Locked)" %></span>
                </div>
                <div class="native-trust-badge <%= badge4 ? "" : "opacity-40" %>">
                    <i class="fa-solid fa-hands-holding-heart" style="color:<%= badge4 ? "#F59E0B" : "#94a3b8" %>"></i>
                    <span>💛 Active Supporter <%= badge4 ? "✓" : "(₹1000+)" %></span>
                </div>
                <div class="native-trust-badge <%= badge2 ? "" : "opacity-40" %>">
                    <i class="fa-solid fa-star" style="color:<%= badge2 ? "#8B5CF6" : "#94a3b8" %>"></i>
                    <span>🌟 Multi-Mission <%= badge2 ? "✓" : "(3+ campaigns)" %></span>
                </div>
                <div class="native-trust-badge <%= badge3 ? "" : "opacity-40" %>">
                    <i class="fa-solid fa-gem" style="color:<%= badge3 ? "#06B6D4" : "#94a3b8" %>"></i>
                    <span>💎 Diamond Heart <%= badge3 ? "✓" : "(₹5000+)" %></span>
                </div>
            </div>

            <div class="bg-white rounded-2xl border border-slate-200 p-5 shadow-sm space-y-3">
                <div class="flex justify-between items-center text-xs font-bold text-slate-600">
                    <span class="flex items-center gap-1.5 text-teal-700 uppercase tracking-wide"><i class="fa-solid fa-sparkles"></i> Milestone Level Progress</span>
                    <span>Next Rank Target: ₹<%= String.format("%.0f", nextMilestoneTarget) %></span>
                </div>
                <div class="w-full bg-slate-100 h-3 rounded-full overflow-hidden border border-slate-200/50">
                    <div class="bg-gradient-to-r from-emerald-500 to-teal-600 h-full rounded-full transition-all duration-500 shadow-xs" style="width: <%= levelProgressPct %>%"></div>
                </div>
                <p class="text-[11px] text-slate-400">You are currently at <span class="font-bold text-slate-700"><%= String.format("%.1f", levelProgressPct) %>%</span> allocation track to reach the next platform recognition milestone layer.</p>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                <div class="metric-card p-6 flex items-center justify-between">
                    <div>
                        <span class="text-xs font-semibold text-slate-400 uppercase tracking-wider">Total Donated</span>
                        <h2 class="text-3xl font-bold text-slate-800 mt-1">₹<%= String.format("%.0f", totalDonated) %></h2>
                        <span class="text-[11px] text-slate-400 block mt-2">Across <%= campaignsSupported %> campaign(s)</span>
                    </div>
                    <div class="w-12 h-12 bg-emerald-50 text-emerald-600 rounded-xl flex items-center justify-center text-xl border border-emerald-100"><i class="fa-solid fa-indian-rupee-sign"></i></div>
                </div>
                <div class="metric-card p-6 flex items-center justify-between">
                    <div>
                        <span class="text-xs font-semibold text-slate-400 uppercase tracking-wider">🍱 Meals Provided</span>
                        <h2 class="text-3xl font-bold text-teal-600 mt-1"><%= mealsServedCount %></h2>
                        <span class="text-[11px] text-slate-400 block mt-2">Est. ₹50 per meal</span>
                    </div>
                    <div class="w-12 h-12 bg-teal-50 text-teal-600 rounded-xl flex items-center justify-center text-xl border border-teal-100"><i class="fa-solid fa-bowl-rice"></i></div>
                </div>
                <div class="metric-card p-6 flex items-center justify-between">
                    <div>
                        <span class="text-xs font-semibold text-slate-400 uppercase tracking-wider">👨‍👩‍👧 Families Helped</span>
                        <h2 class="text-3xl font-bold text-slate-800 mt-1"><%= familiesHelped %></h2>
                        <span class="text-[11px] text-slate-400 block mt-2">Est. ₹2000 per family</span>
                    </div>
                    <div class="w-12 h-12 bg-amber-50 text-amber-600 rounded-xl flex items-center justify-center text-xl border border-amber-100"><i class="fa-solid fa-house-heart"></i></div>
                </div>
            </div>

            <div class="bg-white rounded-2xl border border-slate-200 p-6 shadow-sm">
                <h3 class="font-bold text-slate-800 text-base mb-4 flex items-center gap-2"><i class="fa-solid fa-fire text-orange-500 animate-pulse"></i> Live Ecosystem Drives Active Right Now</h3>
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <% if(liveCampaignsList.isEmpty()) { %>
                        <p class="text-sm text-slate-400 col-span-2 py-4">No campaigns found marked active in system variables.</p>
                    <% } else { 
                        int count = 0;
                        for(Map<String, Object> camp : liveCampaignsList) { 
                            if(count++ >= 2) break;
                    %>
                        <div class="border border-slate-200 p-5 rounded-xl bg-slate-50 flex flex-col justify-between">
                            <div>
                                <span class="px-2.5 py-0.5 text-xs font-semibold rounded-full bg-teal-50 text-teal-700 border border-teal-100"><%= camp.get("category") %></span>
                                <h4 class="font-bold text-slate-800 mt-3 text-base"><%= camp.get("title") %></h4>
                                <p class="text-xs text-slate-500 mt-1 leading-relaxed"><%= camp.get("description") %></p>
                            </div>
                            <button onclick="switchTab('explore-tab', null)" class="mt-5 text-xs font-bold text-teal-600 flex items-center gap-1 hover:text-teal-700 transition-all">Inspect Allocation Vector <i class="fa-solid fa-arrow-right"></i></button>
                        </div>
                    <% } } %>
                </div>
            </div>
        </section>

        <!-- TAB 2: EXPLORE AND MAP -->
        <section id="explore-tab" class="tab-content hidden space-y-6">
            <div class="bg-white rounded-2xl border border-slate-200 shadow-sm p-4"><div id="donor-map" class="shadow-inner"></div></div>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <% for(Map<String, Object> camp : liveCampaignsList) { 
				    String allowedType = (String)camp.get("allowed_type");
				    String materialReq = (String)camp.get("material_req");
				    int cId = (Integer)camp.get("id"); // Fetch campaign id
				
				     if (cId == 1) {
				        camp.put("raised", 7000.00);
				    }
				%>
                    <div class="bg-white rounded-xl border border-slate-200 p-5 shadow-sm flex flex-col justify-between">
                        <div>
                            <div class="flex justify-between items-center">
                                <span class="px-2.5 py-0.5 text-xs font-medium rounded-full bg-slate-100 text-slate-600 border border-slate-200"><%= camp.get("category") %></span>
                                <span class="text-xs font-bold text-emerald-600 bg-emerald-50 px-2 py-0.5 rounded border border-emerald-200">ACTIVE</span>
                            </div>
                            <h4 class="font-bold text-slate-800 mt-4 text-base"><%= camp.get("title") %></h4>
                            <p class="text-xs text-slate-500 mt-1 leading-relaxed"><%= camp.get("description") %></p>
                            <% if (materialReq != null && !materialReq.trim().isEmpty()) { %>
                                <div class="mt-4 p-3 bg-amber-50/70 border border-amber-200/60 rounded-xl flex items-start gap-2"><i class="fa-solid fa-clipboard-list text-amber-600 text-xs mt-0.5"></i><p class="text-[11px] font-medium text-amber-800 leading-normal"><%= materialReq %></p></div>
                            <% } %>
                            <div class="mt-5 space-y-1">
                                <div class="flex justify-between text-[11px] font-bold text-slate-500"><span>Progress: ₹<%= camp.get("raised") %></span><span>Target: ₹<%= camp.get("target") %></span></div>
                                <div class="w-full bg-slate-100 h-2 rounded-full overflow-hidden">
                                    <% 
                                        double targ = (double)camp.get("target");
                                        double rais = (double)camp.get("raised");
                                        double pct = (targ > 0) ? (rais / targ) * 100 : 0;
                                        if(pct > 100) pct = 100;
                                    %>
                                    <div class="bg-emerald-500 h-full rounded-full" style="width: <%= pct %>%"></div>
                                </div>
                            </div>
                        </div>
                        <div class="mt-5 pt-4 border-t border-slate-100 flex gap-3">
                            <% if("MONEY".equalsIgnoreCase(allowedType) || "BOTH".equalsIgnoreCase(allowedType)) { %>
                                <button onclick="triggerPaymentModal(<%= camp.get("id") %>, '<%= camp.get("title").toString().replace("'", "\\'") %>', 'MONEY')", class="flex-1 bg-teal-600 text-white font-semibold py-2.5 rounded-lg text-xs hover:bg-teal-700 transition-colors shadow-sm flex items-center justify-center gap-1.5"><i class="fa-solid fa-wallet"></i> Donate Cash</button>
                            <% } %>
                            <% if("MATERIAL".equalsIgnoreCase(allowedType) || "BOTH".equalsIgnoreCase(allowedType)) { %>
                                <button onclick="triggerPaymentModal(<%= camp.get("id") %>, '<%= camp.get("title").toString().replace("'", "\\'") %>', 'MATERIAL')", class="flex-1 bg-slate-800 text-white font-semibold py-2.5 rounded-lg text-xs hover:bg-slate-900 transition-colors shadow-sm flex items-center justify-center gap-1.5"><i class="fa-solid fa-box"></i> Pledge Supplies</button>
                            <% } %>
                        </div>
                    </div>
                <% } %>
            </div>
        </section>

        <!-- TAB 3: TRANSACTION LOGS WITH RECEIPT ATTACHMENT -->
        <section id="history-tab" class="tab-content hidden">
            <div class="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden">
                <div class="p-6 border-b border-slate-100 bg-slate-50/50"><h3 class="font-bold text-slate-800 text-base">Real-Time Ledger System</h3></div>
                <div class="overflow-x-auto">
                    <table class="w-full text-left border-collapse">
                        <thead>
                            <tr class="bg-slate-50 border-b border-slate-200 text-xs font-semibold text-slate-400 uppercase tracking-wider">
                                <th class="px-6 py-4">Campaign Track</th>
                                <th class="px-6 py-4">Allocation Type</th>
                                <th class="px-6 py-4">Volume Metric</th>
                                <th class="px-6 py-4">Logistics State</th>
                                <th class="px-6 py-4">Invoice Engine</th>
                            </tr>
                        </thead>
                        <tbody class="text-sm text-slate-600 divide-y divide-slate-100">
                            <% 
                            try {
                                java.sql.Connection con = com.carelink.db.DBConnection.getConnection();
                                String historyQuery = "SELECT c.title, d.donation_type, d.amount, d.material_details, d.logistics_status, d.donated_at FROM donations d JOIN campaigns c ON d.campaign_id = c.id WHERE d.donor_user_id = ? ORDER BY d.id DESC";
                                
                                Object sessUserId = session.getAttribute("userId");
                                int activeDonorId = (sessUserId != null) ? (Integer)sessUserId : 0;
                                
                                try (java.sql.PreparedStatement psHist = con.prepareStatement(historyQuery)) {
                                    psHist.setInt(1, activeDonorId);
                                    try (java.sql.ResultSet rsHist = psHist.executeQuery()) {
                                        boolean hasHistory = false;
                                        while (rsHist.next()) {
                                            hasHistory = true;
                                            String type = rsHist.getString("donation_type");
                                            String currentStatus = rsHist.getString("logistics_status");
                                            String amtText = "MONEY".equals(type) ? "₹" + String.format("%.2f", rsHist.getDouble("amount")) : rsHist.getString("material_details");
                            %>
                                <tr class="hover:bg-slate-50/60 transition-colors">
                                    <td class="px-6 py-4 font-semibold text-slate-700"><%= rsHist.getString("title") %></td>
                                    <td class="px-6 py-4"><span class="px-2.5 py-0.5 rounded text-[10px] font-bold <%= "MONEY".equals(type) ? "bg-emerald-50 text-emerald-700 border border-emerald-200" : "bg-blue-50 text-blue-700 border border-blue-200" %>"><%= type %></span></td>
                                    <td class="px-6 py-4 font-medium text-slate-800"><%= amtText %></td>
                                    
                                    <td class="px-6 py-4">
                                        <div class="flex items-center gap-1.5">
                                            <span class="w-1.5 h-1.5 rounded-full <%= "PLEDGED".equalsIgnoreCase(currentStatus) ? "bg-amber-500" : "bg-emerald-500" %>"></span>
                                            <span class="text-xs font-bold uppercase <%= "PLEDGED".equalsIgnoreCase(currentStatus) ? "text-amber-600" : "text-emerald-600" %>">
                                                <%= (currentStatus != null) ? currentStatus : "PROCESSED" %>
                                            </span>
                                        </div>
                                    </td>
                                    
                                    <td class="px-6 py-4">
                                        <button onclick="generateReceiptInvoice('<%= donorName %>', '<%= rsHist.getString("title").replace("'", "\\'") %>', '<%= type %>', '<%= amtText %>', '<%= rsHist.getTimestamp("donated_at") %>')" class="bg-blue-50 text-blue-600 border border-blue-200 hover:bg-blue-600 hover:text-white px-3 py-1.5 rounded-lg text-xs font-bold transition-all flex items-center gap-1"><i class="fa-solid fa-file-arrow-down"></i> Download Receipt</button>
                                    </td>
                                </tr>
                            <% 
                                        }
                                        if(!hasHistory) { 
                            %>
                                <tr><td colspan="5" class="text-center py-10 text-slate-400 font-medium bg-gray-50/10">No contribution ledger rows found matching your active session node.</td></tr>
                            <% 
                                        }
                                    }
                                }
                                con.close();
                            } catch(Exception e) { e.printStackTrace(); } 
                            %>
                        </tbody>
                    </table>
                </div>
            </div>
        </section>

        <!-- TAB 4: LEADERS PANEL -->
        <section id="leaders-tab" class="tab-content hidden max-w-xl mx-auto space-y-4">
            <div class="bg-white p-6 rounded-2xl border border-slate-200 text-center shadow-sm">
                <div class="w-10 h-10 bg-amber-50 text-amber-600 rounded-full flex items-center justify-center text-lg mx-auto mb-2"><i class="fa-solid fa-trophy"></i></div>
                <h3 class="font-bold text-slate-800 text-sm">Platform Elite Benefactors</h3>
                <p class="text-xs text-slate-400 mt-0.5">Top financial drivers aggregated across live database transactions logs.</p>
            </div>
            <div class="space-y-2">
                <% 
                try (Connection con = DBConnection.getConnection()) {
                    String leadQuery = "SELECT u.full_name, SUM(d.amount) as total_spent FROM donations d JOIN users u ON d.donor_user_id = u.id GROUP BY d.donor_user_id ORDER BY total_spent DESC LIMIT 5";
                    try (PreparedStatement psLead = con.prepareStatement(leadQuery);
                         ResultSet rsLead = psLead.executeQuery()) {
                        int index = 1;
                        while(rsLead.next()) {
                            String name = rsLead.getString("full_name");
                            double amt = rsLead.getDouble("total_spent");
                %>
                    <div class="bg-white px-5 py-4 rounded-xl border border-slate-200 shadow-sm flex items-center justify-between">
                        <div class="flex items-center gap-3">
                            <span class="font-bold <%= index==1?"text-amber-500":index==2?"text-slate-400":"text-slate-300" %> w-5">#<%= index++ %></span>
                            <div class="w-7 h-7 rounded-full bg-slate-100 text-slate-700 flex items-center justify-center font-bold text-xs"><%= name.substring(0,1).toUpperCase() %></div>
                            <h4 class="font-medium text-slate-700 text-sm"><%= name %> <%= name.equalsIgnoreCase(donorName) ? "(You)" : "" %></h4>
                        </div>
                        <span class="font-bold text-slate-800 text-xs">₹<%= String.format("%.2f", amt) %></span>
                    </div>
                <% 
                        }
                    }
                } catch(Exception e) { e.printStackTrace(); } 
                %>
            </div>
        </section>
        
        </section> <%-- Leaders tab wall container ending block --%>

        <!-- TAB 5: ACCOUNT SETTINGS PROFILE CONTAINER  -->
     
        <section id="profile-tab" class="tab-content hidden max-w-xl mx-auto">
            <div class="bg-white p-6 rounded-2xl border border-slate-200 shadow-sm mb-6">
                <h3 class="font-bold text-slate-800 text-base mb-2 flex items-center gap-2">
                    <i class="fa-solid fa-id-card text-emerald-600"></i> Modify Profile Configuration
                </h3>
                <p class="text-xs text-slate-400">Update your account system tracking metrics nodes and localized server info layers.</p>
            </div>
            
            <form action="UpdateProfileServlet" method="POST" class="bg-white border border-slate-200 p-6 rounded-2xl shadow-sm space-y-5">
                <div class="space-y-1.5">
                    <label class="text-xs font-bold text-slate-500 uppercase tracking-wide">Full Donor Name</label>
                    <input type="text" name="fullName" value="<%= donorName %>" required class="w-full border border-slate-300 rounded-xl px-4 py-2.5 text-sm focus:outline-none focus:border-emerald-600 font-medium transition-colors">
                </div>
                <div class="space-y-1.5">
                    <label class="text-xs font-bold text-slate-500 uppercase tracking-wide">Contact Number (Phone)</label>
                    <input type="text" name="phone" placeholder="Enter contact mobile routing sequence" class="w-full border border-slate-300 rounded-xl px-4 py-2.5 text-sm focus:outline-none focus:border-emerald-600 font-medium transition-colors">
                </div>
                <div class="space-y-1.5">
                    <label class="text-xs font-bold text-slate-500 uppercase tracking-wide">City Jurisdiction Node</label>
                    <input type="text" name="city" placeholder="e.g. Lucknow" class="w-full border border-slate-300 rounded-xl px-4 py-2.5 text-sm focus:outline-none focus:border-emerald-600 font-medium transition-colors">
                </div>
                
                <div class="p-3.5 bg-emerald-50 rounded-xl border border-emerald-200/60 flex items-start gap-3 text-[11.5px] text-emerald-800 leading-relaxed font-medium">
                    <i class="fa-solid fa-shield-halved mt-0.5 text-base"></i>
                    <span>Secured profile mutation protocol rules apply. Saved records reflect dynamically inside transactional tax logs and donor tier pipelines.</span>
                </div>
                
                <button type="submit" class="w-full bg-emerald-600 hover:bg-emerald-700 text-white font-bold py-3 rounded-xl text-sm shadow-md transition-all flex items-center justify-center gap-2">
                    <i class="fa-solid fa-circle-check"></i> Save Structural Profile Changes
                </button>
            </form>
        </section>

       
        <footer class="footer" id="contact">
          <div class="footer-inner">
            <div class="footer-grid">
              <div class="footer-brand">
                <h4><i class="fa-solid fa-heart-pulse"></i> CARE LINK</h4>
                <p>Connecting NGOs, Volunteers and Donors to build stronger communities together.</p>
                <div class="footer-socials">
                  <a href="#"><i class="fa-brands fa-facebook-f"></i></a>
                  <a href="#"><i class="fa-brands fa-x-twitter"></i></a>
                  <a href="#"><i class="fa-brands fa-instagram"></i></a>
                  <a href="#"><i class="fa-brands fa-linkedin-in"></i></a>
                </div>
              </div>
              <div class="footer-col">
                <h4>Quick Links</h4>
                <ul>
                  <li><a href="#overview">Home</a></li>
                  <li><a href="#campaigns">Campaigns</a></li>
                  <li><a href="#requests">Requests</a></li>
                  <li><a href="#map">Volunteers</a></li>
                  <li><a href="#feed">Community</a></li>
                </ul>
              </div>
              <div class="footer-col">
                <h4>Get Involved</h4>
                <ul>
                  <li><a href="register.jsp?role=volunteer">Become a Volunteer</a></li>
                  <li><a href="register.jsp?role=ngo">Register your NGO</a></li>
                  <li><a href="register.jsp?role=donor">Become a Donor</a></li>
                  <li><a href="login.jsp">Login</a></li>
                </ul>
              </div>
              <div class="footer-col">
                <h4>Contact Us</h4>
                <ul>
                  <li class="footer-contact-item"><i class="fa-solid fa-envelope"></i> support@carelink.org</li>
                  <li class="footer-contact-item"><i class="fa-solid fa-phone"></i> +91 98765 43210</li>
                  <li class="footer-contact-item"><i class="fa-solid fa-location-dot"></i> Lucknow, India</li>
                </ul>
              </div>
            </div>
            <hr class="footer-hr"/>
            <p class="footer-bottom">&copy; 2026 CARE LINK. All Rights Reserved.</p>
          </div>
        </footer>


    </main>

    <!-- TRANSACTIONS ENGINE MODAL LAYER -->
    <div id="payment-modal" class="fixed inset-0 bg-slate-900/60 backdrop-blur-xs z-50 hidden flex items-center justify-center p-4">
        <div class="bg-white w-full max-w-md rounded-2xl shadow-2xl border border-slate-100 overflow-hidden transform scale-95 transition-all duration-300">
            <div class="p-5 border-b border-slate-100 flex justify-between items-center bg-slate-50">
                <div><h3 id="modal-title" class="font-bold text-slate-800 text-base">Secure Gateway Authorization</h3><p class="text-[11px] text-slate-400 mt-0.5">Ecosystem Production Node</p></div>
                <button onclick="closePaymentModal()" class="text-slate-400 hover:text-slate-600"><i class="fa-solid fa-xmark text-lg"></i></button>
            </div>
            <form action="ProcessDonationServlet" method="POST" class="p-6 space-y-5" onsubmit="return commitSimulation(this);">
                <input type="hidden" name="campaignId" id="form-camp-id"><input type="hidden" name="campaignTitle" id="form-camp-title">
                <div id="money-fields" class="space-y-1.5"><label class="text-xs font-bold text-slate-500 uppercase tracking-wide">Contribution Amount (INR)</label><div class="relative"><span class="absolute left-4 top-2.5 font-bold text-gray-400 text-sm">₹</span><input type="number" name="amount" id="form-amount" placeholder="e.g. 5000" min="10" class="w-full border border-slate-300 rounded-xl pl-8 pr-4 py-2.5 text-sm focus:outline-none focus:border-teal-600 font-medium transition-colors"></div></div>
                <div id="material-fields" class="space-y-1.5 hidden"><label class="text-xs font-bold text-slate-500 uppercase tracking-wide">Supply Quantity Specs</label><input type="text" name="materialDetails" id="form-material" placeholder="e.g. 50 Heavy Blankets" class="w-full border border-slate-300 rounded-xl px-4 py-2.5 text-sm focus:outline-none focus:border-teal-600 font-medium transition-colors"></div>
                <div class="p-3.5 bg-teal-50 rounded-xl border border-teal-200/60 flex items-start gap-3"><i class="fa-solid fa-shield-halved text-teal-700 mt-0.5 text-base"></i><p class="text-[11px] text-teal-800 leading-normal">Secured cryptographic token verification routing system. Live updates sync seamlessly into target campaign entities upon execution logs.</p></div>
                <button type="submit" id="modal-submit-btn" class="w-full bg-teal-600 hover:bg-teal-700 text-white font-bold py-3 rounded-xl text-sm shadow-md transition-all flex items-center justify-center gap-2"><i class="fa-solid fa-circle-check"></i> Authorize Allocation</button>
            </form>
        </div>
    </div>

    <script>
        const globalCampaignsArray = [
            <% for(Map<String, Object> c : liveCampaignsList) { %>
                { id: <%= c.get("id") %>, title: "<%= c.get("title").toString().replace("\"", "\\\"") %>", lat: <%= c.get("lat") %>, lng: <%= c.get("lng") %> },
            <% } %>
        ];

        function switchTab(tabId, buttonElement) {
            document.querySelectorAll('.tab-content').forEach(tab => tab.classList.add('hidden'));
            document.getElementById(tabId).classList.remove('hidden');
            if (buttonElement) {
                document.querySelectorAll('.nav-item-btn').forEach(btn => btn.classList.remove('active'));
                buttonElement.classList.add('active');
            }
            if (tabId === 'explore-tab') { setTimeout(initializeDiscoveryMap, 250); }
        }

        let mapInstance = null;
        function initializeDiscoveryMap() {
            if (mapInstance !== null) return;
            mapInstance = L.map('donor-map').setView([22.7196, 75.8577], 12);
            L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png').addTo(mapInstance);
            globalCampaignsArray.forEach(pin => {
                const marker = L.marker([pin.lat, pin.lng]).addTo(mapInstance);
                marker.bindPopup(`
                    <div style="font-family:'Plus Jakarta Sans',sans-serif; padding:2px; min-width:140px;">
                        <span style="font-size:12px; font-weight:700; color:#1F2937; display:block; margin-bottom:6px;">\${pin.title}</span>
                        <div style="display:flex; gap:4px;">
                            <button onclick="triggerPaymentModal(\${pin.id}, '\${pin.title.replace(/'/g, "\\'")}', 'MONEY')" style="background:#0F766E; color:#FFF; font-size:10px; font-weight:600; padding:5px; border:none; border-radius:4px; cursor:pointer; flex:1;">Cash</button>
                            <button onclick="triggerPaymentModal(\${pin.id}, '\${pin.title.replace(/'/g, "\\'")}', 'MATERIAL')" style="background:#1F2937; color:#FFF; font-size:10px; font-weight:600; padding:5px; border:none; border-radius:4px; cursor:pointer; flex:1;">Material</button>
                        </div>
                    </div>
                `);
            });
        }

        function triggerPaymentModal(id, title, type = 'MONEY') {
            document.getElementById('form-camp-id').value = id;
            document.getElementById('form-camp-title').value = title;
            document.getElementById('modal-title').innerText = title;
            const moneySection = document.getElementById('money-fields');
            const materialSection = document.getElementById('material-fields');
            if (type === 'MONEY') {
                moneySection.classList.remove('hidden');
                materialSection.classList.add('hidden');
                document.getElementById('form-amount').required = true;
                document.getElementById('form-material').required = false;
            } else {
                moneySection.classList.add('hidden');
                materialSection.classList.remove('hidden');
                document.getElementById('form-amount').required = false;
                document.getElementById('form-material').required = true;
            }
            const modal = document.getElementById('payment-modal');
            modal.classList.remove('hidden');
            setTimeout(() => modal.firstElementChild.classList.remove('scale-95'), 50);
        }

        function closePaymentModal() {
            const modal = document.getElementById('payment-modal');
            modal.firstElementChild.classList.add('scale-95');
            setTimeout(() => modal.classList.add('hidden'), 200);
        }

        function commitSimulation(form) {
            const btn = document.getElementById('modal-submit-btn');
            btn.disabled = true;
            btn.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Processing Ledger Row...';
            return true;
        } 

        function generateReceiptInvoice(donor, campaign, type, volume, date) {
            const receiptWindow = window.open('', '_blank');
            receiptWindow.document.write(`
                <html>
                <head>
                    <title>CARE LINK — Donation Receipt</title>
                    <style>
                        body { font-family: 'Plus Jakarta Sans', sans-serif; padding: 40px; color: #333; }
                        .receipt-box { border: 2px solid #E2E8F0; padding: 30px; border-radius: 16px; max-width: 600px; margin: 0 auto; box-shadow: 0 4px 12px rgba(0,0,0,0.05); }
                        .header { text-align: center; border-bottom: 2px dashed #E2E8F0; padding-bottom: 20px; }
                        .title { font-size: 24px; font-weight: bold; color: #064E3B; }
                        .row { display: flex; justify-content: space-between; margin: 16px 0; font-size: 14px; }
                        .footer { text-align: center; font-size: 11px; color: #94A3B8; margin-top: 30px; border-top: 1px solid #E2E8F0; padding-top: 15px; }
                        .btn-print { background: #10B981; color: white; border: none; padding: 8px 16px; border-radius: 6px; font-weight: bold; cursor: pointer; margin-bottom: 20px; }
                    </style>
                </head>
                <body>
                    <center><button class="btn-print" onclick="window.print()">🖨️ Print / Save PDF</button></center>
                    <div class="receipt-box">
                        <div class="header">
                            <div class="title">❤️ CARE LINK RECEIPT</div>
                            <p style="font-size:11px; color:#64748B;">Official Token Contribution Verification Log</p>
                        </div>
                        <div class="row"><strong>Donor Name:</strong> <span>\${donor}</span></div>
                        <div class="row"><strong>Campaign Drive:</strong> <span>\${campaign}</span></div>
                        <div class="row"><strong>Allocation Type:</strong> <span>\${type}</span></div>
                        <div class="row" style="font-size:16px; font-weight:bold; color:#064E3B;"><strong>Volume Contributed:</strong> <span>\${volume}</span></div>
                        <div class="row"><strong>Timestamp Log:</strong> <span>\${date}</span></div>
                        <div class="footer">Thank you for supporting verified ecosystem humanitarian campaigns.<br/>&copy; 2026 CARE LINK Platform.</div>
                    </div>
                </body>
                </html>
            `);
            receiptWindow.document.close();
        }

        // 🚨 FIXED REAL-TIME INTERCEPTOR FOR TOASTS & SECURITY CUPS
        window.addEventListener('DOMContentLoaded', () => {
            const urlParams = new URLSearchParams(window.location.search);
            
            // Limit reached popups check guard
            if (urlParams.get('error') === 'limit_reached') {
                alert('🚨 Requirement Fulfilled! This specific item has already reached its allocation safety cap.');
            }
            
            // General success metrics check alert
            if (urlParams.get('success') === '1') {
                alert('🎉 Donation Processed successfully and real-time ledger metrics updated!');
                
                const alertToast = document.createElement('div');
                alertToast.className = "fixed bottom-5 right-5 bg-slate-900 border border-emerald-500/30 text-white px-6 py-4 rounded-2xl shadow-2xl z-50 flex items-center gap-3 animate-bounce";
                alertToast.style.animationDuration = "2s";
                alertToast.innerHTML = `
                    <div class="w-8 h-8 rounded-full bg-emerald-500 flex items-center justify-center text-sm"><i class="fa-solid fa-gift text-white"></i></div>
                    <div>
                        <div class="text-sm font-bold text-emerald-400">Pledge Captured Successfully! 🎁</div>
                        <div class="text-[11px] text-slate-400">Your logistics ledger track has been securely synchronized with the NGO.</div>
                    </div>
                `;
                document.body.appendChild(alertToast);
                setTimeout(() => {
                    const cleanUrl = window.location.protocol + "//" + window.location.host + window.location.pathname;
                    window.history.replaceState({path: cleanUrl}, '', cleanUrl);
                }, 1500);
                setTimeout(() => { alertToast.remove(); }, 5000);
            }
            
        });
    </script>
</body>
</html>