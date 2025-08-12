<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
  <title>Officer Dashboard</title>
  <link rel="stylesheet" href="/CLW_LEAVE/cssFiles/dashboard.css" />
  <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">

  <style>
    body {
      margin: 0;
      font-family: 'Times New Roman', sans-serif;
      transition: background 0.3s, color 0.3s;
    }

    /* Dark Mode (Default) */
    body.dark {
      background-color: #1c2732;
      color: white;
    }

    /* Light Mode (Professional) */
    body.light {
      background-color: #f5f5f5;
      color: black;
    }

    .dashboard-container {
      display: flex;
      height: 100vh;
      overflow: hidden;
    }

    .sidebar {
      position: fixed;
      top: 0;
      left: 0;
      height: 100vh;
      width: 260px;
      background: rgba(30, 30, 30, 0.6);
      backdrop-filter: blur(20px);
      border-right: 1px solid rgba(255, 255, 255, 0.1);
      padding: 20px;
      color: #fff;
      display: flex;
      flex-direction: column;
      align-items: center;
      z-index: 100;
    }

    .main-content {
      flex-grow: 1;
      margin-left: 280px; /* Added space to avoid overlap */
      padding: 20px;
      overflow-y: auto;
      display: flex;
      flex-direction: column;
      align-items: center;
    }

    h2 {
      font-size: 28px;
      margin: 20px 0;
      text-align: center;
      width: 100%;
    }

    table {
      width: 96%;
      max-width: 1600px;
      border-collapse: collapse;
      font-family: 'Times New Roman', sans-serif;
      border-radius: 12px;
      overflow: hidden;
      margin: auto;
    }

    /* Dark mode table */
    body.dark table {
      background: rgba(255, 255, 255, 0.02);
      backdrop-filter: blur(8px);
    }
    body.dark thead {
      background-color: rgba(41, 98, 255, 0.8);
      color: white;
    }
    body.dark th, body.dark td {
      color: #f5f5f5;
    }

    /* Light mode table */
    body.light table {
      background: white;
      border: 1px solid #ddd;
    }
    body.light thead {
      background-color:rgba(41, 98, 255, 0.8);
      color: black;
    }
    body.light th, body.light td {
      color: black;
    }

    th, td {
      padding: 16px 18px;
      text-align: center;
      font-size: 15px;
      border: 1.5px solid #ccc;
    }

    tbody tr:nth-child(even) {
      background-color: rgba(255, 255, 255, 0.05);
    }

    tbody tr:hover {
      background-color: rgba(255, 255, 255, 0.12);
      transition: background 0.3s ease;
    }

    /* Light mode hover fix */
    body.light tbody tr:nth-child(even) {
      background-color: #f9f9f9;
    }
    body.light tbody tr:hover {
      background-color: #eaeaea;
    }

    .approve-btn,
    .reject-btn {
      display: inline-block;
      border: none;
      border-radius: 9999px;
      padding: 8px 20px;
      font-size: 14px;
      font-weight: bold;
      color: white;
      cursor: pointer;
      width: 100px;
      margin: 5px auto;
    }

    .approve-btn {
      background-color: #28a745;
    }
    .reject-btn {
      background-color: #dc3545;
    }
    .approve-btn:hover {
      background-color: #218838;
    }
    .reject-btn:hover {
      background-color: #c82333;
    }

    /* Theme toggle button */
    .theme-toggle {
      position: fixed;
      top: 20px;
      right: 20px;
      width: 45px;
      height: 45px;
      background: rgba(255, 255, 255, 0.15);
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      cursor: pointer;
      backdrop-filter: blur(5px);
      z-index: 2000;
    }
    .theme-toggle .material-icons {
      font-size: 24px;
    }
    body.light .theme-toggle {
      background: rgba(0, 0, 0, 0.1);
    }
  </style>
</head>

<body class="dark">
<!-- Theme toggle -->
<div class="theme-toggle">
  <span class="material-icons">wb_sunny</span>
</div>

<div class="dashboard-container">
  <aside class="sidebar">
    <jsp:include page="../backgroundProcess/dynamicMenu.jsp" />
  </aside>

  <div class="main-content">
    <h2>🛡 Leave Applications Received</h2>
    <table>
      <thead>
      <tr>
        <th>Leave ID</th>
        <th>Control No</th>
        <th>Type</th>
        <th>From</th>
        <th>Time From</th>
        <th>To</th>
        <th>Time To</th>
        <th>Reason</th>
        <th>Status</th>
        <th>Action</th>
      </tr>
      </thead>
      <tbody>
<%
  Connection con = null;
  PreparedStatement ps = null;
  ResultSet rs = null;
  try {
    Class.forName("oracle.jdbc.driver.OracleDriver");
    con = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521/pdbclw", "Shantodeep", "123");

    String sql = "SELECT leave_id, control_no, leave_type, TO_CHAR(leave_from_dt,'DD/MM/YYYY'), leave_from_time, TO_CHAR(leave_to_dt,'DD/MM/YYYY'), leave_to_time, leave_purpose, leave_stats " +
                 "FROM emp_leave_tran WHERE leave_stats = 'F' AND sanction_authority IS NOT NULL";
    ps = con.prepareStatement(sql);
    rs = ps.executeQuery();
    while (rs.next()) {
      String leave_id = rs.getString(1);
      String control_no = rs.getString(2);
      String type = rs.getString(3);
      String from = rs.getString(4);
      String timeFrom = rs.getString(5);
      String to = rs.getString(6);
      String timeTo = rs.getString(7);
      String reason = rs.getString(8);
      String status = rs.getString(9);
%>
      <tr>
        <td><%= leave_id %></td>
        <td><%= control_no %></td>
        <td><%= type %></td>
        <td><%= from %></td>
        <td><%= timeFrom %></td>
        <td><%= to %></td>
        <td><%= timeTo %></td>
        <td><%= reason %></td>
        <td><%= status %></td>
        <td>
          <form action="updateOfficerDecision.jsp" method="post">
            <input type="hidden" name="leave_id" value="<%= leave_id %>">
            <input type="hidden" name="control_no" value="<%= control_no %>">
            <input type="submit" name="decision" value="Approve" class="approve-btn">
            <input type="submit" name="decision" value="Reject" class="reject-btn">
          </form>
        </td>
      </tr>
<%
    }
  } catch (Exception e) {
    out.println("<tr><td colspan='10'>Error: " + e.getMessage() + "</td></tr>");
  } finally {
    if (rs != null) rs.close();
    if (ps != null) ps.close();
    if (con != null) con.close();
  }
%>
      </tbody>
    </table>
  </div>
</div>

<!-- Theme Toggle Script -->
<script>
  const body = document.body;
  const toggle = document.querySelector('.theme-toggle');
  const icon = toggle.querySelector('.material-icons');

  const savedTheme = localStorage.getItem('theme');
  if (savedTheme === 'light') {
    body.classList.add('light');
    body.classList.remove('dark');
    icon.textContent = 'nights_stay';
  }

  toggle.addEventListener('click', () => {
    body.classList.toggle('light');
    body.classList.toggle('dark');
    if (body.classList.contains('light')) {
      localStorage.setItem('theme', 'light');
      icon.textContent = 'nights_stay';
    } else {
      localStorage.setItem('theme', 'dark');
      icon.textContent = 'wb_sunny';
    }
  });
</script>
</body>
</html>