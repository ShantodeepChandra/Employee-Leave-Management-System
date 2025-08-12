<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Invalidate the session and redirect if this page is accessed directly
    if ("true".equals(request.getParameter("logout"))) {
        session.invalidate();
        response.sendRedirect("/CLW_LEAVE/index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Logout</title>
    <link rel="stylesheet" href="/CLW_LEAVE/cssFiles/dashboard.css" />
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: var(--bg-color);
            color: var(--text-color);
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            transition: background 0.3s, color 0.3s;
        }
        .logout-container {
            background: var(--card-bg);
            padding: 30px;
            border-radius: 15px;
            box-shadow: var(--card-shadow);
            text-align: center;
            max-width: 350px;
            width: 100%;
        }
        h1 {
            margin-bottom: 20px;
        }
        .logout-btn {
            background: var(--btn-bg);
            color: var(--btn-text);
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 16px;
            transition: background 0.3s ease, transform 0.2s ease;
        }
        .logout-btn:hover {
            background: var(--btn-hover-bg);
            transform: translateY(-2px);
        }
        .theme-toggle {
            margin-top: 20px;
            padding: 8px 16px;
            background: var(--btn-bg);
            color: var(--btn-text);
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 14px;
        }

        /* Light Theme Variables */
        :root {
            --bg-color: #f9f9f9;
            --text-color: #222;
            --card-bg: #fff;
            --card-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            --btn-bg: #4CAF50;
            --btn-hover-bg: #45a049;
            --btn-text: #fff;
        }

        /* Dark Theme Variables */
        body.dark-mode {
            --bg-color: rgba(17, 25, 40, 0.85);
            --text-color: #fff;
            --card-bg: rgba(255, 255, 255, 0.05);
            --card-shadow: 0 4px 30px rgba(0, 0, 0, 0.3);
            --btn-bg: #00bcd4;
            --btn-hover-bg: #0097a7;
            --btn-text: #fff;
        }
    </style>
</head>
<body>
    <div class="logout-container">
        <h1>Confirm Logout</h1>
        <p>Are you sure you want to logout?</p>
        <form method="post" action="logout.jsp?logout=true">
            <button type="submit" class="logout-btn">Logout</button>
        </form>
        <button class="theme-toggle" onclick="toggleTheme()">Toggle Theme</button>
    </div>

    <script>
        // Load saved theme preference
        if (localStorage.getItem("theme") === "dark") {
            document.body.classList.add("dark-mode");
        }

        function toggleTheme() {
            document.body.classList.toggle("dark-mode");
            if (document.body.classList.contains("dark-mode")) {
                localStorage.setItem("theme", "dark");
            } else {
                localStorage.setItem("theme", "light");
            }
        }
    </script>
</body>
</html>