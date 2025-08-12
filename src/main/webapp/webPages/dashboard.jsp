<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<meta charset="UTF-8">
<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<%
    String ctrlNo = (String) session.getAttribute("global_control_no");
    String empName = "";
    String empDOB = "";
    String empDOA = "";
    String empDesig = "";
    String billUnit = "";
    String zone = "";

    String lastLeaveType = "—", lastAppliedOn = "—", lastStatus = "—";
    String sancLeaveType = "—", sancAppliedOn = "—", sancApprovedOn = "—";

    // Leave balances
    String clBal = "0", lapBal = "0", comBal = "0", rhBal = "0";

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        con = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521/pdbclw", "Shantodeep", "123");

        // Fetch employee details
        ps = con.prepareStatement("SELECT empname, TO_CHAR(empdob,'DD/MM/YYYY'), TO_CHAR(empdoa,'DD/MM/YYYY'), designation, billunit, zone FROM emp_master WHERE control_no = ?");
        ps.setString(1, ctrlNo);
        rs = ps.executeQuery();
        if (rs.next()) {
            empName = rs.getString(1);
            empDOB = rs.getString(2);
            empDOA = rs.getString(3);
            empDesig = rs.getString(4);
            billUnit = rs.getString(5);
            zone = rs.getString(6);
        }
        rs.close();
        ps.close();
        
        // Last leave applied
        ps = con.prepareStatement(
            "SELECT DECODE(leave_type,'CL','Casual Leave','RH','Restricted','LAP','Leave on avg pay','COM','Commuted','Others') AS type, " +
            "TO_CHAR(app_date,'DD/MM/YYYY') AS applied_on, " +
            "DECODE(leave_stats,'N','Applied','F','Pending','A','Approved','R','Rejected') AS status " +
            "FROM emp_leave_tran WHERE control_no = ? ORDER BY app_date DESC FETCH FIRST 1 ROWS ONLY"
        );
        ps.setString(1, ctrlNo);
        rs = ps.executeQuery();
        if (rs.next()) {
            lastLeaveType = rs.getString(1);
            lastAppliedOn = rs.getString(2);
            lastStatus = rs.getString(3);
        }
        rs.close();
        ps.close();

        // Latest sanctioned leave
        ps = con.prepareStatement(
            "SELECT DECODE(leave_type,'CL','Casual Leave','RH','Restricted Holiday','LAP','Leave on avg pay','COM','Commuted','Others') AS type, " +
            "TO_CHAR(app_date,'DD/MM/YYYY') AS applied_on, " +
            "TO_CHAR(sanction_authority_indate,'DD/MM/YYYY') AS approved_on " +
            "FROM emp_leave_tran WHERE control_no = ? AND leave_stats='A' ORDER BY sanction_authority_indate DESC FETCH FIRST 1 ROWS ONLY"
        );
        ps.setString(1, ctrlNo);
        rs = ps.executeQuery();
        if (rs.next()) {
            sancLeaveType = rs.getString(1);
            sancAppliedOn = rs.getString(2);
            sancApprovedOn = rs.getString(3);
        }
        rs.close();
        ps.close();

        // Leave balance at a glance
        ps = con.prepareStatement(
            "select sum(decode(leave_type,'CL',balance,0)) clbal, " +
            "sum(decode(leave_type,'LAP',balance,0)) lapbal, " +
            "sum(decode(leave_type,'COL',balance,0)) combal, " +
            "sum(decode(leave_type,'RH',balance,0)) rhbal " +
            "from emp_leave_bal where control_no = ?"
        );
        ps.setString(1, ctrlNo);
        rs = ps.executeQuery();
        if (rs.next()) {
            clBal = rs.getString(1);
            lapBal = rs.getString(2);
            comBal = rs.getString(3);
            rhBal = rs.getString(4);
        }

    } catch(Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch(Exception ex) {}
        if (ps != null) try { ps.close(); } catch(Exception ex) {}
        if (con != null) try { con.close(); } catch(Exception ex) {}
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>ELMS - Dashboard</title>
  <link rel="stylesheet" href="/CLW_LEAVE/cssFiles/dashboard.css" />
  <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
  <script src="/CLW_LEAVE/jsFiles/script.js"></script>
  <style>
body {
  margin: 0;
  font-family: 'Times New Roman', sans-serif;
  transition: background-color 0.3s, color 0.3s;
  margin-left: 92px;
  margin-right: 92px;
  padding: 30px;
}
.dashboard-container { display: flex; }
.sidebar { width: 230px; min-height: 100vh; background-color: #1c1c1c; color: white; padding: 20px; }
.main-content { flex: 1; padding: 20px; transition: background 0.3s, color 0.3s; }
header { display: flex; justify-content: space-between; align-items: center; }
.top-controls { display: flex; align-items: center; gap: 15px; }

.card {
  background: rgba(255,255,255,0.05);
  backdrop-filter: blur(8px);
  border-radius: 12px;
  padding: 20px;
  box-shadow: 0 0 20px rgba(0,175,255,0.6); /* wider glow */
  transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.card:hover {
  transform: scale(1.05);
  box-shadow: 0 0 40px rgba(0,175,255,0.9); /* wider, brighter glow on hover */
}
.card + .card {
  margin-left: 40px;
}

.dark table { width: 100%; border-collapse: collapse; color : white; font-family : 'Times New Roman', sans-serif;}
.light table{width: 100%; border-collapse: collapse; color : black; font-family : 'Times New Roman', sans-serif;}
th, td { padding: 8px 10px; text-align: left; }

.status-badge {
  padding: 4px 10px;
  border-radius: 8px;
  font-weight: bold;
  color: black;
}
.status-Applied { background-color: #42a5f5; }
.status-Approved { background-color: #4caf50; }
.status-Rejected { background-color: #f44336; }
.status-Pending { background-color: #ff9800; }
.status-Default { background-color: #9e9e9e; }

/* New layout styles */
.dashboard-grid {
  display: grid;
  grid-template-columns: 2fr 1.2fr; /* wider right column */
  gap: 20px;
  margin-top: 20px;
}

.employee-details-card {
  grid-column: 1 / 2;
  font-size: 1.1rem; /* Bigger text */
  color: #ffffff; /* High contrast */
  border: 2px solid transparent;
  border-radius: 12px;
  animation: glowBorder 3s linear infinite;
}

@keyframes glowBorder {
  0% { box-shadow: 0 0 10px #ff00ff, 0 0 20px #00ffff; border-color: #ff00ff; }
  25% { box-shadow: 0 0 10px #00ffff, 0 0 20px #ff0000; border-color: #00ffff; }
  50% { box-shadow: 0 0 10px #ff0000, 0 0 20px #00ff00; border-color: #ffc107; }
  75% { box-shadow: 0 0 10px #00ff00, 0 0 20px #ff00ff; border-color: #00ff00; }
  100% { box-shadow: 0 0 10px #ff00ff, 0 0 20px #00ffff; border-color: #ff00ff; }
}

.leave-balance-list {
  grid-column: 2 / 3;
  min-width: 260px; /* wider so heading fits in one line */
  padding-top: 25px;
  padding-bottom: 25px;
}

.leave-balance-list h3 {
  margin-bottom: 15px; /* more gap after heading */
}

.leave-balance-list .balance-item {
  margin: 10px 0; /* space between rows */
}

.bottom-row {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 20px;
  margin-top: 20px;
}

.leave-balance-list {
  display: grid;
  grid-template-columns: 1fr;
  gap: 10px;
  font-size: 1rem;
}
.leave-balance-list div {
  display: flex;
  justify-content: space-between;
  padding: 8px 12px;
  background: rgba(255,255,255,0.05);
  border-radius: 8px;
}
</style>
  
</head>
<body class="dark">
  <div class="dashboard-container">
    <aside class="sidebar">
      <%@ include file="../backgroundProcess/dynamicMenu.jsp" %>
    </aside>
    <main class="main-content" id="mainContent">
      <header>
        <h1>Employee Leave Management</h1>
        <div class="top-controls">
          <p>Railway ELMS Dashboard</p>
          <label class="switch">
            <input type="checkbox" id="theme-toggle" checked>
            <span class="slider"></span>
          </label>
        </div>
      </header>

      <!-- Top Row -->
      <div class="dashboard-grid">
        <!-- Employee Details -->
        <div class="card employee-details-card">

          <h3>👤 Employee Details</h3>
          <table>
              <tr><th>Name</th><td><%= empName %></td></tr>
              <tr><th>Date of Birth</th><td><%= empDOB %></td></tr>
              <tr><th>Date of Appointment</th><td><%= empDOA %></td></tr>
              <tr><th>Designation</th><td><%= empDesig %></td></tr>
              <tr><th>Bill Unit</th><td><%= billUnit %></td></tr>
              <tr><th>Zone</th><td><%= zone %></td></tr>
              <tr><th>Dealing Clerk</th><td>Sunil Kumar</td></tr>
              <tr><th>Reporting Officer</th><td>Rakesh Sisodiya</td></tr>
          </table>
        </div>

        <!-- Leave Balance at a Glance -->
        <div class="card">
          <h3>📊 Leave Balance at a Glance</h3>
          <div class="leave-balance-list">
            <div><span>Casual Leave</span><span><%= clBal %> Days</span></div>
            <div><span>Earned Leave</span><span><%= lapBal %> Days</span></div>
            <div><span>Commuted Leave</span><span><%= comBal %> Days</span></div>
            <div><span>Restricted Holidays</span><span><%= rhBal %> Days</span></div>
          </div>
        </div>
      </div>

      <!-- Bottom Row -->
      <div class="bottom-row">
        <!-- Last Leave Applied -->
        <div class="card">
          <h3>📝 Last Leave Applied</h3>
          <table>
            <tr><th>Leave Type</th><td><%= lastLeaveType %></td></tr>
            <tr><th>Applied On</th><td><%= lastAppliedOn %></td></tr>
            <tr>
              <th>Status</th>
              <td><span class="status-badge status-<%= lastStatus %>"><%= lastStatus %></span></td>
            </tr>
          </table>
        </div>

        <!-- Latest Sanctioned Leave -->
        <div class="card">
          <h3>✅ Latest Sanctioned Leave</h3>
          <table>
            <tr><th>Leave Type</th><td><%= sancLeaveType %></td></tr>
            <tr><th>Applied On</th><td><%= sancAppliedOn %></td></tr>
            <tr><th>Approved On</th><td><%= sancApprovedOn %></td></tr>
          </table>
        </div>
      </div>

    </main>
  </div>

  <script>
    document.getElementById('theme-toggle').addEventListener('change', function () {
      const body = document.body;
      if (this.checked) {
        body.classList.remove('light');
        body.classList.add('dark');
      } else {
        body.classList.remove('dark');
        body.classList.add('light');
      }
    });
  </script>
</body>
</html>
