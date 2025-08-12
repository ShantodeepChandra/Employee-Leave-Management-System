<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
  <%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
  <meta charset="UTF-8" />
  <title>Dealing Clerk Dashboard</title>

  <!-- CSS Files -->
  <link rel="stylesheet" href="/CLW_LEAVE/cssFiles/dashboard.css">
  <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css">
  <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">

  <!-- JS Files -->
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
  <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
  <script src="/CLW_LEAVE/jsFiles/script.js"></script>

  <style>
    body {
      margin: 0;
      font-family: 'Times New Roman', sans-serif;
      transition: background 0.3s, color 0.3s;
    }

    body.dark {
      background-color: #1c2732;
      color: white;
    }

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
      margin-left: 280px;
      padding: 20px;
      overflow-y: auto;
      display: flex;
      flex-direction: column;
      align-items: center;
    }

    h3 {
      font-size: 28px;
      margin-bottom: 20px;
      text-align: center;
    }

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

    .table-responsive {
      width: 100%;
      max-width: 1400px;
      overflow-x: auto;
      border-radius: 12px;
      box-shadow: 0 6px 20px rgba(0, 0, 0, 0.4);
    }

    table {
      width: 100%;
      border-collapse: collapse;
      font-family: 'Times New Roman', sans-serif;
      border-radius: 12px;
      overflow: hidden;
      border: 1px solid #ccc;
    }

    th, td {
      padding: 14px 18px;
      text-align: center;
      font-size: 15px;
      border: 1px solid #ccc;
    }

    th {
      font-weight: bold;
    }

    body.dark table {
      background: rgba(255, 255, 255, 0.02);
      backdrop-filter: blur(8px);
      color: white;
    }

    body.dark thead {
      background-color: rgba(41, 98, 255, 0.8);
      color: white;
    }

    body.light table {
      background: white;
      color: black;
      border: 1px solid #ddd;
    }

    body.light thead {
      background-color: #2e5bd8;
      color: black;
    }

    body.light th, body.light td {
      color: black;
    }

    body.dark th, body.dark td {
      color: #f5f5f5;
    }

    body.light tbody tr:nth-child(even) {
      background-color: #f9f9f9;
    }

    body.dark tbody tr:nth-child(even) {
      background-color: rgba(255, 255, 255, 0.05);
    }

    tbody tr:hover {
      background-color: rgba(255, 255, 255, 0.12);
      transition: background 0.3s ease;
    }

    input[type="text"] {
      padding: 6px 12px;
      width: 120px;
      border-radius: 6px;
      border: 1px solid rgba(255, 255, 255, 0.2);
      background: rgba(255, 255, 255, 0.1);
      color: inherit;
      outline: none;
    }

    body.light input[type="text"] {
      border: 1px solid #ccc;
      background: #fff;
      color: black;
    }

    button {
      background-color: rgba(41, 98, 255, 0.8);
      color: white;
      padding: 6px 12px;
      border: none;
      border-radius: 8px;
      cursor: pointer;
      font-weight: bold;
    }

    button:hover {
      background-color: rgba(41, 98, 255, 1);
      transition: background 0.3s ease;
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

    <main class="main-content">
      <h3>🧾 Leave Applications Received</h3>

      <div class="table-responsive">
        <table id="leaveTable">
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

    String sql = "SELECT LEAVE_ID,CONTROL_NO, LEAVE_TYPE, TO_CHAR(LEAVE_FROM_DT,'DD/MM/YYYY') AS LEAVE_FROM_DT, LEAVE_FROM_TIME, TO_CHAR(LEAVE_TO_DT, 'DD/MM/YYYY') AS LEAVE_TO_DT, LEAVE_TO_TIME, LEAVE_PURPOSE FROM emp_leave_tran WHERE LEAVE_STATS = 'N' AND DEALING_ASST = 'clk1'";
    ps = con.prepareStatement(sql);
    rs = ps.executeQuery();
    while (rs.next()) {
      String leaveId = rs.getString("LEAVE_ID");
      int ctrlNo = rs.getInt("CONTROL_NO");
      String type = rs.getString("LEAVE_TYPE");
      String from = rs.getString("LEAVE_FROM_DT");
      String fromT = rs.getString("LEAVE_FROM_TIME");
      String to = rs.getString("LEAVE_TO_DT");
      String toT = rs.getString("LEAVE_TO_TIME");
      String reason = rs.getString("LEAVE_PURPOSE");
%>
            <tr>
              <td><%= leaveId %></td>
              <td><%= ctrlNo %></td>
              <td><%= type %></td>
              <td><%= from %></td>
              <td><%= fromT %></td>
              <td><%= to %></td>
              <td><%= toT %></td>
              <td><%= reason %></td>
              <td>
                <form action="forwardLeave.jsp" method="post">
                  <input type="hidden" name="leave_id" value="<%= leaveId %>">
                  <input type="text" name="officer_id" placeholder="Officer ID" required />
                  <button type="submit">Forward</button>
                </form>
              </td>
            </tr>
<%
    }
  } catch(Exception e) {
    out.println("<tr><td colspan='9'>Error: " + e.getMessage() + "</td></tr>");
  } finally {
    if (rs != null) rs.close();
    if (ps != null) ps.close();
    if (con != null) con.close();
  }
%>
          </tbody>
        </table>
      </div>
    </main>
  </div>

  <!-- DataTables Activation -->
  <script>
    $(document).ready(function () {
      $('#leaveTable').DataTable();
    });

    // Theme toggle script
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
