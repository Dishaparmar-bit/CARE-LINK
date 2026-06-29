# CareLink - Integrated Community Relief & NGO Coordination System

An intelligent web platform bridging the gap between donors, volunteers, and NGOs for transparent, location-based, and AI-verified social impact.

## 2. Problem Statement & Solution Overview

### Problem Statement
In community relief initiatives, fragmentation between NGOs, willing volunteers, and donors leads to critical delays and resource mismanagement. NGOs struggle to find nearby volunteers dynamically, donors lack real-time visibility into material requirements, and administrative bodies face challenges manually verifying NGO credentials, leaving the door open for fraudulent operations.

### Solution Overview
CareLink offers a unified dynamic architecture:
* **Role-Based Access Matrices:** Separate, dedicated workflows for Donors, Volunteers, NGOs, and Administrators.
* **AI-Driven Compliance Shielding:** Integrated automated verification routines using custom validation scoring models to filter authentic NGO registration documents, instantly flags structural anomalies, and prevents fake profiles.
* **Location-Aware Dispatch:** Real-time proximity coordinates management mapping nearby volunteers directly to live NGO campaign hotspots.
* **Transparent Supplies Pipeline:** Live status logs letting donors trace materials from acceptance to delivery, cutting out the jhanjhat of missing ledger transparency.

## 3. Tech Stack

* **Frontend Canvas:** HTML5, CSS3, JavaScript, JSP (JavaServer Pages)
* **Backend Application Middleware:** Java EE Servlets, Java Native Threads Layer
* **Data Tier Framework:** MySQL Relational Database Engine (with native SQL optimization)
* **Server Container:** Apache Tomcat v9.0
* **Security Mechanisms:** Built-in SHA-256 secure cryptographic engine architecture for transactional credential integrity

## 4. Installation and Setup Instructions

### Prerequisites
* Java Development Kit (JDK 8 or higher)
* Apache Tomcat Server v9.0
* MySQL Server (v8.0 preferred)
* Eclipse IDE for Enterprise Java Developers

### Step-by-Step Installation

1.  **Clone the Repository**
    ```bash
    git clone [https://github.com/your-username/CareLink.git](https://github.com/your-username/CareLink.git)
    ```

2.  **Database Configuration**
    * Open your MySQL Workbench / Command Line Client.
    * Execute the database setup schema scripts (Tables include: `users`, `ngo_details`, `volunteer_details`, `donor_details`, `campaigns`, `campaign_requests`).
    * Ensure the static server parameters inside the database manager module file `com/carelink/db/DBConnection.java` match your local MySQL setup:
        ```java
        private static final String URL      = "jdbc:mysql://localhost:3306/carelink";
        private static final String USER     = "root";
        private static final String PASSWORD = "root";
        ```

3.  **Project Import and Server Build**
    * Open Eclipse IDE -> Select **File -> Import -> Existing Projects into Workspace**.
    * Select the root directory of the `CareLink` project.
    * Right-click the project folder -> **Build Path -> Configure Build Path** -> Verify JDK compliance levels.
    * Add your local Apache Tomcat v9.0 runtime target environment inside the Server settings tab.

4.  **Deployment Purge and Execution**
    * Execute a structural system recompile (**Project -> Clean**).
    * Right-click the project root -> **Run As -> Run on Server**.
    * Access the local deployment environment fresh: `http://localhost:8080/CareLink/login.jsp`

## 5. AI Tools Disclosure Table

| Task Performed using AI | Specific Tool Used | Reason for Tool Usage |
| :--- | :--- | :--- |
| Mock Safeguarding Integration | Gemini / Custom Rules | Generated high-fidelity mock validation structures for the internal AI document verification scanner subsystem boundaries during sandboxed testing loops. |
| Production Debugging Framework | Gemini | Audited servlet execution flows, automated property array synchronization, and resolved unexpected database data type processing errors. |

## 6. Team Members and Roles

* **Disha Singh Parmar** – Lead Software Engineer & Backend Architect
    * *Responsibilities:* Developed role-based Java Servlets controller matrix, integrated structural password verification engines, built secure database connectivity managers, and configured Tomcat deployment environments.
* **Harsh Nagar** – Frontend Developer & UI Designer
    * *Responsibilities:* Engineered responsive layouts for dashboards canvas, crafted cohesive CSS styling architectures, integrated interactive user grids, and managed client-side data layout renderings.
* **Bhumika Tomar** – Frontend Developer & UX Specialist
    * *Responsibilities:* Designed intuitive navigation systems across application screens, optimized interface accessibility boundaries, built structural form validation scripts, and streamlined multi-role platform interactivity flows.

## 7. Screenshots and Demo Link

* **Walkthrough Demo Video (3–5 min MP4):** https://drive.google.com/file/d/1BvY95dhW8mTBziVvm8EucDb2yxQFWKQP/view

