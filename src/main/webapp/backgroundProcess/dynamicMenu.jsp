<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%!
	String en, ea, eg;
	Connection conn;
	PreparedStatement ps;
	ResultSet rs;
	String userid, password, jsonresponse, dburl, dbuser, dbpassword, tt, username, pwd;
	HttpSession hs;
	String global_userid, global_control_no ,global_empname, global_designation, global_fwd_userid, global_usertype;
%>
<%
	hs = request.getSession();
	global_userid = (String)hs.getAttribute("global_userid");
	global_control_no = (String)hs.getAttribute("global_control_no");
	global_empname = (String)hs.getAttribute("global_empname");
	global_designation = (String)hs.getAttribute("global_designation");
	global_fwd_userid = (String)hs.getAttribute("global_fwd_userid");
	global_usertype = (String)hs.getAttribute("global_usertype");
%>



<img src="https://wp.logos-download.com/wp-content/uploads/2019/11/Indian_Railway_Logo_2.png" class="logo" alt="Railway Logo">
      <h2>Welcome</h2>
      <h3><%=global_empname%></h3>
      <p><%=global_designation%></p>
      <p>Logged in as
      	<%
      		if(global_usertype.equals("emp")) {
      			%>Employee<%
      		} else if(global_usertype.equals("admin")) {
      			%>Admin<%
      		} else if(global_usertype.equals("clerk")) {
      			%>Clerk<%
      		}
      	%>
      </p>
      <%
      	if(global_usertype.equals("emp")) {
      		%>
      			<nav>
			      	<a href="/CLW_LEAVE/webPages/dashboard.jsp"><span class="material-icons">bar_chart</span> Dashboard</a>
			        <a href="/CLW_LEAVE/webPages/leave_balance.jsp"><span class="material-icons">bar_chart</span> Leave Balances</a>
			        <a  href="/CLW_LEAVE/webPages/new_app.jsp"><span class="material-icons">note_add</span> New Application</a>
			        <a href="/CLW_LEAVE/webPages/past_sanc.jsp" ><span class="material-icons">task_alt</span> Past Sanctioned</a>
			        <a href="/CLW_LEAVE/webPages/my_app.jsp"><span class="material-icons">history</span> My Applications</a>
			  	</nav>
      		<%
      	} else if(global_usertype.equals("clerk")) {
      		%>
  			<nav>
		      	<a href="/CLW_LEAVE/webPages/dashboard.jsp"><span class="material-icons">bar_chart</span> Dashboard</a>
		        <a href="/CLW_LEAVE/webPages/receivedApp.jsp"><span class="material-icons">bar_chart</span> Received Applications</a>
		       
		  	</nav>
  		<%
      	}  else if(global_usertype.equals("admin")) {
      		%>
  			<nav>
		      	<a href="/CLW_LEAVE/webPages/dashboard.jsp"><span class="material-icons">bar_chart</span> Dashboard</a>
		       <a href="/CLW_LEAVE/webPages/officer_dashboard.jsp"><span class="material-icons">bar_chart</span>Pending Applications</a>
		  	</nav>
  		<%
      	} 
      %>
      