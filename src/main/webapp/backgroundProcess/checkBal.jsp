<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%!
	String en, ea, eg;
	Connection conn;
	PreparedStatement ps;
	ResultSet rs;
	String userid, password, jsonresponse, dburl, dbuser, dbpassword, tt, username, pwd,control_no,leave_type, fromDate, toDate;
	HttpSession hs;
%>
<%
	// DB connection (unchanged)
	ServletContext context = getServletContext();
	dbuser = context.getInitParameter("dbuser");
	dbpassword = context.getInitParameter("dbpassword");
	dburl = context.getInitParameter("dburl");

	Class.forName("oracle.jdbc.driver.OracleDriver");
	conn = DriverManager.getConnection(dburl, dbuser, dbpassword);

	try {
		hs = request.getSession();
		
		control_no = request.getParameter("controlno");
		leave_type = request.getParameter("leaveType");
  	
		

		// Step 1: Check if user exists
		ps = conn.prepareStatement("select balance from emp_leave_bal where control_no=? and leave_type=?");

		ps.setString(1, control_no);
		ps.setString(2, leave_type);
		
		
		rs = ps.executeQuery();
		rs.next();
		
		if (rs.getString(1).equals("0")) {
			

			jsonresponse = "{\"flag\":\"fail\"}";
		} else {
			
			
			
			jsonresponse = "{\"flag\":\"pass\"}";
		}

		out.print(jsonresponse);

	} catch(Exception e) {
		out.print("{\"flag\":\"error\", \"msg\": \"" + e.getMessage() + "\"}");
	}
%>