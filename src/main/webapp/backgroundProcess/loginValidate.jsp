<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%!
	String en, ea, eg;
	Connection conn;
	PreparedStatement ps;
	ResultSet rs;
	String userid, password, jsonresponse, dburl, dbuser, dbpassword, tt, username, pwd;
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
		
		username = request.getParameter("username");
		pwd = request.getParameter("password");

		

		// Step 1: Check if user exists
		ps = conn.prepareStatement("select m.control_no, empname, designation, fwd_userid, usertype from leave_users u, emp_master m where u.control_no = m.control_no and user_id = ? AND pwd = ?");
		ps.setString(1, username);
		ps.setString(2, pwd);
		rs = ps.executeQuery();

		if (rs.next()) {
			hs.setAttribute("global_userid", username);
			hs.setAttribute("global_control_no", rs.getString(1)); 
			hs.setAttribute("global_empname", rs.getString(2));
			hs.setAttribute("global_designation", rs.getString(3));
			hs.setAttribute("global_fwd_userid", rs.getString(4));
			hs.setAttribute("global_usertype", rs.getString(5));

			jsonresponse = "{\"flag\":\"pass\"}";
		} else {
			
			hs.setAttribute("global_userid", "anonymous");
			hs.setAttribute("global_control_no", "anonymous"); 
			hs.setAttribute("global_empname", "anonymous");
			hs.setAttribute("global_designation", "anonymous");
			hs.setAttribute("global_fwd_userid", "anonymous");
			hs.setAttribute("global_usertype", "anonymous");
			
			jsonresponse = "{\"flag\":\"fail\"}";
		}

		out.print(jsonresponse);

	} catch(Exception e) {
		out.print("{\"flag\":\"error\", \"msg\": \"" + e.getMessage() + "\"}");
	}
%>
