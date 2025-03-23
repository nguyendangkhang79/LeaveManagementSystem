<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>??ng nh?p - Enterprise Leave Management System</title>
    <link rel="shortcut icon" href="/api/placeholder/32/32" type="image/x-icon">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        :root {
            /* Light Mode Colors */
            --primary-color: #2563eb;
            --primary-hover: #1d4ed8;
            --secondary-color: #4f46e5;
            --accent-color: #3b82f6;
            --background-color: #f1f5f9;
            --card-bg-color: #ffffff;
            --text-color: #1e293b;
            --text-secondary: #64748b;
            --border-color: #e2e8f0;
            --success-color: #10b981;
            --warning-color: #f59e0b;
            --danger-color: #ef4444;
            --info-color: #06b6d4;
            
            /* Common Parameters */
            --border-radius: 12px;
            --input-radius: 10px;
            --button-radius: 10px;
            --transition-speed: 0.3s;
            --card-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
            --input-shadow: 0 2px 3px rgba(0, 0, 0, 0.05);
            --button-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
        }

        [data-theme="dark"] {
            --primary-color: #3b82f6;
            --primary-hover: #2563eb;
            --secondary-color: #6366f1;
            --accent-color: #60a5fa;
            --background-color: #0f172a;
            --card-bg-color: #1e293b;
            --text-color: #f1f5f9;
            --text-secondary: #cbd5e1;
            --border-color: #334155;
            --card-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.3), 0 10px 10px -5px rgba(0, 0, 0, 0.2);
            --input-shadow: 0 2px 3px rgba(0, 0, 0, 0.2);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Inter', 'Segoe UI', system-ui, -apple-system, sans-serif;
        }

        body {
            background-color: var(--background-color);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
            position: relative;
            transition: background-color var(--transition-speed) ease;
            background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1440 320"><path fill="%232563eb" fill-opacity="0.12" d="M0,128L48,138.7C96,149,192,171,288,186.7C384,203,480,213,576,192C672,171,768,117,864,117.3C960,117,1056,171,1152,176C1248,181,1344,139,1392,117.3L1440,96L1440,320L1392,320C1344,320,1248,320,1152,320C1056,320,960,320,864,320C768,320,672,320,576,320C480,320,384,320,288,320C192,320,96,320,48,320L0,320Z"></path></svg>');
            background-repeat: no-repeat;
            background-position: bottom;
            background-size: cover;
        }

        [data-theme="dark"] body {
            background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1440 320"><path fill="%233b82f6" fill-opacity="0.16" d="M0,128L48,138.7C96,149,192,171,288,186.7C384,203,480,213,576,192C672,171,768,117,864,117.3C960,117,1056,171,1152,176C1248,181,1344,139,1392,117.3L1440,96L1440,320L1392,320C1344,320,1248,320,1152,320C1056,320,960,320,864,320C768,320,672,320,576,320C480,320,384,320,288,320C192,320,96,320,48,320L0,320Z"></path></svg>');
        }

        .particles-container {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            overflow: hidden;
            z-index: -1;
        }

        .particle {
            position: absolute;
            border-radius: 50%;
            background: var(--primary-color);
            opacity: 0.3;
        }

        .login-container {
            width: 100%;
            max-width: 450px;
            background-color: var(--card-bg-color);
            border-radius: var(--border-radius);
            overflow: hidden;
            box-shadow: var(--card-shadow);
            position: relative;
            transition: all var(--transition-speed) ease;
            transform: translateY(0);
            border: 1px solid rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
        }

        .theme-switch {
            position: absolute;
            top: 20px;
            right: 20px;
            z-index: 10;
        }

        .switch {
            position: relative;
            display: inline-block;
            width: 60px;
            height: 30px;
        }

        .switch input {
            opacity: 0;
            width: 0;
            height: 0;
        }

        .switch-slider {
            position: absolute;
            cursor: pointer;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: rgba(255, 255, 255, 0.3);
            transition: 0.4s;
            border-radius: 30px;
            backdrop-filter: blur(4px);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .switch-slider:before {
            position: absolute;
            content: "";
            height: 22px;
            width: 22px;
            left: 4px;
            bottom: 4px;
            background-color: white;
            transition: 0.4s;
            border-radius: 50%;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
        }

        .switch-slider .icons {
            display: flex;
            justify-content: space-between;
            padding: 5px 10px;
            color: white;
        }

        input:checked + .switch-slider {
            background-color: rgba(0, 0, 0, 0.6);
        }

        input:checked + .switch-slider:before {
            transform: translateX(30px);
        }

        .login-header {
            padding: 40px 30px 20px;
            text-align: center;
            position: relative;
        }

        .login-logo {
            margin-bottom: 20px;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
        }

        .login-logo-icon {
            width: 80px;
            height: 80px;
            background-color: var(--primary-color);
            border-radius: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 16px;
            box-shadow: var(--button-shadow);
            position: relative;
            overflow: hidden;
        }

        .login-logo-icon i {
            font-size: 35px;
            color: white;
            z-index: 1;
        }

        .login-logo-icon:before {
            content: '';
            position: absolute;
            width: 140%;
            height: 140%;
            background: linear-gradient(45deg, var(--primary-color), var(--secondary-color));
            animation: spin 4s linear infinite;
        }

        @keyframes spin {
            from {
                transform: rotate(0deg);
            }
            to {
                transform: rotate(360deg);
            }
        }

        .login-logo h1 {
            font-size: 28px;
            color: var(--text-color);
            font-weight: 700;
            margin: 0;
            transition: color var(--transition-speed) ease;
        }

        .login-logo p {
            color: var(--text-secondary);
            margin-top: 5px;
            font-size: 14px;
            transition: color var(--transition-speed) ease;
        }

        .login-body {
            padding: 20px 30px 30px;
        }

        .form-group {
            margin-bottom: 20px;
            position: relative;
        }

        .form-control {
            width: 100%;
            padding: 15px 15px 15px 50px;
            border: 1px solid var(--border-color);
            border-radius: var(--input-radius);
            font-size: 15px;
            background-color: var(--card-bg-color);
            color: var(--text-color);
            transition: all 0.3s;
            box-shadow: var(--input-shadow);
        }

        .form-control:focus {
            border-color: var(--primary-color);
            outline: none;
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.25);
        }

        .form-icon {
            position: absolute;
            left: 20px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-secondary);
            font-size: 18px;
            transition: color var(--transition-speed) ease;
        }

        .form-control:focus + .form-icon {
            color: var(--primary-color);
        }

        .login-btn {
            display: block;
            width: 100%;
            padding: 15px;
            margin-top: 30px;
            background: linear-gradient(to right, var(--primary-color), var(--secondary-color));
            color: white;
            border: none;
            border-radius: var(--button-radius);
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            box-shadow: var(--button-shadow);
            position: relative;
            overflow: hidden;
            z-index: 1;
        }

        .login-btn:before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
            transition: 0.5s;
            z-index: -1;
        }

        .login-btn:hover:before {
            left: 100%;
        }

        .login-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 15px rgba(37, 99, 235, 0.3);
        }

        .login-btn:active {
            transform: translateY(0);
        }

        .login-btn i {
            margin-right: 10px;
        }

        .login-footer {
            padding: 20px 30px;
            text-align: center;
            background-color: rgba(0,0,0,0.02);
            border-top: 1px solid var(--border-color);
            transition: background-color var(--transition-speed) ease, 
                       border-top var(--transition-speed) ease;
        }

        .login-footer p {
            margin: 6px 0;
            color: var(--text-secondary);
            font-size: 14px;
            transition: color var(--transition-speed) ease;
        }

        .login-links {
            margin-top: 10px;
        }

        .login-links a {
            color: var(--primary-color);
            text-decoration: none;
            margin: 0 10px;
            font-size: 14px;
            font-weight: 500;
            transition: color 0.2s;
            position: relative;
        }

        .login-links a:after {
            content: '';
            position: absolute;
            width: 0;
            height: 2px;
            bottom: -2px;
            left: 0;
            background-color: var(--primary-color);
            transition: width 0.3s;
        }

        .login-links a:hover:after {
            width: 100%;
        }

        .error-message {
            background-color: var(--danger-color);
            color: white;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            animation: slideIn 0.3s ease forwards;
            box-shadow: 0 4px 6px rgba(239, 68, 68, 0.2);
        }

        @keyframes slideIn {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .error-message i {
            margin-right: 10px;
            font-size: 20px;
        }

        .company-info {
            position: absolute;
            bottom: 20px;
            text-align: center;
            color: var(--text-secondary);
            font-size: 14px;
            width: 100%;
            left: 0;
            transition: color var(--transition-speed) ease;
        }

        .company-info span {
            font-weight: 600;
            background: linear-gradient(90deg, var(--primary-color), var(--secondary-color));
            -webkit-background-clip: text;
            background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        /* Modal Styles */
        .modal-backdrop {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            backdrop-filter: blur(5px);
            display: flex;
            justify-content: center;
            align-items: center;
            z-index: 1000;
            opacity: 0;
            visibility: hidden;
            transition: opacity 0.3s, visibility 0.3s;
        }

        .modal-backdrop.show {
            opacity: 1;
            visibility: visible;
        }

        .modal-container {
            width: 90%;
            max-width: 450px;
            background: var(--card-bg-color);
            border-radius: var(--border-radius);
            overflow: hidden;
            box-shadow: var(--card-shadow);
            transform: scale(0.9);
            opacity: 0;
            transition: transform 0.3s, opacity 0.3s;
        }

        .modal-backdrop.show .modal-container {
            transform: scale(1);
            opacity: 1;
        }

        .modal-header {
            padding: 20px 25px;
            background: linear-gradient(to right, var(--primary-color), var(--secondary-color));
            color: white;
            display: flex;
            justify-content: space-between;
            align-items: center;
            position: relative;
        }

        .modal-header::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 25px;
            width: 50px;
            height: 3px;
            background: white;
            border-radius: 3px;
        }

        .modal-title {
            display: flex;
            align-items: center;
            font-size: 18px;
            font-weight: 600;
        }

        .modal-title i {
            margin-right: 10px;
            font-size: 22px;
        }

        .modal-close {
            background: none;
            border: none;
            color: white;
            font-size: 22px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            width: 30px;
            height: 30px;
            border-radius: 50%;
            transition: background-color 0.2s;
        }

        .modal-close:hover {
            background-color: rgba(255, 255, 255, 0.2);
        }

        .modal-body {
            padding: 25px;
            color: var(--text-color);
        }

        .modal-message {
            margin-bottom: 20px;
            line-height: 1.6;
        }

        .contact-card {
            padding: 15px;
            background-color: rgba(59, 130, 246, 0.1);
            border-radius: 10px;
            margin: 15px 0;
            display: flex;
            align-items: center;
            border-left: 4px solid var(--primary-color);
            transition: all 0.3s;
        }

        .contact-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }

        .contact-icon {
            width: 42px;
            height: 42px;
            background: var(--primary-color);
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 15px;
            color: white;
            font-size: 18px;
        }

        .contact-info {
            flex: 1;
        }

        .contact-label {
            font-size: 12px;
            color: var(--text-secondary);
            margin-bottom: 2px;
        }

        .contact-value {
            font-weight: 600;
            color: var(--text-color);
        }

        .modal-footer {
            padding: 20px 25px;
            text-align: right;
            border-top: 1px solid var(--border-color);
        }

        .btn {
            padding: 12px 24px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 14px;
            cursor: pointer;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }

        .btn-primary {
            background: linear-gradient(to right, var(--primary-color), var(--secondary-color));
            color: white;
            border: none;
            box-shadow: 0 4px 6px rgba(59, 130, 246, 0.25);
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 12px rgba(59, 130, 246, 0.3);
        }

        .btn-primary:active {
            transform: translateY(0);
        }

        .btn i {
            margin-right: 8px;
        }

        /* Wave animation at the bottom */
        .wave-container {
            position: fixed;
            bottom: 0;
            left: 0;
            width: 100%;
            z-index: -1;
            overflow: hidden;
            height: 120px;
        }

        .wave {
            position: absolute;
            bottom: 0;
            left: 0;
            width: 100%;
            height: 100px;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1440 320"><path fill="%232563eb" fill-opacity="0.2" d="M0,160L60,170.7C120,181,240,203,360,192C480,181,600,139,720,138.7C840,139,960,181,1080,197.3C1200,213,1320,203,1380,197.3L1440,192L1440,320L1380,320C1320,320,1200,320,1080,320C960,320,840,320,720,320C600,320,480,320,360,320C240,320,120,320,60,320L0,320Z"></path></svg>');
            background-size: 1440px 100px;
            animation: wave-animate 20s linear infinite;
        }

        .wave:nth-child(2) {
            bottom: 0;
            height: 80px;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1440 320"><path fill="%232563eb" fill-opacity="0.25" d="M0,192L60,181.3C120,171,240,149,360,165.3C480,181,600,235,720,240C840,245,960,203,1080,192C1200,181,1320,203,1380,213.3L1440,224L1440,320L1380,320C1320,320,1200,320,1080,320C960,320,840,320,720,320C600,320,480,320,360,320C240,320,120,320,60,320L0,320Z"></path></svg>');
            background-size: 1440px 80px;
            animation: wave-animate 15s linear infinite;
        }

        [data-theme="dark"] .wave {
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1440 320"><path fill="%233b82f6" fill-opacity="0.2" d="M0,160L60,170.7C120,181,240,203,360,192C480,181,600,139,720,138.7C840,139,960,181,1080,197.3C1200,213,1320,203,1380,197.3L1440,192L1440,320L1380,320C1320,320,1200,320,1080,320C960,320,840,320,720,320C600,320,480,320,360,320C240,320,120,320,60,320L0,320Z"></path></svg>');
        }

        [data-theme="dark"] .wave:nth-child(2) {
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1440 320"><path fill="%233b82f6" fill-opacity="0.25" d="M0,192L60,181.3C120,171,240,149,360,165.3C480,181,600,235,720,240C840,245,960,203,1080,192C1200,181,1320,203,1380,213.3L1440,224L1440,320L1380,320C1320,320,1200,320,1080,320C960,320,840,320,720,320C600,320,480,320,360,320C240,320,120,320,60,320L0,320Z"></path></svg>');
        }

        @keyframes wave-animate {
            0% {
                background-position: 0;
            }
            100% {
                background-position: 1440px;
            }
        }

        /* Loading animation for button */
        .login-btn.loading {
            position: relative;
            color: transparent;
        }

        .login-btn.loading::after {
            content: "";
            position: absolute;
            width: 20px;
            height: 20px;
            top: 50%;
            left: 50%;
            margin: -10px 0 0 -10px;
            border: 3px solid rgba(255, 255, 255, 0.3);
            border-radius: 50%;
            border-top-color: white;
            animation: spin 1s ease-in-out infinite;
        }

        /* Responsive adjustments */
        @media (max-width: 500px) {
            .login-container {
                margin: 0 15px;
            }
            
            .login-body, .login-header, .login-footer {
                padding: 20px;
            }

            .login-logo-icon {
                width: 70px;
                height: 70px;
            }

            .login-logo h1 {
                font-size: 24px;
            }

            .form-control {
                padding: 14px 14px 14px 45px;
            }

            .company-info {
                font-size: 12px;
            }
        }
    </style>
</head>

<body>
    <!-- Animated particles background -->
    <div class="particles-container" id="particles-js"></div>

    <!-- Wave animation at the bottom -->
    <div class="wave-container">
        <div class="wave"></div>
        <div class="wave"></div>
    </div>

    <!-- Theme switcher -->
    <div class="theme-switch">
        <label class="switch">
            <input type="checkbox" id="theme-toggle">
            <span class="switch-slider">
                <div class="icons">
                    <i class="fas fa-sun"></i>
                    <i class="fas fa-moon"></i>
                </div>
            </span>
        </label>
    </div>

    <div class="login-container">
        <div class="login-header">
            <div class="login-logo">
                <div class="login-logo-icon">
                    <i class="fas fa-calendar-alt"></i>
                </div>
                <h1>LMS Portal</h1>
                <p>Enterprise Leave Management System</p>
            </div>
        </div>
        
        <div class="login-body">
            <div id="error-container">
                <!-- Error messages will be injected here -->
            </div>
            
            <form id="login-form">
                <div class="form-group">
                    <input type="text" id="username" name="username" class="form-control" placeholder="Tên ??ng nh?p" required>
                    <i class="fas fa-user form-icon"></i>
                </div>
                
                <div class="form-group">
                    <input type="password" id="password" name="password" class="form-control" placeholder="M?t kh?u" required>
                    <i class="fas fa-lock form-icon"></i>
                </div>
                
                <button type="submit" id="login-button" class="login-btn">
                    <i class="fas fa-sign-in-alt"></i> ??ng nh?p
                </button>
            </form>
        </div>
        
        <div class="login-footer">
            <p>&copy; 2025 Enterprise Leave Management System</p>
            <div class="login-links">
                <a href="#" id="forgot-password-link">Quên m?t kh?u?</a>
                <a href="#">Trung tâm tr? giúp</a>
            </div>
        </div>
    </div>

    <div class="company-info">
        Powered by <span>Enterprise Leave Management System</span> - Phiên b?n 1.0.0
    </div>

    <!-- Forgot Password Modal -->
    <div id="forgot-password-modal" class="modal-backdrop">
        <div class="modal-container">
            <div class="modal-header">
                <div class="modal-title">
                    <i class="fas fa-key"></i> Quên m?t kh?u
                </div>
                <button class="modal-close" id="modal-close">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            <div class="modal-body">
                <div class="modal-message">
                    <p>Vui lòng liên h? Admin ho?c g?i email ?? ???c h? tr? ??t l?i m?t kh?u:</p>
                </div>
                
                <div class="contact-card">
                    <div class="contact-icon">
                        <i class="fas fa-envelope"></i>
                    </div>
                    <div class="contact-info">
                        <div class="contact-label">Email h? tr?:</div>
                        <div class="contact-value">Khangndhe186523@fpt.edu.vn</div>
                    </div>
                </div>
                
                <div class="contact-card">
                    <div class="contact-icon">
                        <i class="fas fa-phone-alt"></i>
                    </div>
                    <div class="contact-info">
                        <div class="contact-label">Hotline h? tr?:</div>
                        <div class="contact-value">(+84) 123-456-789</div>
                    </div>
                </div>
                
                <p>Admin s? x? lý yêu c?u c?a b?n và cung c?p h??ng d?n ??t l?i m?t kh?u trong th?i gian s?m nh?t.</p>
            </div>
            <div class="modal-footer">
                <button class="btn btn-primary" id="modal-close-btn">
                    <i class="fas fa-check"></i> ?óng
                </button>
            </div>
        </div>
    </div>

    <script>
        // Create animated particles
        document.addEventListener('DOMContentLoaded', function() {
            const particlesContainer = document.getElementById('particles-js');
            
            // Create particles
            for (let i = 0; i < 50; i++) {
                const size = Math.random() * 6 + 2;
                const particle = document.createElement('div');
                particle.classList.add('particle');
                particle.style.width = size + 'px';
                particle.style.height = size + 'px';
                particle.style.left = Math.random() * 100 + '%';
                particle.style.top = Math.random() * 100 + '%';
                particle.style.opacity = Math.random() * 0.5 + 0.1;
                
                // Add animation
                const duration = Math.random() * 20 + 10;
                const delay = Math.random() * 5;
                particle.style.animation = `floatParticle ${duration}s ease-in-out ${delay}s infinite alternate`;
                
                particlesContainer.appendChild(particle);
            }
        });

        // Add floating animation
        const style = document.createElement('style');
        style.textContent = `
            @keyframes floatParticle {
                0% { transform: translate(0, 0); }
                25% { transform: translate(${Math.random() * 30}px, ${Math.random() * 30}px); }
                50% { transform: translate(${Math.random() * -30}px, ${Math.random() * 30}px); }
                75% { transform: translate(${Math.random() * -30}px, ${Math.random() * -30}px); }
                100% { transform: translate(${Math.random() * 30}px, ${Math.random() * -30}px); }
            }
        `;
        document.head.appendChild(style);

        // Dark mode toggle
        const themeToggle = document.getElementById('theme-toggle');
        
        // Check for saved theme preference
        if (localStorage.getItem('theme') === 'dark') {
            document.documentElement.setAttribute('data-theme', 'dark');
            themeToggle.checked = true;
        }
        
        // Toggle theme
        themeToggle.addEventListener('change', function() {
            if (this.checked) {
                document.documentElement.setAttribute('data-theme', 'dark');
                localStorage.setItem('theme', 'dark');
            } else {
                document.documentElement.removeAttribute('data-theme');
                localStorage.setItem('theme', 'light');
            }
        });

        // Modal functionality
        const modal = document.getElementById('forgot-password-modal');
        const forgotPasswordLink = document.getElementById('forgot-password-link');
        const closeButtons = document.querySelectorAll('#modal-close, #modal-close-btn');
        
        // Open modal
        forgotPasswordLink.addEventListener('click', function(e) {
            e.preventDefault();
            modal.classList.add('show');
            document.body.style.overflow = 'hidden'; // Prevent background scrolling
        });
        
        // Close modal with buttons
        closeButtons.forEach(button => {
            button.addEventListener('click', function() {
                modal.classList.remove('show');
                document.body.style.overflow = '';
            });
        });
        
        // Close modal when clicking outside
        modal.addEventListener('click', function(event) {
            if (event.target === modal) {
                modal.classList.remove('show');
                document.body.style.overflow = '';
            }
        });

        // Form handling with animation
        const loginForm = document.getElementById('login-form');
        const loginButton = document.getElementById('login-button');
        const errorContainer = document.getElementById('error-container');
        
        loginForm.addEventListener('submit', function(e) {
            e.preventDefault();
            
            // Show loading animation
            loginButton.classList.add('loading');
            
            // Get form data
            const username = document.getElementById('username').value;
            const password = document.getElementById('password').value;
            
            // Simulate API call/validation (replace with actual login logic)
            setTimeout(function() {
                loginButton.classList.remove('loading');
                
                // For demo: show error for invalid credentials
                // In production, replace with actual authentication
                if (username === 'admin' && password === 'password') {
                    // Success - redirect to dashboard
                    window.location.href = 'dashboard.html';
                } else {
                    // Show error message
                    showError('Tên ??ng nh?p ho?c m?t kh?u không chính xác!');
                    
                    // Add shake animation to form
                    loginForm.classList.add('shake');
                    setTimeout(() => {
                        loginForm.classList.remove('shake');
                    }, 500);
                }
            }, 1500); // Simulate network delay
        });
        
        // Function to show error messages
        function showError(message) {
            errorContainer.innerHTML = `
                <div class="error-message">
                    <i class="fas fa-exclamation-circle"></i>
                    <span>${message}</span>
                </div>
            `;
            
            // Auto hide error after 5 seconds
            setTimeout(function() {
                const errorMessage = document.querySelector('.error-message');
                if (errorMessage) {
                    errorMessage.style.opacity = '0';
                    errorMessage.style.transform = 'translateY(-10px)';
                    setTimeout(() => {
                        errorContainer.innerHTML = '';
                    }, 300);
                }
            }, 5000);
        }

        // Add shake animation style
        const shakeStyle = document.createElement('style');
        shakeStyle.textContent = `
            @keyframes formShake {
                0%, 100% { transform: translateX(0); }
                10%, 30%, 50%, 70%, 90% { transform: translateX(-5px); }
                20%, 40%, 60%, 80% { transform: translateX(5px); }
            }
            
            .shake {
                animation: formShake 0.5s ease-in-out;
            }
        `;
        document.head.appendChild(shakeStyle);

        // Input field animations and validation
        const inputFields = document.querySelectorAll('.form-control');
        
        inputFields.forEach(input => {
            // Add focus effects
            input.addEventListener('focus', function() {
                this.parentElement.classList.add('focused');
            });
            
            input.addEventListener('blur', function() {
                this.parentElement.classList.remove('focused');
                
                // Basic validation
                if (this.value.trim() === '') {
                    this.classList.add('invalid');
                } else {
                    this.classList.remove('invalid');
                }
            });
        });

        // Add focus/invalid styles
        const inputStyles = document.createElement('style');
        inputStyles.textContent = `
            .form-group.focused .form-icon {
                color: var(--primary-color);
            }
            
            .form-control.invalid {
                border-color: var(--danger-color);
                box-shadow: 0 0 0 3px rgba(239, 68, 68, 0.25);
            }
            
            .form-control.invalid + .form-icon {
                color: var(--danger-color);
            }
        `;
        document.head.appendChild(inputStyles);
    </script>
</body>
</html>