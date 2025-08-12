<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.sql.*" %>
<%
  Object controlNoObj = session.getAttribute("global_control_no");
  String control_no = (controlNoObj != null) ? controlNoObj.toString() : null;
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>New Leave Application</title>
  <link rel="stylesheet" href="/CLW_LEAVE/cssFiles/dashboard.css" />
  <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap" rel="stylesheet">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
  <script src="/CLW_LEAVE/jsFiles/script.js"></script>
  
  <style>
    
  .main-content {
  margin-left: 350px;
  margin-right: 120px;
  display: flex;
  justify-content: center;
  align-items: center; /* Center vertically */
  min-height: 100vh;
  padding: 20px; /* Reduced padding */
  box-sizing: border-box;
}

form {
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(20px);
  -webkit-backdrop-filter: blur(20px);
  border: 1px solid rgba(255, 255, 255, 0.2);
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
  padding: 20px 30px; /* Reduced padding to fit screen */
  border-radius: 20px;
  display: flex;
  flex-direction: column;
  gap: 12px; /* Smaller gap */
  width: 100%;
  max-width: 900px; /* Slightly smaller width */
  max-height: 90vh; /* Keep inside screen */
  overflow-y: auto; /* Scroll if too many fields */
  margin: 0 auto;
}

form h3 {
  margin-bottom: 5px; /* Reduced space */
}
  

    /* Light mode form override */
    body.light form {
      background: #ffffff;
      backdrop-filter: none;
      -webkit-backdrop-filter: none;
      border: 1px solid #cccccc;
      box-shadow: 0 4px 20px rgba(0,0,0,0.05);
    }

    /* Theme toggle button */
    .theme-toggle {
      position: fixed;
      top: 20px;
      right: 20px;
      width: 50px;
      height: 50px;
      background: rgba(255, 255, 255, 0.15);
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      cursor: pointer;
      z-index: 9999;
      backdrop-filter: blur(5px);
      -webkit-backdrop-filter: blur(5px);
      box-shadow: 0 2px 8px rgba(0,0,0,0.2);
    }
    .theme-toggle .material-icons {
      font-size: 24px;
      color: inherit;
    }
    body.light .theme-toggle {
      background: rgba(0, 0, 0, 0.05);
    }
  </style>
</head>
<body>
  
  <!-- Theme toggle button -->
  <div class="theme-toggle">
    <span class="material-icons">wb_sunny</span>
  </div>

  <div class="dashboard-container">
    <aside class="sidebar">
      <jsp:include page="../backgroundProcess/dynamicMenu.jsp" />
    </aside>

    <main class="main-content">
      <form method="post" action="submitLeave.jsp">
        <input type="hidden" name="control_no" id="cno" value="<%=control_no%>" />

        <h3>📝 New Leave Application</h3>
        <label>Leave Type</label>
        <select name="leave_type" id="leave-type" required>
          <option value="NA">Select Leave Type</option>
          <option value="CL">Casual</option>
          <option value="RH">Restricted Holiday</option>
          <option value="COM">Commuted</option>
          <option value="LAP">Leave on Average Pay</option>
        </select>

        <label>From Date:</label>
        <input type="date" name="from_date" id="from-date" required />

        <label>From Time:</label>
        <input type="time" name="from_time" required />

        <label>To Date:</label>
        <input type="date" name="to_date" id="to-date" required />

        <label>To Time:</label>
        <input type="time" name="to_time"  required />
         <label>Reason</label>

        <textarea name="purpose" placeholder="Reason for Leave..." required></textarea>

        <button type="submit" id="submit-leave">Submit</button>
      </form>
    </main>
  </div>

  <script>
    const body = document.body;
    const themeToggle = document.querySelector('.theme-toggle');
    const themeIcon = themeToggle.querySelector('.material-icons');

    const savedTheme = localStorage.getItem('theme');
    if (savedTheme === 'light') {
      body.classList.add('light');
      themeIcon.textContent = 'nights_stay';
    } else {
      body.classList.remove('light');
      themeIcon.textContent = 'wb_sunny';
    }

    themeToggle.addEventListener('click', () => {
      body.classList.toggle('light');
      if (body.classList.contains('light')) {
        localStorage.setItem('theme', 'light');
        themeIcon.textContent = 'nights_stay';
      } else {
        localStorage.setItem('theme', 'dark');
        themeIcon.textContent = 'wb_sunny';
      }
    });
  </script>
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<script>
$(document).ready(function() {
    $("#leaveForm").on("submit", function(e) {
        e.preventDefault(); // stop normal form submission

        $.ajax({
            url: "checkBal.jsp",
            type: "GET",
            data: $(this).serialize(),
            dataType: "json",
            success: function(response) {
                if (response.flag === "pass") {
                    alert("ALAR - Leave can be applied");
                    // optionally submit form for real now
                    // e.currentTarget.submit();
                } else if (response.flag === "fail") {
                    alert("ALAR - " + response.msg);
                } else {
                    alert("Error: " + response.msg);
                }
            },
            error: function() {
                alert("An error occurred while checking leave balance.");
            }
        });
    });
});
</script>
</body>
</html>
