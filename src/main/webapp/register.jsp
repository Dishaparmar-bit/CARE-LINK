<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Register — CARE LINK</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<link rel="stylesheet" href="css/register.css">
<link rel="stylesheet" href="css/style.css">
</head>
<body>

<%
    String role = request.getParameter("role");
    if (role == null || role.isEmpty()) role = "volunteer";
    String errorMsg   = (String) request.getAttribute("error");
    String successMsg = (String) request.getAttribute("success");
%>

<!-- ================= NAVBAR ================= -->
<nav class="navbar navbar-expand-lg fixed-top reg-nav">
    <div class="container">
        <a class="navbar-brand logo-text" href="index.jsp">
            <i class="bi bi-heart-pulse-fill"></i> CARE LINK
        </a>
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
        </div>
    </div>
</nav>

<!-- ================= MAIN FORM ================= -->
<div class="reg-wrapper">
    <div class="reg-card">
        <div class="reg-header">
            <h2 class="reg-title"><i class="bi bi-person-plus-fill"></i> Create Account</h2>
            <p class="reg-sub">Join CARE LINK and start making an impact.</p>
        </div>

<% String error = request.getParameter("error"); %>
<% if("email_exists".equals(error)) { %>
<div class="alert alert-danger text-center">Email already registered. Please login instead.</div>
<% } %>
        <% if (errorMsg != null) { %>
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="bi bi-exclamation-triangle-fill me-2"></i><%= errorMsg %>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <% } %>
        <% if (successMsg != null) { %>
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="bi bi-check-circle-fill me-2"></i><%= successMsg %>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <% } %>

        <!-- Role Tabs (Fixed Routing to register.jsp) -->
        <div class="role-tabs">
            <a href="register.jsp?role=volunteer" class="role-tab <%= "volunteer".equals(role) ? "active" : "" %>"><i class="bi bi-people-fill"></i> Volunteer</a>
            <a href="register.jsp?role=ngo" class="role-tab <%= "ngo".equals(role) ? "active" : "" %>"><i class="bi bi-building"></i> NGO</a>
            <a href="register.jsp?role=donor" class="role-tab <%= "donor".equals(role) ? "active" : "" %>"><i class="bi bi-heart-fill"></i> Donor</a>
        </div>

        <!-- Registration Form -->
        <form action="RegisterServlet" method="post" id="regForm" enctype="multipart/form-data" novalidate>
            <input type="hidden" name="role" value="<%= role %>">
            
            <input type="hidden" name="latitude" id="formLat" value="22.7196">
            <input type="hidden" name="longitude" id="formLng" value="75.8577">

            <!-- Personal Info -->
            <div class="form-section">
                <h6 class="form-section-title">Personal Information</h6>
                <div class="row g-3">
                    <div class="col-md-12">
                        <label class="form-label">Full Name <span class="text-danger">*</span></label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-person-fill"></i></span>
                            <input type="text" name="fullName" class="form-control" pattern="[A-Za-z ]{3,50}" placeholder="Enter your full name" required>
                        </div>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Email Address <span class="text-danger">*</span></label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-envelope-fill"></i></span>
                            <input type="email" name="email" class="form-control" placeholder="you@example.com" required>
                        </div>
                    </div>

                    <div class="col-md-6 d-flex align-items-end">
                        <button type="button" class="btn btn-outline-success w-100" onclick="sendOTP()"><i class="bi bi-send-fill me-1"></i> Send OTP</button>
                    </div>

                    <div class="col-md-12">
                        <label class="form-label">Email OTP</label>
                        <div class="input-group">
                            <input type="text" id="otp" class="form-control" maxlength="6" pattern="[0-9]{6}" placeholder="Enter 6-digit OTP">
                            <button type="button" class="btn btn-success" onclick="verifyOTP()"><i class="bi bi-shield-check me-1"></i> Verify OTP</button>
                        </div>
                        <small id="otpStatus"></small>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Phone Number</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-telephone-fill"></i></span>
                            <input type="tel" name="phone" class="form-control" placeholder="9876543210" maxlength="10" pattern="[0-9]{10}" required>
                        </div>
                    </div>

                    <div class="col-md-4">
                        <label class="form-label">Country <span class="text-danger">*</span></label>
                        <select name="country" class="form-select" required>
                            <option value="">Select Country</option>
                            <option value="India">India</option>
                        </select>
                    </div>

                    <div class="col-md-4">
                        <label class="form-label">State <span class="text-danger">*</span></label>
                        <select name="state" class="form-select" required>
                            <option value="">Select State</option>
                            <option>Andhra Pradesh</option><option>Arunachal Pradesh</option><option>Assam</option><option>Bihar</option><option>Chhattisgarh</option><option>Delhi</option><option>Goa</option><option>Gujarat</option><option>Haryana</option><option>Himachal Pradesh</option><option>Jharkhand</option><option>Karnataka</option><option>Kerala</option><option>Madhya Pradesh</option><option>Maharashtra</option><option>Odisha</option><option>Punjab</option><option>Rajasthan</option><option>Tamil Nadu</option><option>Telangana</option><option>Uttar Pradesh</option><option>Uttarakhand</option><option>West Bengal</option>
                        </select>
                    </div>

                    <div class="col-md-4">
                        <label class="form-label">City <span class="text-danger">*</span></label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-geo-alt-fill"></i></span>
                            <input type="text" name="city" id="cityInput" class="form-control" placeholder="Enter City" required>
                        </div>
                    </div>

                    <!-- Live Satellite Geolocation Link Setup -->
                    <div class="col-md-12">
                        <button type="button" class="btn btn-sm btn-outline-dark" onclick="fetchLiveCoordinates()"><i class="bi bi-crosshairs"></i> Detect Live Geo-Coordinates for Impact Map</button>
                        <small id="geoFeedback" class="text-muted d-block mt-1" style="font-size:11px;">Default center mapping: Indore (22.7196, 75.8577) will be verified unless auto-detected.</small>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Password <span class="text-danger">*</span></label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-lock-fill"></i></span>
                            <input type="password" name="password" id="password" class="form-control" placeholder="Min 8 characters" minlength="8" pattern="^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&]).{8,}$" required>
                            <button class="btn btn-outline-secondary toggle-pw" type="button" onclick="togglePw('password', this)"><i class="bi bi-eye"></i></button>
                        </div>
                        <small class="text-muted" style="font-size:12px;">Must contain uppercase, lowercase, number and special character.</small>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Confirm Password <span class="text-danger">*</span></label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-lock-fill"></i></span>
                            <input type="password" name="confirmPassword" id="confirmPassword" class="form-control" placeholder="Re-enter password" required>
                            <button class="btn btn-outline-secondary toggle-pw" type="button" onclick="togglePw('confirmPassword', this)"><i class="bi bi-eye"></i></button>
                        </div>
                        <div id="pwMatch" class="form-text" style="font-size:12px;"></div>
                    </div>
                </div>
            </div>

            <!-- Volunteer Fields -->
            <% if ("volunteer".equals(role)) { %>
            <div class="form-section">
                <h6 class="form-section-title">Volunteer Details</h6>
                <div class="row g-3">
                    <div class="col-md-12">
                        <label class="form-label">Skills / Interests</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-tools"></i></span>
                            <input type="text" name="skills" class="form-control" placeholder="e.g. Teaching, Medical, Driving, Cooking">
                        </div>
                    </div>
                    <div class="col-md-12">
                        <label class="form-label">Availability</label>
                        <select name="availability" class="form-select">
                            <option value="">Select availability</option>
                            <option value="weekdays">Weekdays</option>
                            <option value="weekends">Weekends</option>
                            <option value="both">Both Weekdays &amp; Weekends</option>
                            <option value="flexible">Flexible</option>
                        </select>
                    </div>
                </div>
            </div>
            <% } %>

            <!-- NGO Fields -->
            <% if ("ngo".equals(role)) { %>
            <div class="form-section">
                <h6 class="form-section-title">NGO Details</h6>
                <div class="row g-3">
                    <div class="col-md-12">
                        <label class="form-label">Organisation Name <span class="text-danger">*</span></label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-building"></i></span>
                            <input type="text" name="orgName" class="form-control" placeholder="Registered organisation name" required>
                        </div>
                    </div>
                    <div class="col-md-12">
                        <label class="form-label">Registration Number</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-card-text"></i></span>
                            <input type="text" name="regNumber" class="form-control" placeholder="NGO registration / trust number" minlength="5" maxlength="50">
                        </div>
                    </div>
                    <div class="col-md-12">
                        <label class="form-label">NGO Registration Certificate (PDF/JPG/PNG, max 10MB) <span class="text-danger">*</span></label>
                        <input type="file" name="ngoDocument" class="form-control" accept=".pdf,.jpg,.jpeg,.png" required>
                    </div>
                    <div class="col-md-12">
                        <label class="form-label">NGO Website</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-globe"></i></span>
                            <input type="url" name="website" class="form-control" placeholder="https://example.org">
                        </div>
                    </div>
                    <div class="col-md-12">
                        <label class="form-label">About Your NGO</label>
                        <textarea name="description" class="form-control" rows="3" minlength="20" maxlength="500" placeholder="Briefly describe your work and mission"></textarea>
                    </div>
                </div>
            </div>
            <% } %>

            <!-- Donor Fields -->
            <% if ("donor".equals(role)) { %>
            <div class="form-section">
                <h6 class="form-section-title">Donor Preferences</h6>
                <div class="row g-3">
                    <div class="col-md-12">
                        <label class="form-label">Preferred Cause</label>
                        <select name="cause" class="form-select">
                            <option value="">Select a cause</option>
                            <option value="education">Education</option>
                            <option value="food">Food &amp; Nutrition</option>
                            <option value="health">Healthcare</option>
                            <option value="environment">Environment</option>
                            <option value="all">All Causes</option>
                        </select>
                    </div>
                </div>
            </div>
            <% } %>

            <!-- Terms -->
            <div class="form-check mt-3">
                <input class="form-check-input" type="checkbox" id="terms" required>
                <label class="form-check-label" for="terms">
                    I agree to the <a href="#" class="text-success">Terms of Service</a> and <a href="#" class="text-success">Privacy Policy</a>
                </label>
            </div>

            <!-- Submit -->
            <button type="submit" id="registerBtn" class="btn btn-success reg-submit-btn mt-4 w-100" disabled>
                <i class="bi bi-person-check-fill me-2"></i> Create <%= "volunteer".equals(role) ? "Volunteer" : "ngo".equals(role) ? "NGO" : "Donor" %> Account
            </button>
            <p class="text-center mt-3 small" style="color:#6b8c78;">Already have an account? <a href="login.jsp" class="text-success fw-semibold">Login here</a></p>
        </form>
    </div>
</div>

<!-- ================= FOOTER ================= -->
<footer class="footer" id="contact">
    <div class="container">
        <div class="row g-4">
            <div class="col-md-4">
                <h4><i class="bi bi-heart-pulse-fill"></i> CARE LINK</h4>
                <p class="mt-3">Connecting NGOs, Volunteers and Donors to build stronger communities together.</p>
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
        <p class="text-center mb-0" style="color:#6b7280; font-size:13px;">&copy; 2026 CARE LINK. All Rights Reserved.</p>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function togglePw(fieldId, btn) {
        const field = document.getElementById(fieldId);
        const icon  = btn.querySelector('i');
        if (field.type === 'password') {
            field.type = 'text';
            icon.className = 'bi bi-eye-slash';
        } else {
            field.type = 'password';
            icon.className = 'bi bi-eye';
        }
    }

    const pw  = document.getElementById('password');
    const cpw = document.getElementById('confirmPassword');
    const msg = document.getElementById('pwMatch');

    function checkMatch() {
        if (cpw.value === '') { msg.textContent = ''; return; }
        if (pw.value === cpw.value) {
            msg.textContent = '✓ Passwords match';
            msg.style.color = '#00a86b';
        } else {
            msg.textContent = '✗ Passwords do not match';
            msg.style.color = '#dc2626';
        }
    }

    pw.addEventListener('input', checkMatch);
    cpw.addEventListener('input', checkMatch);

    document.getElementById('regForm').addEventListener('submit', function(e) {
        if (pw.value !== cpw.value) {
            e.preventDefault();
            alert('Passwords do not match!');
            return;
        }
        if (pw.value.length < 8) {
            e.preventDefault();
            alert('Password must be at least 8 characters.');
            return;
        }
        if (!document.getElementById('terms').checked) {
            e.preventDefault();
            alert('Please accept the Terms of Service.');
        }
    });

    function sendOTP() {
        let email = document.querySelector('input[name="email"]').value;
        if (email === '') { alert('Enter email first'); return; }
        fetch('SendOtpServlet', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'email=' + encodeURIComponent(email)
        })
        .then(r => r.text())
        .then(data => {
            const s = document.getElementById('otpStatus');
            if (data.trim() === 'OTP_SENT') {
                s.textContent = '✉️ OTP sent to your email';
                s.style.color = '#00a86b';
            } else {
                s.textContent = 'Failed to send OTP. Try again.';
                s.style.color = '#dc2626';
            }
        });
    }

    function verifyOTP() {
        let email = document.querySelector('input[name="email"]').value;
        let otp   = document.getElementById('otp').value;
        fetch('VerifyOtpServlet', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'email=' + encodeURIComponent(email) + '&otp=' + encodeURIComponent(otp)
        })
        .then(r => r.text())
        .then(data => {
            const s = document.getElementById('otpStatus');
            if (data.trim() === 'VERIFIED') {
                s.textContent = '✅ Email Verified';
                s.style.color = '#00a86b';
                document.getElementById('registerBtn').disabled = false;
            } else if (data.trim() === 'EXPIRED') {
                s.textContent = '⚠️ OTP Expired. Please resend.';
                s.style.color = '#d97706';
            } else {
                s.textContent = '✗ Invalid OTP';
                s.style.color = '#dc2626';
            }
        });

        document.querySelector('input[name="email"]').addEventListener('input', function() {
            document.getElementById('registerBtn').disabled = true;
            document.getElementById('otpStatus').textContent = '';
        });
    }

    // 🛠️ Satellite Tracking Script for Impact Maps Integration
    function fetchLiveCoordinates() {
        if (!navigator.geolocation) {
            alert('Geolocation is not supported by your current browser browser node.');
            return;
        }
        document.getElementById('geoFeedback').innerText = "🌐 Accessing core satellite telemetry links...";
        navigator.geolocation.getCurrentPosition(function(pos) {
            document.getElementById('formLat').value = pos.coords.latitude.toFixed(6);
            document.getElementById('formLng').value = pos.coords.longitude.toFixed(6);
            document.getElementById('geoFeedback').innerHTML = "<span style='color:#00a86b; font-weight:700;'>✓ Live Node Sync Connected! Coordinates captured: " + pos.coords.latitude.toFixed(4) + ", " + pos.coords.longitude.toFixed(4) + "</span>";
        }, function(err) {
            document.getElementById('geoFeedback').innerText = "⚠️ Failed to resolve satellite lock. Reverting back to city defaults.";
        });
    }

    document.querySelector('input[name="phone"]').addEventListener('input', function() {
        this.value = this.value.replace(/\D/g, '').slice(0, 10);
    });

    document.getElementById('otp').addEventListener('input', function() {
        this.value = this.value.replace(/\D/g, '').slice(0, 6);
    });
</script>
</body>
</html>