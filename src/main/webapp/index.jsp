<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
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
                    <a class="nav-link" href="#">Home</a>
                </li>

                <li class="nav-item">
                    <a class="nav-link" href="#">Features</a>
                </li>

                <li class="nav-item">
                    <a class="nav-link" href="#">NGOs</a>
                </li>

                <li class="nav-item">
                    <a class="nav-link" href="#">Volunteers</a>
                </li>

                <li class="nav-item">
                    <a class="nav-link" href="#">Contact</a>
                </li>
            </ul>

            <a href="login.jsp" class="btn login-btn">
                Login
            </a>

        </div>

    </div>
</nav>


<!-- Hero Section -->
<section class="hero-section">

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

<div class="mt-4">

<a href="register.jsp"
class="btn btn-success btn-lg me-3">

<i class="bi bi-people-fill"></i>
Join Volunteer

</a>

<a href="register.jsp"
class="btn btn-outline-light btn-lg me-3">

<i class="bi bi-building"></i>
Register NGO

</a>

<a href="register.jsp"
class="btn btn-warning btn-lg">

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

</div>

</div>

<div class="col-lg-5 text-center">

<div class="hero-card">

<div class="live-dot"></div>

<h5>Live Impact</h5>

<hr>

<p>24 Active NGO Requests</p>

<p>85 Volunteers Available</p>

<p>12 Donation Drives Running</p>

<p class="text-success">
✓ Real-Time Community Support
</p>

</div>

</div>

</div>

</div>

</section>
<!-- Statistics -->
<div class="container mt-5">

    <div class="row text-center">

        <div class="col-md-3 mb-3">
            <div class="card p-4">
                <h2>150+</h2>
                <p>NGOs</p>
            </div>
        </div>

        <div class="col-md-3 mb-3">
            <div class="card p-4">
                <h2>1200+</h2>
                <p>Volunteers</p>
            </div>
        </div>

        <div class="col-md-3 mb-3">
            <div class="card p-4">
                <h2>450+</h2>
                <p>Donations</p>
            </div>
        </div>

        <div class="col-md-3 mb-3">
            <div class="card p-4">
                <h2>320+</h2>
                <p>Requests Completed</p>
            </div>
        </div>

    </div>

</div>

<!-- NGO Requests -->

<section class="container py-5">

    <div class="text-center mb-5">
        <span class="hero-badge">ACTIVE REQUESTS</span>

        <h2 class="mt-3 fw-bold">
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

                <h4>Food Distribution Drive</h4>

                <p>
                    Need volunteers and food supplies
                    for 300 families.
                </p>

                <div class="request-footer">
                    <span>Lucknow</span>
                    <button class="btn btn-success">
                        Support
                    </button>
                </div>

            </div>

        </div>

        <div class="col-md-4">

            <div class="request-card">

                <span class="urgent-tag">
                    Active
                </span>

                <h4>School Kit Donation</h4>

                <p>
                    Collecting notebooks and school
                    supplies for children.
                </p>

                <div class="request-footer">
                    <span>Kanpur</span>
                    <button class="btn btn-success">
                        Donate
                    </button>
                </div>

            </div>

        </div>

        <div class="col-md-4">

            <div class="request-card">

                <span class="urgent-tag">
                    New
                </span>

                <h4>Blood Donation Camp</h4>

                <p>
                    Volunteers required for organizing
                    health awareness camp.
                </p>

                <div class="request-footer">
                    <span>Prayagraj</span>
                    <button class="btn btn-success">
                        Join
                    </button>
                </div>

            </div>

        </div>

    </div>

</section>

<!-- Top Volunteers -->

<section class="container py-5">

    <div class="text-center mb-5">
        <span class="hero-badge">VOLUNTEER LEADERBOARD</span>

        <h2 class="mt-3 fw-bold">
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

                <h4>Rahul Sharma</h4>

                <p>120 Hours Completed</p>

                <span class="points">
                    ⭐ 2500 Points
                </span>

            </div>
        </div>

        <div class="col-md-4">
            <div class="leader-card">

                <div class="rank-badge">#2</div>

                <h4>Priya Verma</h4>

                <p>95 Hours Completed</p>

                <span class="points">
                    ⭐ 2100 Points
                </span>

            </div>
        </div>

        <div class="col-md-4">
            <div class="leader-card">

                <div class="rank-badge">#3</div>

                <h4>Aman Singh</h4>

                <p>80 Hours Completed</p>

                <span class="points">
                    ⭐ 1800 Points
                </span>

            </div>
        </div>

    </div>

</section>

<!-- Features Section -->

<section class="container py-5">

    <div class="text-center mb-5">
        <span class="hero-badge">CARE LINK FEATURES</span>

        <h2 class="mt-3 fw-bold">
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
                    Find requests and donation centers nearby.
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
                <h4>Certificates</h4>
                <p>
                    Get digital certificates after completed drives.
                </p>
            </div>
        </div>

    </div>

</section>
<!----- HOW IT WORKS ------>

<div class="container mt-5 mb-5">

    <h2 class="text-center mb-5">
        How CARE LINK Works
    </h2>

    <div class="row text-center">

        <div class="col-md-3">
            <div class="work-card">
                <div class="step-circle">1</div>

                <i class="bi bi-building fs-1"></i>

                <h5 class="mt-3">NGO Creates Request</h5>

                <p>
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

                <p>
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

                <p>
                    Donors contribute funds,
                    resources and supplies.
                </p>
            </div>
        </div>

        <div class="col-md-3">
            <div class="work-card">
                <div class="step-circle">4</div>

                <i class="bi bi-globe2 fs-1"></i>

                <h5 class="mt-3">Community Benefits</h5>

                <p>
                    Help reaches the people
                    who need it most.
                </p>
            </div>
        </div>

    </div>

</div>



<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>