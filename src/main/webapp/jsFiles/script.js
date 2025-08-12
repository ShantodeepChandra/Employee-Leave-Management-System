$(document).ready(function () {
  // Login → Register toggle
  $(document).on("click", "#reg-toggle", function () {
    $(".login-box").animate({ right: "50%" }, 500);
    $(".left-panel").animate({ left: "50%" }, 500);

	let register_template = `
	  <h2>Register</h2>
	  <p class="subtitle">Register your Account</p>
	  <form action="/CLW_LEAVE/backgroundProcess/register.jsp" method="post">
	  <div class="input-group">
	  	      <label for="control_no">🆔</label>
	  	      <input type="number" id="reg-control-no" name="control_no" placeholder="Control Number" required />
	  	    </div>
			<button type="submit" class="validate-emp">Validate</button>
			
			<div class="validate-box">
			
			<div class="input-group">
			      <label for="username">👤</label>
			      <input type="text" id="reg-username" name="user_id" placeholder="Username" required />
			    </div>

			    <div class="input-group">
			      <label for="password">🔒</label>
			      <input type="password" id="reg-password" name="pwd" placeholder="Password" required />
			    </div>

				<div class="input-group">
					      <label for="cnf_password">🔒</label>
					      <input type="password" id="reg-cnf-password" name="cnf_password" placeholder="Confirm Password" required />
					    </div>

			    

			    <div class="input-group">
			      <label for="usertype">⚙</label>
			      <select id="reg-usertype" name="usertype" required>
			        <option value="">Select User Type</option>
			        <option value="admin">Admin</option>
			        <option value="emp">Employee</option>
			      </select>
			    </div>

			    <button type="submit" class="register-btn">Register</button>
			
			</div>
			
			
	   

	    <p class="register-link">
	      Already Registered? <span id="log-toggle" class="span-btn">Login</span>
	    </p>
	  </form>

	  <div class="links">
	    <a href="#">Need Help for Login?</a>
	    <a href="#">Forgot Password?</a>
	    <a href="#">CGA Application Registration</a>
	  </div>

	  <p class="notice"><strong>⚠ Click here to access APAR Module</strong></p>`;


    setTimeout(function () {
      $(".login-box").html(register_template);
    }, 250);
  });

  // Register → Login toggle
  $(document).on("click", "#log-toggle", function () {
    $(".login-box").animate({ right: "0" }, 500);
    $(".left-panel").animate({ left: "0" }, 500);

    let login_template = `
      <h2>Login</h2>
      <p class="subtitle">Login to your Account</p>
      <div class="input-group">
        <label for="username">👤</label>
        <input type="text" id="username" name="username" placeholder="Username" required />
      </div>

      <div class="input-group">
        <label for="password">🔒</label>
        <input type="password" id="password" name="password" placeholder="Password" required />
      </div>

      <button type="button" class="login-btn" id="sys-login">Login</button>

      <p class="register-link">
        New user? <span id="reg-toggle" class="span-btn">Register Here</span>
      </p>

      <div class="links">
        <a href="#">Need Help for Login?</a>
        <a href="#">Forgot Password?</a>
        <a href="#">CGA Application Registration</a>
      </div>

      <p class="notice"><strong>⚠ Click here to access APAR Module</strong></p>`;

    setTimeout(function () {
      $(".login-box").html(login_template);
    }, 250);
  });

  // Leave Application Click → Show Details
  $(document).on("click", ".leave-item", function () {
    const type = $(this).data("type");
    const from = $(this).data("from");
    const to = $(this).data("to");
    const status = $(this).data("status");
    const reason = $(this).data("reason");
    const priority = $(this).data("priority");

    const detailHtml = `
      <h4>📄 Leave Details</h4>
      <p><strong>Type:</strong> ${type}</p>
      <p><strong>From:</strong> ${from}</p>
      <p><strong>To:</strong> ${to}</p>
      <p><strong>Status:</strong> ${status}</p>
      <p><strong>Reason:</strong> ${reason}</p>
      <p><strong>Priority:</strong> ${priority} / 5</p>
    `;

    $("#leaveDetail").html(detailHtml);
  });

  // Optional: Toggle section visibility
  $(document).on("click", ".nav-item", function () {
    const sectionId = $(this).data("section");
    $(".content-section").hide();
    $(`#${sectionId}`).fadeIn();
  });

  // ✅ LOGIN Validation (after page load or toggle login)
  $(document).on("click", "#sys-login", function () {
    const username = $("#username").val().trim();
    const password = $("#password").val().trim();

    if (!username || !password) {
      alert("Please enter both username and password");
      return;
    }
	
	let msg = `<i class="fa fa-spinner fa-spin" aria-hidden="true"></i> Validating User`
	let msg_red = `<span class="text-red"><i class="fa fa-times" aria-hidden="true"></i> Invalid Credentials</span>`
	$(".loader").html(msg)
	setTimeout(function() {
		$.ajax({
					      type: "POST",
					      url: "/CLW_LEAVE/backgroundProcess/loginValidate.jsp",
					      data: {
					        username: username,
					        password: password
					      },
					      success: function (data) {
					        try {
					          const json = JSON.parse(data.trim());
					          if (json.flag === "pass") {
					            window.location.href = "/CLW_LEAVE/webPages/dashboard.jsp";
					          } else {
					            $(".loader").html(msg_red)
					          }
					        } catch (e) {
					          console.error("Invalid JSON:", data);
					          alert("Login failed: Unexpected server response");
					        }
					      },
					      error: function (xhr, status, error) {
					        alert("AJAX error: " + error);
					      }
					    });
	}, 2000)
			    
  });
  
  
  $(document).on("click", ".validate-emp", function() {
	
	$.ajax({
								cache: false,
								async: false,
						      type: "POST",
						      url: "/CLW_LEAVE/backgroundProcess/validateEmp.jsp",
						      data: {
						        controlno: $("#reg-control-no").val()
						      
						      },
						      success: function (data) {
						       let jsonobj = JSON.parse(data)
							   if(jsonobj.flag=="pass") {
								$(".validate-box").css({"display":"block"})
							   } else {
								alert("Employee not present in database")
							   }
						      },
						      error: function (xhr, status, error) {
						        alert("AJAX error: " + error);
						      }
						    });
  })
  
  
  
  // Check balance when leave type changes
  $(document).on("change", "#leave-type", function() {

      	$.ajax({
      								cache: false,
      								async: false,
      						      type: "POST",
      						      url: "/CLW_LEAVE/backgroundProcess/checkBal.jsp",
      						      data: {
      						        controlno: $("#cno").val(),
    								leaveType: $(this).val(),
      						    
      						      },
      						      success: function (data) {
      						       let jsonobj = JSON.parse(data)
    							   
      							   if(jsonobj.flag=="pass") {
      								
      							   } else {
      								
    								$("#submit-leave").prop("disabled",true).html("Insufficient Leave Balance")
    								
      							   }
      						      },
      						      error: function (xhr, status, error) {
      						        alert("AJAX error: " + error);
      						      }
      						    });
        })
  // Submit leave form via AJAX
 
 

  

  // Optional Sidebar load
  $(".sidebar").load("/CLW_LEAVE/backgroundProcess/dynamicMenu.jsp");
});