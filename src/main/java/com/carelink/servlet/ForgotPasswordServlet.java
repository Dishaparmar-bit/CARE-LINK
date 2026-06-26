package com.carelink.servlet; 

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.carelink.util.EmailUtil; 

@WebServlet("/ForgotPasswordServlet")
public class ForgotPasswordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        
        if (email != null && !email.trim().isEmpty()) {
            try {
             
                String resetLink = "http://localhost:8080/CareLink/resetPassword.jsp?email=" + email + "&token=SECURE_MOCK_XYZ123";
                
                EmailUtil.sendPasswordResetEmail(email, resetLink);
                
                response.sendRedirect("forgotPassword.jsp?status=success&target=" + email);
                return;
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("forgotPassword.jsp?status=error");
                return;
            }
        }
        
        response.sendRedirect("forgotPassword.jsp?status=invalid");
    }
}