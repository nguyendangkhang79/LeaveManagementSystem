<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>

<% 
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    String userInitials = user.getUsername().substring(0, 1).toUpperCase();
    if (user.getUsername().contains(" ") && user.getUsername().split(" ").length > 1) {
        userInitials += user.getUsername().split(" ")[1].substring(0, 1).toUpperCase();
    }
    
    boolean isAdmin = user.isAdmin();
    boolean isManager = user.isManager() || isAdmin;
    
    // Theme preference from cookie
    String theme = "light";
    Cookie[] cookies = request.getCookies();
    if (cookies != null) {
        for (Cookie cookie : cookies) {
            if ("theme".equals(cookie.getName())) {
                theme = cookie.getValue();
                break;
            }
        }
    }
%>

<!DOCTYPE html>
<html lang="vi" data-theme="<%= theme %>">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Enterprise Leave Management System</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    
    <!-- Directly embed essential CSS to ensure interface functionality -->
    <style>
        :root {
            --primary-color: #1565c0;
            --secondary-color: #0d47a1;
            --accent-color: #1e88e5;
            --background-color: #f5f7fa;
            --sidebar-bg: #2c3e50;
            --sidebar-hover: #34495e;
            --card-bg-color: #ffffff;
            --text-color: #333333;
            --text-secondary: #6c757d;
            --border-color: #e9ecef;
            --success-color: #28a745;
            --warning-color: #ffc107;
            --danger-color: #dc3545;
            --info-color: #17a2b8;
            
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
            --sidebar-bg: #1a1a1a;
            --sidebar-hover: #2d2d2d;
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
        }

        body {
            font-family: 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Open Sans', 'Helvetica Neue', sans-serif;
            background-color: var(--background-color);
            color: var(--text-color);
            line-height: 1.6;
            font-size: 16px;
        }

        /* Layout responsive */
        .app-container {
            display: flex;
            min-height: 100vh;
        }

        .sidebar {
            width: 280px;
            background: linear-gradient(180deg, var(--sidebar-bg) 0%, var(--sidebar-bg) 100%);
            color: #fff;
            position: fixed;
            height: 100vh;
            transition: all 0.3s;
            box-shadow: var(--box-shadow);
            overflow-y: auto;
            z-index: 1000;
        }

        .main-content {
            flex: 1;
            margin-left: 280px;
            padding: 20px;
            transition: margin-left 0.3s;
        }

        /* Sidebar header */
        .sidebar-header {
            padding: 20px;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }

        .logo {
            color: #fff;
            font-size: 24px;
            font-weight: bold;
            text-decoration: none;
            display: flex;
            align-items: center;
        }

        .logo i {
            margin-right: 12px;
            font-size: 24px;
        }

        /* Menu items */
        .sidebar-menu {
            list-style: none;
            padding: 0;
            margin: 20px 0;
        }

        .menu-category {
            font-size: 12px;
            color: rgba(255,255,255,0.6);
            text-transform: uppercase;
            padding: 16px 20px 8px;
            font-weight: 600;
            letter-spacing: 0.5px;
        }

        .menu-item {
            margin-bottom: 5px;
        }

        .menu-link {
            display: flex;
            align-items: center;
            padding: 12px 20px;
            color: rgba(255,255,255,0.8);
            text-decoration: none;
            transition: all 0.3s;
            border-left: 3px solid transparent;
        }

        .menu-link:hover, 
        .menu-link.active {
            background-color: var(--sidebar-hover);
            color: #ffffff;
            border-left-color: var(--primary-color);
        }

        .menu-icon {
            margin-right: 12px;
            width: 20px;
            text-align: center;
            font-size: 16px;
        }

        /* Cards */
        .card {
            background-color: var(--card-bg-color);
            border-radius: var(--border-radius);
            border: 1px solid var(--border-color);
            box-shadow: var(--box-shadow);
            margin-bottom: 24px;
            transition: transform 0.2s, box-shadow 0.2s;
        }

        .card-header {
            padding: 16px 20px;
            border-bottom: 1px solid var(--border-color);
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-top-left-radius: var(--border-radius);
            border-top-right-radius: var(--border-radius);
        }

        .card-body {
            padding: 20px;
        }

        /* Buttons */
        .btn {
            padding: 10px 16px;
            border-radius: var(--border-radius);
            font-weight: 500;
            border: none;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            transition: all 0.2s;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            text-decoration: none;
            color: white;
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        .btn i {
            margin-right: 8px;
        }

        .btn-primary {
            background-color: var(--primary-color);
            color: white;
        }

        .btn-success {
            background-color: var(--success-color);
            color: white;
        }

        .btn-danger {
            background-color: var(--danger-color);
            color: white;
        }

        .btn-secondary {
            background-color: var(--text-secondary);
            color: white;
        }

        .btn-sm {
            padding: 6px 10px;
            font-size: 14px;
        }

        /* Tables */
        .table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            margin-bottom: 24px;
        }

        .table th, 
        .table td {
            padding: 16px;
            text-align: left;
            border-bottom: 1px solid var(--border-color);
        }

        .table th {
            font-weight: 600;
            background-color: rgba(0, 0, 0, 0.02);
            color: var(--text-color);
        }

        .table tbody tr:hover {
            background-color: rgba(0, 0, 0, 0.03);
        }

        /* Header */
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 20px;
            background-color: var(--card-bg-color);
            border-radius: var(--border-radius);
            margin-bottom: 24px;
            box-shadow: var(--box-shadow);
        }

        .header-left {
            display: flex;
            align-items: center;
        }

        .header-right {
            display: flex;
            align-items: center;
        }

        .page-title {
            font-size: 24px;
            margin: 0 0 0 15px;
            font-weight: 600;
            color: var(--text-color);
        }

        .btn-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            background-color: transparent;
            border: none;
            color: var(--text-color);
            font-size: 18px;
            cursor: pointer;
            transition: background-color 0.2s;
        }

        .btn-icon:hover {
            background-color: rgba(0,0,0,0.05);
        }

        /* User profile */
        .user-profile {
            display: flex;
            align-items: center;
            cursor: pointer;
            position: relative;
            padding: 5px;
            border-radius: var(--border-radius);
            transition: background-color 0.2s;
        }

        .user-profile:hover {
            background-color: rgba(0,0,0,0.05);
        }

        .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background-color: var(--primary-color);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            margin-right: 12px;
        }

        .user-info {
            margin-right: 10px;
        }

        .user-name {
            font-weight: 600;
            display: flex;
            align-items: center;
        }

        .admin-badge {
            margin-left: 8px;
            background-color: var(--danger-color);
            color: white;
            font-size: 10px;
            padding: 2px 6px;
            border-radius: 10px;
        }

        .user-role {
            font-size: 12px;
            color: var(--text-secondary);
        }

        /* Dropdown menu */
        .dropdown-menu {
            position: absolute;
            top: 100%;
            right: 0;
            background-color: var(--card-bg-color);
            min-width: 200px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.15);
            border-radius: var(--border-radius);
            display: none;
            z-index: 1000;
            overflow: hidden;
        }

        .dropdown-menu.show {
            display: block;
        }

        .dropdown-item {
            display: flex;
            align-items: center;
            padding: 12px 15px;
            color: var(--text-color);
            text-decoration: none;
            transition: background-color 0.2s;
        }

        .dropdown-item:hover {
            background-color: rgba(0,0,0,0.05);
        }

        .dropdown-item i {
            margin-right: 10px;
            width: 20px;
            color: var(--text-secondary);
        }

        .dropdown-divider {
            height: 1px;
            background-color: var(--border-color);
            margin: 8px 0;
        }

        /* Theme switch */
        .theme-switch {
            display: flex;
            align-items: center;
            margin-top: auto;
            padding: 16px 24px;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
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
            width: 50px;
            height: 24px;
            margin: 0 10px;
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
            background-color: var(--accent-color);
        }

        input:checked + .theme-switch-slider:before {
            transform: translateX(26px);
        }

        /* Mobile responsive */
        @media (max-width: 992px) {
            .sidebar {
                width: 70px;
                transform: translateX(0);
            }
            
            .sidebar.expanded {
                width: 280px;
            }
            
            .sidebar:not(.expanded) .logo span,
            .sidebar:not(.expanded) .menu-category,
            .sidebar:not(.expanded) .menu-link span {
                display: none;
            }
            
            .sidebar:not(.expanded) .menu-link {
                justify-content: center;
                padding: 16px 0;
            }
            
            .sidebar:not(.expanded) .menu-icon {
                margin-right: 0;
                font-size: 22px;
            }
            
            .main-content {
                margin-left: 70px;
            }
            
            .main-content.sidebar-expanded {
                margin-left: 280px;
            }
        }

        @media (max-width: 768px) {
            .sidebar {
                transform: translateX(-100%);
                width: 280px;
                z-index: 1100;
            }
            
            .sidebar.show {
                transform: translateX(0);
            }
            
            .main-content {
                margin-left: 0;
            }
            
            .card-header {
                flex-direction: column;
                align-items: flex-start;
            }
            
            .card-header h2 {
                margin-bottom: 16px;
            }
        }
    </style>
</head>
<body>
    <div class="app-container">
        <!-- Sidebar -->
        <div class="sidebar" id="sidebar">
            <div class="sidebar-header">
                <a href="#" class="logo">
                    <i class="fas fa-calendar-alt"></i>
                    <span>LMS Portal</span>
                </a>
            </div>
            
            <ul class="sidebar-menu">
                <!-- Menu đơn nghỉ phép -->
                <div class="menu-category">Quản lý nghỉ phép</div>
                <li class="menu-item">
                    <a href="viewLeaves.jsp" class="menu-link <%= request.getRequestURI().contains("viewLeaves.jsp") ? "active" : "" %>">
                        <span class="menu-icon"><i class="fas fa-list"></i></span>
                        <span>Danh sách đơn</span>
                    </a>
                </li>
                
                <li class="menu-item">
                    <a href="createLeave.jsp" class="menu-link <%= request.getRequestURI().contains("createLeave.jsp") ? "active" : "" %>">
                        <span class="menu-icon"><i class="fas fa-plus-circle"></i></span>
                        <span>Tạo đơn mới</span>
                    </a>
                </li>
                
                <% if (isManager) { %>
                <li class="menu-item">
                    <a href="agenda.jsp" class="menu-link <%= request.getRequestURI().contains("agenda.jsp") ? "active" : "" %>">
                        <span class="menu-icon"><i class="fas fa-calendar"></i></span>
                        <span>Lịch nghỉ phép <%= isAdmin ? "Toàn bộ" : "Phòng ban" %></span>
                    </a>
                </li>
                <% } %>
                
                <!-- Menu báo cáo và thống kê -->
                <div class="menu-category">Báo cáo & Thống kê</div>
                <li class="menu-item">
                    <a href="#" class="menu-link">
                        <span class="menu-icon"><i class="fas fa-chart-pie"></i></span>
                        <span>Thống kê</span>
                    </a>
                </li>
                
                <% if (isAdmin) { %>
                <!-- Menu quản trị hệ thống (chỉ dành cho Super Admin) -->
                <div class="menu-category">Quản trị</div>
                <li class="menu-item">
                    <a href="admin-users.jsp" class="menu-link <%= request.getRequestURI().contains("admin-users.jsp") ? "active" : "" %>">
                        <span class="menu-icon"><i class="fas fa-users"></i></span>
                        <span>Quản lý người dùng</span>
                    </a>
                </li>
                
                <li class="menu-item">
                    <a href="admin-departments.jsp" class="menu-link <%= request.getRequestURI().contains("admin-departments.jsp") ? "active" : "" %>">
                        <span class="menu-icon"><i class="fas fa-building"></i></span>
                        <span>Quản lý phòng ban</span>
                    </a>
                </li>
                
                <li class="menu-item">
                    <a href="#" class="menu-link">
                        <span class="menu-icon"><i class="fas fa-sliders-h"></i></span>
                        <span>Cấu hình hệ thống</span>
                    </a>
                </li>
                <% } %>
                
                <!-- Cài đặt cá nhân -->
                <div class="menu-category">Cài đặt</div>
                <li class="menu-item">
                    <a href="#" class="menu-link">
                        <span class="menu-icon"><i class="fas fa-cog"></i></span>
                        <span>Tùy chỉnh</span>
                    </a>
                </li>
            </ul>
            
            <!-- Theme Switcher -->
            <div class="theme-switch">
                <label class="theme-switch-label">
                    <i class="fas fa-sun"></i>
                    <span class="theme-switch-toggle">
                        <input type="checkbox" id="theme-toggle" <%= "dark".equals(theme) ? "checked" : "" %>>
                        <span class="theme-switch-slider"></span>
                    </span>
                    <i class="fas fa-moon"></i>
                </label>
            </div>
        </div>
        
        <!-- Main Content -->
        <div class="main-content" id="main-content">
            <!-- Top Navigation Bar -->
            <header class="header">
                <div class="header-left">
                    <button id="sidebar-toggle" class="btn-icon">
                        <i class="fas fa-bars"></i>
                    </button>
                    <h2 class="page-title">
                        <%= request.getRequestURI().contains("viewLeaves.jsp") ? "Danh sách đơn nghỉ phép" : 
                           request.getRequestURI().contains("createLeave.jsp") ? "Tạo đơn nghỉ phép mới" :
                           request.getRequestURI().contains("admin-users.jsp") ? "Quản lý người dùng" :
                           request.getRequestURI().contains("admin-departments.jsp") ? "Quản lý phòng ban" :
                           request.getRequestURI().contains("agenda.jsp") ? "Lịch nghỉ phép" : "Dashboard" %>
                    </h2>
                </div>
                
                <div class="header-right">
                    <div class="user-profile" onclick="toggleDropdown()">
                        <div class="user-avatar"><%= userInitials %></div>
                        <div class="user-info">
                            <div class="user-name"><%= user.getUsername() %>
                                <% if (isAdmin) { %>
                                    <span class="admin-badge">ADMIN</span>
                                <% } %>
                            </div>
                            <div class="user-role"><%= user.getRole() %> - <%= user.getDepartment() %></div>
                        </div>
                        <i class="fas fa-chevron-down"></i>
                        
                        <div class="dropdown-menu" id="user-dropdown">
                            <a href="#" class="dropdown-item">
                                <i class="fas fa-user"></i> Thông tin cá nhân
                            </a>
                            <a href="#" class="dropdown-item">
                                <i class="fas fa-cog"></i> Cài đặt tài khoản
                            </a>
                            <div class="dropdown-divider"></div>
                            <a href="login.jsp" class="dropdown-item">
                                <i class="fas fa-sign-out-alt"></i> Đăng xuất
                            </a>
                        </div>
                    </div>
                </div>
            </header>
            
            <!-- Page content begins here -->
            <div class="content-container">