<%@ page import="java.sql.*, java.util.*" %>
<%!
HttpSession hs;
String global_userid, global_control_no ,global_empname, global_designation, global_fwd_userid, global_usertype;
%>
<%
  Object controlNoObj = session.getAttribute("control_no");
  String control_no = (controlNoObj != null) ? controlNoObj.toString() : null;

 
  hs = request.getSession();
	global_userid = (String)hs.getAttribute("global_userid");
	global_control_no = (String)hs.getAttribute("global_control_no");
	global_empname = (String)hs.getAttribute("global_empname");
	global_designation = (String)hs.getAttribute("global_designation");
	global_fwd_userid = (String)hs.getAttribute("global_fwd_userid");
	global_usertype = (String)hs.getAttribute("global_usertype");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
  <meta charset="UTF-8" />
  <title>My Applications</title>
  <link rel="stylesheet" href="/CLW_LEAVE/cssFiles/dashboard.css" />
  <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
<style>
  .dashboard-container {
    display: flex;
    height: 100vh;
    overflow: hidden;
  }

  .sidebar {
    width: 250px;
    flex-shrink: 0;
  }

  .main-content {
    flex-grow: 1;
    padding: 20px;
    overflow-y: auto;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: flex-start;
  }

  h3 {
    font-size: 28px;
    margin-bottom: 30px;
    text-align: center;
  }

  .leave-list {
    width: 100%;
    overflow-x: auto;
    border-radius: 12px;
    box-shadow: 0 6px 20px rgba(0, 0, 0, 0.4);
  }

table {
  min-width: 1000px;
  width: 100%;
  border-collapse: collapse;
  font-family: 'Times New Roman', sans-serif;
  background: rgba(255, 255, 255, 0.02);
  backdrop-filter: blur(8px);
  border-radius: 12px;
  overflow: hidden;
  table-layout: fixed;
}

/* Dark mode table text */
body.dark table,
body.dark th,
body.dark td {
  color: white;
}

/* Light mode table text */
body.light table,
body.light th,
body.light td {
  color: black;
}
  
  thead {
    background-color: rgba(41, 98, 255, 0.8);
    color: white;
  }

  th, td {
    padding: 12px 8px;
    text-align: center;
    font-size: 16px;
    overflow: hidden;
    text-overflow: ellipsis;
  }
  
  th:nth-child(1), td:nth-child(1) { width: 10%; }
  th:nth-child(2), td:nth-child(2) { width: 10%; }
  th:nth-child(3), td:nth-child(3) { width: 8%; }
  th:nth-child(4), td:nth-child(4) { width: 10%; }
  th:nth-child(5), td:nth-child(5) { width: 8%; }
  th:nth-child(6), td:nth-child(6) { width: 27%; }
  th:nth-child(7), td:nth-child(7) { width: 12%; }
  th:nth-child(8), td:nth-child(8) { width: 15%; }
  
  tbody tr:nth-child(even) {
    background-color: rgba(255, 255, 255, 0.05);
  }

  tbody tr:hover {
    background-color: rgba(255, 255, 255, 0.12);
    transition: background 0.3s ease;
  }

  .status-badge {
    padding: 6px 16px;
    border-radius: 12px;
    font-size: 0.95em;
    font-weight: bold;
    color: black;
    display: inline-block;
  }

  .status-Applied { background-color: #42a5f5; }
  .status-Approved { background-color: #4caf50; }
  .status-Rejected { background-color: #f44336; }
  .status-Pending { background-color: #ff9800; }
  .status-Default { background-color: #9e9e9e; }
</style>
 
</head>

<body class="dark">
  <div class="dashboard-container">
    <aside class="sidebar">
      <jsp:include page="../backgroundProcess/dynamicMenu.jsp" />
    </aside>

    <main class="main-content">
      <header style="width: 100%; max-width: 1600px; display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
        <h3>📋 My Leave Applications</h3>
        <label class="switch">
          <input type="checkbox" id="theme-toggle" checked>
          <span class="slider"></span>
        </label>
      </header>

      <div class="leave-list">
        <table border="1" cellpadding="10" cellspacing="0">
          <thead>
            <tr>
              <th>Type</th>
              <th>From Date</th>
              <th>From Time</th>
              <th>To Date</th>
              <th>To Time</th>
              <th>Reason</th>
              <th>Status</th>
              <th>Holder</th>
            </tr>
          </thead>
          <tbody>
            <%
              Connection con = null;
              PreparedStatement ps = null;
              ResultSet rs = null;
              try {
                Class.forName("oracle.jdbc.driver.OracleDriver");
                con = DriverManager.getConnection("jdbc:oracle:thin:@//localhost:1521/pdbclw", "Shantodeep", "123");
                String sql = "SELECT " +
                		  "DECODE(leave_type,'CL','Casual Leave','RH','Restricted','LAP','Leave on avg pay','COM','Commuted') AS type, " +
                		  "TO_CHAR(leave_from_dt,'DD/MM/YYYY'), leave_from_time, " +
                		  "TO_CHAR(leave_to_dt,'DD/MM/YYYY'), leave_to_time, leave_purpose, " +
                		  "DECODE(leave_stats,'N','Applied','F','Pending','A','Approved','R','Rejected') AS status, " +
                		  "CASE " +
                		  "  WHEN leave_stats = 'F' THEN (SELECT empname FROM emp_master e1 JOIN leave_users l1 ON e1.control_no = l1.control_no WHERE l1.user_id = sanction_authority) " +
                		  "  WHEN leave_stats = 'N' THEN (SELECT empname FROM emp_master e2 JOIN leave_users l2 ON e2.control_no = l2.control_no WHERE l2.user_id = dealing_asst) " +
                		  "  WHEN leave_stats IN ('A','R') THEN '—' " +
                		  "  ELSE '—' END AS holder " +
                		  "FROM emp_leave_tran " +
                		  "WHERE control_no = ?";


                ps = con.prepareStatement(sql);
                ps.setString(1, global_control_no);
                rs = ps.executeQuery();
                while (rs.next()) {
                  String type = rs.getString(1);
                  String start = rs.getString(2);
                  String fromTime = rs.getString(3);
                  String end = rs.getString(4);
                  String toTime = rs.getString(5);
                  String reason = rs.getString(6);
                  String status = rs.getString(7);
                  String holder = rs.getString(8);
            %>
              <tr>
                <td><%= type %></td>
                <td><%= start %></td>
                <td><%= fromTime %></td>
                <td><%= end %></td>
                <td><%= toTime %></td>
                <td><%= reason %></td>
                <td><span class="status-badge status-<%= status %>"><%= status %></span></td>
                <td><%= holder %></td>
              </tr>
            <%
                }
              } catch (Exception e) {
                out.println("<h3>Error: " + e.getMessage() + "</h3>");
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
  <script>
    // Theme toggle
    document.getElementById('theme-toggle').addEventListener('change', function () {
      const body = document.body;
      if (this.checked) {
        // Switch to dark mode
        body.classList.remove('light');
        body.classList.add('dark');
      } else {
        // Switch to light mode
        body.classList.remove('dark');
        body.classList.add('light');
      }
    });
  </script>
</body>
</html>