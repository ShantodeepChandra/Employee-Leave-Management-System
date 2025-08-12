<%@ page import="java.sql.*" %>
<%
  Object clerkObj = session.getAttribute("control_no");
  String clerkId = (clerkObj != null) ? clerkObj.toString() : null;

  if (clerkId == null) {
    response.sendRedirect("index.jsp");
    return;
  }
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Dealing Clerk Dashboard</title>
  <link rel="stylesheet" href="/CLW_LEAVE/cssFiles/dealing_dashboard.css">
  <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
  <script src="/CLW_LEAVE/jsFiles/script.js"></script>
</head>
<body>
<div class="dashboard-container">
  <aside class="sidebar">
    <jsp:include page="../backgroundProcess/dynamicMenu.jsp" />
  </aside>

  <main class="main-content">
    <h3>🧾 Leave Applications Received</h3>
    <table border="1" style="width:100%; background:white;">
      <thead style="background:#2962ff; color:white;">
        <tr>
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

    String sql = "SELECT CONTROL_NO, LEAVE_TYPE, TO_CHAR(LEAVE_FROM_DT,'DD/MM/YYYY') AS LEAVE_FROM_DT, LEAVE_FROM_TIME, TO_CHAR(LEAVE_TO_DT, 'DD/MM/YYYY') AS LEAVE_TO_DT, LEAVE_TO_TIME, LEAVE_PURPOSE FROM emp_leave_tran WHERE LEAVE_STATS = 'N' AND DEALING_ASST='clk1' ";

    ps = con.prepareStatement(sql);
    rs = ps.executeQuery();
    while (rs.next()) {
      int ctrlNo = rs.getInt("control_no");
      String type = rs.getString("leave_type");
      String from = rs.getString("leave_from_dt");
      String fromT = rs.getString("leave_from_time");
      String to = rs.getString("leave_to_dt");
      
      String toT = rs.getString("leave_to_time");
      String reason = rs.getString("leave_purpose");
%>
      <tr>
        <td><%= ctrlNo %></td>
        <td><%= type %></td>
        <td><%= from %></td>
          <td><%= fromT %></td>
        <td><%= to %></td>
        <td><%= toT %></td>
        <td><%= reason %></td>
        <td>
          <form action="forwardLeave.jsp" method="post">
            <input type="hidden" name="control_no" value="<%= ctrlNo %>">
            <input type="text" name="officer_id" placeholder="Officer ID" required />
            <button type="submit">Forward</button>
          </form>
        </td>
      </tr>
<%
    }
  } catch(Exception e) {
    out.println("<tr><td colspan='8'>Error: " + e.getMessage() + "</td></tr>");
  } finally {
    if (rs != null) rs.close();
    if (ps != null) ps.close();
    if (con != null) con.close();
  }
%>
      </tbody>
    </table>
  </main>
</div>
</body>
</html>
