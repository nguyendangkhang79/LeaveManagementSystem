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
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Enterprise Leave Management System</title>
    <link rel="stylesheet" href="css/custom-style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        /* CSS Inline để đảm bảo trang luôn hoạt động */
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f0f2f5;
        }
        
        .app-container {
            display: flex;
        }
        
        .sidebar {
            width: 250px;
            background-color: #2c3e50;
            color: #fff;
            height: 100vh;
            position: fixed;
            left: 0;
            top: 0;
            z-index: 999;
            overflow-y: auto;
        }
        
        .main-content {
            margin-left: 250px;
            padding: 20px;
            width: calc(100% - 250px);
        }
        
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
            margin-right: 10px;
        }
        
        .sidebar-menu {
            list-style: none;
            padding: 0;
            margin: 20px 0;
        }
        
        .menu-item {
            margin-bottom: 5px;
        }
        
        .menu-link {
            display: flex;
            align-items: center;
            padding: 12px 20px;
            color: #ecf0f1;
            text-decoration: none;
            transition: all 0.3s;
        }
        
        .menu-link:hover, .menu-link.active {
            background-color: rgba(255,255,255,0.1);
        }
        
        .menu-icon {
            margin-right: 10px;
            width: 20px;
            text-align: center;
        }
        
        .header {
            background-color: #fff;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            padding: 15px 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .user-profile {
            display: flex;
            align-items: center;
            cursor: pointer;
            position: relative;
        }
        
        .user-avatar {
            width: 40px;
            height: 40px;
            background-color: #3498db;
            color: #fff;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            margin-right: 10px;
        }

        .admin-badge {
            background-color: #e74c3c;
            color: white;
            font-size: 10px;
            padding: 3px 6px;
            border-radius: 10px;
            margin-left: 5px;
        }
        
        .dropdown-menu {
            position: absolute;
            top: 100%;
            right: 0;
            background-color: #fff;
            min-width: 180px;
            box-shadow: 0 5px 10px rgba(0,0,0,0.1);
            border-radius: 5px;
            display: none;
            z-index: 1000;
        }
        
        .dropdown-menu.show {
            display: block;
        }
        
        .dropdown-item {
            display: block;
            padding: 10px 15px;
            color: #333;
            text-decoration: none;
        }
        
        .dropdown-item:hover {
            background-color: #f5f5f5;
        }
        
        .dropdown-divider {
            border-top: 1px solid #eee;
            margin: 5px 0;
        }
        
        .card {
            background-color: #fff;
            border-radius: 5px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        
        .card-header {
            padding: 15px 20px;
            border-bottom: 1px solid #eee;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .card-body {
            padding: 20px;
        }
        
        .btn {
            display: inline-block;
            padding: 8px 15px;
            background-color: #3498db;
            color: #fff;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
        }
        
        .btn-primary {
            background-color: #3498db;
        }
        
        .btn-success {
            background-color: #2ecc71;
        }
        
        .btn-danger {
            background-color: #e74c3c;
        }
        
        .btn-secondary {
            background-color: #95a5a6;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        
        .form-control {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
        }
        
        textarea.form-control {
            min-height: 100px;
        }
        
        .table {
            width: 100%;
            border-collapse: collapse;
        }
        
        .table th, .table td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        
        .table th {
            background-color: #f5f5f5;
            font-weight: bold;
        }
        
        .menu-category {
            font-size: 12px;
            color: #bdc3c7;
            text-transform: uppercase;
            padding: 20px 20px 5px 20px;
            font-weight: bold;
        }
        
        @media (max-width: 768px) {
            .sidebar {
                width: 0;
                overflow: hidden;
            }
            
            .main-content {
                margin-left: 0;
                width: 100%;
            }
            
            .sidebar.show {
                width: 250px;
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
        </div>
        
        <!-- Main Content -->
        <div class="main-content" id="main-content">
            <!-- Top Navigation Bar -->
            <header class="header">
                <button id="sidebar-toggle" class="btn btn-secondary">
                    <i class="fas fa-bars"></i>
                </button>
                
                <div class="user-profile" onclick="toggleDropdown()">
                    <div class="user-avatar"><%= userInitials %></div>
                    <div>
                        <div style="font-weight: bold;"><%= user.getUsername() %>
                            <% if (isAdmin) { %>
                                <span class="admin-badge">ADMIN</span>
                            <% } %>
                        </div>
                        <div style="font-size: 12px; color: #777;"><%= user.getRole() %> - <%= user.getDepartment() %></div>
                    </div>
                    <i class="fas fa-chevron-down" style="margin-left: 10px;"></i>
                    
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
            </header>
            
            <!-- Page content begins here -->
            <div class="content-container" style="padding: 20px;">