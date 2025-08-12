<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8"/>
<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
<title>Past Sanctioned Leaves</title>
<link rel="stylesheet" href="/CLW_LEAVE/cssFiles/dashboard.css"/>
<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
<style>
  body.dark { background-color: #1e293b; 
  color: #e2e8f0; 
  }
  body.light { background-color: #f1f5f9; color: #0f172a; }
  .content-section { margin-top: 20px; }
  table { width: 100%; border-collapse: collapse; border-radius: 8px; overflow: hidden; box-shadow: 0 0 10px rgba(0,0,0,0.2);  }
  th, td { padding: 12px; text-align: left; border : 1px solid black;}
  thead tr { background-color: #3b82f6; color: white; }
  tbody tr { border-bottom: 1px solid #ccc; }
  .dark table { background-color: #334155; color: #f1f5f9; }
  .dark tbody tr { border-color: #475569; }
  .light table { background-color: #ffffff; color: #0f172a; }
  .light tbody tr { border-color: #cbd5e1; }
  .switch { position: relative; display: inline-block; width: 50px; height: 24px; }
  .switch input { opacity: 0; width: 0; height: 0; }
  .slider { position: absolute; cursor: pointer; top: 0; left: 0; right: 0; bottom: 0;
            background-color: #ccc; transition: .4s; border-radius: 34px; }
  .slider:before { position: absolute; content: ""; height: 18px; width: 18px; left: 3px; bottom: 3px;
                   background-color: white; transition: .4s; border-radius: 50%; }
  input:checked + .slider { background-color: #3b82f6; }
  input:checked + .slider:before { transform: translateX(26px); }
</style>
<script>
window.addEventListener('DOMContentLoaded', () => {
  document.body.classList.add('dark'); // Default dark mode
  document.getElementById('theme-toggle').checked = true;
});
function toggleTheme() {
  document.body.classList.toggle('dark');
  document.body.classList.toggle('light');
}
</script>
</head>

<body>
<div class="dashboard-container">
  <aside class="sidebar">
    <jsp:include page="../backgroundProcess/dynamicMenu.jsp"/>
  </aside>

  <main class="main-content">
    <header>
      <h1>My Leave Applications</h1>
      <div class="top-controls">
        <p>Railway ELMS Dashboard</p>
        <label class="switch">
          <input type="checkbox" id="theme-toggle" onchange="toggleTheme()">
          <span class="slider"></span>
        </label>
      </div>
    </header>

    <section class="card content-section">
      <h3>📄 Past Sanctioned Leaves</h3>
      <div style="overflow-x:auto;">
        <table>
          <thead>
            <tr>
              <th>Applied Date</th>
              <th>Type</th>
              <th>From Date</th>
              <th>From Time</th>
              <th>To Date</th>
              <th>To Time</th>
              <th>Reason</th>
              <th>Approved Date</th>
            </tr>
          </thead>
          <tbody>
          <%
            Connection con=null;
            PreparedStatement ps=null;
            ResultSet rs=null;
            try {
              Class.forName("oracle.jdbc.driver.OracleDriver");
              con=DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521/pdbclw", "Shantodeep", "123");
              String ctrlNo = (String)session.getAttribute("global_control_no");

              String sql = "SELECT " +
                           "TO_CHAR(app_date,'DD/MM/YYYY') AS app_date, " +
                           "DECODE(leave_type,'CL','Casual Leave','RH','Restricted Holiday','LAP','Leave on avg pay','COM','Commuted','Others') AS type, " +
                           "TO_CHAR(leave_from_dt,'DD/MM/YYYY') AS from_date, leave_from_time, " +
                           "TO_CHAR(leave_to_dt,'DD/MM/YYYY') AS to_date, leave_to_time, " +
                           "leave_purpose, " +
                           "TO_CHAR(sanction_authority_indate,'DD/MM/YYYY') AS appr_date " +
                           "FROM emp_leave_tran " +
                           "WHERE control_no = ? AND leave_stats='A' " +
                           "ORDER BY leave_from_dt DESC";

              ps=con.prepareStatement(sql);
              ps.setString(1, ctrlNo);
              rs=ps.executeQuery();
              while(rs.next()){
                String appDate=rs.getString("app_date");
                String type=rs.getString("type");
                String fDate=rs.getString("from_date");
                String fTime=rs.getString("leave_from_time");
                String tDate=rs.getString("to_date");
                String tTime=rs.getString("leave_to_time");
                String reason=rs.getString("leave_purpose");
                String apprDate=(rs.getString("appr_date")!=null)?rs.getString("appr_date"):"—";
          %>
            <tr>
              <td><%=appDate%></td>
              <td><%=type%></td>
              <td><%=fDate%></td>
              <td><%=fTime%></td>
              <td><%=tDate%></td>
              <td><%=tTime%></td>
              <td><%=reason%></td>
              <td><%=apprDate%></td>
            </tr>
          <%
              }
            } catch(Exception e){
              out.println("<tr><td colspan='8'>Error fetching data: "+e.getMessage()+"</td></tr>");
            } finally {
              if(rs!=null) try{rs.close();}catch(Exception e){}
              if(ps!=null) try{ps.close();}catch(Exception e){}
              if(con!=null) try{con.close();}catch(Exception e){}
            }
          %>
          </tbody>
        </table>
      </div>
    </section>
  </main>
</div>
</body>
</html>
