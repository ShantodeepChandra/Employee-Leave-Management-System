<%@ page import="java.sql.*" %>
<%
    String userId = request.getParameter("user_id");
    String pwd = request.getParameter("pwd");
    String usertype = request.getParameter("usertype");
    String controlStr = request.getParameter("control_no");
    String isactive = "yes";

    if (userId == null || pwd == null || usertype == null || controlStr == null ||
        userId.trim().isEmpty() || pwd.trim().isEmpty() || usertype.trim().isEmpty() || controlStr.trim().isEmpty()) {
        out.println("<p>Error: All fields are required. <a href='../index.jsp'>Go Back</a></p>");
        return;
    }

    int controlNo = 0;
    try {
        controlNo = Integer.parseInt(controlStr);
    } catch (NumberFormatException e) {
        out.println("<p>Invalid Control Number. <a href='../index.jsp'>Go Back</a></p>");
        return;
    }

    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");

        String dburl = application.getInitParameter("dburl");
        String dbuser = application.getInitParameter("dbuser");
        String dbpassword = application.getInitParameter("dbpassword");

        Connection con = DriverManager.getConnection(dburl, dbuser, dbpassword);

        PreparedStatement check = con.prepareStatement("SELECT * FROM leave_users WHERE user_id = ?");
        check.setString(1, userId);
        ResultSet rs = check.executeQuery();

        if (rs.next()) {
            out.println("<p>User already exists. <a href='../index.jsp'>Login here</a></p>");
        } else {
            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO leave_users (user_id, pwd, control_no, usertype, isactive) VALUES (?, ?, ?, ?, ?)"
            );
            ps.setString(1, userId);
            ps.setString(2, pwd);
            ps.setInt(3, controlNo);
            ps.setString(4, usertype);
            ps.setString(5, isactive);

            int i = ps.executeUpdate();
            if (i > 0) {
                response.sendRedirect("../index.jsp?registered=true");
            } else {
                out.println("<p>Registration failed. <a href='../index.jsp'>Try Again</a></p>");
            }
        }

        con.close();
    } catch (Exception e) {
        out.println("<p><strong>Error:</strong> " + e.getMessage() + "</p>");
        e.printStackTrace();
    }
%>
