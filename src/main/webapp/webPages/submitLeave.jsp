<%@ page import="java.sql.*, java.util.*" %>
<%
String leave_type = request.getParameter("leave_type");
String from = request.getParameter("from_date");
String to = request.getParameter("to_date");
String from_time = request.getParameter("from_time");
String to_time = request.getParameter("to_time");
String purpose = request.getParameter("purpose");
int control_no;
String global_userid, global_control_no ,global_empname, global_designation, global_fwd_userid, global_usertype;
HttpSession hs;

Connection con = null;
PreparedStatement ps = null;

try {
Class.forName("oracle.jdbc.driver.OracleDriver");
con = DriverManager.getConnection(
"jdbc:oracle:thin:@//localhost:1521/pdbclw",
"Shantodeep",
"123"
);

hs = request.getSession();
global_userid = (String)hs.getAttribute("global_userid");
global_control_no = (String)hs.getAttribute("global_control_no");
global_empname = (String)hs.getAttribute("global_empname");
global_designation = (String)hs.getAttribute("global_designation");
global_fwd_userid = (String)hs.getAttribute("global_fwd_userid");
global_usertype = (String)hs.getAttribute("global_usertype");

String sql1="update emp_leave_bal set balance=balance-(to_date(?,'YYYY-MM-DD') - to_date(?,'YYYY-MM-DD')) where control_no=? and leave_type=?";
ps=con.prepareStatement(sql1);
ps.setString(1, to);
ps.setString(2, from);
ps.setInt(3, Integer.parseInt(global_control_no));
ps.setString(4, leave_type);
ps.executeUpdate();



String sql = "INSERT INTO emp_leave_tran(control_no, leave_type, leave_from_dt, leave_to_dt, leave_purpose, leave_stats, leave_from_time, leave_to_time, dealing_asst, dealing_asst_indate, leave_id, app_date) VALUES (?, ?, TO_DATE(?, 'YYYY-MM-DD'), TO_DATE(?, 'YYYY-MM-DD'), ?, 'N', ?, ?, ?, sysdate, (select nvl(max(leave_id)+1,to_char(sysdate,'YYYYMM')||'00001') from emp_leave_tran where to_char(app_date,'YYYYMM')=to_char(sysdate,'YYYYMM')), sysdate)";

ps = con.prepareStatement(sql);
ps.setInt(1, Integer.parseInt(global_control_no));
ps.setString(2, leave_type);
ps.setString(3, from);
ps.setString(4, to);
ps.setString(5, purpose);
ps.setString(6, from_time);
ps.setString(7, to_time);
ps.setString(8, global_fwd_userid);
//ps.setInt(9, Integer.parseInt(global_control_no));

int result = ps.executeUpdate();

if (result > 0) {
  out.println(
    "<script>alert('Leave application submitted successfully.'); window.location='my_app.jsp';</script>"
  );
} else {
  out.println(
    "<script>alert('Submission failed.'); history.back();</script>"
  );
}
} catch (Exception e) {
out.println("<h3>Error: " + e.getMessage() + "</h3>");
e.printStackTrace();
} finally {
if (ps != null)
ps.close();
if (con != null)
con.close();
}
%>