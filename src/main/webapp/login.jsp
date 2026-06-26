<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Login — CARE LINK</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="css/style.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<link rel="stylesheet" href="css/login.css">

</head>
<body class="login-page-bg">

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
             <a href="register.jsp" class="btn login-btn ms-lg-3">Register</a>
        </div>

    </div>
</nav>

<!-- ================= LOGIN SECTION ================= -->
<div class="login-wrapper">

    <div class="login-card">

        <!-- Logo -->
        <a href="index.jsp" class="login-logo">
            <i class="bi bi-heart-pulse-fill"></i> CARE LINK
        </a>

        <h2>Welcome Back</h2>
        <p class="subtitle">Login to continue making an impact</p>

        <!-- ---- Dynamic Alert Messaging Container ---- -->
        <%
            String registered = request.getParameter("registered");
            String loginError = request.getParameter("error");
        %>

        <% if ("success".equals(registered)) { %>
        <div class="alert-success-custom">
            <i class="bi bi-check-circle-fill fs-5"></i>
            <div>
                <strong>Registration successful!</strong><br>
                <span style="opacity:.85">Welcome to CARE LINK. Please login to continue.</span>
            </div>
        </div>
        <% } %>

        <% if ("invalid".equals(loginError)) { %>
        <div class="alert-error-custom">
            <i class="bi bi-exclamation-circle-fill fs-5"></i>
            <div>
                <strong>Login failed.</strong><br>
                <span style="opacity:.85">Invalid email or password. Please try again.</span>
            </div>
        </div>
        <% } %>

        <% if ("pending_approval".equals(loginError)) { %>
        <div class="alert alert-warning text-start d-flex align-items-start gap-3 my-3" style="border-radius: 12px; font-size: 14px; background-color: #fffbeb; border: 1px solid #fde68a; color: #78350f;">
            <i class="bi bi-shield-lock-fill fs-5 text-warning"></i>
            <div>
                <strong>Account Pending Review</strong><br>
                <span style="opacity:0.9">Your NGO credentials are currently being verified by our admin panel. Please try logging in once approval is completed.</span>
            </div>
        </div>
        <% } %>

        <!-- ---- Login Form ---- -->
        <form action="LoginServlet" method="post" id="loginForm" novalidate>

            <input type="hidden" name="role" id="roleInput" value="volunteer">

            <div class="mb-3">
                <label class="form-label">
                    <i class="bi bi-envelope-fill text-success"></i> Email Address
                </label>
                <div class="input-icon-wrap">
                    <input type="email"
                           class="form-control"
                           name="email"
                           id="email"
                           placeholder="you@example.com"
                           required>
                    <i class="bi bi-envelope"></i>
                </div>
                <div class="invalid-feedback">Please enter a valid email.</div>
            </div>

            <div class="mb-2">
                <label class="form-label">
                    <i class="bi bi-lock-fill text-success"></i> Password
                </label>
                <div class="input-icon-wrap">
                    <input type="password"
                           class="form-control"
                           name="password"
                           id="password"
                           placeholder="Enter your password"
                           required>
                    <i class="bi bi-eye-slash" id="togglePassword" title="Show/hide password"></i>
                </div>
                <div class="invalid-feedback">Password cannot be empty.</div>
            </div>

            <div class="d-flex justify-content-between align-items-center mb-3">
                <div class="form-check">
                    <input class="form-check-input" type="checkbox" id="rememberMe" name="rememberMe">
                    <label class="form-check-label text-secondary" for="rememberMe" style="font-size:13px;">
                        Remember me
                    </label>
                </div>
                <a href="forgotPassword.jsp" class="forgot-link">Forgot password?</a>
            </div>

            <button type="submit" class="btn-login">
                <i class="bi bi-box-arrow-in-right"></i> Login
            </button>

        </form>

        <div class="divider">or</div>

        <p class="text-center text-secondary mb-0" style="font-size:14px;">
            New to CARE LINK?
            <a href="register.jsp" class="register-link">Create an account</a>
        </p>

        <!-- Trust badges -->
        <div class="trust-badges">
            <span class="trust-badge">
                <i class="bi bi-shield-fill-check"></i> Secure Login
            </span>
            <span class="trust-badge">
                <i class="bi bi-lock-fill"></i> Encrypted
            </span>
            <span class="trust-badge">
                <i class="bi bi-patch-check-fill"></i> Verified NGOs
            </span>
        </div>

    </div>

</div>

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
                    <li><a href="index.jsp#top">Home</a></li>
                    <li><a href="index.jsp#features">Features</a></li>
                    <li><a href="index.jsp#requests">Requests</a></li>
                    <li><a href="index.jsp#leaderboard">Volunteers</a></li>
                    <li><a href="index.jsp#community">Community</a></li>
                </ul>
            </div>

            <div class="col-md-3">
                <h4>Get Involved</h4>
                <ul class="list-unstyled mt-3 footer-links">
                    <li><a href="register.jsp?role=volunteer">Become a Volunteer</a></li>
                    <li><a href="register.jsp?role=ngo">Register your NGO</a></li>
                    <li><a href="register.jsp?role=donor">Become a Donor</a></li>
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

<!-- Back to top -->
<a href="#" class="back-to-top" id="backToTop">
    <i class="bi bi-arrow-up"></i>
</a>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // ---- Role selector ----
    function selectRole(role, el) {
        document.querySelectorAll('.role-pill').forEach(p => p.classList.remove('active'));
        el.classList.add('active');
        document.getElementById('roleInput').value = role;
    }

    // ---- Password show/hide ----
    const toggleBtn = document.getElementById('togglePassword');
    const pwdField  = document.getElementById('password');

    toggleBtn.addEventListener('click', () => {
        const isHidden = pwdField.type === 'password';
        pwdField.type = isHidden ? 'text' : 'password';
        toggleBtn.classList.toggle('bi-eye-slash', !isHidden);
        toggleBtn.classList.toggle('bi-eye', isHidden);
    });

    // ---- Form validation ----
    document.getElementById('loginForm').addEventListener('submit', function(e) {
        if (!this.checkValidity()) {
            e.preventDefault();
            e.stopPropagation();
        }
        this.classList.add('was-validated');
    });

    // ---- Navbar shadow on scroll ----
    window.addEventListener('scroll', () => {
        const nav = document.getElementById('mainNav');
        nav.classList.toggle('nav-scrolled', window.scrollY > 50);
    });

    // ---- Back to top ----
    const backBtn = document.getElementById('backToTop');
    window.addEventListener('scroll', () => {
        backBtn.style.opacity      = window.scrollY > 400 ? '1' : '0';
        backBtn.style.pointerEvents = window.scrollY > 400 ? 'auto' : 'none';
    });

    // ---- Pre-select role from URL param (?role=ngo) ----
    const urlRole = new URLSearchParams(window.location.search).get('role');
    if (urlRole) {
        document.querySelectorAll('.role-pill').forEach(p => {
            if (p.textContent.trim().toLowerCase().includes(urlRole)) {
                p.click();
            }
        });
    }
</script>

</body>
</html>