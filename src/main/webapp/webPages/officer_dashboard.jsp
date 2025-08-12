<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // Get officer ID from session
    Object officerObj = session.getAttribute("global_control_no");
    String officerId = (officerObj != null) ? officerObj.toString() : null;

    // Officer details
    String empName = "", dob = "", doa = "", designation = "", billUnit = "", zone = "";

    // Last Approved/Rejected Application
    String lastCtrlNo = "", lastEmpName = "", lastFrom = "", lastTo = "", lastStatus = "";

    // Latest Pending Application
    String pendingCtrlNo = "", pendingEmpName = "", pendingFrom = "", pendingTo = "", pendingType = "";

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        con = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521/pdbclw", "Shantodeep", "123");

        // Officer details from emp_master
        ps = con.prepareStatement(
            "SELECT EMPNAME, TO_CHAR(EMPDOB,'DD/MM/YYYY') AS DOB, " +
            "TO_CHAR(EMPDOA,'DD/MM/YYYY') AS DOA, DESIGNATION, BILLUNIT, ZONE " +
            "FROM emp_master WHERE CONTROL_NO = ?"
        );
        ps.setString(1, officerId);
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

        // Last Approved/Rejected Application by officer
        ps = con.prepareStatement(
            "SELECT e.CONTROL_NO, m.EMPNAME, " +
            "TO_CHAR(e.LEAVE_FROM_DT,'DD/MM/YYYY') AS FROM_DT, " +
            "TO_CHAR(e.LEAVE_TO_DT,'DD/MM/YYYY') AS TO_DT, " +
            "CASE WHEN e.LEAVE_STATS = 'A' THEN 'Approved' WHEN e.LEAVE_STATS = 'R' THEN 'Rejected' ELSE e.LEAVE_STATS END AS STATUS " +
            "FROM emp_leave_tran e " +
            "JOIN emp_master m ON e.CONTROL_NO = m.CONTROL_NO " +
            "WHERE  e.LEAVE_STATS IN ('A','R') " +
            "ORDER BY e.LEAVE_APPR_REJ_DATE DESC FETCH FIRST 1 ROWS ONLY"
        );
        
        rs = ps.executeQuery();
        if (rs.next()) {
            lastCtrlNo = rs.getString("CONTROL_NO");
            lastEmpName = rs.getString("EMPNAME");
            lastFrom = rs.getString("FROM_DT");
            lastTo = rs.getString("TO_DT");
            lastStatus = rs.getString("STATUS");
        }
        rs.close();
        ps.close();

        // Latest Pending Application for officer
       ps = con.prepareStatement(
    "SELECT * FROM (" +
    "SELECT e.CONTROL_NO, m.EMPNAME, " +
    "TO_CHAR(e.LEAVE_FROM_DT,'DD/MM/YYYY') AS FROM_DT, " +
    "TO_CHAR(e.LEAVE_TO_DT,'DD/MM/YYYY') AS TO_DT, e.LEAVE_TYPE " +
    "FROM emp_leave_tran e " +
    "JOIN emp_master m ON e.CONTROL_NO = m.CONTROL_NO " +
    "WHERE UPPER(e.LEAVE_STATS) = 'F' " +
    "ORDER BY e.APP_DATE DESC" +
    ") WHERE ROWNUM = 1"
);

rs = ps.executeQuery();
if (rs.next()) {
    pendingCtrlNo = rs.getString("CONTROL_NO");
    pendingEmpName = rs.getString("EMPNAME");
    pendingFrom = rs.getString("FROM_DT");
    pendingTo = rs.getString("TO_DT");
    pendingType = rs.getString("LEAVE_TYPE");
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
<title>Officer Dashboard</title>
<link rel="stylesheet" href="/CLW_LEAVE/cssFiles/dashboard.css">
<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
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

.dashboard-container {
    display: flex;
    flex-direction: column;
    align-items: center;
    width: 100%;
    min-height: 100vh;
    box-sizing: border-box;
    padding: 40px 0;
}

.main-content {
    width: 70%;
    display: flex;
    flex-direction: column;
    gap: 40px;
}

.card-container, .card {
    background: var(--card-bg-dark);
    border-radius: 12px;
    border: 2px solid var(--accent-color);
    box-shadow: var(--neon-border);
    transition: transform 0.3s ease, box-shadow 0.3s ease;
    box-sizing: border-box;
}

.card-container {
    padding: 30px;
}

.bottom-container {
    display: flex;
    justify-content: space-between;
    gap: 20px;
}

.bottom-container .card {
    flex-basis: 48%;
    padding: 25px;
}

body.light-mode .card-container,
body.light-mode .card {
    background: var(--card-bg-light);
    color: var(--text-light);
    border-color: var(--border-light);
    box-shadow: var(--card-shadow-light);
}

.card-container:hover, .card:hover {
    transform: translateY(-5px) scale(1.02);
    z-index: 2;
}

body.dark-mode .card-container:hover,
body.dark-mode .card:hover {
    box-shadow: var(--neon-border-hover);
}

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
        <!-- Officer Details -->
        <div class="card-container">
            <h3>🛡 Officer Details</h3>
            <p><b>Name:</b> <%= empName %></p>
            <p><b>Date of Birth:</b> <%= dob %></p>
            <p><b>Date of Appointment:</b> <%= doa %></p>
            <p><b>Designation:</b> <%= designation %></p>
            <p><b>Bill Unit:</b> <%= billUnit %></p>
            <p><b>Zone:</b> <%= zone %></p>
        </div>

        <!-- Lower Section -->
        <div class="bottom-container">
            <div class="card">
                <h4>📄 Last Approved/Rejected Application</h4>
                <p><b>Control No:</b> <%= lastCtrlNo %></p>
                <p><b>Name:</b> <%= lastEmpName %></p>
                <p><b>From:</b> <%= lastFrom %></p>
                <p><b>To:</b> <%= lastTo %></p>
                <p><b>Status:</b> <%= lastStatus %></p>
            </div>
            <div class="card">
                <h4>⏳ Latest Pending Application</h4>
                <p><b>Control No:</b> <%= pendingCtrlNo %></p>
                <p><b>Name:</b> <%= pendingEmpName %></p>
                <p><b>From:</b> <%= pendingFrom %></p>
                <p><b>To:</b> <%= pendingTo %></p>
                <p><b>Leave Type:</b> <%= pendingType %></p>
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
