<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Care Link | Reset Password Gateway</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        :root { --brand-success: #059669; --brand-dark: #1E293B; --bg-light: #F8FAFC; --text-danger: #EF4444; }
        body { font-family: 'Segoe UI', sans-serif; background: var(--bg-light); display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .card { background: white; padding: 40px; border-radius: 12px; border: 1px solid #E2E8F0; box-shadow: 0 4px 12px rgba(0,0,0,0.05); width: 100%; max-width: 400px; }
        .header { text-align: center; margin-bottom: 24px; }
        .header i { color: var(--brand-success); font-size: 32px; }
        .header h2 { color: var(--brand-dark); margin: 10px 0 0 0; font-size: 20px; }
        .form-group { margin-bottom: 18px; }
        .form-group label { display: block; font-size: 13px; font-weight: 600; margin-bottom: 6px; color: var(--brand-dark); }
        .form-control { width: 100%; padding: 10px 12px; border: 1px solid #CBD5E1; border-radius: 6px; box-sizing: border-box; font-size: 14px; }
        .form-control:focus { outline: none; border-color: var(--brand-success); }
        .btn-submit { width: 100%; padding: 12px; background: var(--brand-success); color: white; border: none; border-radius: 6px; font-weight: 600; cursor: pointer; font-size: 14px; }
        .btn-submit:hover { background: #047857; }
        .alert { padding: 12px; border-radius: 6px; font-size: 13px; margin-bottom: 18px; font-weight: 500; text-align: left; }
        .alert-error { background: #FEF2F2; border: 1px solid #FCA5A5; color: var(--text-danger); }
    </style>
</head>
<body>

<div class="card" id="reset-box">
    <% 
        String status = request.getParameter("status");
        String emailParam = request.getParameter("email");
        if (emailParam == null) emailParam = "";
        
        if ("synchronized".equals(status)) { 
    %>
        <div class="header">
            <i class="fa-solid fa-circle-check" style="color: #10B981;"></i>
            <h2 style="margin-top:15px;">Password Synchronized!</h2>
            <p style="font-size: 13px; color: #64748B; margin-top: 5px;">Your identity credentials have been securely overwritten inside the MySQL database layer.</p>
            <a href="login.jsp" style="display:inline-block; margin-top:20px; background:var(--brand-success); color:white; padding:10px 20px; border-radius:6px; text-decoration:none; font-weight:600; font-size:13px;">Proceed to Login</a>
        </div>
    <% } else { %>
        
        <div class="header">
            <i class="fa-solid fa-lock-open"></i>
            <h2>Create New Password</h2>
            <p style="font-size: 13px; color: #64748B; margin-top: 5px;">Configure your new security credentials node for <strong><%= emailParam %></strong></p>
        </div>

        <% if ("mismatch".equals(status)) { %>
            <div class="alert alert-error"><i class="fa-solid fa-triangle-exclamation"></i> Action Aborted: Passwords do not match!</div>
        <% } else if ("error".equals(status) || "notfound".equals(status)) { %>
            <div class="alert alert-error"><i class="fa-solid fa-triangle-exclamation"></i> Engine Alert: Database mapping failed or email invalid.</div>
        <% } %>

        <form action="ResetPasswordServlet" method="POST" onsubmit="return validateSubmission(this)">
            <input type="hidden" name="email" value="<%= emailParam %>">
            
            <div class="form-group">
                <label>New Password</label>
                <input type="password" name="password" id="pass" class="form-control" placeholder="••••••••" required>
            </div>
            <div class="form-group">
                <label>Confirm Password</label>
                <input type="password" id="confPass" class="form-control" placeholder="••••••••" required>
            </div>
            <button type="submit" class="btn-submit">Update Access Node</button>
        </form>
    <% } %>
</div>

<script>
function validateSubmission(form) {
    const p = document.getElementById('pass').value;
    const cp = document.getElementById('confPass').value;
    if(p !== cp) {
        window.location.href = "resetPassword.jsp?status=mismatch&email=" + encodeURIComponent(form.email.value);
        return false;
    }
    return true;
}
</script>

</body>
</html>