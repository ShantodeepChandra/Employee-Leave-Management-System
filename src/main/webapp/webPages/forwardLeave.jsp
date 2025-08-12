<%@ page import="java.sql.*" %>
<%
  request.setCharacterEncoding("UTF-8");

  // Step 1: Get form parameters
  String leaveId = request.getParameter("leave_id");
  String officer_id = request.getParameter("officer_id");

  // Step 2: Get dealing clerk ID from session
  Object sessionControlNo = session.getAttribute("global_control_no");

  // Step 3: Validate
  if (leaveId == null || officer_id == null || sessionControlNo == null || sessionControlNo.equals("anonymous")) {
      out.println("<script>alert('Session expired or leave_id not found. Please log in again.'); window.location='login.jsp';</script>");
      return;
  }

  String clerk_id = sessionControlNo.toString();

  Connection con = null;
  PreparedStatement ps = null;

  try {
    Class.forName("oracle.jdbc.driver.OracleDriver");
    con = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521/pdbclw", "Shantodeep", "123");

    String sql = "UPDATE emp_leave_tran SET dealing_asst = ?, sanction_authority = ?, leave_stats = 'F', dealing_asst_indate = SYSDATE WHERE leave_id = ?";
    ps = con.prepareStatement(sql);
    ps.setString(1, clerk_id);
    ps.setString(2, officer_id);
    ps.setString(3, leaveId);

    int i = ps.executeUpdate();
    if (i > 0) {
      out.println("<script>alert('Application forwarded to Officer.'); window.location='receivedApp.jsp';</script>");
    } else {
      out.println("<script>alert('Forwarding failed. Please try again.'); history.back();</script>");
    }

  } catch(Exception e) {
    out.println("<h3>Error: " + e.getMessage() + "</h3>");
  } finally {
    if (ps != null) ps.close();
    if (con != null) con.close();
  }
%>
