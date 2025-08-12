<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Leave Approval - Admin Panel</title>
  <link rel="stylesheet" href="/CLW_LEAVE/cssFiles/admin.css" />
</head>
<body>
  <div class="admin-container">
    <aside class="sidebar">
      <h2>Officer Panel</h2>
      <ul class="menu">
        <li class="active" onclick="showSection('pending')">🟡 Pending Approvals</li>
        <li onclick="showSection('approved')">✅ Approved Applications</li>
        <li onclick="showSection('rejected')">❌ Rejected Applications</li>
        <li>🔒 Logout</li>
      </ul>
    </aside>

    <main class="main-content">
      <section class="header">
        <h1>Welcome, Reporting Officer</h1>
        <p>Review Leave Applications forwarded by Clerk</p>
      </section>

      <!-- PENDING SECTION -->
      <section class="applications-section" id="pending">
        <h2>Pending Leave Applications</h2>
        <div class="card-table">
          <table>
            <thead>
              <tr>
                <th>Application ID</th>
                <th>Employee Name</th>
                <th>Leave Type</th>
                <th>Dates</th>
                <th>Reason</th>
                <th>Priority</th>
                <th>Action</th>
              </tr>
            </thead>
            <tbody>
              <tr id="app-201">
                <td>#201</td>
                <td>Preeti Yadav</td>
                <td>EL</td>
                <td>20 Jul - 30 Jul</td>
                <td>Personal</td>
                <td>3</td>
                <td>
                  <button class="approve-btn" onclick="moveTo('app-201', 'approved')">Approve</button>
                  <button class="reject-btn" onclick="moveTo('app-201', 'rejected')">Reject</button>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </section>

      <!-- APPROVED SECTION -->
      <section class="applications-section hidden" id="approved">
        <h2>Approved Applications</h2>
        <div class="card-table">
          <table>
            <thead>
              <tr>
                <th>Application ID</th>
                <th>Employee Name</th>
                <th>Leave Type</th>
                <th>Dates</th>
                <th>Reason</th>
                <th>Priority</th>
              </tr>
            </thead>
            <tbody id="approved-body"></tbody>
          </table>
        </div>
      </section>

      <!-- REJECTED SECTION -->
      <section class="applications-section hidden" id="rejected">
        <h2>Rejected Applications</h2>
        <div class="card-table">
          <table>
            <thead>
              <tr>
                <th>Application ID</th>
                <th>Employee Name</th>
                <th>Leave Type</th>
                <th>Dates</th>
                <th>Reason</th>
                <th>Priority</th>
              </tr>
            </thead>
            <tbody id="rejected-body"></tbody>
          </table>
        </div>
      </section>
    </main>
  </div>
  <!-- LOGOUT SECTION -->


  <script>
    function showSection(id) {
      const sections = document.querySelectorAll(".applications-section");
      sections.forEach(section => section.classList.add("hidden"));
      document.getElementById(id).classList.remove("hidden");

      const menuItems = document.querySelectorAll(".menu li");
      menuItems.forEach(item => item.classList.remove("active"));
      event.target.classList.add("active");
    }

    function moveTo(rowId, target) {
    	  const row = document.getElementById(rowId);
    	  const clone = row.cloneNode(true);
    	  clone.removeChild(clone.lastElementChild); // remove action buttons

    	  document.getElementById(`${target}-body`).appendChild(clone);
    	  row.remove();
    	  alert("Application " + rowId + " " + (target === 'approved' ? 'Approved' : 'Rejected'));
    	}

  </script>
 <script>function showSection(id) {
	  const sections = document.querySelectorAll(".applications-section");
	  sections.forEach(section => section.classList.add("hidden"));
	  document.getElementById(id).classList.remove("hidden");

	  const menuItems = document.querySelectorAll(".menu li");
	  menuItems.forEach(item => item.classList.remove("active"));
	  event.target.classList.add("active");
	}
	  </script>
  
</body>
</html>