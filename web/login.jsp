<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Enterprise Leave Management System</title>
    <link rel="stylesheet" href="css/custom-style.css">
    <!-- Đảm bảo đường dẫn này đúng với vị trí lưu file CSS -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        /* CSS Inline để đảm bảo login page hoạt động ngay cả khi file CSS không tải được */
        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(135deg, #3498db 0%, #2c3e50 100%);
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        
        .login-container {
            width: 400px;
            max-width: 90%;
            background-color: #fff;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
        
        .login-header {
            background-color: #2c3e50;
            color: #fff;
            padding: 25px;
            text-align: center;
        }
        
        .login-logo {
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .login-logo i {
            font-size: 2.5rem;
            margin-right: 15px;
            color: #3498db;
        }
        
        .login-body {
            padding: 25px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-control {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
            font-size: 16px;
        }
        
        .login-btn {
            width: 100%;
            padding: 12px;
            background-color: #3498db;
            color: #fff;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            font-weight: bold;
        }
        
        .login-btn:hover {
            background-color: #2980b9;
        }
        
        .login-footer {
            padding: 15px;
            text-align: center;
            background-color: #f8f9fa;
            border-top: 1px solid #eee;
            font-size: 14px;
            color: #666;
        }
        
        .error-message {
            background-color: #f8d7da;
            color: #721c24;
            padding: 10px;
            border-radius: 4px;
            margin-bottom: 20px;
            text-align: center;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="login-header">
            <div class="login-logo">
                <i class="fas fa-calendar-alt"></i>
                <h1>LMS Portal</h1>
            </div>
            <p>Enterprise Leave Management System</p>
        </div>
        
        <div class="login-body">
            <% 
                String error = (String) request.getAttribute("error");
                if (error != null) {
            %>
                <div class="error-message">
                    <i class="fas fa-exclamation-circle"></i> <%= error %>
                </div>
            <% } %>
            
            <form action="login" method="post">
                <div class="form-group">
                    <label for="username">Username</label>
                    <input type="text" id="username" name="username" class="form-control" required>
                </div>
                
                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" class="form-control" required>
                </div>
                
                <button type="submit" class="login-btn">
                    <i class="fas fa-sign-in-alt"></i> Login
                </button>
            </form>
        </div>
        
        <div class="login-footer">
            <p>&copy; 2025 Enterprise Leave Management System</p>
            <p><a href="#">Forgot Password?</a> | <a href="#">Help Center</a></p>
        </div>
    </div>
</body>
</html>