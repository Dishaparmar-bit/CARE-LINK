<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.carelink.db.DBConnection" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Admin Dashboard — CARE LINK</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<link rel="stylesheet" href="css/admin.css">

<!-- Custom embedded styling for AI Copilot features to keep integration self-contained and clean -->
<style>
.floating-copilot {
    position: fixed;
    bottom: 25px;
    right: 25px;
    z-index: 1050;
    font-family: system-ui, -apple-system, sans-serif;
}
.copilot-bubble {
    width: 56px;
    height: 56px;
    border-radius: 50%;
    background: #0f172a;
    color: #10B981;
    border: 2px solid #10B981;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 24px;
    cursor: pointer;
    position: relative;
    transition: all 0.3s ease;
}
.copilot-bubble:hover {
    transform: scale(1.08);
    background: #1e293b;
}
.pulse-ring {
    position: absolute;
    border: 3px solid #10B981;
    border-radius: 50%;
    top: -3px; left: -3px; right: -3px; bottom: -3px;
    animation: copilot-pulse 1.8s infinite;
    opacity: 0;
}
@keyframes copilot-pulse {
    0% { transform: scale(0.95); opacity: 0.8; }
    100% { transform: scale(1.3); opacity: 0; }
}
.copilot-window {
    width: 320px;
    height: 420px;
    background: white;
    border-radius: 14px;
    overflow: hidden;
    position: absolute;
    bottom: 70px;
    right: 0;
    display: flex;
    flex-direction: column;
    border: 1px solid #e2e8f0;
}
.copilot-header {
    background: #0f172a !important;
}
.copilot-body {
    flex: 1;
    overflow-y: auto;
    background: #f8fafc;
    display: flex;
    flex-direction: column;
    gap: 10px;
}
.copilot-msg {
    display: flex;
    width: 100%;
}
.copilot-msg.bot { justify-content: flex-start; }
.copilot-msg.user { justify-content: flex-end; }
.msg-bubble {
    max-width: 85%;
    padding: 10px 14px;
    border-radius: 12px;
    font-size: 12.5px;
    line-height: 1.45;
}
.copilot-msg.bot .msg-bubble {
    background: white;
    color: #1e293b;
    border: 1px solid #e2e8f0;
    border-top-left-radius: 2px;
}
.copilot-msg.user .msg-bubble {
    background: #10B981;
    color: white;
    border-top-right-radius: 2px;
}
.copilot-suggestions {
    background: #f8fafc;
}
.copilot-suggestions button {
    font-size: 10px;
    padding: 4px 8px;
    background: white;
    border: 1px solid #cbd5e1;
    border-radius: 20px;
    color: #475569;
    cursor: pointer;
    transition: all 0.2s ease;
}
.copilot-suggestions button:hover {
    background: #f1f5f9;
    color: #0f172a;
    border-color: #94a3b8;
}
</style>
</head>
<body>

<%
    // Session check — redirect to login if not admin 
    HttpSession sess = request.getSession(false); 
    if (sess == null || !"admin".equals(sess.getAttribute("role"))) { 
        response.sendRedirect("login.jsp?error=unauthorized"); 
        return; 
    }
    
    // ✅ SYNCED WITH THE REAL ACTIVE SESSION CONSOLE 
    String adminName = sess.getAttribute("userName") != null ? (String) sess.getAttribute("userName") : "Platform Admin";
    String currentPage = request.getParameter("page"); 
    if (currentPage == null) currentPage = "overview";
    
    Connection con = null; 
    int totalUsers = 0; 
    int totalNGOs = 0; 
    int totalVolunteers = 0; 
    int totalDonors = 0; 
    int pendingNGOs = 0; 
    int approvedNGOs = 0; 
    int rejectedNGOs = 0; 

    // Fetch administrative profile credentials dynamically
    String adminEmail = (String) sess.getAttribute("email");
    if (adminEmail == null) adminEmail = "admin@carelink.org"; 

    try {
        con = DBConnection.getConnection(); 
        Statement st = con.createStatement(); 
        ResultSet rs; 

        rs = st.executeQuery("SELECT COUNT(*) FROM users"); 
        if(rs.next()) totalUsers = rs.getInt(1); 

        rs = st.executeQuery("SELECT COUNT(*) FROM users WHERE role='ngo'"); 
        if(rs.next()) totalNGOs = rs.getInt(1); 

        rs = st.executeQuery("SELECT COUNT(*) FROM users WHERE role='volunteer'"); 
        if(rs.next()) totalVolunteers = rs.getInt(1); 

        rs = st.executeQuery("SELECT COUNT(*) FROM users WHERE role='donor'"); 
        if(rs.next()) totalDonors = rs.getInt(1); 

        rs = st.executeQuery("SELECT COUNT(*) FROM ngo_details WHERE status='pending' OR status='Pending'"); 
        if(rs.next()) pendingNGOs = rs.getInt(1); 
        
        rs = st.executeQuery("SELECT COUNT(*) FROM ngo_details WHERE status='rejected' OR status='Rejected'"); 
        if(rs.next()) rejectedNGOs = rs.getInt(1); 
        
        rs = st.executeQuery("SELECT COUNT(*) FROM ngo_details WHERE status='approved' OR status='Approved'"); 
        if(rs.next()) approvedNGOs = rs.getInt(1); 

    } catch(Exception e) {
        e.printStackTrace(); 
    }
%>

<div class="admin-layout">

<aside class="sidebar" id="sidebar">
    <div class="sidebar-logo">
        <a href="index.jsp" class="logo-link">
            <i class="bi bi-heart-pulse-fill"></i>
            <span>CARE LINK</span>
        </a>
        <button class="sidebar-close d-lg-none" onclick="toggleSidebar()">
            <i class="bi bi-x-lg"></i>
        </button>
    </div>

    <div class="sidebar-label">MAIN MENU</div> 
    <nav class="sidebar-nav">
        <a href="adminDashboard.jsp?page=overview" class="sidebar-link <%= "overview".equals(currentPage) ? "active" : "" %>">
            <i class="bi bi-grid-1x2-fill"></i>
            <span>Overview</span>
        </a>
        <a href="adminDashboard.jsp?page=ngo-approvals" class="sidebar-link <%= "ngo-approvals".equals(currentPage) ? "active" : "" %>">
            <i class="bi bi-patch-check-fill"></i>
            <span>NGO Approvals</span>
        </a>
        <a href="adminDashboard.jsp?page=users" class="sidebar-link <%= "users".equals(currentPage) ? "active" : "" %>">
            <i class="bi bi-people-fill"></i>
            <span>Users</span>
        </a>
        <a href="adminDashboard.jsp?page=volunteers" class="sidebar-link <%= "volunteers".equals(currentPage) ? "active" : "" %>">
            <i class="bi bi-person-badge-fill"></i>
            <span>Volunteers</span>
        </a>
        <a href="adminDashboard.jsp?page=donors" class="sidebar-link <%= "donors".equals(currentPage) ? "active" : "" %>">
            <i class="bi bi-heart-fill"></i>
            <span>Donors</span>
        </a>
        <a href="adminDashboard.jsp?page=reports" class="sidebar-link <%= "reports".equals(currentPage) ? "active" : "" %>">
            <i class="bi bi-bar-chart-fill"></i>
            <span>Reports</span>
        </a>
        <a href="adminDashboard.jsp?page=messages" class="sidebar-link <%= "messages".equals(currentPage) ? "active" : "" %>">
            <i class="bi bi-chat-dots-fill"></i>
            <span>Messages</span>
        </a>
    </nav>

    <div class="sidebar-label mt-3">ACCOUNT</div>
    <nav class="sidebar-nav">
        <a href="adminDashboard.jsp?page=profile" class="sidebar-link <%= "profile".equals(currentPage) ? "active" : "" %>">
            <i class="bi bi-person-circle"></i>
            <span>Profile</span>
        </a>
        <a href="LogoutServlet" class="sidebar-link sidebar-logout">
            <i class="bi bi-box-arrow-left"></i>
            <span>Logout</span>
        </a>
    </nav>
</aside>
<div class="sidebar-overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div> 

<main class="admin-main"> 

    <header class="admin-topbar">
        <div class="topbar-left">
            <button class="sidebar-toggle d-lg-none" onclick="toggleSidebar()">
                <i class="bi bi-list"></i>
            </button>
            <div class="topbar-title" id="pageTitle">
                <% if ("overview".equals(currentPage)) { %> 
                    <i class="bi bi-grid-1x2-fill"></i> Dashboard Overview 
                <% } else if ("ngo-approvals".equals(currentPage)) { %> 
                    <i class="bi bi-patch-check-fill"></i> NGO Approvals 
                <% } else if ("users".equals(currentPage)) { %> 
                    <i class="bi bi-people-fill"></i> User Management 
                <% } else if ("volunteers".equals(currentPage)) { %> 
                    <i class="bi bi-person-badge-fill"></i> Volunteer Management 
                <% } else if ("donors".equals(currentPage)) { %> 
                    <i class="bi bi-heart-fill"></i> Donor Management 
                <% } else if ("reports".equals(currentPage)) { %> 
                    <i class="bi bi-bar-chart-fill"></i> Reports 
                <% } else if ("messages".equals(currentPage)) { %> 
                    <i class="bi bi-chat-dots-fill"></i> Messages 
                <% } else if ("profile".equals(currentPage)) { %> 
                    <i class="bi bi-person-circle"></i> My Profile 
                <% } %>
            </div>
        </div>

        <div class="topbar-right">
            <div class="topbar-search"> 
                <i class="bi bi-search"></i> 
                <input type="text" placeholder="Search..."> 
            </div> 
            <div class="topbar-notif"> 
                <i class="bi bi-bell-fill"></i> 
                <span class="notif-dot"></span> 
            </div> 
            <div class="admin-profile-btn" onclick="toggleProfileMenu()"> 
                <div class="admin-avatar"> 
                    <%= adminName.substring(0,1).toUpperCase() %> 
                </div> 
                <div class="admin-info d-none d-md-block"> 
                    <span class="admin-name"><%= adminName %></span> 
                    <span class="admin-role">Administrator</span> 
                </div> 
                <i class="bi bi-chevron-down d-none d-md-block" style="font-size:12px;color:#6b8c78;"></i> 
                <div class="profile-dropdown" id="profileDropdown"> 
                    <a href="adminDashboard.jsp?page=profile"> 
                        <i class="bi bi-person-circle"></i> My Profile 
                    </a> 
                    <hr> 
                    <a href="LogoutServlet" class="text-danger"> 
                        <i class="bi bi-box-arrow-left"></i> Logout 
                    </a> 
                </div> 
            </div> 
        </div>
    </header>

    <div class="admin-content">

    <% if ("overview".equals(currentPage)) { %> 

        <div class="row g-4 mb-4">
            <div class="col-6 col-md-3">
                <div class="stat-card">
                    <div class="stat-icon bg-green"> 
                        <i class="bi bi-people-fill"></i> 
                    </div> 
                    <div class="stat-info"> 
                        <h3><%= totalUsers %></h3> 
                        <p>Total Users</p> 
                    </div> 
                    <span class="stat-trend up"> 
                        <i class="bi bi-arrow-up-short"></i> 12% 
                    </span> 
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="stat-card">
                    <div class="stat-icon bg-blue"> 
                        <i class="bi bi-building"></i> 
                    </div> 
                    <div class="stat-info"> 
                       <h3><%= totalNGOs %></h3> 
                       <p>Total NGOs</p> 
                    </div> 
                    <span class="stat-trend up"> 
                        <i class="bi bi-arrow-up-short"></i> 5% 
                    </span> 
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="stat-card">
                    <div class="stat-icon bg-orange"> 
                        <i class="bi bi-person-badge-fill"></i> 
                    </div> 
                    <div class="stat-info"> 
                        <h3><%= totalVolunteers %></h3> 
                        <p>Volunteers</p> 
                    </div> 
                    <span class="stat-trend up"> 
                        <i class="bi bi-arrow-up-short"></i> 8% 
                    </span> 
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="stat-card">
                    <div class="stat-icon bg-red"> 
                        <i class="bi bi-heart-fill"></i> 
                    </div> 
                    <div class="stat-info"> 
                        <h3><%= totalDonors %></h3> 
                        <p>Donors</p> 
                    </div> 
                    <span class="stat-trend up"> 
                        <i class="bi bi-arrow-up-short"></i> 3% 
                    </span> 
                </div>
            </div>
        </div>

        <div class="row g-4 mb-4">
            <div class="col-md-4">
                <div class="mini-stat pending"> 
                    <i class="bi bi-hourglass-split"></i> 
                    <div> 
                        <h4><%= pendingNGOs %></h4> 
                        <p>Pending Approvals</p> 
                    </div> 
                    <a href="adminDashboard.jsp?page=ngo-approvals" class="mini-stat-link"> 
                        Review <i class="bi bi-arrow-right"></i> 
                    </a> 
                </div>
            </div>
            <div class="col-md-4">
                <div class="mini-stat approved"> 
                    <i class="bi bi-check-circle-fill"></i> 
                    <div> 
                        <h4><%= approvedNGOs %></h4> 
                        <p>Approved NGOs</p> 
                    </div> 
                </div>
            </div>
            <div class="col-md-4">
                <div class="mini-stat rejected"> 
                    <i class="bi bi-x-circle-fill"></i> 
                    <div> 
                        <h4><%= rejectedNGOs %></h4> 
                        <p>Rejected NGOs</p> 
                    </div> 
                </div>
            </div>
        </div>

        <div class="admin-card mb-4">
            <div class="admin-card-header">
                <h5><i class="bi bi-clock-history"></i> Recent NGO Applications</h5> 
                <a href="adminDashboard.jsp?page=ngo-approvals" class="btn-view-all"> 
                    View All <i class="bi bi-arrow-right"></i> 
                </a> 
            </div>
            <div class="table-responsive">
                <table class="admin-table">
                    <thead> 
                        <tr> 
                            <th>NGO Name</th> 
                            <th>Email</th> 
                            <th>City</th> 
                            <th>Applied</th> 
                            <th>Status</th> 
                            <th>Action</th> 
                        </tr> 
                    </thead> 
                    <tbody>
						<%
						try {
						    String sql = "SELECT nd.id, nd.org_name, nd.status, u.email, u.city, u.created_at " + 
						    		     "FROM ngo_details nd " + 
						    		     "JOIN users u ON nd.user_id = u.id " + 
						    		     "ORDER BY nd.id DESC LIMIT 5"; 
						    PreparedStatement ps = con.prepareStatement(sql); 
						    ResultSet rs = ps.executeQuery(); 
						    while(rs.next()) {
						%>
						<tr>
							<td><strong><%= rs.getString("org_name") %></strong></td> 
							<td><%= rs.getString("email") %></td> 
							<td><%= rs.getString("city") %></td> 
							<td><%= rs.getTimestamp("created_at") %></td> 
							<td><span class="status-badge <%= rs.getString("status").toLowerCase() %>"><%= rs.getString("status") %></span></td> 
							<td><a href="adminDashboard.jsp?page=ngo-approvals" class="btn-action approve">View</a></td> 
						</tr>
						<%
						    }
						} catch(Exception e) { e.printStackTrace(); } 
						%>
                    </tbody>
                </table>
            </div>
        </div>

        <div class="admin-card">
            <div class="admin-card-header">
                <h5><i class="bi bi-person-lines-fill"></i> Recent Registrations</h5> 
                <a href="adminDashboard.jsp?page=users" class="btn-view-all">View All <i class="bi bi-arrow-right"></i></a> 
            </div>
            <div class="table-responsive">
                <table class="admin-table">
                    <thead> 
                        <tr> 
                            <th>Name</th> 
                            <th>Email</th> 
                            <th>Role</th> 
                            <th>City</th> 
                            <th>Status</th> 
                        </tr> 
                    </thead> 
                    <tbody>
						<%
						try {
						    String sql = "SELECT full_name,email,role,city FROM users ORDER BY id DESC LIMIT 5"; 
							PreparedStatement ps = con.prepareStatement(sql); 
							ResultSet rs = ps.executeQuery(); 
							while(rs.next()) { 
						%>
						<tr>
							<td><strong><%= rs.getString("full_name") %></strong></td> 
							<td><%= rs.getString("email") %></td> 
							<td><%= rs.getString("role") %></td> 
							<td><%= rs.getString("city") %></td> 
							<td><span class="status-badge approved">Active</span></td> 
						</tr>
						<%
							}
						} catch(Exception e) { e.printStackTrace(); } 
						%>
					</tbody>
                </table>
            </div>
        </div>
    <% } %>

    <% if ("ngo-approvals".equals(currentPage)) { %> 
        <div class="admin-card">
            <div class="admin-card-header">
                <h5><i class="bi bi-patch-check-fill"></i> NGO Verification Requests</h5> 
                <div class="filter-tabs"> 
                    <button class="filter-tab active" onclick="filterTable(this,'all')">All</button> 
                    <button class="filter-tab" onclick="filterTable(this,'pending')">Pending</button> 
                    <button class="filter-tab" onclick="filterTable(this,'approved')">Approved</button> 
                    <button class="filter-tab" onclick="filterTable(this,'rejected')">Rejected</button> 
                </div>
            </div>

            <div class="table-responsive">
                <table class="admin-table" id="ngoTable">
                    <thead> 
                        <tr> 
                            <th>NGO Name</th> 
                            <th>Reg. Number</th> 
                            <th>Email</th> 
                            <th>City</th> 
                            <th style="min-width:145px;">Certificate & AI Scan</th> 
                            <th style="min-width:150px; text-align:center;">AI Copilot Score</th>
                            <th>Status</th> 
                            <th>Actions</th> 
                        </tr> 
                    </thead> 
                    <tbody>
						<%
						try {
						    con = DBConnection.getConnection(); 
							String sql = "SELECT nd.id, nd.org_name, nd.registration_number, nd.document_path, nd.status, " +
							             "nd.ai_status, nd.ai_confidence_score, nd.extracted_reg_no, nd.ai_analysis_summary, nd.ai_passed_checks, nd.ai_critical_issues, " +
							             "u.email, u.city " + 
							             "FROM ngo_details nd JOIN users u ON nd.user_id = u.id ORDER BY nd.id DESC"; 
							PreparedStatement ps = con.prepareStatement(sql); 
							ResultSet rs = ps.executeQuery(); 
							while(rs.next()) { 
                                // Safe extraction with try/catch to maintain full backward compatibility 
                                String aiStatus = "NOT_ANALYZED";
                                int aiScore = 0;
                                String extRegNo = "N/A";
                                String aiSummary = "";
                                String passedChecks = "";
                                String criticalIssues = "";

                                try {
                                    aiStatus = rs.getString("ai_status");
                                    if (aiStatus == null) aiStatus = "NOT_ANALYZED";
                                } catch(SQLException ex) {}

                                try {
                                    aiScore = rs.getInt("ai_confidence_score");
                                } catch(SQLException ex) {}

                                try {
                                    extRegNo = rs.getString("extracted_reg_no");
                                    if (extRegNo == null) extRegNo = "N/A";
                                } catch(SQLException ex) {}

                                try {
                                    aiSummary = rs.getString("ai_analysis_summary");
                                    if (aiSummary == null) aiSummary = "";
                                } catch(SQLException ex) {}

                                try {
                                    passedChecks = rs.getString("ai_passed_checks");
                                    if (passedChecks == null) passedChecks = "";
                                } catch(SQLException ex) {}

                                try {
                                    criticalIssues = rs.getString("ai_critical_issues");
                                    if (criticalIssues == null) criticalIssues = "";
                                } catch(SQLException ex) {}
						%>
						<tr data-status="<%= rs.getString("status").toLowerCase() %>"> 
							<td><strong><%= rs.getString("org_name") %></strong></td> 
							<td><%= rs.getString("registration_number") %></td> 
							<td><%= rs.getString("email") %></td> 
							<td><%= rs.getString("city") %></td> 
							<td>
                                <div class="d-flex flex-column gap-1">
                                    <a href="<%= rs.getString("document_path") %>" target="_blank" class="btn-cert text-center py-1.5"><i class="bi bi-file-earmark-pdf-fill"></i> View PDF</a>
                                    
                                    <!-- Direct Server-side AI Scanner Trigger form (No file choosing popup) -->
                                    <form action="verifyNGO" method="POST" class="m-0 mt-1">
                                        <input type="hidden" name="ngo_id" value="<%= rs.getInt("id") %>">
                                        <input type="hidden" name="document_path" value="<%= rs.getString("document_path") %>">
                                        <button type="submit" class="btn btn-sm btn-outline-success w-100 text-xs d-flex align-items-center justify-content-center gap-1 py-1" style="font-size: 11px; border-radius: 6px;">
                                            <i class="bi bi-robot"></i> Run AI Scan
                                        </button>
                                    </form>
                                </div>
                            </td> 
                            <td>
                                <div class="d-flex flex-column align-items-center justify-content-center">
                                    <% if ("NOT_ANALYZED".equals(aiStatus)) { %>
                                        <span class="badge bg-secondary text-xs py-1.5 px-2.5"><i class="bi bi-cpu"></i> Waiting Scan</span>
                                    <% } else { %>
                                        <div class="w-100 px-1" style="min-width: 120px;">
                                            <div class="d-flex justify-content-between text-xs mb-1" style="font-size: 11px;">
                                                <span class="fw-bold"><%= aiScore %>% Match</span>
                                                <% if (aiScore >= 75) { %>
                                                    <span class="text-success fw-bold">Safe</span>
                                                <% } else if (aiScore >= 45) { %>
                                                    <span class="text-warning fw-bold">Manual</span>
                                                <% } else { %>
                                                    <span class="text-danger fw-bold">Flagged</span>
                                                <% } %>
                                            </div>
                                            <div class="progress" style="height: 6px; border-radius: 3px; background-color: #f1f5f9;">
                                                <%
                                                    String pBarColor = "bg-danger";
                                                    if (aiScore >= 75) pBarColor = "bg-success";
                                                    else if (aiScore >= 45) pBarColor = "bg-warning";
                                                %>
                                                <div class="progress-bar <%= pBarColor %>" role="progressbar" style="width: <%= aiScore %>%"></div>
                                            </div>
                                            <button type="button" class="btn btn-link p-0 text-xs text-primary mt-1.5 d-block text-center mx-auto" style="font-size: 11px; text-decoration: none;"
                                                    onclick="showAIAnalysisDetails('<%= rs.getString("org_name").replace("'", "\\'") %>', '<%= aiScore %>', '<%= aiStatus %>', '<%= extRegNo.replace("'", "\\'") %>', '<%= aiSummary.replace("'", "\\'").replace("\n", " ") %>', '<%= passedChecks.replace("'", "\\'") %>', '<%= criticalIssues.replace("'", "\\'") %>')">
                                                <i class="bi bi-brain"></i> Inspect Report
                                            </button>
                                        </div>
                                    <% } %>
                                </div>
                            </td>
							<td><span class="status-badge <%= rs.getString("status").toLowerCase() %>"><%= rs.getString("status") %></span></td> 
							<td>
							<% if("pending".equalsIgnoreCase(rs.getString("status"))) { %> 
							    <div class="d-flex gap-1">
                                    <form action="ApproveNGOServlet" method="POST" style="display:inline;">
                                        <input type="hidden" name="id" value="<%= rs.getInt("id") %>">
                                        <input type="hidden" name="email" value="<%= rs.getString("email") %>">
                                        <input type="hidden" name="ngoName" value="<%= rs.getString("org_name") %>">
                                        <button type="submit" class="btn-action approve py-1 px-2 border-0">Approve</button>
                                    </form>
                                    <form action="RejectNGOServlet" method="POST" style="display:inline;">
                                        <input type="hidden" name="id" value="<%= rs.getInt("id") %>">
                                        <input type="hidden" name="email" value="<%= rs.getString("email") %>">
                                        <input type="hidden" name="ngoName" value="<%= rs.getString("org_name") %>">
                                        <button type="submit" class="btn-action reject py-1 px-2 border-0">Reject</button>
                                    </form>
                                </div>
							<% } else if("approved".equalsIgnoreCase(rs.getString("status"))) { %> 
							    <span class="text-success fw-bold">Approved</span> 
							<% } else { %>
							    <span class="text-danger fw-bold">Rejected</span> 
							<% } %>
							</td>
						</tr>
						<%
							}
						} catch(Exception e) { e.printStackTrace(); } 
						%>
                    </tbody>
                </table>
            </div>
        </div>
    <% } %>

    <% if ("users".equals(currentPage)) { %> 
        <div class="admin-card">
            <div class="admin-card-header">
                <h5><i class="bi bi-people-fill"></i> All Users</h5> 
                <div class="topbar-search"> 
                    <i class="bi bi-search"></i> 
                    <input type="text" placeholder="Search users..." oninput="searchTable(this,'usersTable')"> 
                </div>
            </div>
            <div class="table-responsive">
                <table class="admin-table" id="usersTable">
                    <thead> 
                        <tr> 
                            <th>SNo.</th> 
                            <th>Name</th> 
                            <th>Email</th> 
                            <th>Role</th> 
                            <th>City</th> 
                            <th>State</th> 
                            <th>Status</th> 
                            <th>Actions</th> 
                        </tr> 
                    </thead> 
                    <tbody>
						<%
						try {
						    int srNo = 1; 
						    String sql = "SELECT * FROM users ORDER BY id DESC"; 
							PreparedStatement ps = con.prepareStatement(sql); 
							ResultSet rs = ps.executeQuery(); 
							while(rs.next()) {
						%>
						<tr>
						    <td><%= srNo++ %></td> 
						    <td><strong><%= rs.getString("full_name") %></strong></td> 
						    <td><%= rs.getString("email") %></td> 
						    <td><%= rs.getString("role") %></td> 
						    <td><%= rs.getString("city") %></td> 
						    <td><%= rs.getString("state") %></td> 
						    <td><span class="status-badge approved">Active</span></td> 
						    <td><button class="btn-action view" onclick="viewUser('<%= rs.getString("full_name") %>')"><i class="bi bi-eye"></i></button></td> 
						</tr>
						<%
							}
						} catch(Exception e) { e.printStackTrace(); } 
						%>
					</tbody>
                </table>
            </div>
        </div>
    <% } %>

    <% if ("volunteers".equals(currentPage)) { %> 
        <div class="admin-card">
            <div class="admin-card-header">
                <h5><i class="bi bi-person-badge-fill"></i> Volunteer Management</h5> 
                <div class="topbar-search"> 
                    <i class="bi bi-search"></i> 
                    <input type="text" placeholder="Search volunteers..." oninput="searchTable(this,'volTable')"> 
                </div>
            </div>
            <div class="table-responsive"> 
                <table class="admin-table" id="volTable">
                    <thead> 
                        <tr> 
                            <th>S.No.</th> 
                            <th>Name</th> 
                            <th>Skills</th> 
                            <th>Availability</th> 
                            <th>Hours Served</th> 
                            <th>Points</th> 
                            <th>Status</th> 
                        </tr> 
                    </thead> 
                    <tbody>
                       <%
						try {
						    int srNo = 1; 
							String sql = "SELECT u.full_name, vd.skills, vd.availability, vd.total_hours, vd.points " + 
							             "FROM users u LEFT JOIN volunteer_details vd ON u.id = vd.user_id WHERE u.role='volunteer' ORDER BY u.id DESC"; 
							PreparedStatement ps = con.prepareStatement(sql); 
							ResultSet rs = ps.executeQuery(); 
							while(rs.next()) {
						%>
						<tr>
						    <td><%= srNo++ %></td> 
						    <td><strong><%= rs.getString("full_name") %></strong></td> 
						    <td><%= rs.getString("skills") != null ? rs.getString("skills") : "General" %></td> 
						    <td><%= rs.getString("availability") != null ? rs.getString("availability") : "Flexible" %></td> 
						    <td><strong><%= rs.getInt("total_hours") %></strong> hrs</td> 
						    <td><span class="points-badge"><%= rs.getInt("points") %> pts</span></td> 
						    <td><span class="status-badge approved">Active</span></td> 
						</tr>
						<%
							}
						} catch(Exception e) { e.printStackTrace(); } 
						%>
                    </tbody>
                </table>
            </div>
        </div>
    <% } %>

    <% if ("donors".equals(currentPage)) { %> 
        <div class="admin-card">
            <div class="admin-card-header"> 
                <h5><i class="bi bi-heart-fill"></i> Donor Management</h5> 
                <div class="topbar-search"> 
                    <i class="bi bi-search"></i> 
                    <input type="text" placeholder="Search donors..." oninput="searchTable(this,'donorTable')"> 
                </div>
            </div> 
            <div class="table-responsive"> 
                <table class="admin-table" id="donorTable">
                    <thead> 
                        <tr> 
                            <th>SNo.</th> 
                            <th>Name</th> 
                            <th>Email</th> 
                            <th>Preferred Cause</th> 
                            <th>City</th> 
                            <th>Total Donations</th> 
                            <th>Status</th> 
                        </tr> 
                    </thead> 
                    <tbody>
						<%
						try {
							int srNo = 1; 
							String sql = "SELECT u.full_name, u.email, u.city, dd.preferred_cause, dd.total_donated " + 
							             "FROM users u LEFT JOIN donor_details dd ON u.id = dd.user_id WHERE u.role='donor' ORDER BY u.id DESC"; 
							PreparedStatement ps = con.prepareStatement(sql); 
						    ResultSet rs = ps.executeQuery(); 
						    while(rs.next()) {
						%>
						<tr>
							<td><%= srNo++ %></td> 
							<td><strong><%= rs.getString("full_name") %></strong></td> 
							<td><%= rs.getString("email") %></td> 
							<td><%= rs.getString("preferred_cause") != null ? rs.getString("preferred_cause") : "All Causes" %></td> 
							<td><%= rs.getString("city") %></td> 
							<td><strong class="text-success">₹<%= rs.getDouble("total_donated") %></strong></td> 
							<td><span class="status-badge approved">Active</span></td> 
						</tr>
						<%
						    }
						} catch(Exception e) { e.printStackTrace(); } 
						%>
					</tbody>
                </table>
            </div>
        </div>
    <% } %>

    <% if ("reports".equals(currentPage)) { 
		int volunteerCount = 0; 
		int donorCount = 0; 
		int ngoCount = 0; 
		int approvedNGO = 0; 
		int pendingNGO = 0; 
		int rejectedNGO = 0; 
		double totalDonations = 0; 
		int totalVolunteerHours = 0; 
		int totalCities = 0; 
		
		try {
		    PreparedStatement ps; 
		    ResultSet rs; 
		
		    ps = con.prepareStatement("SELECT COUNT(*) FROM users WHERE role='volunteer'"); 
		    rs = ps.executeQuery(); 
		    if(rs.next()) volunteerCount = rs.getInt(1); 
		
		    ps = con.prepareStatement("SELECT COUNT(*) FROM users WHERE role='donor'"); 
		    rs = ps.executeQuery(); 
		    if(rs.next()) donorCount = rs.getInt(1); 
		
		    ps = con.prepareStatement("SELECT COUNT(*) FROM users WHERE role='ngo'"); 
		    rs = ps.executeQuery(); 
		    if(rs.next()) ngoCount = rs.getInt(1); 
		
		    ps = con.prepareStatement("SELECT COUNT(*) FROM ngo_details WHERE status='approved' OR status='Approved'"); 
		    rs = ps.executeQuery(); 
		    if(rs.next()) approvedNGO = rs.getInt(1); 
		
		    ps = con.prepareStatement("SELECT COUNT(*) FROM ngo_details WHERE status='pending' OR status='Pending'"); 
		    rs = ps.executeQuery(); 
		    if(rs.next()) pendingNGO = rs.getInt(1); 
		
		    ps = con.prepareStatement("SELECT COUNT(*) FROM ngo_details WHERE status='rejected' OR status='Rejected'"); 
		    rs = ps.executeQuery(); 
		    if(rs.next()) rejectedNGO = rs.getInt(1); 
		
		    ps = con.prepareStatement("SELECT IFNULL(SUM(amount), 0) FROM donations WHERE donation_type='MONEY'");
		    rs = ps.executeQuery(); 
		    if(rs.next()) totalDonations = rs.getDouble(1); 
		
		    ps = con.prepareStatement("SELECT IFNULL(SUM(total_hours),0) FROM volunteer_details"); 
		    rs = ps.executeQuery(); 
		    if(rs.next()) totalVolunteerHours = rs.getInt(1); 
		
		    ps = con.prepareStatement("SELECT COUNT(DISTINCT city) FROM users WHERE city IS NOT NULL AND city <> ''"); 
		    rs = ps.executeQuery(); 
		    if(rs.next()) totalCities = rs.getInt(1); 
		
		} catch(Exception e) { e.printStackTrace(); } 
		
		// Percentage computation matrices for dynamic sizing
		int roleSum = volunteerCount + donorCount + ngoCount;
		double volPct = roleSum > 0 ? (volunteerCount / (double)roleSum) * 100 : 0;
		double donPct = roleSum > 0 ? (donorCount / (double)roleSum) * 100 : 0;
		double ngoPct = roleSum > 0 ? (ngoCount / (double)roleSum) * 100 : 0;
		
		int ngoSum = approvedNGO + pendingNGO + rejectedNGO;
		double appPct = ngoSum > 0 ? (approvedNGO / (double)ngoSum) * 100 : 0;
		double penPct = ngoSum > 0 ? (pendingNGO / (double)ngoSum) * 100 : 0;
		double rejPct = ngoSum > 0 ? (rejectedNGO / (double)ngoSum) * 100 : 0;
	%>
	
	<div class="row g-4 mb-4">
	    <div class="col-md-6">
	        <div class="admin-card h-100">
	            <div class="admin-card-header">
	                <h5><i class="bi bi-pie-chart-fill"></i> Users by Role</h5> 
	            </div>
	            <div class="report-bars">
	                <div class="report-bar-row">
	                    <span class="report-label">Volunteers</span>
	                    <div class="report-bar-track"><div class="report-bar-fill green" style="width: <%= volPct %>%"></div></div> 
	                    <span class="report-count"><%= volunteerCount %></span> 
	                </div>
	                <div class="report-bar-row">
	                    <span class="report-label">Donors</span> 
	                    <div class="report-bar-track"><div class="report-bar-fill blue" style="width: <%= donPct %>%"></div></div>
	                    <span class="report-count"><%= donorCount %></span> 
	                </div>
	                <div class="report-bar-row">
	                    <span class="report-label">NGOs</span> 
	                    <div class="report-bar-track"><div class="report-bar-fill orange" style="width: <%= ngoPct %>%"></div></div> 
	                    <span class="report-count"><%= ngoCount %></span> 
	                </div>
	            </div>
	        </div>
	    </div>
	
	    <div class="col-md-6">
	        <div class="admin-card h-100"> 
	            <div class="admin-card-header">
	                <h5><i class="bi bi-patch-check-fill"></i> NGO Status</h5> 
	            </div> 
	            <div class="report-bars">
	                <div class="report-bar-row">
	                    <span class="report-label">Approved</span> 
	                    <div class="report-bar-track"><div class="report-bar-fill green" style="width: <%= appPct %>%"></div></div> 
	                    <span class="report-count"><%= approvedNGO %></span> 
	                </div>
	                <div class="report-bar-row">
	                    <span class="report-label">Pending</span> 
	                    <div class="report-bar-track"><div class="report-bar-fill orange" style="width: <%= penPct %>%"></div></div>
	                    <span class="report-count"><%= pendingNGO %></span> 
	                </div>
	                <div class="report-bar-row">
	                    <span class="report-label">Rejected</span> 
	                    <div class="report-bar-track"><div class="report-bar-fill red" style="width: <%= rejPct %>%"></div></div>
	                    <span class="report-count"><%= rejectedNGO %></span> 
	                </div>
	            </div>
	        </div>
	    </div>
	</div>
	
	<div class="admin-card">
	    <div class="admin-card-header">
	        <h5><i class="bi bi-graph-up-arrow"></i> Platform Summary</h5> 
	    </div>
	    <div class="row g-4 p-3">
	        <div class="col-md-3 col-6">
	            <div class="summary-box">
	                <i class="bi bi-people-fill text-success"></i>
	                <h4><%= roleSum %></h4> 
	                <p>Total Users</p> 
	            </div>
	        </div>
	        <div class="col-md-3 col-6">
	            <div class="summary-box">
	                <i class="bi bi-cash-stack text-success"></i>
	                <h4>₹<%= (long)totalDonations %></h4> 
	                <p>Total Donations</p> 
	            </div>
	        </div>
	        <div class="col-md-3 col-6">
	            <div class="summary-box">
	                <i class="bi bi-clock-fill text-warning"></i>
	                <h4><%= totalVolunteerHours %></h4> 
	                <p>Volunteer Hours</p> 
            </div>
	        </div>
	        <div class="col-md-3 col-6">
	            <div class="summary-box">
	                <i class="bi bi-geo-alt-fill text-danger"></i>
	                <h4><%= totalCities %></h4> 
	                <p>Cities Covered</p> 
	            </div>
	        </div>
	    </div>
	</div>
    <% } %>

    <% if ("messages".equals(currentPage)) { %> 
        <div class="admin-card">
            <div class="admin-card-header">
                <h5><i class="bi bi-chat-dots-fill"></i> Community Messages</h5> 
            </div>
            <div class="table-responsive">
                <table class="admin-table">
                    <thead> 
                        <tr> 
                            <th>Name</th> 
                            <th>Email</th> 
                            <th>Message</th> 
                            <th>Date</th> 
                            <th>Action</th> 
                        </tr> 
                    </thead> 
                    <tbody>
                        <tr> 
                            <td><strong>Ravi Kumar</strong></td> 
                            <td>ravi@email.com</td> 
                            <td class="msg-preview">How do I register my NGO on CARE LINK?</td> 
                            <td>13 Jun 2026</td> 
                            <td><button class="btn-action view" onclick="viewMessage(this)"><i class="bi bi-eye"></i> View</button></td> 
                        </tr> 
                        <tr> 
                            <td><strong>Meena Shah</strong></td> 
                            <td>meena@email.com</td> 
                            <td class="msg-preview">Can donors track where their money goes?</td> 
                            <td>12 Jun 2026</td> 
                            <td><button class="btn-action view" onclick="viewMessage(this)"><i class="bi bi-eye"></i> View</button></td> 
                        </tr> 
                        <tr> 
                            <td><strong>Arjun Nair</strong></td> 
                            <td>arjun@email.com</td> 
                            <td class="msg-preview">I want to volunteer but don't know where to start.</td> 
                            <td>11 Jun 2026</td> 
                            <td><button class="btn-action view" onclick="viewMessage(this)"><i class="bi bi-eye"></i> View</button></td> 
                        </tr> 
                    </tbody>
                </table>
            </div>
        </div>
    <% } %>

    <% if ("profile".equals(currentPage)) { %> 
        <div class="row g-4 justify-content-center">
            <div class="col-md-8">
                <div class="admin-card p-5">
                    <div class="text-center mb-4">
                        <div class="profile-avatar-lg mx-auto mb-2" style="width:70px; height:70px; background:#e2f0e7; color:#10B981; border-radius:50%; display:flex; align-items:center; justify-content:center; font-size:32px; font-weight:800; align-items:center;">
                            <%= adminName.substring(0,1).toUpperCase() %>
                        </div>
                        <h3><%= adminName %></h3> 
                        <p class="text-muted">Central Core System Security Node</p>
                        <span class="status-badge approved">Super Admin Status Active</span>
                    </div>
                    
                    <form action="UpdateProfileServlet" method="POST" class="space-y-4 row g-3">
                        <div class="col-md-6 mt-2">
                            <label class="form-label text-xs font-bold text-slate-500 text-uppercase">Full Display Name</label>
                            <input type="text" name="fullName" value="<%= adminName %>" required class="form-control px-3 py-2 text-sm" style="border-radius:10px;">
                        </div>
                        <div class="col-md-6 mt-2">
                            <label class="form-label text-xs font-bold text-slate-500 text-uppercase">System Phone Track</label>
                            <input type="text" name="phone" placeholder="+91 98765 43210" class="form-control px-3 py-2 text-sm" style="border-radius:10px;">
                        </div>
                        <div class="col-md-12 mt-2">
                            <label class="form-label text-xs font-bold text-slate-500 text-uppercase">Central Jurisdiction City</label>
                            <input type="text" name="city" value="Indore" placeholder="e.g. Indore" class="form-control px-3 py-2 text-sm" style="border-radius:10px;">
                        </div>
                        <div class="col-md-12 mt-2">
                            <div class="p-3 bg-light rounded text-muted text-xs" style="font-size:11.5px; border-left:4px solid #10B981;">
                                <i class="bi bi-shield-lock-fill text-success"></i> Security protocols are fully operational. Mutation adjustments map instant notifications across global server logs.
                            </div>
                        </div>
                        <div class="col-12 mt-4 text-center">
                            <button type="submit" class="btn btn-success font-bold px-4 py-2 text-sm border-0" style="border-radius:10px; background:#10B981;">
                                <i class="bi bi-check-circle"></i> Save Administrative Configuration
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    <% } %>

    </div></main>
</div>

<div class="modal-overlay" id="certModal" onclick="closeCertModal()">
    <div class="cert-modal" onclick="event.stopPropagation()">
        <div class="cert-modal-header">
            <h5><i class="bi bi-file-earmark-pdf-fill"></i> NGO Certificate</h5> 
            <button onclick="closeCertModal()"><i class="bi bi-x-lg"></i></button> 
        </div> 
        <div class="cert-modal-body"> 
            <div class="cert-placeholder"> 
                <i class="bi bi-file-earmark-pdf-fill"></i> 
                <p>Certificate preview will load here.</p> 
                <small id="certFileName"></small> 
            </div> 
        </div> 
    </div>
</div>

<!-- Bootstrap 5 AI Compliance Inspector Modal -->
<div class="modal fade" id="aiInspectorModal" tabindex="-1" aria-labelledby="aiInspectorModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered modal-lg">
    <div class="modal-content" style="border-radius: 16px; border: none; overflow: hidden; box-shadow: 0 10px 30px rgba(0,0,0,0.15);">
      <div class="modal-header bg-dark text-white py-3 px-4 d-flex justify-content-between align-items-center">
        <h5 class="modal-title d-flex align-items-center gap-2" id="aiInspectorModalLabel">
          <i class="bi bi-cpu-fill text-success"></i> CareLink AI Copilot — Compliance Integrity Report
        </h5>
        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body p-4 bg-light">
        <div class="row g-3">
          <!-- NGO Profile Summary Card -->
          <div class="col-12 bg-white p-3 rounded shadow-sm border border-light">
            <span class="text-xs text-muted fw-bold uppercase" style="font-size: 11px; letter-spacing: 0.5px;">EVALUATED ENTITY</span>
            <h4 class="fw-bold text-dark m-0 mt-1" id="aiModalNgoName">NGO Name</h4>
          </div>
          
          <!-- Rating details -->
          <div class="col-md-6">
            <div class="bg-white p-3 rounded shadow-sm border border-light h-100 d-flex flex-column justify-content-between">
              <span class="text-xs text-muted fw-bold" style="font-size: 11px;">AI INTEGRITY CONFIDENCE RATING</span>
              <div class="d-flex align-items-baseline gap-2 mt-2">
                <span class="fs-2 fw-bold text-dark" id="aiModalScore" style="font-weight: 800;">0%</span>
                <span class="text-success text-xs fw-bold" id="aiModalMetricStatus"><i class="bi bi-shield-fill-check"></i> High Integrity Credential</span>
              </div>
              <div class="progress mt-2" style="height: 6px; border-radius: 3px; background-color: #f1f5f9;">
                <div class="progress-bar bg-success" id="aiModalProgressBar" role="progressbar" style="width: 0%"></div>
              </div>
            </div>
          </div>
          
          <div class="col-md-6">
            <div class="bg-white p-3 rounded shadow-sm border border-light h-100">
              <span class="text-xs text-muted fw-bold block mb-1" style="font-size: 11px;">EVALUATION PIPELINE STATE</span>
              <div class="mt-2">
                <span id="aiModalStatusBadge" class="badge bg-secondary py-1 px-3" style="border-radius: 30px;">PENDING</span>
              </div>
              <small class="text-muted d-block mt-3" style="font-size: 11px;"><i class="bi bi-info-circle"></i> Executed instantly via heuristic file extraction</small>
            </div>
          </div>
          
          <!-- Registration Number -->
          <div class="col-12">
            <div class="bg-white p-3 rounded shadow-sm border border-light">
              <span class="text-xs text-muted fw-bold" style="font-size: 11px;">EXTRACTED CERTIFICATE REGISTRATION CODE</span>
              <div class="font-mono bg-light p-2.5 rounded border mt-2 text-dark fw-bold" id="aiModalRegNo" style="font-family: monospace;">
                N/A
              </div>
            </div>
          </div>
          
          <!-- Text Compliance Logs -->
          <div class="col-12">
            <div class="bg-white p-3 rounded shadow-sm border border-light">
              <span class="text-xs text-muted fw-bold" style="font-size: 11px;">AI COMPLIANCE ANALYSIS SUMMARY LOG</span>
              <p class="text-sm text-dark bg-light p-3 border rounded mt-2 mb-0" id="aiModalSummary" style="font-size: 13px; line-height: 1.5;">
                Summary of integrity checks...
              </p>
            </div>
          </div>
          
          <!-- Checklist Items -->
          <div class="col-md-6">
            <div class="bg-white p-3 rounded border border-success h-100" style="border-left: 4px solid #198754 !important;">
              <span class="text-xs text-muted fw-bold text-success d-block mb-2" style="font-size: 11px;"><i class="bi bi-shield-check"></i> Passed Security Rules</span>
              <ul class="list-unstyled d-flex flex-column gap-1.5" id="aiModalPassedChecks" style="font-size: 12.5px;">
                <!-- Populated Dynamically -->
              </ul>
            </div>
          </div>
          
          <div class="col-md-6">
            <div class="bg-white p-3 rounded border border-danger h-100" style="border-left: 4px solid #dc3545 !important;">
              <span class="text-xs text-muted fw-bold text-danger d-block mb-2" style="font-size: 11px;"><i class="bi bi-exclamation-triangle"></i> Flagged Tampering Risks</span>
              <ul class="list-unstyled d-flex flex-column gap-1.5" id="aiModalCriticalIssues" style="font-size: 12.5px;">
                <!-- Populated Dynamically -->
              </ul>
            </div>
          </div>
        </div>
      </div>
      <div class="modal-footer bg-light border-0 py-3">
        <button type="button" class="btn btn-dark btn-sm py-2 px-4" style="border-radius: 8px;" data-bs-dismiss="modal">Acknowledge Audit Logs</button>
      </div>
    </div>
  </div>
</div>

<!-- Floating AI Copilot Assistant Chatbot -->
<div id="floatingAiCopilot" class="floating-copilot">
    <!-- Floating Circle Trigger -->
    <button class="copilot-bubble shadow" onclick="toggleCopilotWindow()">
        <i class="bi bi-robot"></i>
        <span class="pulse-ring"></span>
    </button>
    
    <!-- Floating Chat Box -->
    <div class="copilot-window shadow-lg d-none" id="copilotWindow">
        <div class="copilot-header text-white p-3 d-flex justify-content-between align-items-center">
            <div class="d-flex align-items-center gap-2">
                <i class="bi bi-cpu text-success fs-5"></i>
                <div>
                    <h6 class="m-0 fw-bold">CareLink AI Copilot</h6>
                    <small class="text-success" style="font-size: 10px;">🛡️ Audit System Agent Active</small>
                </div>
            </div>
            <button class="btn btn-sm text-white p-0 opacity-75" onclick="toggleCopilotWindow()">
                <i class="bi bi-dash-lg"></i>
            </button>
        </div>
        
        <div class="copilot-body p-3" id="copilotChatLogs">
            <!-- Starting system greetings -->
            <div class="copilot-msg bot">
                <div class="msg-bubble shadow-sm text-xs">
                    Namaste! Main hoon aapka <strong>CareLink AI Copilot</strong>. Main real-time NGO metadata verification, trust token mappings, aur system databases ko check karne me help kar sakta hoon. <br><br>
                    Koi compliance ya validation rule poochna chahte hain?
                </div>
            </div>
        </div>
        
        <!-- Quick recommendation pills -->
        <div class="copilot-suggestions px-3 pb-2 d-flex flex-wrap gap-1">
            <button onclick="sendCopilotQuery('NGO validation rules kya hain?')">NGO Checks</button>
            <button onclick="sendCopilotQuery('Heuristic scoring engine kaise kaam karta hai?')">Heuristic Logic</button>
            <button onclick="sendCopilotQuery('Batao current platform statistics')">System Stats</button>
        </div>
        
        <div class="copilot-footer border-top p-2 d-flex gap-1 align-items-center">
            <input type="text" class="form-control form-control-sm text-xs" style="border-radius: 6px; font-size: 12.5px;" id="copilotInputField" placeholder="Type compliance check..." onkeypress="handleCopilotKeypress(event)">
            <button class="btn btn-sm btn-dark" onclick="submitCopilotText()"><i class="bi bi-send-fill"></i></button>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function toggleSidebar() {
        document.getElementById('sidebar').classList.toggle('open'); 
        document.getElementById('sidebarOverlay').classList.toggle('show'); 
    }

    function toggleProfileMenu() {
        document.getElementById('profileDropdown').classList.toggle('show'); 
    }

    document.addEventListener('click', function(e) {
        const dd = document.getElementById('profileDropdown'); 
        if (!e.target.closest('.admin-profile-btn')) dd.classList.remove('show'); 
    });

    function filterTable(btn, status) {
        document.querySelectorAll('.filter-tab').forEach(b => b.classList.remove('active')); 
        btn.classList.add('active'); 
        document.querySelectorAll('#ngoTable tbody tr').forEach(row => { 
            row.style.display = (status === 'all' || row.dataset.status === status) ? '' : 'none'; 
        }); 
    }

    // Dynamic search filter updated to support case insensitive matching
    function searchTable(input, tableId) {
        const q = input.value.toLowerCase(); 
        document.querySelectorAll('#' + tableId + ' tbody tr').forEach(row => { 
            row.style.display = row.textContent.toLowerCase().includes(q) ? '' : 'none'; 
        }); 
    }

    function viewUser(name) { showToast('Viewing profile token: ' + name); } 
    function viewMessage(btn) {
        const msg = btn.closest('tr').querySelector('.msg-preview').textContent; 
        showToast('Message preview: ' + msg); 
    }

    function showToast(msg) {
        let t = document.getElementById('adminToast'); 
        if (!t) { 
            t = document.createElement('div'); 
            t.id = 'adminToast'; 
            t.style.cssText = 'position:fixed;bottom:30px;right:30px;background:#0d1f17;color:white;padding:14px 22px;border-radius:12px;font-size:14px;font-weight:600;z-index:9999;box-shadow:0 4px 20px rgba(0,0,0,.2);border-left:4px solid #00a86b;transition:.3s;'; 
            document.body.appendChild(t); 
        } 
        t.textContent = msg; 
        t.style.opacity = '1'; 
        setTimeout(() => { t.style.opacity = '0'; }, 2500); 
    }

    // Dynamic Bootstrap Modal Data Population function for AI compliance evaluation
    function showAIAnalysisDetails(name, score, status, regNo, summary, passedFlat, failedFlat) {
        document.getElementById('aiModalNgoName').innerText = name;
        document.getElementById('aiModalScore').innerText = score + '%';
        document.getElementById('aiModalRegNo').innerText = regNo && regNo !== 'null' && regNo.trim() !== '' ? regNo : 'N/A';
        document.getElementById('aiModalSummary').innerText = summary && summary !== 'null' && summary.trim() !== '' ? summary : 'Manual credential audit is advised. No automated anomalies triggered.';

        const progressBar = document.getElementById('aiModalProgressBar');
        progressBar.style.width = score + '%';
        progressBar.className = 'progress-bar ';
        
        const metricStatus = document.getElementById('aiModalMetricStatus');
        const badge = document.getElementById('aiModalStatusBadge');
        badge.innerText = status.replace('_', ' ');
        badge.className = 'badge py-1.5 px-3 ';

        if (score >= 75) {
            progressBar.className += 'bg-success';
            metricStatus.className = 'text-success text-xs fw-bold';
            metricStatus.innerHTML = '<i class="bi bi-shield-fill-check"></i> High Integrity Credential';
            badge.className += 'bg-success';
        } else if (score >= 45) {
            progressBar.className += 'bg-warning text-dark';
            metricStatus.className = 'text-warning text-xs fw-bold';
            metricStatus.innerHTML = '<i class="bi bi-shield-fill-exclamation"></i> Moderate Validation Risks';
            badge.className += 'bg-warning text-dark';
        } else {
            progressBar.className += 'bg-danger';
            metricStatus.className = 'text-danger text-xs fw-bold';
            metricStatus.innerHTML = '<i class="bi bi-shield-fill-x"></i> High Security Risk Flagged';
            badge.className += 'bg-danger';
        }

        // Dynamic checks lists population
        const passedList = document.getElementById('aiModalPassedChecks');
        passedList.innerHTML = '';
        if (passedFlat && passedFlat !== 'null' && passedFlat.trim() !== '') {
            passedFlat.split(',').forEach(chk => {
                passedList.innerHTML += `<li class="d-flex align-items-center gap-1.5 text-success"><i class="bi bi-check-circle-fill" style="font-size: 11px;"></i> ${chk.trim()}</li>`;
            });
        } else {
            passedList.innerHTML = `<li class="text-muted"><i class="bi bi-info-circle"></i> No explicit trust tokens extracted</li>`;
        }

        const failedList = document.getElementById('aiModalCriticalIssues');
        failedList.innerHTML = '';
        if (failedFlat && failedFlat !== 'null' && failedFlat.trim() !== '') {
            failedFlat.split(',').forEach(iss => {
                failedList.innerHTML += `<li class="d-flex align-items-center gap-1.5 text-danger"><i class="bi bi-x-circle-fill" style="font-size: 11px;"></i> ${iss.trim()}</li>`;
            });
        } else {
            failedList.innerHTML = `<li class="text-muted"><i class="bi bi-shield-check"></i> Zero safety threats triggered</li>`;
        }

        // Launch modal via vanilla Bootstrap 5
        const myModal = new bootstrap.Modal(document.getElementById('aiInspectorModal'));
        myModal.show();
    }

    // Floating AI Copilot Assistant Chatbot Window Controls
    function toggleCopilotWindow() {
        const win = document.getElementById('copilotWindow');
        win.classList.toggle('d-none');
    }

    function handleCopilotKeypress(event) {
        if (event.key === 'Enter') {
            submitCopilotText();
        }
    }

    function sendCopilotQuery(txt) {
        appendCopilotMsg(txt, 'user');
        generateCopilotResponse(txt);
    }

    function submitCopilotText() {
        const input = document.getElementById('copilotInputField');
        const txt = input.value.trim();
        if (txt === '') return;
        input.value = '';
        sendCopilotQuery(txt);
    }

    function appendCopilotMsg(text, sender) {
        const logs = document.getElementById('copilotChatLogs');
        const msgDiv = document.createElement('div');
        msgDiv.className = `copilot-msg ${sender}`;
        
        msgDiv.innerHTML = `
            <div class="msg-bubble shadow-sm text-xs">
                ${text}
            </div>
        `;
        logs.appendChild(msgDiv);
        logs.scrollTop = logs.scrollHeight;
    }

    // Heuristics Simulation Response Matrix
    function generateCopilotResponse(query) {
        const qLower = query.toLowerCase();
        let reply = "";
        
        setTimeout(() => {
            if (qLower.includes('rule') || qLower.includes('validate') || qLower.includes('ngo') || qLower.includes('check')) {
                reply = "Hamari verification rules strictly set hain. AI PDF scanning engine dynamically core elements (e.g. Society Act 1860, Section 8, or Trust Deed layouts) aur MHA (Ministry of Home Affairs) official formatting trace check karta hai to prevent profile fraud.";
            } else if (qLower.includes('heuristic') || qLower.includes('scoring') || qLower.includes('logic') || qLower.includes('system')) {
                reply = "Verification scanning score system credibility checks par based hai. Valid registrations/Trust tags match hone par rating increment hoti hai (+10% per rule match). Watermarks, suspicious formatting elements, or template markers hone par confidence reduction lagta hai (-25% per indicator).";
            } else if (qLower.includes('stat') || qLower.includes('statistic') || qLower.includes('data') || qLower.includes('database')) {
                reply = "<strong>Active Central Database Metrics:</strong><br>" +
                        "• Approved NGOs count: <%= approvedNGOs %><br>" +
                        "• Pending compliance audit: <%= pendingNGOs %><br>" +
                        "• Total platform registered users: <%= totalUsers %>";
            } else {
                reply = "Aapka query humare security guidelines panel me register kiya gaya hai. Kisi bhi query ke compliance verification ke liye, live panel me dynamic scanning process trigger kijiye!";
            }
            appendCopilotMsg(reply, 'bot');
        }, 750);
    }

    // Intercept automatic notifications parameters
    window.addEventListener('DOMContentLoaded', () => {
        const urlParams = new URLSearchParams(window.location.search);
        if (urlParams.get('success') === '1') {
            showToast('🤖 AI Integrity scan successfully logged in database! Security score: ' + urlParams.get('score') + '%');
            window.history.replaceState({}, document.title, window.location.pathname);
        }
        if (urlParams.get('status') === 'approved') {
            showToast('✅ NGO verified successfully and secure mail dispatched.');
            window.history.replaceState({}, document.title, window.location.pathname);
        } else if (urlParams.get('status') === 'approved_failed' || urlParams.get('status') === 'failed') {
            showToast('❌ Operational error: State transition failed.');
            window.history.replaceState({}, document.title, window.location.pathname);
        }
        if (urlParams.get('profile') === 'updated') {
            showToast('🎉 System Administrator configuration synchronized successfully!');
            window.history.replaceState({}, document.title, window.location.pathname);
        }
    });
</script>
</body>
</html>