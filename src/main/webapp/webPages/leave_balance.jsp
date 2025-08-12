<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import ="java.sql.*"%>

<%
Connection conn;
PreparedStatement ps, ps1;
ResultSet rs, rs1;
HttpSession hs;
String userid, password, jsonresponse, dburl, dbuser, dbpassword, control_no;
String user_id;
%>
<%
ServletContext context = getServletContext();
dbuser = context.getInitParameter("dbuser");
dbpassword = context.getInitParameter("dbpassword");
dburl = context.getInitParameter("dburl");
Class.forName("oracle.jdbc.driver.OracleDriver");
conn = DriverManager.getConnection(dburl, dbuser, dbpassword);
hs = request.getSession();
user_id = (String) hs.getAttribute("globalUserid");
control_no = (String) hs.getAttribute("global_control_no");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>ELMS - Dashboard</title>
  <link rel="stylesheet" href="/CLW_LEAVE/cssFiles/dashboard.css" />
  <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
  <script src="/CLW_LEAVE/jsFiles/script.js"></script>

  <style>
    /* Table Base */
    .leave-table {
      width: 100%;
      border-collapse: collapse;
      margin-top: 10px;
      font-size: 0.95rem;
      border-radius: 10px;
      overflow: hidden;
      box-shadow: 0 2px 8px rgba(0,0,0,0.1);
      transition: all 0.3s ease;
    }
    .leave-table th, .leave-table td {
      padding: 10px 14px;
      text-align: left;
      border : 1px solid black;
    }
    .leave-table thead {
      font-weight: bold;
    }

    /* Dark Mode Styles */
    body.dark {
      background-color: #121212;
      color: #ddd;
    }
    body.dark .leave-table thead {
      background: #222;
      color: #4da3ff;
    }
    body.dark .leave-table tr:nth-child(even) {
      background: #1b1b1b;
    }
    body.dark .leave-table tr:nth-child(odd) {
      background: #242424;
    }
    body.dark .leave-table td {
      color: #ddd;
    }

    /* Light Mode Styles */
    body.light {
      background: #f5f8ff;
      color: #000;
    }
    body.light .main-content header h1 {
      color: #004080;
    }
    body.light .leave-table thead {
      background: #007bff;
      color: #fff;
    }
    body.light .leave-table tr:nth-child(even) {
      background: #e9f2ff;
    }
    body.light .leave-table tr:nth-child(odd) {
      background: #ffffff;
    }
    body.light .leave-table td {
      color: #000;
    }

    /* Card styling consistency */
    .leave-table-container {
      margin-top: 15px;
    }

    /* Hover Effect */
    .leave-table tbody tr:hover {
      transform: scale(1.01);
      background: rgba(0, 123, 255, 0.1);
      transition: 0.2s ease-in-out;
    }
  </style>
</head>

<body>
<div class="dashboard-container">
  <!-- Sidebar -->
  <aside class="sidebar">
    <!-- Dynamic loading from dynamicMenu.jsp -->
    <jsp:include page="../backgroundProcess/dynamicMenu.jsp" />
  </aside>

  <!-- Main Content -->
  <main class="main-content">
    <header>
      <h1>Employee Leave Management</h1>
      <div class="top-controls">
        <p>Railway ELMS Dashboard</p>
        <label class="switch">
          <input type="checkbox" id="theme-toggle">
          <span class="slider"></span>
        </label>
      </div>
    </header>

    <!-- Leave Balances Section -->
    <section id="balances" class="card content-section">
      <h3>🧮 My Leave Balances</h3>
      <%
        ps = conn.prepareStatement(
          "select sum(decode(leave_type,'CL',balance,0)) clbal, " +
          "sum(decode(leave_type,'LAP',balance,0)) lapbal, " +
          "sum(decode(leave_type,'COL',balance,0)) combal, " +
          "sum(decode(leave_type,'RH',balance,0)) rhbal " +
          "from emp_leave_bal where control_no = ?"
        );
        ps.setString(1, control_no);
        rs = ps.executeQuery();
        rs.next();
      %>
      <div class="stats">
        <div class="stat-box"><h4>Casual</h4><p><%=rs.getString(1)%> Days</p></div>
        <div class="stat-box"><h4>Sick</h4><p><%=rs.getString(3)%> Days</p></div>
        <div class="stat-box"><h4>Earned</h4><p><%=rs.getString(2)%> Days</p></div>
        <div class="stat-box"><h4>Restricted Holidays</h4><p><%=rs.getString(4)%> Days</p></div>
      </div>

      <!-- Leave Entitlement Table -->
      <div class="leave-table-container">
        <h4>📅 Annual Leave Entitlements (Indian Railways)</h4>
        <table class="leave-table">
          <thead>
            <tr>
              <th>Leave Type</th>
              <th>Total Days / Year</th>
            </tr>
          </thead>
          <tbody>
            <tr><td>Casual Leave (CL)</td><td>8</td></tr>
            <tr><td>Leave on Average Pay (LAP / Earned Leave)</td><td>30</td></tr>
            <tr><td>Leave on Half Average Pay (LHAP / Commuted Leave)</td><td>20</td></tr>
            <tr><td>Restricted Holidays (RH)</td><td>2</td></tr>
            <tr><td>Maternity Leave</td><td>180 (per confinement)</td></tr>
            <tr><td>Paternity Leave</td><td>15</td></tr>
            <tr><td>Child Care Leave (CCL)</td><td>730 (max in service)</td></tr>
            <tr><td>Special Casual Leave</td><td>As per rules</td></tr>
          </tbody>
        </table>
      </div>
    </section>
  </main>

  <!-- Modal -->
  <div class="modal" id="leave-modal">
    <div class="modal-content">
      <span class="close-btn" onclick="closeModal()">&times;</span>
      <h3>Leave Details</h3>
      <p><strong>Type:</strong> Casual Leave</p>
      <p><strong>Dates:</strong> 02–03 July</p>
      <p><strong>Status:</strong> Approved</p>
      <button onclick="closeModal()">Close</button>
    </div>
  </div>
</div>

<script>
  const toggleSwitch = document.getElementById('theme-toggle');
  toggleSwitch.addEventListener('change', () => {
    document.body.classList.toggle('light');
    document.body.classList.toggle('dark');
  });

  // Default to dark mode
  document.body.classList.add('dark');

  function closeModal() {
    document.getElementById("leave-modal").style.display = "none";
  }
</script>

</body>
</html>
