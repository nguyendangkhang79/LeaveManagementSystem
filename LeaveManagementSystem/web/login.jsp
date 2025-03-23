<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập - Enterprise Leave Management System</title>
    <link rel="shortcut icon" href="favicon.ico" type="image/x-icon">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        :root {
            /* Biến màu sắc chế độ sáng */
            --primary-color: #1565c0;
            --secondary-color: #0d47a1;
            --accent-color: #1e88e5;
            --background-color: #f5f7fa;
            --card-bg-color: #ffffff;
            --text-color: #333333;
            --text-secondary: #6c757d;
            --border-color: #e9ecef;
            --success-color: #28a745;
            --warning-color: #ffc107;
            --danger-color: #dc3545;
            --info-color: #17a2b8;
            
            /* Thông số chung */
            --border-radius: 8px;
            --transition-speed: 0.3s;
            --box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
            --box-shadow-hover: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
        }

        [data-theme="dark"] {
            --primary-color: #2196f3;
            --secondary-color: #1976d2;
            --accent-color: #64b5f6;
            --background-color: #121212;
            --card-bg-color: #1e1e1e;
            --text-color: #e0e0e0;
            --text-secondary: #adb5bd;
            --border-color: #2d2d2d;
            --box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.2);
            --box-shadow-hover: 0 0.5rem 1rem rgba(0, 0, 0, 0.3);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            transition: background-color var(--transition-speed) ease, 
                        color var(--transition-speed) ease;
        }

        body {
            font-family: 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Open Sans', 'Helvetica Neue', sans-serif;
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
            position: relative;
            overflow: hidden;
        }

        /* Animated background */
        .background-animation {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: -1;
            opacity: 0.1;
        }

        .circle {
            position: absolute;
            border-radius: 50%;
            background-color: white;
            animation: float 15s infinite linear;
            opacity: 0.5;
        }

        @keyframes float {
            0% {
                transform: translateY(0) translateX(0);
            }
            25% {
                transform: translateY(-20px) translateX(10px);
            }
            50% {
                transform: translateY(0) translateX(20px);
            }
            75% {
                transform: translateY(20px) translateX(10px);
            }
            100% {
                transform: translateY(0) translateX(0);
            }
        }

        .login-container {
            width: 100%;
            max-width: 450px;
            background-color: var(--card-bg-color);
            border-radius: var(--border-radius);
            overflow: hidden;
            box-shadow: 0 15px 30px rgba(0,0,0,0.2);
            animation: fadeIn 0.5s ease forwards;
            position: relative;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .login-header {
            position: relative;
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            color: #ffffff;
            padding: 35px 30px;
            text-align: center;
        }

        .theme-switch {
            position: absolute;
            top: 15px;
            right: 15px;
            display: flex;
            align-items: center;
        }

        .theme-switch-label {
            display: flex;
            align-items: center;
            cursor: pointer;
            color: #fff;
        }

        .theme-switch-toggle {
            position: relative;
            display: inline-block;
            width: 46px;
            height: 24px;
            margin: 0 8px;
        }

        .theme-switch-toggle input {
            opacity: 0;
            width: 0;
            height: 0;
        }

        .theme-switch-slider {
            position: absolute;
            cursor: pointer;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: rgba(255, 255, 255, 0.3);
            border-radius: 24px;
            transition: 0.4s;
        }

        .theme-switch-slider:before {
            position: absolute;
            content: "";
            height: 18px;
            width: 18px;
            left: 3px;
            bottom: 3px;
            background-color: white;
            border-radius: 50%;
            transition: 0.4s;
        }

        input:checked + .theme-switch-slider {
            background-color: #64b5f6;
        }

        input:checked + .theme-switch-slider:before {
            transform: translateX(22px);
        }

        .login-logo {
            margin-bottom: 15px;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
        }

        .login-logo-icon {
            width: 80px;
            height: 80px;
            background-color: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 40px;
            color: var(--primary-color);
            margin-bottom: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }

        .login-logo h1 {
            font-size: 28px;
            margin: 0;
            font-weight: 600;
        }

        .login-body {
            padding: 35px 30px;
        }

        .form-group {
            margin-bottom: 24px;
            position: relative;
        }

        .form-control {
            width: 100%;
            padding: 14px 16px 14px 48px;
            border: 1px solid var(--border-color);
            border-radius: var(--border-radius);
            font-size: 16px;
            background-color: var(--card-bg-color);
            color: var(--text-color);
            transition: all 0.3s;
        }

        .form-control:focus {
            border-color: var(--primary-color);
            outline: none;
            box-shadow: 0 0 0 3px rgba(21, 101, 192, 0.25);
        }

        .form-icon {
            position: absolute;
            left: 16px;
            top: 14px;
            color: var(--text-secondary);
            font-size: 18px;
        }

        .login-btn {
            width: 100%;
            padding: 14px;
            background-color: var(--primary-color);
            color: white;
            border: none;
            border-radius: var(--border-radius);
            font-size: 18px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .login-btn:hover {
            background-color: var(--secondary-color);
            transform: translateY(-2px);
            box-shadow: 0 6px 8px rgba(0,0,0,0.15);
        }

        .login-btn:active {
            transform: translateY(0);
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }

        .login-btn i {
            margin-right: 10px;
        }

        .login-footer {
            padding: 20px 30px;
            text-align: center;
            background-color: rgba(0,0,0,0.02);
            border-top: 1px solid var(--border-color);
        }

        .login-footer p {
            margin: 6px 0;
            color: var(--text-secondary);
            font-size: 14px;
        }

        .login-footer a {
            color: var(--primary-color);
            text-decoration: none;
            transition: color 0.2s;
        }

        .login-footer a:hover {
            color: var(--secondary-color);
            text-decoration: underline;
        }

        .error-message {
            background-color: var(--danger-color);
            color: white;
            padding: 14px;
            border-radius: var(--border-radius);
            margin-bottom: 24px;
            display: flex;
            align-items: center;
            animation: shake 0.5s ease-in-out;
        }

        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            10%, 30%, 50%, 70%, 90% { transform: translateX(-5px); }
            20%, 40%, 60%, 80% { transform: translateX(5px); }
        }

        .error-message i {
            margin-right: 10px;
            font-size: 20px;
        }

        .company-info {
            position: absolute;
            bottom: 20px;
            text-align: center;
            color: rgba(255, 255, 255, 0.8);
            font-size: 14px;
            width: 100%;
            left: 0;
        }

        .company-info span {
            font-weight: 600;
        }

        /* Modal Popup Style */
        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            z-index: 1000;
            justify-content: center;
            align-items: center;
        }
        
        .modal-content {
            background-color: var(--card-bg-color);
            width: 90%;
            max-width: 450px;
            border-radius: var(--border-radius);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
            padding: 0;
            overflow: hidden;
            animation: modalFadeIn 0.3s ease forwards;
        }
        
        @keyframes modalFadeIn {
            from { opacity: 0; transform: translateY(-30px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        .modal-header {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            color: white;
            padding: 15px 20px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        
        .modal-header h3 {
            margin: 0;
            font-size: 18px;
        }
        
        .close-button {
            background: none;
            border: none;
            color: white;
            font-size: 24px;
            cursor: pointer;
        }
        
        .modal-body {
            padding: 20px;
            color: var(--text-color);
        }
        
        .modal-body p {
            margin: 15px 0;
            line-height: 1.6;
        }
        
        .modal-body .contact-info {
            display: flex;
            align-items: center;
            margin: 15px 0;
            padding: 10px;
            background-color: rgba(0, 0, 0, 0.05);
            border-radius: var(--border-radius);
        }
        
        .modal-body .contact-info i {
            margin-right: 10px;
            color: var(--primary-color);
            font-size: 20px;
        }
        
        .modal-footer {
            padding: 15px 20px;
            text-align: right;
            border-top: 1px solid var(--border-color);
        }
        
        .modal-btn {
            padding: 10px 16px;
            background-color: var(--primary-color);
            color: white;
            border: none;
            border-radius: var(--border-radius);
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s;
        }
        
        .modal-btn:hover {
            background-color: var(--secondary-color);
        }

        /* Responsive adjustments */
        @media (max-width: 500px) {
            .login-container {
                margin: 0 15px;
            }
            
            .login-body, .login-header, .login-footer {
                padding: 25px 20px;
            }

            .login-logo h1 {
                font-size: 24px;
            }

            .form-control {
                padding: 12px 12px 12px 44px;
                font-size: 15px;
            }

            .form-icon {
                left: 15px;
                top: 12px;
            }

            .login-btn {
                padding: 12px;
                font-size: 16px;
            }
        }
    </style>
</head>
<body>
    <!-- Animated background elements -->
    <div class="background-animation">
        <% for(int i=0; i<15; i++) { 
            double size = Math.random() * 100 + 50;
            double top = Math.random() * 100;
            double left = Math.random() * 100;
            double opacity = Math.random() * 0.5 + 0.1;
            double delay = Math.random() * 15;
            double duration = Math.random() * 20 + 10;
        %>
            <div class="circle" style="
                width: <%= size %>px;
                height: <%= size %>px;
                top: <%= top %>%;
                left: <%= left %>%;
                opacity: <%= opacity %>;
                animation-delay: <%= delay %>s;
                animation-duration: <%= duration %>s;
            "></div>
        <% } %>
    </div>

    <div class="login-container">
        <div class="login-header">
            <!-- Theme switcher -->
            <div class="theme-switch">
                <label class="theme-switch-label">
                    <i class="fas fa-sun"></i>
                    <span class="theme-switch-toggle">
                        <input type="checkbox" id="theme-toggle">
                        <span class="theme-switch-slider"></span>
                    </span>
                    <i class="fas fa-moon"></i>
                </label>
            </div>

            <div class="login-logo">
                <div class="login-logo-icon">
                    <i class="fas fa-calendar-alt"></i>
                </div>
                <h1>LMS Portal</h1>
                <p>Enterprise Leave Management System</p>
            </div>
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
                    <i class="fas fa-user form-icon"></i>
                    <input type="text" id="username" name="username" class="form-control" placeholder="Tên đăng nhập" required>
                </div>
                
                <div class="form-group">
                    <i class="fas fa-lock form-icon"></i>
                    <input type="password" id="password" name="password" class="form-control" placeholder="Mật khẩu" required>
                </div>
                
                <button type="submit" class="login-btn">
                    <i class="fas fa-sign-in-alt"></i> Đăng nhập
                </button>
            </form>
        </div>
        
        <div class="login-footer">
            <p>&copy; 2025 Enterprise Leave Management System</p>
            <p><a href="#" id="forgotPassword">Quên mật khẩu?</a> | <a href="#">Trung tâm trợ giúp</a></p>
        </div>
    </div>

    <div class="company-info">
        Powered by <span>Enterprise Leave Management System</span> - Phiên bản 1.0.0
    </div>

    <!-- Forgot Password Modal -->
    <div id="forgotPasswordModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3><i class="fas fa-key"></i> Quên mật khẩu</h3>
                <button class="close-button" id="closeModal">&times;</button>
            </div>
            <div class="modal-body">
                <p>Vui lòng liên hệ Admin hoặc gửi email để được hỗ trợ đặt lại mật khẩu:</p>
                
                <div class="contact-info">
                    <i class="fas fa-envelope"></i>
                    <strong>Khangndhe186523@fpt.edu.vn</strong>
                </div>
                
                <p>Admin sẽ xử lý yêu cầu của bạn và cung cấp hướng dẫn đặt lại mật khẩu trong thời gian sớm nhất.</p>
            </div>
            <div class="modal-footer">
                <button class="modal-btn" id="closeModalBtn">Đóng</button>
            </div>
        </div>
    </div>

    <script>
        // Dark mode toggle
        document.getElementById('theme-toggle').addEventListener('change', function() {
            if (this.checked) {
                document.documentElement.setAttribute('data-theme', 'dark');
                setCookie('theme', 'dark', 365);
            } else {
                document.documentElement.setAttribute('data-theme', 'light');
                setCookie('theme', 'light', 365);
            }
        });

        // Check for saved theme preference
        window.addEventListener('DOMContentLoaded', function() {
            const savedTheme = getCookie('theme');
            if (savedTheme === 'dark') {
                document.documentElement.setAttribute('data-theme', 'dark');
                document.getElementById('theme-toggle').checked = true;
            }

            // Focus on username field
            document.getElementById('username').focus();
        });

        // Cookie utilities
        function setCookie(name, value, days) {
            let expires = "";
            if (days) {
                const date = new Date();
                date.setTime(date.getTime() + (days*24*60*60*1000));
                expires = "; expires=" + date.toUTCString();
            }
            document.cookie = name + "=" + (value || "")  + expires + "; path=/";
        }
        
        function getCookie(name) {
            const nameEQ = name + "=";
            const ca = document.cookie.split(';');
            for(let i=0; i < ca.length; i++) {
                let c = ca[i];
                while (c.charAt(0) === ' ') c = c.substring(1, c.length);
                if (c.indexOf(nameEQ) === 0) return c.substring(nameEQ.length, c.length);
            }
            return null;
        }

        // Auto hide error message after 5 seconds
        const errorMessage = document.querySelector('.error-message');
        if (errorMessage) {
            setTimeout(function() {
                errorMessage.style.opacity = '0';
                errorMessage.style.height = '0';
                errorMessage.style.padding = '0';
                errorMessage.style.margin = '0';
                errorMessage.style.overflow = 'hidden';
                errorMessage.style.transition = 'all 0.5s ease';
            }, 5000);
        }

        // Forgot Password Modal
        const modal = document.getElementById("forgotPasswordModal");
        const forgotPasswordLink = document.getElementById("forgotPassword");
        const closeModal = document.getElementById("closeModal");
        const closeModalBtn = document.getElementById("closeModalBtn");

        forgotPasswordLink.addEventListener("click", function(e) {
            e.preventDefault();
            modal.style.display = "flex";
        });

        function closeModalFunction() {
            modal.style.display = "none";
        }

        closeModal.addEventListener("click", closeModalFunction);
        closeModalBtn.addEventListener("click", closeModalFunction);

        // Close modal when clicking outside of it
        window.addEventListener("click", function(event) {
            if (event.target === modal) {
                closeModalFunction();
            }
        });
    </script>
</body>
</html>