<%@ page import="java.sql.*" %>
<%
  String transId = request.getParameter("forwardBtn");
  String officer = request.getParameter("officer_" + transId);
  String dealingClerk = (String) session.getAttribute("control_no");

  if (transId != null && officer != null && dealingClerk != null) {
    Connection con = null;
    PreparedStatement ps = null;
    try {
      Class.forName("oracle.jdbc.driver.OracleDriver");
      con = DriverManager.getConnection("jdbc:oracle:thin:@//localhost:1521/pdbclw", "Shantodeep", "123");

      String updateSQL = "UPDATE emp_leave_tran SET dealing_asst = ?, sanction_authority = ? WHERE trans_id = ?";
      ps = con.prepareStatement(updateSQL);
      ps.setString(1, dealingClerk);
      ps.setString(2, officer);
      ps.setString(3, transId);

      ps.executeUpdate();
      response.sendRedirect("forwarded_app.jsp");
    } catch (Exception e) {
      out.println("<h3>Error: " + e.getMessage() + "</h3>");
    } finally {
      if (ps != null) ps.close();
      if (con != null) con.close();
    }
  } else {
    out.println("<h3>Invalid submission. Officer not selected.</h3>");
  }
%>
