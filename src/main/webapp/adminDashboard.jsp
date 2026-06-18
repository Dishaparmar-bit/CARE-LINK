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
</head>
<body>

<%
    // Session check — redirect to login if not admin
    HttpSession sess = request.getSession(false);
    if (sess == null || !"admin".equals(sess.getAttribute("role"))) {
        response.sendRedirect("login.jsp?error=unauthorized");
        return;
    }
    String adminName = sess.getAttribute("fullName") != null
                       ? (String) sess.getAttribute("fullName") : "Admin";
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

        rs = st.executeQuery(
            "SELECT COUNT(*) FROM ngo_details WHERE status='pending'"
        );

        if(rs.next()) pendingNGOs = rs.getInt(1);
        
        rs = st.executeQuery(
                "SELECT COUNT(*) FROM ngo_details WHERE status='rejected'"
            );

            if(rs.next()) rejectedNGOs = rs.getInt(1);

        
        rs = st.executeQuery(
                "SELECT COUNT(*) FROM ngo_details WHERE status='approved'"
            );

            if(rs.next()) approvedNGOs = rs.getInt(1);
        

    } catch(Exception e) {
        e.printStackTrace();
    }
%>

<div class="admin-layout">

<!-- ========== SIDEBAR ========== -->
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
        <a href="adminDashboard.jsp?page=overview"
           class="sidebar-link <%= "overview".equals(currentPage) ? "active" : "" %>">
            <i class="bi bi-grid-1x2-fill"></i>
            <span>Overview</span>
        </a>
        <a href="adminDashboard.jsp?page=ngo-approvals"
           class="sidebar-link <%= "ngo-approvals".equals(currentPage) ? "active" : "" %>">
            <i class="bi bi-patch-check-fill"></i>
            <span>NGO Approvals</span>
           
        </a>
        <a href="adminDashboard.jsp?page=users"
           class="sidebar-link <%= "users".equals(currentPage) ? "active" : "" %>">
            <i class="bi bi-people-fill"></i>
            <span>Users</span>
        </a>
        <a href="adminDashboard.jsp?page=volunteers"
           class="sidebar-link <%= "volunteers".equals(currentPage) ? "active" : "" %>">
            <i class="bi bi-person-badge-fill"></i>
            <span>Volunteers</span>
        </a>
        <a href="adminDashboard.jsp?page=donors"
           class="sidebar-link <%= "donors".equals(currentPage) ? "active" : "" %>">
            <i class="bi bi-heart-fill"></i>
            <span>Donors</span>
        </a>
        <a href="adminDashboard.jsp?page=reports"
           class="sidebar-link <%= "reports".equals(currentPage) ? "active" : "" %>">
            <i class="bi bi-bar-chart-fill"></i>
            <span>Reports</span>
        </a>
        <a href="adminDashboard.jsp?page=messages"
           class="sidebar-link <%= "messages".equals(currentPage) ? "active" : "" %>">
            <i class="bi bi-chat-dots-fill"></i>
            <span>Messages</span>
        </a>
    </nav>

    <div class="sidebar-label mt-3">ACCOUNT</div>
    <nav class="sidebar-nav">
        <a href="adminDashboard.jsp?page=profile"
           class="sidebar-link <%= "profile".equals(currentPage) ? "active" : "" %>">
            <i class="bi bi-person-circle"></i>
            <span>Profile</span>
        </a>
        <a href="LogoutServlet" class="sidebar-link sidebar-logout">
            <i class="bi bi-box-arrow-left"></i>
            <span>Logout</span>
        </a>
    </nav>

</aside>
<!-- sidebar overlay for mobile -->
<div class="sidebar-overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>

<!-- ========== MAIN CONTENT ========== -->
<main class="admin-main">

    <!-- Top Bar -->
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
                <!-- dropdown -->
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

    <!-- Page Content -->
    <div class="admin-content">

    <!-- ===== OVERVIEW ===== -->
    <% if ("overview".equals(currentPage)) { %>

        <!-- Stat Cards -->
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

        <!-- NGO Status Row -->
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

        <!-- Recent NGO Applications -->
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
						
						    String sql =
						    		"SELECT nd.id, nd.org_name, nd.status, " +
						    		        "u.email, u.city, u.created_at " +
						    		        "FROM ngo_details nd " +
						    		        "JOIN users u ON nd.user_id = u.id " +
						    		        "ORDER BY nd.id DESC LIMIT 5";

						
						    PreparedStatement ps =con.prepareStatement(sql);
						
						    ResultSet rs =ps.executeQuery();
						        while(rs.next()) {
						%>
						<tr>
						<td>
						<strong><%= rs.getString("org_name") %>
						</strong>
						</td>
						<td><%= rs.getString("email") %></td>
						<td><%= rs.getString("city") %></td>
						<td><%= rs.getTimestamp("created_at") %></td>
						<td>
						<span class="status-badge <%= rs.getString("status") %>">
						<%= rs.getString("status") %>
						</span>
						</td>
						<td>
						<a href="adminDashboard.jsp?page=ngo-approvals"
						class="btn-action approve">View</a>
						</td>
						</tr>
						<%
						 }
						} catch(Exception e) {
						
						    e.printStackTrace();
						}
						
						%>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Recent Users -->
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
							  String sql =
							        "SELECT full_name,email,role,city " +
							        "FROM users " +
							        "ORDER BY id DESC LIMIT 5";
							
							    PreparedStatement ps =
							        con.prepareStatement(sql);
							    ResultSet rs =
							        ps.executeQuery();
							while(rs.next()) {
							%>
							
							<tr>
							<td>
							        <strong>
							            <%= rs.getString("full_name") %>
							        </strong>
							    </td>
							
							    <td>
							        <%= rs.getString("email") %>
							    </td>
							    <td>
							        <%= rs.getString("role") %>
							    </td>
							    <td>
							        <%= rs.getString("city") %>
							    </td>
								<td>
							        <span class="status-badge approved">
							            Active
							        </span>
							    </td>
							</tr>
							
							<%
							}
							
							} catch(Exception e) {
							
							    e.printStackTrace();
							}
							
							%>
							
							</tbody>
                </table>
            </div>
        </div>

    <% } %>

    <!-- ===== NGO APPROVALS ===== -->
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
                            <th>Certificate</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                       <tbody>

							<%
							
							try {
								con = DBConnection.getConnection();
							
							String sql =
							    "SELECT nd.id, nd.org_name, nd.registration_number, " +
							    "nd.document_path, nd.status, " +
							    "u.email, u.city " +
							    "FROM ngo_details nd " +
							    "JOIN users u ON nd.user_id = u.id " +
							    "ORDER BY nd.id DESC";
							
							PreparedStatement ps =
							        con.prepareStatement(sql);
							
							ResultSet rs =
							        ps.executeQuery();
							
							while(rs.next()) {
							
							%>
							
							<tr data-status="<%= rs.getString("status") %>">
							<td>
							    <strong>
							        <%= rs.getString("org_name") %>
							    </strong>
							</td>
							<td>
							    <%= rs.getString("registration_number") %>
							</td>
						    <td>
							    <%= rs.getString("email") %>
							</td>
							<td>
							    <%= rs.getString("city") %>
							</td>
							<td>
							 <a
							        href="<%= rs.getString("document_path") %>"
							        target="_blank"
							        class="btn-cert">
							
							        <i class="bi bi-file-earmark-pdf-fill"></i>
							        View
							
							    </a>
							
							</td>
							<td>
							
							    <span class="status-badge <%= rs.getString("status") %>">
							
							        <%= rs.getString("status") %>
							
							    </span>
							</td>
							<td>
							
							<% if("pending".equals(rs.getString("status"))) { %>
							
							    <a href="ApproveNGOServlet?id=<%= rs.getInt("id") %>"
							       class="btn-action approve">
							
							       Approve
							
							    </a>
							
							    <a href="RejectNGOServlet?id=<%= rs.getInt("id") %>"
							       class="btn-action reject">
							
							       Reject
							
							    </a>
							
							<% } else if("approved".equals(rs.getString("status"))) { %>
							
							    <span class="text-success fw-bold">
							        Approved
							    </span>
							
							<% } else { %>
							
							    <span class="text-danger fw-bold">
							        Rejected
							    </span>
							
							<% } %>
							
							</td>
						</tr>
							
							<%
							}
							} catch(Exception e) {
							e.printStackTrace();
							}
							%>

</tbody>
                       
                    </tbody>
                </table>
            </div>
        </div>

    <% } %>

    <!-- ===== USERS ===== -->
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
							
							    <td>
							        <strong><%= rs.getString("full_name") %></strong>
							    </td>
							
							    <td><%= rs.getString("email") %></td>
							
							    <td><%= rs.getString("role") %></td>
							
							    <td><%= rs.getString("city") %></td>
							
							    <td><%= rs.getString("state") %></td>
							
							    <td>
							        <span class="status-badge approved">Active</span>
							    </td>
							
							    <td>
							        <button class="btn-action view">
							            <i class="bi bi-eye"></i>
							        </button>
							    </td>
							</tr>
							
							<%
							    }
							
							} catch(Exception e) {
							    e.printStackTrace();
							}
							%>
						</tbody>
                </table>
            </div>
        </div>

    <% } %>

    <!-- ===== VOLUNTEERS ===== -->
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
                            <th>#</th>
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
							
							    String sql =
							        "SELECT u.full_name, u.email, u.city, " +
							        "vd.skills, vd.availability, vd.total_hours, vd.points " +
							        "FROM users u " +
							        "LEFT JOIN volunteer_details vd ON u.id = vd.user_id " +
							        "WHERE u.role='volunteer' " +
							        "ORDER BY u.id DESC";
							
							    PreparedStatement ps = con.prepareStatement(sql);
							
							    ResultSet rs = ps.executeQuery();
							
							    while(rs.next()) {
							%>
							
							<tr>
							    <td><%= srNo++ %></td>
							
							    <td>
							        <strong><%= rs.getString("full_name") %></strong>
							    </td>
							
							    <td><%= rs.getString("skills") %></td>
							
							    <td><%= rs.getString("availability") %></td>
							
							    <td>
							        <strong><%= rs.getInt("total_hours") %></strong> hrs
							    </td>
							
							    <td>
							        <span class="points-badge">
							            <%= rs.getInt("points") %> pts
							        </span>
							    </td>
							
							    <td>
							        <span class="status-badge approved">
							            Active
							        </span>
							    </td>
							</tr>
							
							<%
							    }
							
							} catch(Exception e) {
							
							    e.printStackTrace();
							}
							%>
                    </tbody>
                </table>
            </div>
        </div>

    <% } %>

    <!-- ===== DONORS ===== -->
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
						String sql =
						        "SELECT u.full_name, u.email, u.city, " +
						        "dd.preferred_cause, dd.total_donated " +
						        "FROM users u " +
						        "LEFT JOIN donor_details dd ON u.id = dd.user_id " +
						        "WHERE u.role='donor' " +
						        "ORDER BY u.id DESC";
						
						    PreparedStatement ps = con.prepareStatement(sql);
						
						    ResultSet rs = ps.executeQuery();
						
						    while(rs.next()) {
						%>
						
						<tr>
						<td><%= srNo++ %></td>
						<td>
						  <strong><%= rs.getString("full_name") %></strong>
						 </td>
						<td><%= rs.getString("email") %></td>
						<td><%= rs.getString("preferred_cause") %></td>
						<td><%= rs.getString("city") %></td>
						<td>
						        <strong class="text-success">
						            ₹<%= rs.getDouble("total_donated") %>
						        </strong>
						</td>
						 <td>
						        <span class="status-badge approved">
						            Active
						        </span>
						</td>
						</tr>
						<%
						    }
						} catch(Exception e) {
						
						    e.printStackTrace();
						}
						%>
						</tbody>
                    </tbody>
                </table>
            </div>
        </div>

    <% } %>

<!------------ REPORTS----------->
   <% if ("reports".equals(currentPage)) { %>

<%
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

    // Volunteers
    ps = con.prepareStatement(
        "SELECT COUNT(*) FROM users WHERE role='volunteer'"
    );
    rs = ps.executeQuery();
    if(rs.next()) volunteerCount = rs.getInt(1);

    // Donors
    ps = con.prepareStatement(
        "SELECT COUNT(*) FROM users WHERE role='donor'"
    );
    rs = ps.executeQuery();
    if(rs.next()) donorCount = rs.getInt(1);

    // NGOs
    ps = con.prepareStatement(
        "SELECT COUNT(*) FROM users WHERE role='ngo'"
    );
    rs = ps.executeQuery();
    if(rs.next()) ngoCount = rs.getInt(1);

    // Approved NGOs
    ps = con.prepareStatement(
        "SELECT COUNT(*) FROM ngo_details WHERE status='approved'"
    );
    rs = ps.executeQuery();
    if(rs.next()) approvedNGO = rs.getInt(1);

    // Pending NGOs
    ps = con.prepareStatement(
        "SELECT COUNT(*) FROM ngo_details WHERE status='pending'"
    );
    rs = ps.executeQuery();
    if(rs.next()) pendingNGO = rs.getInt(1);

    // Rejected NGOs
    ps = con.prepareStatement(
        "SELECT COUNT(*) FROM ngo_details WHERE status='rejected'"
    );
    rs = ps.executeQuery();
    if(rs.next()) rejectedNGO = rs.getInt(1);

    // Total Donations
    ps = con.prepareStatement(
        "SELECT IFNULL(SUM(total_donated),0) FROM donor_details"
    );
    rs = ps.executeQuery();
    if(rs.next()) totalDonations = rs.getDouble(1);

    // Volunteer Hours
    ps = con.prepareStatement(
        "SELECT IFNULL(SUM(total_hours),0) FROM volunteer_details"
    );
    rs = ps.executeQuery();
    if(rs.next()) totalVolunteerHours = rs.getInt(1);

    // Cities Covered
    ps = con.prepareStatement(
        "SELECT COUNT(DISTINCT city) FROM users WHERE city IS NOT NULL AND city <> ''"
    );
    rs = ps.executeQuery();
    if(rs.next()) totalCities = rs.getInt(1);

} catch(Exception e) {
    e.printStackTrace();
}
%>

<div class="row g-4 mb-4">

    <div class="col-md-6">
        <div class="admin-card h-100">

            <div class="admin-card-header">
                <h5>
                    <i class="bi bi-pie-chart-fill"></i>
                    Users by Role
                </h5>
            </div>

            <div class="report-bars">

                <div class="report-bar-row">
                    <span class="report-label">Volunteers</span>
                    <div class="report-bar-track">
                        <div class="report-bar-fill green" style="width:100%"></div>
                    </div>
                    <span class="report-count"><%= volunteerCount %></span>
                </div>

                <div class="report-bar-row">
                    <span class="report-label">Donors</span>
                    <div class="report-bar-track">
                        <div class="report-bar-fill blue" style="width:100%"></div>
                    </div>
                    <span class="report-count"><%= donorCount %></span>
                </div>

                <div class="report-bar-row">
                    <span class="report-label">NGOs</span>
                    <div class="report-bar-track">
                        <div class="report-bar-fill orange" style="width:100%"></div>
                    </div>
                    <span class="report-count"><%= ngoCount %></span>
                </div>

            </div>

        </div>
    </div>

    <div class="col-md-6">
        <div class="admin-card h-100">

            <div class="admin-card-header">
                <h5>
                    <i class="bi bi-patch-check-fill"></i>
                    NGO Status
                </h5>
            </div>

            <div class="report-bars">

                <div class="report-bar-row">
                    <span class="report-label">Approved</span>
                    <div class="report-bar-track">
                        <div class="report-bar-fill green" style="width:100%"></div>
                    </div>
                    <span class="report-count"><%= approvedNGO %></span>
                </div>

                <div class="report-bar-row">
                    <span class="report-label">Pending</span>
                    <div class="report-bar-track">
                        <div class="report-bar-fill orange" style="width:100%"></div>
                    </div>
                    <span class="report-count"><%= pendingNGO %></span>
                </div>

                <div class="report-bar-row">
                    <span class="report-label">Rejected</span>
                    <div class="report-bar-track">
                        <div class="report-bar-fill red" style="width:100%"></div>
                    </div>
                    <span class="report-count"><%= rejectedNGO %></span>
                </div>

            </div>

        </div>
    </div>

</div>

<div class="admin-card">

    <div class="admin-card-header">
        <h5>
            <i class="bi bi-graph-up-arrow"></i>
            Platform Summary
        </h5>
    </div>

    <div class="row g-4 p-3">

        <div class="col-md-3 col-6">
            <div class="summary-box">
                <i class="bi bi-people-fill text-success"></i>
                <h4><%= volunteerCount + donorCount + ngoCount %></h4>
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

    <!-- ===== MESSAGES ===== -->
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

    <!-- ===== PROFILE ===== -->
    <% if ("profile".equals(currentPage)) { %>

        <div class="row g-4 justify-content-center">
            <div class="col-md-6">
                <div class="admin-card text-center p-4">
                    <div class="profile-avatar-lg">
                        <%= adminName.substring(0,1).toUpperCase() %>
                    </div>
                    <h3 class="mt-3"><%= adminName %></h3>
                    <p class="text-muted">Administrator — CARE LINK</p>
                    <span class="status-badge approved">Active</span>

                    <hr class="my-4">

                    <div class="text-start">
                        <div class="profile-info-row">
                            <i class="bi bi-person-fill"></i>
                            <div>
                                <small>Full Name</small>
                                <p><%= adminName %></p>
                            </div>
                        </div>
                        <div class="profile-info-row">
                            <i class="bi bi-envelope-fill"></i>
                            <div>
                                <small>Email</small>
                                <p>admin@carelink.org</p>
                            </div>
                        </div>
                        <div class="profile-info-row">
                            <i class="bi bi-shield-fill-check"></i>
                            <div>
                                <small>Role</small>
                                <p>Super Administrator</p>
                            </div>
                        </div>
                        <div class="profile-info-row">
                            <i class="bi bi-geo-alt-fill"></i>
                            <div>
                                <small>Location</small>
                                <p>Lucknow, India</p>
                            </div>
                        </div>
                    </div>

                    <a href="LogoutServlet" class="btn-action reject mt-4 d-inline-block">
                        <i class="bi bi-box-arrow-left"></i> Logout
                    </a>
                </div>
            </div>
        </div>

    <% } %>

    </div><!-- end admin-content -->
</main>
</div><!-- end admin-layout -->

<!-- Certificate Modal -->
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

    function changeStatus(btn, newStatus) {
        const row = btn.closest('tr');
        const badge = row.querySelector('.status-badge');
        badge.className = 'status-badge ' + newStatus;
        badge.textContent = newStatus.charAt(0).toUpperCase() + newStatus.slice(1);
        row.dataset.status = newStatus;
        const td = btn.closest('td');
        if (newStatus === 'approved') {
            td.innerHTML = '<button class="btn-action reject" onclick="changeStatus(this,\'rejected\')"><i class="bi bi-x-lg"></i> Revoke</button>';
        } else {
            td.innerHTML = '<button class="btn-action approve" onclick="changeStatus(this,\'approved\')"><i class="bi bi-check-lg"></i> Re-approve</button>';
        }
        showToast(newStatus === 'approved' ? '✅ NGO Approved!' : '❌ NGO Rejected.');
    }

    function viewCert(filename) {
        document.getElementById('certFileName').textContent = filename;
        document.getElementById('certModal').classList.add('show');
    }

    function closeCertModal() {
        document.getElementById('certModal').classList.remove('show');
    }

    function searchTable(input, tableId) {
        const q = input.value.toLowerCase();
        document.querySelectorAll('#' + tableId + ' tbody tr').forEach(row => {
            row.style.display = row.textContent.toLowerCase().includes(q) ? '' : 'none';
        });
    }

    function viewUser(name) { showToast('Viewing profile: ' + name); }
    function deactivateUser(btn) {
        const badge = btn.closest('tr').querySelector('.status-badge');
        const isActive = badge.classList.contains('approved');
        badge.className = isActive ? 'status-badge pending' : 'status-badge approved';
        badge.textContent = isActive ? 'Inactive' : 'Active';
        showToast(isActive ? 'User deactivated.' : 'User activated.');
    }
    function viewMessage(btn) {
        const msg = btn.closest('tr').querySelector('.msg-preview').textContent;
        showToast('Message: ' + msg);
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
</script>
</body>
</html>
