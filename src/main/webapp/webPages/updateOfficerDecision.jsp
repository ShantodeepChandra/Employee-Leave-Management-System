<%@ page import="java.sql.*" %>
<%
String emp_control_no, emp_leave_type,from,to;
ResultSet rs;
String leaveId = request.getParameter("leave_id");
String controlNo = request.getParameter("control_no");
String decision = request.getParameter("decision");

Connection con = null;
PreparedStatement ps = null;


String officerUserId = (String) session.getAttribute("global_userid");

try {
    Class.forName("oracle.jdbc.driver.OracleDriver");
    con = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521/pdbclw", "Shantodeep", "123");

    
    String statusCode = decision.equalsIgnoreCase("Approve") ? "A" : "R";
    if(statusCode.equals("R")){
    	
    String sql2="select control_no,leave_type,to_char(leave_from_dt,'YYYY-MM-DD'),to_char(leave_to_dt,'YYYY-MM-DD') from emp_leave_tran where leave_id=?"	;
    ps = con.prepareStatement(sql2);
    ps.setString(1, leaveId);
   rs= ps.executeQuery();
   rs.next();
   emp_control_no=rs.getString(1);
   emp_leave_type=rs.getString(2);
   from=rs.getString(3);
   to=rs.getString(4);
    	
    String sql1="update emp_leave_bal set balance=balance+(to_date(?,'YYYY-MM-DD') - to_date(?,'YYYY-MM-DD')) where control_no=? and leave_type=? "; 
    ps = con.prepareStatement(sql1);
    ps.setString(1, to);
    ps.setString(2, from);  
    ps.setString(3, emp_control_no);
    ps.setString(4, emp_leave_type);
    ps.executeUpdate();
    }

   
    String sql = "UPDATE emp_leave_tran " +
                 "SET leave_stats = ?, sanction_authority = ?, sanction_authority_indate = SYSDATE " +
                 "WHERE leave_id = ? AND control_no = ?";
    ps = con.prepareStatement(sql);
    ps.setString(1, statusCode);          
    ps.setString(2, officerUserId);      
    ps.setString(3, leaveId);
    ps.setString(4, controlNo);

    int i = ps.executeUpdate();
    if (i > 0) {
        response.sendRedirect("officer_dashboard.jsp?msg=Decision+saved");
    } else {
        out.println("<script>alert('Failed to update leave status.'); history.back();</script>");
    }
} catch (Exception e) {
    out.println("Error: " + e.getMessage());
} finally {
    if (ps != null) try { ps.close(); } catch (Exception e) {}
    if (con != null) try { con.close(); } catch (Exception e) {}
}
%>