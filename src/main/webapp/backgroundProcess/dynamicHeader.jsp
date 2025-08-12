<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*"%>
<%!
	Connection conn;
	PreparedStatement ps,ps1;
	ResultSet rs, rs1;
	HttpSession hs;
	String userid, password,jsonresponse,dburl,dbuser,dbpassword;
	String user_name;
%>
<%
	//Connection codes please dont modify Start >>
		ServletContext context = getServletContext();
		dbuser=context.getInitParameter("dbuser");
		dbpassword=context.getInitParameter("dbpassword");
		dburl =context.getInitParameter("dburl");
		
		Class.forName("oracle.jdbc.driver.OracleDriver");
		conn=DriverManager.getConnection(dburl,dbuser,dbpassword);
	
	// Connection codes please dont modify End <<
	
	hs = request.getSession();
	user_name = (String)hs.getAttribute("session_name");
%>
<p><%=user_name%></p>