<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.carelink.db.DBConnection" %>
<%
    int liveNGOsCount = 0;
    int liveVolunteersCount = 0;
    double liveDonations = 0.0;
    int liveCampaignsCount = 0;

    List<Map<String, String>> urgentRequests = new ArrayList<>();
    List<Map<String, String>> leaderboard = new ArrayList<>();

    try (Connection con = DBConnection.getConnection()) {
        
        // 1. Fetch Platform-wide Core Counter Metrics
        String qNGO = "SELECT COUNT(*) FROM users WHERE role = 'ngo'";
        try (PreparedStatement ps = con.prepareStatement(qNGO); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) liveNGOsCount = rs.getInt(1);
        }

        String qVol = "SELECT COUNT(*) FROM users WHERE role = 'volunteer'";
        try (PreparedStatement ps = con.prepareStatement(qVol); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) liveVolunteersCount = rs.getInt(1);
        }

        String qDon = "SELECT COALESCE(SUM(amount), 0) FROM donations";
        try (PreparedStatement ps = con.prepareStatement(qDon); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) liveDonations = rs.getDouble(1);
        }

        String qCampCount = "SELECT COUNT(*) FROM campaigns WHERE status = 'closed'";
        try (PreparedStatement ps = con.prepareStatement(qCampCount); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) liveCampaignsCount = rs.getInt(1);
        }

        // 2. Fetch Top 3 Urgent Active Campaigns Mapped with NGO Names
        String qActive = "SELECT c.id, c.title, c.description, c.category, u.full_name AS ngoName, u.city " +
                         "FROM campaigns c JOIN users u ON c.ngo_user_id = u.id " +
                         "WHERE c.status = 'active' ORDER BY c.id DESC LIMIT 3";
        try (PreparedStatement ps = con.prepareStatement(qActive); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, String> row = new HashMap<>();
                row.put("id", rs.getString("id"));
                row.put("title", rs.getString("title"));
                row.put("description", rs.getString("description"));
                row.put("category", rs.getString("category"));
                row.put("ngoName", rs.getString("ngoName"));
                row.put("city", rs.getString("city"));
                urgentRequests.add(row);
            }
        }

        // 3. Fetch Real Top 3 Volunteers from Leaderboard Standings
        String qLeader = "SELECT u.full_name, vd.total_hours, vd.points " +
                         "FROM volunteer_details vd JOIN users u ON vd.user_id = u.id " +
                         "ORDER BY vd.points DESC LIMIT 3";
        try (PreparedStatement ps = con.prepareStatement(qLeader); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, String> row = new HashMap<>();
                row.put("name", rs.getString("full_name"));
                row.put("hours", rs.getString("total_hours"));
                row.put("points", rs.getString("points"));
                leaderboard.add(row);
            }
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    
    while (leaderboard.size() < 3) {
        Map<String, String> fallback = new HashMap<>();
        fallback.put("name", "Active Changemaker");
        fallback.put("hours", "0");
        fallback.put("points", "0");
        leaderboard.add(fallback);
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>CARE LINK</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="css/style.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>
<body>

<!-- ================= NAVBAR ================= -->
<nav class="navbar navbar-expand-lg fixed-top reg-nav custom-nav" id="mainNav">
    <div class="container">
        <a class="navbar-brand logo-text" href="index.jsp"><i class="bi bi-heart-pulse-fill"></i> CARE LINK</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#regMenu">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="regMenu">
            <ul class="navbar-nav ms-auto align-items-lg-center me-3">
                <li class="nav-item"><a class="nav-link" href="index.jsp#top"><i class="bi bi-house-fill"></i> Home</a></li>
                <li class="nav-item"><a class="nav-link" href="index.jsp#features"><i class="bi bi-stars"></i> Features</a></li>
                <li class="nav-item"><a class="nav-link" href="index.jsp#requests"><i class="bi bi-card-list"></i> Requests</a></li>
                <li class="nav-item"><a class="nav-link" href="index.jsp#leaderboard"><i class="bi bi-trophy-fill"></i> Volunteers</a></li>
                <li class="nav-item"><a class="nav-link" href="index.jsp#community"><i class="bi bi-people-fill"></i> Community</a></li>
                <li class="nav-item"><a class="nav-link" href="index.jsp#contact"><i class="bi bi-envelope-fill"></i> Contact</a></li>
            </ul>
            <a href="login.jsp" class="btn login-btn ms-lg-3">Login</a>
            <a href="register.jsp" class="btn login-btn ms-lg-3">Register</a>
        </div>
    </div>
</nav>

<!-- ================= HERO SECTION ================== -->
<section class="hero-section" id="top">
    <div id="heroCarousel" class="carousel slide hero-bg-carousel" data-bs-ride="carousel" data-bs-interval="4000">
        <div class="carousel-inner">
            <div class="carousel-item active">
                <img src="images/volunteer.jpg" onerror="this.onerror=null;this.src='https://images.unsplash.com/photo-1593113598332-cd288d649433?w=1600&q=80'" alt="Volunteer">
            </div>
            <div class="carousel-item">
                <img src="images/community.jpg" onerror="this.onerror=null;this.src='https://images.unsplash.com/photo-1509099836639-18ba1795216d?w=1600&q=80'" alt="Community">
            </div>
            <div class="carousel-item">
                <img src="images/donation.jpg" onerror="this.onerror=null;this.src='https://images.unsplash.com/photo-1532629345422-7515f3d16bb6?w=1600&q=80'" alt="Donation">
            </div>
        </div>
    </div>
    <div class="hero-overlay"></div>

    <div class="container position-relative">
        <div class="row">
            <div class="col-lg-7">
                <span class="hero-badge reveal"><i class="bi bi-geo-alt-fill"></i> India's Community Impact Platform</span>
                <h1 class="hero-title reveal">Connecting Communities<br>Through Action</h1>
                <p class="hero-text reveal">CARE LINK connects NGOs, volunteers and donors on one platform to create meaningful impact and help communities grow stronger together.</p>

                <div class="mt-4 d-flex flex-wrap gap-3 reveal">
                    <a href="register.jsp?role=volunteer" class="btn btn-success btn-lg hero-btn"><i class="bi bi-people-fill"></i> Join Volunteer</a>
                    <a href="register.jsp?role=ngo" class="btn btn-outline-light btn-lg hero-btn"><i class="bi bi-building"></i> Register NGO</a>
                    <a href="register.jsp?role=donor" class="btn btn-warning btn-lg hero-btn"><i class="bi bi-heart-fill"></i> Become Donor</a>
                </div>

                <!-- LIVE METRICS PIPELINE FROM DATABASE -->
                <div class="hero-stats mt-5 reveal">
                    <div class="hero-stat-item">
                        <h3><%= liveNGOsCount %></h3>
                        <p>NGOs Registered</p>
                    </div>
                    <div class="hero-stat-divider"></div>
                    <div class="hero-stat-item">
                        <h3><%= liveVolunteersCount %></h3>
                        <p>Volunteers Enrolled</p>
                    </div>
                    <div class="hero-stat-divider"></div>
                    <div class="hero-stat-item">
                        <h3>₹<%= String.format("%.0f", liveDonations) %></h3>
                        <p>Total Funds Raised</p>
                    </div>
                    <div class="hero-stat-divider"></div>
                    <div class="hero-stat-item">
                        <h3><%= liveCampaignsCount %></h3>
                        <p>Drives Fulfilled</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="scroll-hint"><i class="bi bi-chevron-double-down"></i></div>
</section>

<!-- NGO REQUESTS -->
<section class="container py-4" id="requests">
    <div class="text-center mb-4 reveal">
        <span class="section-badge">ACTIVE REQUESTS</span>
        <h2 class="mt-3 fw-bold section-title">Urgent Community Needs</h2>
        <p class="text-secondary">Support ongoing NGO initiatives near you.</p>
    </div>

    <div class="row g-4">
        <% 
            if (urgentRequests.isEmpty()) { 
        %>
            <div class="col-12 text-center py-4 reveal">
                <div class="alert alert-light border text-muted">
                    <i class="bi bi-inbox fs-3 d-block mb-2"></i> No active public campaigns found in the system right now.
                </div>
            </div>
        <% 
            } else { 
                for (Map<String, String> camp : urgentRequests) {
                    String cat = camp.getOrDefault("category", "General");
                    boolean isUrgent = cat.contains("Food") || cat.contains("Disaster") || cat.contains("Healthcare");
        %>
            <div class="col-md-4 reveal">
                <div class="request-card d-flex flex-column h-100 justify-content-between">
                    <div>
                        <span class="urgent-tag <%= isUrgent ? "urgent" : "active" %>"><%= isUrgent ? "🔴 Urgent" : "🟢 Active" %></span>
                        <span class="badge bg-light text-dark border float-end text-uppercase" style="font-size: 10px; padding: 4px 8px;"><%= cat %></span>
                        <h4 class="mt-3 fw-bold h5 text-dark"><%= camp.get("title") %></h4>
                        <p class="text-secondary small line-clamp"><%= camp.get("description") %></p>
                    </div>
                    <div class="pt-3 border-top mt-2">
                        <div class="d-flex justify-content-between align-items-center mb-2" style="font-size: 12px;">
                            <span class="text-muted">NGO: <strong><%= camp.get("ngoName") %></strong></span>
                        </div>
                        <div class="request-footer d-flex justify-content-between align-items-center">
                            <span class="text-success fw-bold small"><i class="bi bi-geo-alt-fill"></i> <%= camp.get("city") %></span>
                            <a href="login.jsp" class="btn btn-success btn-sm px-3">Contribute</a>
                        </div>
                    </div>
                </div>
            </div>
        <% 
                } 
            } 
        %>
    </div>
</section>

<!-- TOP VOLUNTEERS -->
<section class="leaderboard-section py-4" id="leaderboard">
    <div class="container">
        <div class="text-center mb-4 reveal">
            <span class="section-badge">VOLUNTEER LEADERBOARD</span>
            <h2 class="mt-3 fw-bold section-title">Top Impact Makers</h2>
            <p class="text-secondary">Real-time performance ranking based on verified service records.</p>
        </div>

        <div class="row g-4 justify-content-center">
            <!-- #2 Position Mapped from Index 1 -->
            <div class="col-md-4 reveal">
                <div class="leader-card">
                    <div class="rank-badge">#2</div>
                    <i class="bi bi-award-fill feature-icon"></i>
                    <h4 class="mt-2 fw-bold"><%= leaderboard.get(1).get("name") %></h4>
                    <p class="text-secondary"><%= leaderboard.get(1).get("hours") %> Hours Completed</p>
                    <div class="progress-bar-wrap"><div class="progress-bar-fill" style="width: 80%"></div></div>
                    <span class="points"><i class="bi bi-star-fill"></i> <%= leaderboard.get(1).get("points") %> Score</span>
                </div>
            </div>

            <!-- #1 Position Mapped from Index 0 -->
            <div class="col-md-4 reveal">
                <div class="leader-card first-place">
                    <div class="rank-badge rank-gold">#1</div>
                    <i class="bi bi-trophy-fill feature-icon gold-icon"></i>
                    <h4 class="mt-2 fw-bold"><%= leaderboard.get(0).get("name") %></h4>
                    <p class="text-secondary"><%= leaderboard.get(0).get("hours") %> Hours Completed</p>
                    <div class="progress-bar-wrap"><div class="progress-bar-fill" style="width: 100%"></div></div>
                    <span class="points"><i class="bi bi-star-fill"></i> <%= leaderboard.get(0).get("points") %> Score</span>
                </div>
            </div>

            <!-- #3 Position Mapped from Index 2 -->
            <div class="col-md-4 reveal">
                <div class="leader-card">
                    <div class="rank-badge">#3</div>
                    <i class="bi bi-award-fill feature-icon"></i>
                    <h4 class="mt-2 fw-bold"><%= leaderboard.get(2).get("name") %></h4>
                    <p class="text-secondary"><%= leaderboard.get(2).get("hours") %> Hours Completed</p>
                    <div class="progress-bar-wrap"><div class="progress-bar-fill" style="width: 60%"></div></div>
                    <span class="points"><i class="bi bi-star-fill"></i> <%= leaderboard.get(2).get("points") %> Score</span>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- FEATURES SECTION -->
<section class="container py-4" id="features">
    <div class="text-center mb-4 reveal">
        <span class="section-badge">CARE LINK FEATURES</span>
        <h2 class="mt-3 fw-bold section-title">Everything Needed To Create Impact</h2>
    </div>
    <div class="row g-4">
        <div class="col-md-4 reveal"><div class="feature-card"><i class="bi bi-people-fill"></i><h4>Volunteer Matching</h4><p>Match volunteers with nearby NGO opportunities instantly.</p></div></div>
        <div class="col-md-4 reveal"><div class="feature-card"><i class="bi bi-chat-dots-fill"></i><h4>Real Time Chat</h4><p>Direct communication between NGOs and volunteers.</p></div></div>
        <div class="col-md-4 reveal"><div class="feature-card"><i class="bi bi-geo-alt-fill"></i><h4>Location Mapping</h4><p>Find requests and donation centers nearby on the map.</p></div></div>
        <div class="col-md-4 reveal"><div class="feature-card"><i class="bi bi-heart-fill"></i><h4>Donation Tracking</h4><p>Monitor donations and impact transparently.</p></div></div>
        <div class="col-md-4 reveal"><div class="feature-card"><i class="bi bi-trophy-fill"></i><h4>Volunteer Ranking</h4><p>Earn points and climb the leaderboard.</p></div></div>
        <div class="col-md-4 reveal"><div class="feature-card"><i class="bi bi-award-fill"></i><h4>Digital Certificates</h4><p>Get verified digital certificates for hours volunteered.</p></div></div>
    </div>
</section>

<!--  COMMUNITY PREVIEW -->
<section class="container py-4" id="community">
    <div class="text-center mb-4 reveal">
        <span class="section-badge">CARE LINK COMMUNITY</span>
        <h2 class="mt-3 fw-bold section-title">One Community. One Mission.</h2>
    </div>
    <div class="row g-4">
        <div class="col-md-4 reveal">
            <div class="community-card">
                <div class="d-flex align-items-center mb-3">
                    <div class="avatar-circle volunteer-avatar">DP</div>
                    <div><h6 class="mb-0">Disha Parmar</h6><small class="text-secondary"><i class="bi bi-patch-check-fill text-success"></i> Volunteer</small></div>
                </div>
                <p>Just completed the School Kit Donation drive in Indore &mdash; distributed supplies to kids today! 🎉</p>
                <div class="community-footer"><span class="like-btn"><i class="bi bi-heart"></i> 48</span><span class="text-secondary small">Just now</span></div>
            </div>
        </div>
        <div class="col-md-4 reveal">
            <div class="community-card">
                <div class="d-flex align-items-center mb-3">
                    <div class="avatar-circle ngo-avatar">HM</div>
                    <div><h6 class="mb-0">Dr. Harsh Mishra</h6><small class="text-secondary"><i class="bi bi-patch-check-fill text-success"></i> NGO</small></div>
                </div>
                <p>Thank you to all volunteers who supported our winter campaign loops. Goal successfully achieved! ❤️</p>
                <div class="community-footer"><span class="like-btn"><i class="bi bi-heart"></i> 93</span><span class="text-secondary small">5 hours ago</span></div>
            </div>
        </div>
        <div class="col-md-4 reveal">
            <div class="community-card">
                <div class="d-flex align-items-center mb-3">
                    <div class="avatar-circle donor-avatar">AP</div>
                    <div><h6 class="mb-0">Aminesh Parmar</h6><small class="text-secondary"><i class="bi bi-patch-check-fill text-success"></i> Donor</small></div>
                </div>
                <p>Proud to contribute financially to the local neighborhood development funds via CareLink. 🙏</p>
                <div class="community-footer"><span class="like-btn"><i class="bi bi-heart"></i> 61</span><span class="text-secondary small">1 day ago</span></div>
            </div>
        </div>
    </div>
</section>

<!--  HOW IT WORKS  -->
<section class="how-it-works-section py-4">
    <div class="container">
        <div class="text-center mb-4 reveal"><span class="section-badge">THE PROCESS</span><h2 class="mt-3 fw-bold section-title">How CARE LINK Works</h2></div>
        <div class="row text-center g-4">
            <div class="col-md-3 reveal"><div class="work-card"><div class="step-circle">1</div><i class="bi bi-building fs-1"></i><h5 class="mt-3">NGO Creates Request</h5><p class="text-secondary">NGOs post requirements for resource optimization workflows.</p></div></div>
            <div class="col-md-3 reveal"><div class="work-card"><div class="step-circle">2</div><i class="bi bi-people-fill fs-1"></i><h5 class="mt-3">Volunteers Join</h5><p class="text-secondary">Volunteers browse nearby allocations and apply instantly.</p></div></div>
            <div class="col-md-3 reveal"><div class="work-card"><div class="step-circle">3</div><i class="bi bi-heart-fill fs-1"></i><h5 class="mt-3">Donors Support</h5><p class="text-secondary">Donors contribute clean institutional funds directly.</p></div></div>
            <div class="col-md-3 reveal"><div class="work-card"><div class="step-circle">4</div><i class="bi bi-award-fill fs-1"></i><h5 class="mt-3">Earn Recognition</h5><p class="text-secondary">Download automated credentials and certificates.</p></div></div>
        </div>
    </div>
</section>

<!--  CTA BANNER  -->
<section class="cta-section reveal">
    <div class="container text-center">
        <h2 class="cta-title">Ready to Make a Difference?</h2>
        <div class="d-flex justify-content-center gap-3 flex-wrap mt-4">
            <a href="register.jsp?role=volunteer" class="btn btn-light btn-lg cta-btn"><i class="bi bi-people-fill"></i> Join as Volunteer</a>
            <a href="register.jsp?role=donor" class="btn btn-outline-light btn-lg cta-btn"><i class="bi bi-heart-fill"></i> Become a Donor</a>
        </div>
    </div>
</section>

<!-- ================= FOOTER ================= -->
<footer class="footer" id="contact">
    <div class="container">
        <div class="row g-4">
            <div class="col-md-4">
                <h4><i class="bi bi-heart-pulse-fill"></i> CARE LINK</h4>
                <p class="text-secondary mt-3">Connecting NGOs, Volunteers and Donors to build stronger communities together.</p>
            </div>
            <div class="col-md-2">
                <h4>Quick Links</h4>
                <ul class="list-unstyled mt-3 footer-links">
                    <li><a href="#top">Home</a></li>
                    <li><a href="#features">Features</a></li>
                    <li><a href="#requests">Requests</a></li>
                    <li><a href="#leaderboard">Volunteers</a></li>
                </ul>
            </div>
            <div class="col-md-3">
                <h4>Get Involved</h4>
                <ul class="list-unstyled mt-3 footer-links">
                    <li><a href="register.jsp?role=volunteer">Become Volunteer</a></li>
                    <li><a href="register.jsp?role=ngo">Register NGO</a></li>
                    <li><a href="login.jsp">Login Portal</a></li>
                </ul>
            </div>
            <div class="col-md-3">
                <h4>Contact Us</h4>
                <ul class="list-unstyled mt-3 footer-links">
                    <li><i class="bi bi-envelope-fill"></i> support@carelink.org</li>
                    <li class="mt-2"><i class="bi bi-telephone-fill"></i> +91 98765 43210</li>
                    <li class="mt-2"><i class="bi bi-geo-alt-fill"></i> Indore, India</li>
                </ul>
            </div>
        </div>
        <hr class="footer-hr">
        <p class="text-center text-secondary mb-0">&copy; 2026 CARE LINK. All Rights Reserved.</p>
    </div>
</footer>

<a href="#top" class="back-to-top" id="backToTop"><i class="bi bi-arrow-up"></i></a>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => { if (entry.isIntersecting) entry.target.classList.add('visible'); });
    }, { threshold: 0.12 });
    document.querySelectorAll('.reveal').forEach(el => observer.observe(el));

    window.addEventListener('scroll', () => {
        const nav = document.getElementById('mainNav');
        if (window.scrollY > 50) nav.classList.add('nav-scrolled');
        else nav.classList.remove('nav-scrolled');
    });

    const backBtn = document.getElementById('backToTop');
    window.addEventListener('scroll', () => {
        backBtn.style.opacity = window.scrollY > 400 ? '1' : '0';
        backBtn.style.pointerEvents = window.scrollY > 400 ? 'auto' : 'none';
    });
</script>
</body>
</html>