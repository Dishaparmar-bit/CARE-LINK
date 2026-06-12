<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>CARE LINK</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="css/style.css">
<link rel="stylesheet"
href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

</head>
<body>

<!-- Navbar -->
<nav class="navbar navbar-expand-lg fixed-top custom-nav">
    <div class="container">

        <a class="navbar-brand fw-bold logo-text" href="#">
            <i class="bi bi-heart-pulse-fill"></i> CARE LINK
        </a>

        <button class="navbar-toggler" type="button"
            data-bs-toggle="collapse"
            data-bs-target="#menu">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="menu">

            <ul class="navbar-nav ms-auto me-4">
                <li class="nav-item">
                    <a class="nav-link" href="#top">Home</a>
                </li>

                <li class="nav-item">
                    <a class="nav-link" href="#features">Features</a>
                </li>

                <li class="nav-item">
                    <a class="nav-link" href="#requests">Requests</a>
                </li>

                <li class="nav-item">
                    <a class="nav-link" href="#leaderboard">Volunteers</a>
                </li>

                <li class="nav-item">
                    <a class="nav-link" href="#community">Community</a>
                </li>

                <li class="nav-item">
                    <a class="nav-link" href="#contact">Contact</a>
                </li>
            </ul>

            <a href="login.jsp" class="btn login-btn">
                Login
            </a>

        </div>

    </div>
</nav>


<!-- Hero Section -->
<section class="hero-section" id="top">

<div class="container">

<div class="row align-items-center">

<div class="col-lg-7">

<span class="badge hero-badge">
    Community Impact Platform
</span>

<h1 class="hero-title">
    Connecting NGOs,
    Volunteers &
    Donors Together
</h1>

<p class="hero-text">

CARE LINK helps NGOs find volunteers,
receive donations and manage community
requests from one intelligent platform.

</p>

<div class="mt-4 hero-cta">

<a href="register.jsp?role=volunteer"
class="btn btn-success btn-lg me-3 mb-2">

<i class="bi bi-people-fill"></i>
Join as Volunteer

</a>

<a href="register.jsp?role=ngo"
class="btn btn-outline-light btn-lg me-3 mb-2">

<i class="bi bi-building"></i>
Register NGO

</a>

<a href="register.jsp?role=donor"
class="btn btn-warning btn-lg mb-2">

<i class="bi bi-heart-fill"></i>
Become Donor

</a>

</div>

<div class="hero-stats mt-5">

<div>
<h3>150+</h3>
<p>NGOs</p>
</div>

<div>
<h3>1200+</h3>
<p>Volunteers</p>
</div>

<div>
<h3>₹8L+</h3>
<p>Donations</p>
</div>

<div>
<h3>320+</h3>
<p>Requests Fulfilled</p>
</div>

</div>

</div>

<div class="col-lg-5 text-center">

<div class="hero-card">

<div class="live-dot"></div>

<h5>Live Impact</h5>

<hr>

<p><i class="bi bi-broadcast"></i> 24 Active NGO Requests</p>

<p><i class="bi bi-person-check-fill"></i> 85 Volunteers Available</p>

<p><i class="bi bi-gift-fill"></i> 12 Donation Drives Running</p>

<p class="text-success mb-0">
✓ Real-Time Community Support
</p>

</div>

</div>

</div>

</div>

</section>

<!-- NGO Requests -->

<section class="container py-5" id="requests">

    <div class="text-center mb-5">
        <span class="hero-badge">ACTIVE REQUESTS</span>

        <h2 class="mt-3 fw-bold section-title">
            Urgent Community Needs
        </h2>

        <p class="text-secondary">
            Support ongoing NGO initiatives near you.
        </p>
    </div>

    <div class="row g-4">

        <div class="col-md-4">

            <div class="request-card">

                <span class="urgent-tag">
                    Urgent
                </span>

                <h4 class="mt-3">Food Distribution Drive</h4>

                <p class="text-secondary">
                    Need volunteers and food supplies
                    for 300 families.
                </p>

                <div class="request-footer">
                    <span><i class="bi bi-geo-alt-fill"></i> Lucknow</span>
                    <a href="request.jsp?id=1" class="btn btn-success">
                        Support
                    </a>
                </div>

            </div>

        </div>

        <div class="col-md-4">

            <div class="request-card">

                <span class="urgent-tag">
                    Active
                </span>

                <h4 class="mt-3">School Kit Donation</h4>

                <p class="text-secondary">
                    Collecting notebooks and school
                    supplies for children.
                </p>

                <div class="request-footer">
                    <span><i class="bi bi-geo-alt-fill"></i> Kanpur</span>
                    <a href="request.jsp?id=2" class="btn btn-success">
                        Donate
                    </a>
                </div>

            </div>

        </div>

        <div class="col-md-4">

            <div class="request-card">

                <span class="urgent-tag">
                    New
                </span>

                <h4 class="mt-3">Blood Donation Camp</h4>

                <p class="text-secondary">
                    Volunteers required for organizing
                    health awareness camp.
                </p>

                <div class="request-footer">
                    <span><i class="bi bi-geo-alt-fill"></i> Prayagraj</span>
                    <a href="request.jsp?id=3" class="btn btn-success">
                        Join
                    </a>
                </div>

            </div>

        </div>

    </div>

    <div class="text-center mt-4">
        <a href="request.jsp" class="btn btn-outline-light">
            View All Requests <i class="bi bi-arrow-right"></i>
        </a>
    </div>

</section>

<!-- Top Volunteers -->

<section class="container py-5" id="leaderboard">

    <div class="text-center mb-5">
        <span class="hero-badge">VOLUNTEER LEADERBOARD</span>

        <h2 class="mt-3 fw-bold section-title">
            Top Impact Makers
        </h2>

        <p class="text-secondary">
            Volunteers making the biggest difference in communities.
        </p>
    </div>

    <div class="row g-4">

        <div class="col-md-4">
            <div class="leader-card first-place">

                <div class="rank-badge">#1</div>

                <i class="bi bi-trophy-fill feature-icon"></i>

                <h4 class="mt-2">Rahul Sharma</h4>

                <p class="text-secondary">120 Hours Completed</p>

                <span class="points">
                    <i class="bi bi-star-fill"></i> 2500 Points
                </span>

            </div>
        </div>

        <div class="col-md-4">
            <div class="leader-card">

                <div class="rank-badge">#2</div>

                <i class="bi bi-award-fill feature-icon"></i>

                <h4 class="mt-2">Priya Verma</h4>

                <p class="text-secondary">95 Hours Completed</p>

                <span class="points">
                    <i class="bi bi-star-fill"></i> 2100 Points
                </span>

            </div>
        </div>

        <div class="col-md-4">
            <div class="leader-card">

                <div class="rank-badge">#3</div>

                <i class="bi bi-award-fill feature-icon"></i>

                <h4 class="mt-2">Aman Singh</h4>

                <p class="text-secondary">80 Hours Completed</p>

                <span class="points">
                    <i class="bi bi-star-fill"></i> 1800 Points
                </span>

            </div>
        </div>

    </div>

    <div class="text-center mt-4">
        <a href="register.jsp?role=volunteer" class="btn btn-outline-light">
            Join the Leaderboard <i class="bi bi-arrow-right"></i>
        </a>
    </div>

</section>

<!-- Features Section -->

<section class="container py-5" id="features">

    <div class="text-center mb-5">
        <span class="hero-badge">CARE LINK FEATURES</span>

        <h2 class="mt-3 fw-bold section-title">
            Everything Needed To Create Impact
        </h2>

        <p class="text-secondary">
            NGOs, Volunteers and Donors connected through one platform.
        </p>
    </div>

    <div class="row g-4">

        <div class="col-md-4">
            <div class="feature-card">
                <i class="bi bi-people-fill"></i>
                <h4>Volunteer Matching</h4>
                <p>
                    Match volunteers with nearby NGO opportunities.
                </p>
            </div>
        </div>

        <div class="col-md-4">
            <div class="feature-card">
                <i class="bi bi-chat-dots-fill"></i>
                <h4>Real Time Chat</h4>
                <p>
                    Direct communication between NGOs and volunteers.
                </p>
            </div>
        </div>

        <div class="col-md-4">
            <div class="feature-card">
                <i class="bi bi-geo-alt-fill"></i>
                <h4>Location Mapping</h4>
                <p>
                    Find requests and donation centers nearby on the map.
                </p>
            </div>
        </div>

        <div class="col-md-4">
            <div class="feature-card">
                <i class="bi bi-heart-fill"></i>
                <h4>Donation Tracking</h4>
                <p>
                    Monitor donations and impact transparently.
                </p>
            </div>
        </div>

        <div class="col-md-4">
            <div class="feature-card">
                <i class="bi bi-trophy-fill"></i>
                <h4>Volunteer Ranking</h4>
                <p>
                    Earn points and climb the leaderboard.
                </p>
            </div>
        </div>

        <div class="col-md-4">
            <div class="feature-card">
                <i class="bi bi-award-fill"></i>
                <h4>Digital Certificates</h4>
                <p>
                    Get verified digital certificates for hours volunteered
                    and donations made.
                </p>
            </div>
        </div>

    </div>

</section>

<!-- Community Preview -->

<section class="container py-5" id="community">

    <div class="text-center mb-5">
        <span class="hero-badge">CARE LINK COMMUNITY</span>

        <h2 class="mt-3 fw-bold section-title">
            One Community. One Mission.
        </h2>

        <p class="text-secondary">
            NGOs, Volunteers and Donors share updates, stories and support each other.
        </p>
    </div>

    <div class="row g-4">

        <div class="col-md-4">
            <div class="feature-card text-start">
                <div class="d-flex align-items-center mb-3">
                    <i class="bi bi-person-circle fs-2 me-2"></i>
                    <div>
                        <h6 class="mb-0">Priya Verma</h6>
                        <small class="text-secondary">Volunteer</small>
                    </div>
                </div>
                <p>
                    Just completed the School Kit Donation drive in Kanpur —
                    distributed 150 kits today! 🎉
                </p>
            </div>
        </div>

        <div class="col-md-4">
            <div class="feature-card text-start">
                <div class="d-flex align-items-center mb-3">
                    <i class="bi bi-building fs-2 me-2"></i>
                    <div>
                        <h6 class="mb-0">Hope Foundation</h6>
                        <small class="text-secondary">NGO</small>
                    </div>
                </div>
                <p>
                    Thank you to all donors who supported our Blood Donation Camp.
                    Goal achieved! ❤️
                </p>
            </div>
        </div>

        <div class="col-md-4">
            <div class="feature-card text-start">
                <div class="d-flex align-items-center mb-3">
                    <i class="bi bi-person-circle fs-2 me-2"></i>
                    <div>
                        <h6 class="mb-0">Aman Singh</h6>
                        <small class="text-secondary">Donor</small>
                    </div>
                </div>
                <p>
                    Proud to contribute to the Food Distribution Drive.
                    Every bit helps! 🙏
                </p>
            </div>
        </div>

    </div>

    <div class="text-center mt-4">
        <a href="login.jsp" class="btn btn-success">
            <i class="bi bi-chat-square-heart-fill"></i> Join the Community
        </a>
    </div>

</section>

<!----- HOW IT WORKS ------>

<div class="container mt-5 mb-5">

    <h2 class="text-center mb-5 section-title">
        How CARE LINK Works
    </h2>

    <div class="row text-center g-4">

        <div class="col-md-3">
            <div class="work-card">
                <div class="step-circle">1</div>

                <i class="bi bi-building fs-1"></i>

                <h5 class="mt-3">NGO Creates Request</h5>

                <p class="text-secondary">
                    NGOs post requirements for food,
                    education, healthcare or supplies.
                </p>
            </div>
        </div>

        <div class="col-md-3">
            <div class="work-card">
                <div class="step-circle">2</div>

                <i class="bi bi-people-fill fs-1"></i>

                <h5 class="mt-3">Volunteers Join</h5>

                <p class="text-secondary">
                    Volunteers browse opportunities
                    and register instantly.
                </p>
            </div>
        </div>

        <div class="col-md-3">
            <div class="work-card">
                <div class="step-circle">3</div>

                <i class="bi bi-heart-fill fs-1"></i>

                <h5 class="mt-3">Donors Support</h5>

                <p class="text-secondary">
                    Donors contribute funds,
                    resources and supplies.
                </p>
            </div>
        </div>

        <div class="col-md-3">
            <div class="work-card">
                <div class="step-circle">4</div>

                <i class="bi bi-award-fill fs-1"></i>

                <h5 class="mt-3">Earn Recognition</h5>

                <p class="text-secondary">
                    Get certificates, points and
                    climb the leaderboard.
                </p>
            </div>
        </div>

    </div>

</div>

<!-- Footer -->
<footer class="footer" id="contact">
    <div class="container">
        <div class="row g-4">

            <div class="col-md-4">
                <h4><i class="bi bi-heart-pulse-fill"></i> CARE LINK</h4>
                <p class="text-secondary mt-3">
                    Connecting NGOs, Volunteers and Donors to build
                    stronger communities together.
                </p>
            </div>

            <div class="col-md-2">
                <h4>Quick Links</h4>
                <ul class="list-unstyled mt-3 footer-links">
                    <li><a href="#top">Home</a></li>
                    <li><a href="#features">Features</a></li>
                    <li><a href="#requests">Requests</a></li>
                    <li><a href="#leaderboard">Volunteers</a></li>
                    <li><a href="#community">Community</a></li>
                </ul>
            </div>

            <div class="col-md-3">
                <h4>Get Involved</h4>
                <ul class="list-unstyled mt-3 footer-links">
                    <li><a href="register.jsp?role=volunteer">Become a Volunteer</a></li>
                    <li><a href="register.jsp?role=ngo">Register your NGO</a></li>
                    <li><a href="register.jsp?role=donor">Become a Donor</a></li>
                    <li><a href="login.jsp">Login</a></li>
                </ul>
            </div>

            <div class="col-md-3">
                <h4>Contact Us</h4>
                <ul class="list-unstyled mt-3 footer-links">
                    <li><i class="bi bi-envelope-fill"></i> support@carelink.org</li>
                    <li><i class="bi bi-telephone-fill"></i> +91 98765 43210</li>
                    <li><i class="bi bi-geo-alt-fill"></i> Lucknow, India</li>
                </ul>

                <div class="social-icons mt-3">
                    <a href="#"><i class="bi bi-facebook"></i></a>
                    <a href="#"><i class="bi bi-twitter-x"></i></a>
                    <a href="#"><i class="bi bi-instagram"></i></a>
                    <a href="#"><i class="bi bi-linkedin"></i></a>
                </div>
            </div>

        </div>

        <hr class="footer-hr">

        <p class="text-center text-secondary mb-0">
            &copy; 2026 CARE LINK. All Rights Reserved.
        </p>
    </div>
</footer>


<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
