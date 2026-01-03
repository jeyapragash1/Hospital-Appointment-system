<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Register - Hospital Appointment System</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #e0f7fa; /* Light blue background color */
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            background-image: url('images/back.avif'); /* Background image */
            background-size: cover;
            background-position: center;
        }

        .register-container {
            background-color: rgba(255, 255, 255, 0.9); /* Semi-transparent white background */
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            max-width: 400px;
            width: 100%;
            text-align: center;
        }

        .register-container h1 {
            color: #4CAF50;
            margin-bottom: 20px;
        }

        .register-container h2 {
            margin-bottom: 20px;
            color: #333;
        }

        .form-group {
            margin-bottom: 20px;
            text-align: left;
        }

        .form-group label {
            display: block;
            margin-bottom: 5px;
            color: #333;
        }

        .form-group input[type="text"],
        .form-group input[type="email"],
        .form-group input[type="password"] {
            width: 100%;
            padding: 10px;
            border-radius: 5px;
            border: 1px solid #ccc;
            font-size: 16px;
            box-sizing: border-box;
        }

        .form-group input:focus {
            border-color: #4CAF50;
            outline: none;
        }

        .form-group input[type="checkbox"] {
            margin-right: 10px;
        }

        .form-group a {
            color: #4CAF50;
            text-decoration: none;
        }

        .form-group a:hover {
            text-decoration: underline;
        }

        .register-container button {
            width: 100%;
            padding: 12px;
            background-color: #4CAF50; /* Green button */
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
            transition: background-color 0.3s ease;
            margin-top: 10px;
        }

        .register-container button:hover {
            background-color: #45a049;
        }

        .register-container p {
            color: #333;
            margin-top: 10px;
        }

        .error-message {
            color: red;
            text-align: center;
            margin-top: 10px;
        }

        .success-message {
            color: green;
            text-align: center;
            margin-top: 10px;
        }
    </style>
    <script>
        function redirectToLogin() {
            alert('Registration successful! Redirecting to login page...');
            window.location.href = 'login.jsp'; // Redirect to login page
        }
    </script>
</head>
<body>

<div class="register-container">
   
    <h2>Create an Account</h2>
    <%
        // Registration is handled by /RegisterHandler servlet.
        String message = null;
        if (request.getParameter("success") != null) {
            message = "Registration successful. Please log in.";
        } else if (request.getParameter("error") != null) {
            message = request.getParameter("error");
        }
    %>
   <form action="RegisterHandler" method="post">
    <label for="name">Name:</label>
    <input type="text" id="name" name="name" required><br>

    <label for="email">Email:</label>
    <input type="email" id="email" name="email" required><br>

    <label for="password">Password:</label>
    <input type="password" id="password" name="password" required><br>

    <input type="submit" value="Register">
</form>

    <p class="<%= (request.getParameter("success") != null) ? "success-message" : "error-message" %>"><%= message == null ? "" : message %></p>
    <p>Already registered? <a href="login.jsp">Log in here</a>.</p>
</div>

</body>
</html>
