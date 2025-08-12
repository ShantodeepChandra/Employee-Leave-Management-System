<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%!
	String en, ea, eg;
	Connection conn;
	PreparedStatement ps;
	ResultSet rs;
	String userid, password, jsonresponse, dburl, dbuser, dbpassword, tt, username, pwd, controlno;
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
		controlno = request.getParameter("controlno");
		ps = conn.prepareStatement("select count(*) from emp_master where control_no = ?");
		ps.setString(1,controlno);
		rs = ps.executeQuery();
		rs.next();
		if(rs.getString(1).equals("0")) {
			jsonresponse = "{\"flag\":\"fail\"}";
		} else {
			jsonresponse = "{\"flag\":\"pass\"}";
		}

		out.print(jsonresponse);

	} catch(Exception e) {
		out.print("{\"flag\":\"error\", \"msg\": \"" + e.getMessage() + "\"}");
	}
%>