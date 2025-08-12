<%@ page import="java.sql.*, java.util.*" %>
<%
  Object clerkIdObj = session.getAttribute("control_no");
  String clerk_id = (clerkIdObj != null) ? clerkIdObj.toString() : null;

  if (clerk_id == null) {
    response.sendRedirect("index.jsp");
    return;
  }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>Dealing Clerk - Forwarded Applications</title>
  <link rel="stylesheet" href="/CLW_LEAVE/cssFiles/dealing_dashboard.css" />
</head>
<body>
<div class="dashboard-container">
  <aside class="sidebar">
    <jsp:include page="../backgroundProcess/dynamicMenu.jsp" />
  </aside>

  <main class="main-content">
    <h3>📤 Applications to Forward</h3>
    <div class="leave-list">
      <form method="post" action="forwardToOfficer.jsp">
      <table border="1" cellpadding="10" cellspacing="0" style="width: 100%; background-color: white;">
        <thead>
          <tr style="background-color: #2962ff; color: white;">
            <th>Employee</th>
            <th>Type</th>
            <th>From</th>
            <th>To</th>
            <th>Reason</th>
            <th>Officer</th>
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
            con = DriverManager.getConnection("jdbc:oracle:thin:@//localhost:1521/pdbclw", "Shantodeep", "123");

            String sql = "SELECT elt.trans_id, elt.control_no, em.emp_name, elt.leave_type, " +
                         "TO_CHAR(elt.leave_from_dt, 'DD-Mon') AS start_dt, " +
                         "TO_CHAR(elt.leave_to_dt, 'DD-Mon') AS end_dt, elt.leave_purpose " +
                         "FROM emp_leave_tran elt " +
                         "JOIN emp_master em ON elt.control_no = em.control_no " +
                         "WHERE elt.dealing_asst IS NULL";

            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
              String trans_id = rs.getString("trans_id");
              String emp_name = rs.getString("emp_name");
              String type = rs.getString("leave_type");
              String from = rs.getString("start_dt");
              String to = rs.getString("end_dt");
              String reason = rs.getString("leave_purpose");
        %>
          <tr>
            <td><%= emp_name %></td>
            <td><%= type %></td>
            <td><%= from %></td>
            <td><%= to %></td>
            <td><%= reason %></td>
            <td>
              <select name="officer_<%= trans_id %>" required>
                <option value="">-- Select Officer --</option>
                <option value="OFF001">Officer 1</option>
                <option value="OFF002">Officer 2</option>
                <option value="OFF003">Officer 3</option>
              </select>
            </td>
            <td>
              <button type="submit" name="forwardBtn" value="<%= trans_id %>">Forward</button>
            </td>
          </tr>
        <%
            }
          } catch (Exception e) {
            out.println("<tr><td colspan='7'>Error: " + e.getMessage() + "</td></tr>");
          } finally {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (con != null) con.close();
          }
        %>
        </tbody>
      </table>
      </form>
    </div>
  </main>
</div>
</body>
</html>
