<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Railway ELMS - Login</title>
  <link rel="stylesheet" href="/CLW_LEAVE/cssFiles/login.css" />
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
  <script src="/CLW_LEAVE/jsFiles/script.js"></script>
</head>
<body>
  <div class="landing-overlay"></div> 
  <div class="container">
    <!-- Left Section -->
    <div class="left-panel">
      <img src="https://wp.logos-download.com/wp-content/uploads/2019/11/Indian_Railway_Logo_2.png" alt="Railway Logo" class="logo" />
      <h1>Employee Leave <br>Management System</h1>
      <p>Welcome to ELMS Application<br>for Indian Railways</p>
     
      <footer>
        <small>Version : 3.3.0 | Host : cris.in<br>
        Languages: English हिंदी<br>
        © 2024 Centre For Railway Information Systems</small>
       
      </footer>
    </div>

    <!-- Right Section -->
    <div class="login-box">
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

  <button type="submit" class="login-btn" id="sys-login">Login</button>
  <p class="loader"></p>

  <p class="register-link">
    New user? <span id="reg-toggle" class="span-btn">Register Here</span>
  </p>



      <div class="links">
        <a href="#">Need Help for Login?</a>
        <a href="#">Forgot Password?</a>
        <a href="#">CGA Application Registration</a>
      </div>

      <p class="notice"><strong>⚠ Click here to access APAR Module</strong></p>
    </div>
  </div>
</body>
</html>