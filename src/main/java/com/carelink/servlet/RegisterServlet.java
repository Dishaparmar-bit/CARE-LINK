package com.carelink.servlet;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

import com.carelink.db.DBConnection;
import com.carelink.util.EmailUtil;
import com.carelink.util.PasswordUtil; // FIX: hashing ke liye

@WebServlet("/RegisterServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize       = 1024 * 1024 * 10,
    maxRequestSize    = 1024 * 1024 * 50
)
public class RegisterServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String fullName = request.getParameter("fullName");
        String email    = request.getParameter("email");
        String phone    = request.getParameter("phone");
        String password = request.getParameter("password");
        String role     = request.getParameter("role");
        String country  = request.getParameter("country");
        String state    = request.getParameter("state");
        String city     = request.getParameter("city");

        
        if (fullName == null || email == null || password == null || role == null
                || fullName.trim().isEmpty() || email.trim().isEmpty()
                || password.trim().isEmpty() || role.trim().isEmpty()) {
            response.sendRedirect("register.jsp?error=missing_fields");
            return;
        }

     
        String hashedPassword = PasswordUtil.hash(password);

        try (Connection con = DBConnection.getConnection()) {

            // Duplicate email check
            try (PreparedStatement checkPs = con.prepareStatement(
                    "SELECT id FROM users WHERE email=?")) {
                checkPs.setString(1, email.trim());
                try (ResultSet checkRs = checkPs.executeQuery()) {
                    if (checkRs.next()) {
                        response.sendRedirect("register.jsp?error=email_exists");
                        return;
                    }
                }
            }

            String userSql =
                "INSERT INTO users " +
                "(full_name,email,phone,password,role,country,state,city,is_verified) " +
                "VALUES(?,?,?,?,?,?,?,?,1)";

            int userId = 0;
            try (PreparedStatement ps = con.prepareStatement(
                    userSql, PreparedStatement.RETURN_GENERATED_KEYS)) {

                ps.setString(1, fullName.trim());
                ps.setString(2, email.trim());
                ps.setString(3, phone);
                ps.setString(4, hashedPassword); // FIX: hashed password store karo
                ps.setString(5, role);
                ps.setString(6, country);
                ps.setString(7, state);
                ps.setString(8, city);
                ps.executeUpdate();

                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        userId = rs.getInt(1);
                    }
                }
            }

            if ("ngo".equals(role)) {

                String orgName     = request.getParameter("orgName");
                String regNumber   = request.getParameter("regNumber");
                String description = request.getParameter("description");
                String website     = request.getParameter("website");
                String documentPath = "";

                Part certificatePart = request.getPart("ngoDocument");
                if (certificatePart != null && certificatePart.getSize() > 0) {

                    String originalFileName = certificatePart.getSubmittedFileName();
                    String fileName = System.currentTimeMillis() + "_" + originalFileName;

                    String uploadPath = getServletContext().getRealPath("")
                            + File.separator + "images"
                            + File.separator + "ngo_documents";

                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) uploadDir.mkdirs();

                    certificatePart.write(uploadPath + File.separator + fileName);
                    documentPath = "images/ngo_documents/" + fileName;
                }

                try (PreparedStatement ngoPs = con.prepareStatement(
                        "INSERT INTO ngo_details " +
                        "(user_id,org_name,registration_number,description,website,document_path,status) " +
                        "VALUES(?,?,?,?,?,?,?)")) {
                    ngoPs.setInt(1, userId);
                    ngoPs.setString(2, orgName);
                    ngoPs.setString(3, regNumber);
                    ngoPs.setString(4, description);
                    ngoPs.setString(5, website);
                    ngoPs.setString(6, documentPath);
                    ngoPs.setString(7, "pending");
                    ngoPs.executeUpdate();
                }

            } else if ("volunteer".equals(role)) {

                String skills       = request.getParameter("skills");
                String availability = request.getParameter("availability");

                try (PreparedStatement volPs = con.prepareStatement(
                        "INSERT INTO volunteer_details (user_id,skills,availability) VALUES(?,?,?)")) {
                    volPs.setInt(1, userId);
                    volPs.setString(2, skills);
                    volPs.setString(3, availability);
                    volPs.executeUpdate();
                }

            } else if ("donor".equals(role)) {

                String cause = request.getParameter("cause");

                try (PreparedStatement donorPs = con.prepareStatement(
                        "INSERT INTO donor_details (user_id,preferred_cause) VALUES(?,?)")) {
                    donorPs.setInt(1, userId);
                    donorPs.setString(2, cause);
                    donorPs.executeUpdate();
                }
            }

            EmailUtil.sendWelcomeEmail(email, fullName, role);
            response.sendRedirect("login.jsp?registered=success");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("register.jsp?error=registration_failed");
        }
    }
}