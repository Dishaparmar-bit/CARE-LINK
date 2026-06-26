package com.carelink.servlet;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.carelink.dao.NGODao;
import com.carelink.dao.VolunteerDao;

@WebServlet("/VolunteerDashboardServlet")
public class VolunteerDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Session and Security Check
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp?msg=session_expired");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        String role = (String) session.getAttribute("role");
        if (!"volunteer".equalsIgnoreCase(role)) {
            response.sendRedirect("login.jsp?error=unauthorized");
            return;
        }
        
        // Initialize DAOs
        VolunteerDao volDao = new VolunteerDao();
        NGODao ngoDao = new NGODao(); 
        try {
            // 2. Fetch Volunteer-specific Metrics & Application History
            Map<String, Object> stats = volDao.getVolunteerStats(userId);
            List<Map<String, String>> myApplications = volDao.getMyApplications(userId);

            // 3. Fetch Global Data for Exploration Feeds
            List<Map<String, String>> allFeedPosts = ngoDao.getAllGlobalFeeds();
            List<Map<String, String>> allCampaigns = volDao.getAllActiveCampaigns();

            // 4. Set attributes cleanly for JSP parsing with safety mapping parameters
            request.setAttribute("stats", stats);
            request.setAttribute("myApplications", myApplications);
            request.setAttribute("feedPosts", allFeedPosts);
            request.setAttribute("allCampaigns", allCampaigns);

            // 5. Forward straight to Volunteer UI
            request.getRequestDispatcher("volunteerDashboard.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp?msg=error");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}