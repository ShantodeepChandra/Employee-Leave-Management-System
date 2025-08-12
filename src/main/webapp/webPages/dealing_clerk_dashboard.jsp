<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<meta charset="UTF-8">
<%@ page import="java.sql.*" %>
<%
    // Get clerk ID from session
    Object clerkObj = session.getAttribute("global_control_no");
    String clerkId = (clerkObj != null) ? clerkObj.toString() : null;

    String empName = "", dob = "", doa = "", designation = "", billUnit = "", zone = "";
    String reportingOfficer = "Subhnarayan Anand";

    // Last Forwarded Leave
    String lastFwdControlNo = "", lastFwdEmpName = "", lastFwdAppliedDate = "", lastFwdFrom = "", lastFwdTo = "", lastFwdDate = "";

    // Latest Pending Application
    String pendingControlNo = "", pendingEmpName = "", pendingFrom = "", pendingTo = "", pendingAppliedDate = "";

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        con = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521/pdbclw", "Shantodeep", "123");

        // Fetch Clerk Details
        ps = con.prepareStatement(
            "SELECT EMPNAME, TO_CHAR(EMPDOB,'DD/MM/YYYY') AS DOB, " +
            "TO_CHAR(EMPDOA,'DD/MM/YYYY') AS DOA, DESIGNATION, BILLUNIT, ZONE " +
            "FROM emp_master WHERE CONTROL_NO = ?"
        );
        ps.setString(1, clerkId);
        rs = ps.executeQuery();
        if (rs.next()) {
            empName = rs.getString("EMPNAME");
            dob = rs.getString("DOB");
            doa = rs.getString("DOA");
            designation = rs.getString("DESIGNATION");
            billUnit = rs.getString("BILLUNIT");
            zone = rs.getString("ZONE");
        }
        rs.close();
        ps.close();

        // Last Forwarded Leave (with employee name)
        ps = con.prepareStatement(
            "SELECT e.CONTROL_NO, m.EMPNAME, " +
            "TO_CHAR(e.APP_DATE,'DD/MM/YYYY') AS APPLIED_ON, " +
            "TO_CHAR(e.LEAVE_FROM_DT,'DD/MM/YYYY') AS FROM_DT, " +
            "TO_CHAR(e.LEAVE_TO_DT,'DD/MM/YYYY') AS TO_DT, " +
            "TO_CHAR(e.SANCTION_AUTHORITY_INDATE,'DD/MM/YYYY') AS FWD_DATE " +
            "FROM emp_leave_tran e " +
            "JOIN emp_master m ON e.CONTROL_NO = m.CONTROL_NO " +
            "WHERE e.DEALING_ASST = ? AND e.SANCTION_AUTHORITY_INDATE IS NOT NULL " +
            "ORDER BY e.SANCTION_AUTHORITY_INDATE DESC FETCH FIRST 1 ROWS ONLY"
        );
        ps.setString(1, clerkId);
        rs = ps.executeQuery();
        if (rs.next()) {
            lastFwdControlNo = rs.getString("CONTROL_NO");
            lastFwdEmpName = rs.getString("EMPNAME");
            lastFwdAppliedDate = rs.getString("APPLIED_ON");
            lastFwdFrom = rs.getString("FROM_DT");
            lastFwdTo = rs.getString("TO_DT");
            lastFwdDate = rs.getString("FWD_DATE");
        }
        rs.close();
        ps.close();

        // Latest Pending Application
        ps = con.prepareStatement(
            "SELECT e.CONTROL_NO, m.EMPNAME, " +
            "TO_CHAR(e.LEAVE_FROM_DT,'DD/MM/YYYY') AS FROM_DT, " +
            "TO_CHAR(e.LEAVE_TO_DT,'DD/MM/YYYY') AS TO_DT, " +
            "TO_CHAR(e.APP_DATE,'DD/MM/YYYY') AS APPLIED_ON " +
            "FROM emp_leave_tran e " +
            "JOIN emp_master m ON e.CONTROL_NO = m.CONTROL_NO " +
            "WHERE e.LEAVE_STATS = 'N' " +
            "ORDER BY e.APP_DATE DESC FETCH FIRST 1 ROWS ONLY"
        );
        
        rs = ps.executeQuery();
        if (rs.next()) {
            pendingControlNo = rs.getString("CONTROL_NO");
            pendingEmpName = rs.getString("EMPNAME");
            pendingFrom = rs.getString("FROM_DT");
            pendingTo = rs.getString("TO_DT");
            pendingAppliedDate = rs.getString("APPLIED_ON");
        }
        rs.close();
        ps.close();

    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) rs.close();
        if (ps != null) ps.close();
        if (con != null) con.close();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Dealing Clerk Dashboard</title>
    <link rel="stylesheet" href="/CLW_LEAVE/cssFiles/dashboard.css">
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <style>
:root {
    --card-bg-dark: #1e2a38;
    --card-bg-light: #ffffff;
    --text-dark: #eee;
    --text-light: #222;
    --accent-color: #00e6e6;
    --border-light: #dde2e6;
    --card-shadow-light: 0 4px 12px rgba(0, 0, 0, 0.1);
    --neon-border: 0 0 10px var(--accent-color), 0 0 20px var(--accent-color);
    --neon-border-hover: 0 0 15px var(--accent-color), 0 0 30px var(--accent-color);
}

body {
    margin: 0;
    font-family: "Times New Roman", sans-serif;
}

body.dark-mode {
    background: #0f2027;
    color: var(--text-dark);
}

body.light-mode {
    background: #f4f7f6;
    color: var(--text-light);
}

/* Main Layout Structure */
.dashboard-container {
    display: flex;
    flex-direction: column;
    align-items: center;
    width: 100%;
    min-height: 100vh;
    box-sizing: border-box;
    padding: 40px 0;
    overflow: visible;
}

.main-content {
    width: 70%;
    padding: 0;
    box-sizing: border-box;
    display: flex;
    flex-direction: column;
    gap: 40px;
}

/* --- Card Styling --- */
.card-container, .card {
    background: var(--card-bg-dark);
    border-radius: 12px;
    border: 2px solid var(--accent-color);
    box-shadow: var(--neon-border);
    transition: transform 0.3s ease, box-shadow 0.3s ease;
    box-sizing: border-box;
    overflow: visible;
    transform-origin: bottom; /* Make hover grow downward */
}
.sidebar .light-mode{
    background: white;
    border-right: 1px solid rgba(255, 255, 255, 0.1);
    color: black;
}
/* Top container */
.card-container {
    padding: 30px;
    flex-grow: 1;
    min-height: auto; /* Remove large fixed height */
    max-height: 280px; /* Limit so it won't touch toggle */
    display: flex;
    flex-direction: column;
    justify-content: center;
}

/* Bottom section */
.bottom-container {
    display: flex;
    justify-content: space-between;
    gap: 20px;
}

/* Bottom cards */
.bottom-container .card {
    flex-basis: 48%;
    padding: 25px;
}

/* Light Mode */
body.light-mode .card-container,
body.light-mode .card {
    background: var(--card-bg-light);
    color: var(--text-light);
    border-color: var(--border-light);
    box-shadow: var(--card-shadow-light);
}

/* Hover */
.card-container:hover, .card:hover {
    transform: translateY(-5px) scale(1.02);
    z-index: 2;
}

body.dark-mode .card-container:hover,
body.dark-mode .card:hover {
    box-shadow: var(--neon-border-hover);
}

/* Typography */
h3, h4 {
    margin-bottom: 20px;
}

/* Theme Toggle */
.theme-toggle {
    position: fixed;
    top: 20px;
    right: 30px;
}

.theme-toggle input {
    display: none;
}

.theme-toggle label {
    cursor: pointer;
    width: 50px;
    height: 25px;
    background: #555;
    display: block;
    border-radius: 25px;
    position: relative;
}

.theme-toggle label::after {
    content: "";
    width: 21px;
    height: 21px;
    background: white;
    position: absolute;
    top: 2px;
    left: 2px;
    border-radius: 50%;
    transition: 0.3s;
}

.theme-toggle input:checked + label {
    background: var(--accent-color);
}

.theme-toggle input:checked + label::after {
    left: 27px;
}
</style>
</head>
<body class="dark-mode">
<div class="theme-toggle">
    <input type="checkbox" id="toggleTheme">
    <label for="toggleTheme"></label>
</div>

<div class="dashboard-container">
    <aside class="sidebar">
        <jsp:include page="../backgroundProcess/dynamicMenu.jsp" />
    </aside>

    <main class="main-content">
        <!-- Clerk Details Card -->
        <div class="card-container">
            <h3>📋 Clerk Details</h3>
            <p><b>Name:</b> <%= empName %></p>
            <p><b>Date of Birth:</b> <%= dob %></p>
            <p><b>Date of Appointment:</b> <%= doa %></p>
            <p><b>Designation:</b> <%= designation %></p>
            <p><b>Bill Unit:</b> <%= billUnit %></p>
            <p><b>Zone:</b> <%= zone %></p>
            <p><b>Reporting Officer:</b> <%= reportingOfficer %></p>
        </div>

        <!-- Lower half -->
        <div class="bottom-container">
            <div class="card">
                <h4>📤 Last Forwarded Leave</h4>
                <p><b>Control No:</b> <%= lastFwdControlNo %></p>
                <p><b>Name:</b> <%= lastFwdEmpName %></p>
                <p><b>Applied On:</b> <%= lastFwdAppliedDate %></p>
                <p><b>From:</b> <%= lastFwdFrom %></p>
                <p><b>To:</b> <%= lastFwdTo %></p>
                <p><b>Forwarded On:</b> <%= lastFwdDate %></p>
            </div>
            <div class="card">
                <h4>📩 Latest Pending Application</h4>
                <p><b>Control No:</b> <%= pendingControlNo %></p>
                <p><b>Name:</b> <%= pendingEmpName %></p>
                <p><b>Applied On:</b> <%= pendingAppliedDate %></p>
                <p><b>From:</b> <%= pendingFrom %></p>
                <p><b>To:</b> <%= pendingTo %></p>
            </div>
        </div>
    </main>
</div>

<script>
    document.getElementById("toggleTheme").addEventListener("change", function() {
        if (this.checked) {
            document.body.classList.remove("dark-mode");
            document.body.classList.add("light-mode");
        } else {
            document.body.classList.remove("light-mode");
            document.body.classList.add("dark-mode");
        }
    });
</script>
</body>
</html>