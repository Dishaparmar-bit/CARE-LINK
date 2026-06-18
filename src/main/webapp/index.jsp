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
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

</head>
<body>

<!-- ================= NAVBAR ================= -->
<nav class="navbar navbar-expand-lg fixed-top reg-nav custom-nav" id="mainNav">
    <div class="container">

        <a class="navbar-brand logo-text" href="index.jsp">
            <i class="bi bi-heart-pulse-fill"></i> CARE LINK
        </a>

        <button class="navbar-toggler" type="button"
                data-bs-toggle="collapse" data-bs-target="#regMenu">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="regMenu">
            <ul class="navbar-nav ms-auto align-items-lg-center me-3">
                <li class="nav-item">
                    <a class="nav-link" href="index.jsp#top">
                        <i class="bi bi-house-fill"></i> Home
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="index.jsp#features">
                        <i class="bi bi-stars"></i> Features
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="index.jsp#requests">
                        <i class="bi bi-card-list"></i> Requests
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="index.jsp#leaderboard">
                        <i class="bi bi-trophy-fill"></i> Volunteers
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="index.jsp#community">
                        <i class="bi bi-people-fill"></i> Community
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="index.jsp#contact">
                        <i class="bi bi-envelope-fill"></i> Contact
                    </a>
                </li>
            </ul>
              <a href="login.jsp" class="btn login-btn ms-lg-3">Login</a>
               <a href="register.jsp" class="btn login-btn ms-lg-3">Register</a>
        </div>

    </div>
</nav>

<!-- ================= HERO SECTION ================== -->

<section class="hero-section" id="top">

    <div id="heroCarousel"
         class="carousel slide hero-bg-carousel"
         data-bs-ride="carousel"
         data-bs-interval="4000">
        <div class="carousel-inner">
            <div class="carousel-item active">
                <img src="images/volunteer.jpg"
                     onerror="this.onerror=null;this.src='https://images.unsplash.com/photo-1593113598332-cd288d649433?w=1600&q=80'"
                     alt="Volunteer">
            </div>
            <div class="carousel-item">
                <img src="images/community.jpg"
                     onerror="this.onerror=null;this.src='https://images.unsplash.com/photo-1509099836639-18ba1795216d?w=1600&q=80'"
                     alt="Community">
            </div>
            <div class="carousel-item">
                <img src="images/donation.jpg"
                     onerror="this.onerror=null;this.src='https://images.unsplash.com/photo-1532629345422-7515f3d16bb6?w=1600&q=80'"
                     alt="Donation">
            </div>
            <div class="carousel-item">
                <img src="images/ngo.jpg"
                     onerror="this.onerror=null;this.src='https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?w=1600&q=80'"
                     alt="NGO">
            </div>
        </div>
    </div>

    <div class="hero-overlay"></div>

    <div class="container position-relative">
        <div class="row">
            <div class="col-lg-7">

                <span class="hero-badge reveal">
                    <i class="bi bi-geo-alt-fill"></i> India's Community Impact Platform
                </span>

                <h1 class="hero-title reveal">
                    Connecting Communities<br>Through Action
                </h1>

                <p class="hero-text reveal">
                    CARE LINK connects NGOs, volunteers and donors on one platform
                    to create meaningful impact and help communities grow stronger together.
                </p>

                <div class="mt-4 d-flex flex-wrap gap-3 reveal">
                    <a href="register.jsp?role=volunteer" class="btn btn-success btn-lg hero-btn">
                        <i class="bi bi-people-fill"></i> Join Volunteer
                    </a>
                    <a href="register.jsp?role=ngo" class="btn btn-outline-light btn-lg hero-btn">
                        <i class="bi bi-building"></i> Register NGO
                    </a>
                    <a href="register.jsp?role=donor" class="btn btn-warning btn-lg hero-btn">
                        <i class="bi bi-heart-fill"></i> Become Donor
                    </a>
                </div>

                <div class="hero-stats mt-5 reveal">
                    <div class="hero-stat-item">
                        <h3>150+</h3>
                        <p>NGOs</p>
                    </div>
                    <div class="hero-stat-divider"></div>
                    <div class="hero-stat-item">
                        <h3>1200+</h3>
                        <p>Volunteers</p>
                    </div>
                    <div class="hero-stat-divider"></div>
                    <div class="hero-stat-item">
                        <h3>&#8377;8L+</h3>
                        <p>Donations</p>
                    </div>
                    <div class="hero-stat-divider"></div>
                    <div class="hero-stat-item">
                        <h3>320+</h3>
                        <p>Requests Fulfilled</p>
                    </div>
                </div>

            </div>
        </div>
    </div>

    <!-- Scroll hint -->
    <div class="scroll-hint">
        <i class="bi bi-chevron-double-down"></i>
    </div>

</section>

<!-- ================= NGO REQUESTS ================= -->

<section class="container py-4" id="requests">

    <div class="text-center mb-4 reveal">
        <span class="section-badge">ACTIVE REQUESTS</span>
        <h2 class="mt-3 fw-bold section-title">Urgent Community Needs</h2>
        <p class="text-secondary">Support ongoing NGO initiatives near you.</p>
    </div>

    <div class="row g-4">

        <div class="col-md-4 reveal reveal-delay-1">
            <div class="request-card">
                <span class="urgent-tag urgent">&#128308; Urgent</span>
                <h4 class="mt-3">Food Distribution Drive</h4>
                <p class="text-secondary">Need volunteers and food supplies for 300 families.</p>
                <div class="request-meta">
                    <span class="meta-pill"><i class="bi bi-people-fill"></i> 12 volunteers needed</span>
                    <span class="meta-pill"><i class="bi bi-calendar3"></i> Jun 20</span>
                </div>
                <div class="request-footer">
                    <span><i class="bi bi-geo-alt-fill"></i> Lucknow</span>
                    <a href="request.jsp?id=1" class="btn btn-success btn-sm">Support</a>
                </div>
            </div>
        </div>

        <div class="col-md-4 reveal reveal-delay-2">
            <div class="request-card">
                <span class="urgent-tag active">&#128994; Active</span>
                <h4 class="mt-3">School Kit Donation</h4>
                <p class="text-secondary">Collecting notebooks and school supplies for children.</p>
                <div class="request-meta">
                    <span class="meta-pill"><i class="bi bi-box-seam"></i> 200 kits needed</span>
                    <span class="meta-pill"><i class="bi bi-calendar3"></i> Jun 25</span>
                </div>
                <div class="request-footer">
                    <span><i class="bi bi-geo-alt-fill"></i> Kanpur</span>
                    <a href="request.jsp?id=2" class="btn btn-success btn-sm">Donate</a>
                </div>
            </div>
        </div>

        <div class="col-md-4 reveal reveal-delay-3">
            <div class="request-card">
                <span class="urgent-tag new">&#128309; New</span>
                <h4 class="mt-3">Blood Donation Camp</h4>
                <p class="text-secondary">Volunteers required for organizing health awareness camp.</p>
                <div class="request-meta">
                    <span class="meta-pill"><i class="bi bi-droplet-fill"></i> 50 donors needed</span>
                    <span class="meta-pill"><i class="bi bi-calendar3"></i> Jul 1</span>
                </div>
                <div class="request-footer">
                    <span><i class="bi bi-geo-alt-fill"></i> Prayagraj</span>
                    <a href="request.jsp?id=3" class="btn btn-success btn-sm">Join</a>
                </div>
            </div>
        </div>

    </div>

    <div class="text-center mt-4 reveal">
        <a href="request.jsp" class="btn btn-outline-success">
            View All Requests <i class="bi bi-arrow-right"></i>
        </a>
    </div>

</section>

<!-- ================= TOP VOLUNTEERS ================= -->

<section class="leaderboard-section py-4" id="leaderboard">
    <div class="container">

        <div class="text-center mb-4 reveal">
            <span class="section-badge">VOLUNTEER LEADERBOARD</span>
            <h2 class="mt-3 fw-bold section-title">Top Impact Makers</h2>
            <p class="text-secondary">Volunteers making the biggest difference in communities.</p>
        </div>

        <div class="row g-4 justify-content-center">

            <!-- #2 shown left -->
            <div class="col-md-4 reveal reveal-delay-1">
                <div class="leader-card">
                    <div class="rank-badge">#2</div>
                    <i class="bi bi-award-fill feature-icon"></i>
                    <h4 class="mt-2">Priya Verma</h4>
                    <p class="text-secondary">95 Hours Completed</p>
                    <div class="progress-bar-wrap">
                        <div class="progress-bar-fill" style="width:84%"></div>
                    </div>
                    <span class="points"><i class="bi bi-star-fill"></i> 2100 Points</span>
                </div>
            </div>

            <!-- #1 center, elevated -->
            <div class="col-md-4 reveal reveal-delay-2">
                <div class="leader-card first-place">
                    <div class="rank-badge rank-gold">#1</div>
                    <i class="bi bi-trophy-fill feature-icon gold-icon"></i>
                    <h4 class="mt-2">Rahul Sharma</h4>
                    <p class="text-secondary">120 Hours Completed</p>
                    <div class="progress-bar-wrap">
                        <div class="progress-bar-fill" style="width:100%"></div>
                    </div>
                    <span class="points"><i class="bi bi-star-fill"></i> 2500 Points</span>
                </div>
            </div>

            <!-- #3 shown right -->
            <div class="col-md-4 reveal reveal-delay-3">
                <div class="leader-card">
                    <div class="rank-badge">#3</div>
                    <i class="bi bi-award-fill feature-icon"></i>
                    <h4 class="mt-2">Aman Singh</h4>
                    <p class="text-secondary">80 Hours Completed</p>
                    <div class="progress-bar-wrap">
                        <div class="progress-bar-fill" style="width:72%"></div>
                    </div>
                    <span class="points"><i class="bi bi-star-fill"></i> 1800 Points</span>
                </div>
            </div>

        </div>

        <div class="text-center mt-4 reveal">
            <a href="register.jsp?role=volunteer" class="btn btn-outline-success">
                Join the Leaderboard <i class="bi bi-arrow-right"></i>
            </a>
        </div>

    </div>
</section>

<!-- ================= FEATURES SECTION ================= -->

<section class="container py-4" id="features">

    <div class="text-center mb-4 reveal">
        <span class="section-badge">CARE LINK FEATURES</span>
        <h2 class="mt-3 fw-bold section-title">Everything Needed To Create Impact</h2>
        <p class="text-secondary">NGOs, Volunteers and Donors connected through one platform.</p>
    </div>

    <div class="row g-4">

        <div class="col-md-4 reveal reveal-delay-1">
            <div class="feature-card">
                <i class="bi bi-people-fill"></i>
                <h4>Volunteer Matching</h4>
                <p>Match volunteers with nearby NGO opportunities instantly.</p>
            </div>
        </div>

        <div class="col-md-4 reveal reveal-delay-2">
            <div class="feature-card">
                <i class="bi bi-chat-dots-fill"></i>
                <h4>Real Time Chat</h4>
                <p>Direct communication between NGOs and volunteers.</p>
            </div>
        </div>

        <div class="col-md-4 reveal reveal-delay-3">
            <div class="feature-card">
                <i class="bi bi-geo-alt-fill"></i>
                <h4>Location Mapping</h4>
                <p>Find requests and donation centers nearby on the map.</p>
            </div>
        </div>

        <div class="col-md-4 reveal reveal-delay-1">
            <div class="feature-card">
                <i class="bi bi-heart-fill"></i>
                <h4>Donation Tracking</h4>
                <p>Monitor donations and impact transparently.</p>
            </div>
        </div>

        <div class="col-md-4 reveal reveal-delay-2">
            <div class="feature-card">
                <i class="bi bi-trophy-fill"></i>
                <h4>Volunteer Ranking</h4>
                <p>Earn points and climb the leaderboard.</p>
            </div>
        </div>

        <div class="col-md-4 reveal reveal-delay-3">
            <div class="feature-card">
                <i class="bi bi-award-fill"></i>
                <h4>Digital Certificates</h4>
                <p>Get verified digital certificates for hours volunteered and donations made.</p>
            </div>
        </div>

    </div>

</section>

<!-- ================= COMMUNITY PREVIEW ================= -->

<section class="container py-4" id="community">

    <div class="text-center mb-4 reveal">
        <span class="section-badge">CARE LINK COMMUNITY</span>
        <h2 class="mt-3 fw-bold section-title">One Community. One Mission.</h2>
        <p class="text-secondary">NGOs, Volunteers and Donors share updates, stories and support each other.</p>
    </div>

    <div class="row g-4">

        <div class="col-md-4 reveal reveal-delay-1">
            <div class="community-card">
                <div class="d-flex align-items-center mb-3">
                    <div class="avatar-circle volunteer-avatar">PV</div>
                    <div>
                        <h6 class="mb-0">Priya Verma</h6>
                        <small class="text-secondary"><i class="bi bi-patch-check-fill text-success"></i> Volunteer</small>
                    </div>
                </div>
                <p>Just completed the School Kit Donation drive in Kanpur &mdash; distributed 150 kits today! &#127881;</p>
                <div class="community-footer">
                    <span class="like-btn"><i class="bi bi-heart"></i> 48</span>
                    <span class="text-secondary small">2 hours ago</span>
                </div>
            </div>
        </div>

        <div class="col-md-4 reveal reveal-delay-2">
            <div class="community-card">
                <div class="d-flex align-items-center mb-3">
                    <div class="avatar-circle ngo-avatar">HF</div>
                    <div>
                        <h6 class="mb-0">Hope Foundation</h6>
                        <small class="text-secondary"><i class="bi bi-patch-check-fill text-success"></i> NGO</small>
                    </div>
                </div>
                <p>Thank you to all donors who supported our Blood Donation Camp. Goal achieved! &#10084;&#65039;</p>
                <div class="community-footer">
                    <span class="like-btn"><i class="bi bi-heart"></i> 93</span>
                    <span class="text-secondary small">5 hours ago</span>
                </div>
            </div>
        </div>

        <div class="col-md-4 reveal reveal-delay-3">
            <div class="community-card">
                <div class="d-flex align-items-center mb-3">
                    <div class="avatar-circle donor-avatar">AS</div>
                    <div>
                        <h6 class="mb-0">Aman Singh</h6>
                        <small class="text-secondary"><i class="bi bi-patch-check-fill text-success"></i> Donor</small>
                    </div>
                </div>
                <p>Proud to contribute to the Food Distribution Drive. Every bit helps! &#128591;</p>
                <div class="community-footer">
                    <span class="like-btn"><i class="bi bi-heart"></i> 61</span>
                    <span class="text-secondary small">1 day ago</span>
                </div>
            </div>
        </div>

    </div>

    <div class="text-center mt-4 reveal">
        <a href="login.jsp" class="btn btn-success">
            <i class="bi bi-chat-square-heart-fill"></i> Join the Community
        </a>
    </div>

</section>

<!-- ================= HOW IT WORKS ================= -->

<section class="how-it-works-section py-4">
    <div class="container">

        <div class="text-center mb-4 reveal">
            <span class="section-badge">THE PROCESS</span>
            <h2 class="mt-3 fw-bold section-title">How CARE LINK Works</h2>
        </div>

        <div class="row text-center g-4">

            <div class="col-md-3 reveal reveal-delay-1">
                <div class="work-card">
                    <div class="step-circle">1</div>
                    <i class="bi bi-building fs-1"></i>
                    <h5 class="mt-3">NGO Creates Request</h5>
                    <p class="text-secondary">NGOs post requirements for food, education, healthcare or supplies.</p>
                </div>
            </div>

            <div class="col-md-3 reveal reveal-delay-2">
                <div class="work-card">
                    <div class="step-circle">2</div>
                    <i class="bi bi-people-fill fs-1"></i>
                    <h5 class="mt-3">Volunteers Join</h5>
                    <p class="text-secondary">Volunteers browse opportunities and register instantly.</p>
                </div>
            </div>

            <div class="col-md-3 reveal reveal-delay-3">
                <div class="work-card">
                    <div class="step-circle">3</div>
                    <i class="bi bi-heart-fill fs-1"></i>
                    <h5 class="mt-3">Donors Support</h5>
                    <p class="text-secondary">Donors contribute funds, resources and supplies.</p>
                </div>
            </div>

            <div class="col-md-3 reveal reveal-delay-4">
                <div class="work-card">
                    <div class="step-circle">4</div>
                    <i class="bi bi-award-fill fs-1"></i>
                    <h5 class="mt-3">Earn Recognition</h5>
                    <p class="text-secondary">Get certificates, points and climb the leaderboard.</p>
                </div>
            </div>

        </div>

    </div>
</section>

<!-- ================= CTA BANNER ================= -->

<section class="cta-section reveal">
    <div class="container text-center">
        <h2 class="cta-title">Ready to Make a Difference?</h2>
        <p class="cta-sub">Join thousands of volunteers, NGOs and donors across India.</p>
        <div class="d-flex justify-content-center gap-3 flex-wrap mt-4">
            <a href="register.jsp?role=volunteer" class="btn btn-light btn-lg cta-btn">
                <i class="bi bi-people-fill"></i> Join as Volunteer
            </a>
            <a href="register.jsp?role=donor" class="btn btn-outline-light btn-lg cta-btn">
                <i class="bi bi-heart-fill"></i> Become a Donor
            </a>
        </div>
    </div>
</section>

<!-- ================= FOOTER ================= -->

<footer class="footer" id="contact">
    <div class="container">
        <div class="row g-4">

            <div class="col-md-4">
                <h4><i class="bi bi-heart-pulse-fill"></i> CARE LINK</h4>
                <p class="text-secondary mt-3">
                    Connecting NGOs, Volunteers and Donors to build stronger communities together.
                </p>
                <div class="social-icons mt-3">
                    <a href="#"><i class="bi bi-facebook"></i></a>
                    <a href="#"><i class="bi bi-twitter-x"></i></a>
                    <a href="#"><i class="bi bi-instagram"></i></a>
                    <a href="#"><i class="bi bi-linkedin"></i></a>
                </div>
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
                    <li class="mt-2"><i class="bi bi-telephone-fill"></i> +91 98765 43210</li>
                    <li class="mt-2"><i class="bi bi-geo-alt-fill"></i> Lucknow, India</li>
                </ul>
            </div>

        </div>

        <hr class="footer-hr">

        <p class="text-center text-secondary mb-0">
            &copy; 2026 CARE LINK. All Rights Reserved.
        </p>
    </div>
</footer>

<!-- Back to top button -->
<a href="#top" class="back-to-top" id="backToTop">
    <i class="bi bi-arrow-up"></i>
</a>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // ---- Scroll reveal animation ----
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('visible');
            }
        });
    }, { threshold: 0.12 });

    document.querySelectorAll('.reveal').forEach(el => observer.observe(el));

    // ---- Navbar shadow on scroll ----
    window.addEventListener('scroll', () => {
        const nav = document.getElementById('mainNav');
        if (window.scrollY > 50) {
            nav.classList.add('nav-scrolled');
        } else {
            nav.classList.remove('nav-scrolled');
        }
    });

    // ---- Back to top button ----
    const backBtn = document.getElementById('backToTop');
    window.addEventListener('scroll', () => {
        backBtn.style.opacity = window.scrollY > 400 ? '1' : '0';
        backBtn.style.pointerEvents = window.scrollY > 400 ? 'auto' : 'none';
    });

    // ---- Community like button toggle ----
    document.querySelectorAll('.like-btn').forEach(btn => {
        btn.addEventListener('click', () => {
            btn.classList.toggle('liked');
        });
    });
</script>

</body>
</html>
