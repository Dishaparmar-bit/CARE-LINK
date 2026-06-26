<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Care Link | Identity Recovery Subsystem</title>
    <!-- FontAwesome Assets -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        :root {
            --brand-primary: #059669; /* Green Theme Accent Tokens */
            --brand-dark: #1E293B;    /* Clean Dark Containers */
            --bg-neutral: #F8FAFC;    /* Main Body background */
            --text-muted: #64748B;
        }
        
        body {
            font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
            background-color: var(--bg-neutral);
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            padding: 20px;
        }

        .login-card {
            background: #FFFFFF;
            padding: 40px;
            border-radius: 12px;
            border: 1px solid #E2E8F0;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05), 0 2px 4px -1px rgba(0, 0, 0, 0.02);
            width: 100%;
            max-width: 420px;
            box-sizing: border-box;
        }

        .brand-header {
            text-align: center;
            margin-bottom: 28px;
        }

        .brand-header i {
            color: var(--brand-primary);
            font-size: 32px;
            margin-bottom: 8px;
        }

        .brand-header h2 {
            color: var(--brand-dark);
            font-size: 22px;
            font-weight: 700;
            margin: 0;
        }

        .brand-header p {
            color: var(--text-muted);
            font-size: 13.5px;
            margin-top: 6px;
            line-height: 1.5;
        }

        .form-group {
            margin-bottom: 20px;
            position: relative;
        }

        .form-group label {
            display: block;
            font-size: 12.5px;
            font-weight: 600;
            color: var(--brand-dark);
            margin-bottom: 6px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .input-wrapper {
            position: relative;
        }

        .input-wrapper i {
            position: absolute;
            left: 14px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-muted);
            font-size: 14px;
        }

        .form-control {
            width: 100%;
            padding: 12px 14px 12px 40px;
            background: #FFFFFF;
            border: 1px solid #CBD5E1;
            border-radius: 6px;
            font-size: 14px;
            color: var(--brand-dark);
            box-sizing: border-box;
            transition: all 0.2s ease;
        }

        .form-control:focus {
            outline: none;
            border-color: var(--brand-primary);
            box-shadow: 0 0 0 3px rgba(5, 150, 105, 0.1);
        }

        .btn-submit {
            width: 100%;
            padding: 12px;
            background-color: var(--brand-primary);
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.2s ease;
        }

        .btn-submit:hover {
            background-color: #047857;
        }

        .alert-node {
            padding: 12px 16px;
            border-radius: 6px;
            font-size: 13px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
            font-weight: 500;
        }

        .alert-success {
            background-color: #ECFDF5;
            border: 1px solid #A7F3D0;
            color: #065F46;
        }

        .back-to-gateway {
            display: block;
            text-align: center;
            margin-top: 24px;
            font-size: 13px;
            color: var(--text-muted);
            text-decoration: none;
            font-weight: 500;
        }

        .back-to-gateway:hover {
            color: var(--brand-primary);
        }
    </style>
</head>
<body>

    <div class="login-card">
        <% 
            String status = request.getParameter("status");
            String targetEmail = request.getParameter("target");
            if("success".equals(status)) { 
        %>
            
            <div class="alert-node alert-success">
                <i class="fa-solid fa-circle-check" style="font-size: 16px;"></i>
                <div>
                    <strong>Reset Token Dispatched!</strong><br>
                    Secure recovery node logs successfully transmitted to <span style="text-decoration:underline;"><%= targetEmail %></span>.
                </div>
            </div>
        <% } %>

        <div class="brand-header">
            <i class="fa-solid fa-shield-heart"></i>
            <h2>Identity Recovery</h2>
            <p>Input your registered tracking email address parameter below to receive a secure credentials clearance override token link.</p>
        </div>

        <form action="ForgotPasswordServlet" method="POST">
            <div class="form-group">
                <label for="email">Registered Email Node</label>
                <div class="input-wrapper">
                    <i class="fa-solid fa-envelope"></i>
                    <input type="email" id="email" name="email" class="form-control" placeholder="name@domain.com" required>
                </div>
            </div>
            
            <button type="submit" class="btn-submit">Dispatch Security Token</button>
        </form>

        <a href="login.jsp" class="back-to-gateway"><i class="fa-solid fa-arrow-left-long"></i> Back to Platform Login</a>
    </div>

</body>
</html>