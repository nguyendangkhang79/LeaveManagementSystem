<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.UserDAO, model.User, java.util.List, java.util.ArrayList, java.util.Map, java.util.HashMap" %>

<%-- Include Header --%>
<%@ include file="header.jsp" %>

<%
    // Security check: Only Super Admin can access this page
    if (user == null || !user.isAdmin()) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Get all users
    UserDAO userDAO = new UserDAO();
    List<User> allUsers = userDAO.getAllUsers();
    
    // Get all departments for filtering
    List<String> allDepartments = userDAO.getAllDepartments();
    
    // Get all managers for assigning new users
    List<User> allManagers = new ArrayList<User>();
    for (User u : allUsers) {
        if (u.isManager() || u.isAdmin()) {
            allManagers.add(u);
        }
    }
    
    // Get filter parameters
    String roleFilter = request.getParameter("role");
    String deptFilter = request.getParameter("department");
    
    // Apply filters if provided
    List<User> filteredUsers = new ArrayList<User>();
    for (User u : allUsers) {
        boolean roleMatch = roleFilter == null || roleFilter.isEmpty() || roleFilter.equals("all") || u.getRole().equals(roleFilter);
        boolean deptMatch = deptFilter == null || deptFilter.isEmpty() || deptFilter.equals("all") || u.getDepartment().equals(deptFilter);
        
        if (roleMatch && deptMatch) {
            filteredUsers.add(u);
        }
    }
    
    // Get action message if any
    String actionMessage = request.getParameter("message");
    String actionType = request.getParameter("type");
%>

<style>
    /* Enhanced styles for User Management */
    .card {
        border: none;
        border-radius: 0.75rem;
        box-shadow: 0 0.5rem 1.5rem rgba(0, 0, 0, 0.08);
        margin-bottom: 2rem;
        background-color: var(--card-bg-color);
        overflow: hidden;
    }
    
    .card-header {
        padding: 1.25rem 1.5rem;
        background-color: var(--card-bg-color);
        border-bottom: 1px solid var(--border-color);
        display: flex;
        justify-content: space-between;
        align-items: center;
    }
    
    .card-header h2 {
        margin: 0;
        font-size: 1.25rem;
        font-weight: 600;
        color: var(--text-color);
        display: flex;
        align-items: center;
    }
    
    .card-header h2 i {
        margin-right: 0.75rem;
        color: var(--primary-color);
    }
    
    .card-body {
        padding: 1.5rem;
    }
    
    /* Form Controls */
    .form-control {
        display: block;
        width: 100%;
        padding: 0.75rem 1rem;
        font-size: 1rem;
        line-height: 1.5;
        color: var(--text-color);
        background-color: var(--card-bg-color);
        background-clip: padding-box;
        border: 1px solid var(--border-color);
        border-radius: 0.5rem;
        transition: border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
    }
    
    .form-control:focus {
        border-color: var(--primary-color);
        outline: 0;
        box-shadow: 0 0 0 0.2rem rgba(21, 101, 192, 0.25);
    }
    
    .form-group {
        margin-bottom: 1.5rem;
    }
    
    .form-label {
        display: block;
        margin-bottom: 0.5rem;
        font-weight: 500;
        color: var(--text-color);
    }
    
    /* Button Styles */
    .btn {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        padding: 0.75rem 1.25rem;
        font-size: 0.95rem;
        font-weight: 500;
        text-align: center;
        white-space: nowrap;
        vertical-align: middle;
        cursor: pointer;
        border: 1px solid transparent;
        border-radius: 0.5rem;
        transition: all 0.3s;
        text-decoration: none;
    }
    
    .btn i {
        margin-right: 0.5rem;
    }
    
    .btn-primary {
        color: #fff;
        background-color: var(--primary-color);
        border-color: var(--primary-color);
    }
    
    .btn-primary:hover {
        background-color: var(--secondary-color);
        border-color: var(--secondary-color);
        transform: translateY(-2px);
        box-shadow: 0 0.25rem 0.5rem rgba(0, 0, 0, 0.15);
    }
    
    .btn-secondary {
        color: var(--text-color);
        background-color: #f0f0f0;
        border-color: #f0f0f0;
    }
    
    .btn-secondary:hover {
        background-color: #e0e0e0;
        border-color: #e0e0e0;
        transform: translateY(-2px);
        box-shadow: 0 0.25rem 0.5rem rgba(0, 0, 0, 0.15);
    }
    
    .btn-danger {
        color: #fff;
        background-color: #e74c3c;
        border-color: #e74c3c;
    }
    
    .btn-danger:hover {
        background-color: #c0392b;
        border-color: #c0392b;
        transform: translateY(-2px);
        box-shadow: 0 0.25rem 0.5rem rgba(0, 0, 0, 0.15);
    }
    
    .btn-info {
        color: #fff;
        background-color: #3498db;
        border-color: #3498db;
    }
    
    .btn-info:hover {
        background-color: #2980b9;
        border-color: #2980b9;
        transform: translateY(-2px);
        box-shadow: 0 0.25rem 0.5rem rgba(0, 0, 0, 0.15);
    }
    
    .btn-sm {
        padding: 0.5rem 0.75rem;
        font-size: 0.875rem;
        border-radius: 0.375rem;
    }
    
    /* Table styles */
    .table-container {
        overflow-x: auto;
        border-radius: 0.5rem;
        background-color: var(--card-bg-color);
    }
    
    .table {
        width: 100%;
        border-collapse: separate;
        border-spacing: 0;
        margin-bottom: 0;
    }
    
    .table th {
        background-color: rgba(0, 0, 0, 0.02);
        color: var(--text-color);
        font-weight: 600;
        text-align: left;
        padding: 1rem;
        border-bottom: 1px solid var(--border-color);
        position: sticky;
        top: 0;
        z-index: 10;
    }
    
    .table td {
        padding: 1rem;
        border-bottom: 1px solid var(--border-color);
        color: var(--text-color);
        vertical-align: middle;
    }
    
    .table tr:last-child td {
        border-bottom: none;
    }
    
    .table tbody tr {
        transition: background-color 0.3s;
    }
    
    .table tbody tr:hover {
        background-color: rgba(0, 0, 0, 0.02);
    }
    
    /* Badges */
    .badge {
        display: inline-block;
        padding: 0.4rem 0.8rem;
        font-size: 0.75rem;
        font-weight: 600;
        line-height: 1;
        text-align: center;
        white-space: nowrap;
        vertical-align: baseline;
        border-radius: 50rem;
    }
    
    .badge-danger {
        background-color: #e74c3c;
        color: #fff;
    }
    
    .badge-primary {
        background-color: var(--primary-color);
        color: #fff;
    }
    
    .badge-secondary {
        background-color: #6c757d;
        color: #fff;
    }
    
    /* Modals */
    .modal {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(0, 0, 0, 0.5);
        z-index: 1050;
        display: none;
        align-items: center;
        justify-content: center;
        overflow: auto;
    }
    
    .modal.show {
        display: flex;
    }
    
    .modal-dialog {
        position: relative;
        width: 100%;
        max-width: 800px;
        margin: 1.75rem auto;
        pointer-events: none;
    }
    
    .modal-content {
        position: relative;
        display: flex;
        flex-direction: column;
        width: 100%;
        pointer-events: auto;
        background-color: var(--card-bg-color);
        background-clip: padding-box;
        border-radius: 0.75rem;
        box-shadow: 0 0.5rem 1.5rem rgba(0, 0, 0, 0.15);
        outline: 0;
    }
    
    .modal-header {
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 1.25rem 1.5rem;
        border-bottom: 1px solid var(--border-color);
        border-top-left-radius: 0.75rem;
        border-top-right-radius: 0.75rem;
    }
    
    .modal-title {
        margin: 0;
        font-size: 1.25rem;
        font-weight: 600;
        color: var(--text-color);
    }
    
    .modal-close {
        background: transparent;
        border: 0;
        font-size: 1.5rem;
        font-weight: 700;
        color: var(--text-secondary);
        cursor: pointer;
        padding: 0;
        margin: 0;
    }
    
    .modal-body {
        position: relative;
        flex: 1 1 auto;
        padding: 1.5rem;
    }
    
    .modal-footer {
        display: flex;
        align-items: center;
        justify-content: flex-end;
        padding: 1.25rem 1.5rem;
        border-top: 1px solid var(--border-color);
        border-bottom-right-radius: 0.75rem;
        border-bottom-left-radius: 0.75rem;
    }
    
    .modal-footer > * {
        margin: 0 0.25rem;
    }
    
    /* Row & Columns */
    .row {
        display: flex;
        flex-wrap: wrap;
        margin-right: -0.75rem;
        margin-left: -0.75rem;
    }
    
    .col-md-4, .col-md-6 {
        position: relative;
        width: 100%;
        padding-right: 0.75rem;
        padding-left: 0.75rem;
    }
    
    @media (min-width: 768px) {
        .col-md-4 {
            flex: 0 0 33.333333%;
            max-width: 33.333333%;
        }
        
        .col-md-6 {
            flex: 0 0 50%;
            max-width: 50%;
        }
    }
    
    /* Alerts */
    .alert {
        position: relative;
        padding: 1rem 1.25rem;
        margin-bottom: 1.5rem;
        border: 1px solid transparent;
        border-radius: 0.5rem;
    }
    
    .alert-success {
        color: #155724;
        background-color: #d4edda;
        border-color: #c3e6cb;
    }
    
    .alert-danger {
        color: #721c24;
        background-color: #f8d7da;
        border-color: #f5c6cb;
    }
    
    .alert-dismissible {
        padding-right: 4rem;
    }
    
    .alert-dismissible .close {
        position: absolute;
        top: 0;
        right: 0;
        padding: 1rem 1.25rem;
        color: inherit;
        background: transparent;
        border: 0;
        cursor: pointer;
    }
    
    /* Responsive adjustments */
    @media (max-width: 991px) {
        .row {
            flex-direction: column;
        }
    }
    
    @media (max-width: 768px) {
        .card-header {
            flex-direction: column;
            align-items: stretch;
        }
        
        .card-header h2 {
            margin-bottom: 1rem;
        }
        
        .modal-dialog {
            margin: 0.5rem;
        }
    }
</style>

<!-- Page Header -->
<div class="card">
    <div class="card-header">
        <h2><i class="fas fa-users"></i> Quản lý người dùng</h2>
        
        <button class="btn btn-primary" onclick="showModal('addUserModal')">
            <i class="fas fa-user-plus"></i> Thêm người dùng mới
        </button>
    </div>
</div>

<!-- Action Message (if any) -->
<% if (actionMessage != null && !actionMessage.isEmpty()) { %>
    <div class="alert alert-<%= actionType != null && actionType.equals("success") ? "success" : "danger" %> alert-dismissible">
        <%= actionMessage %>
        <button type="button" class="close" onclick="this.parentElement.style.display='none';">
            <span aria-hidden="true">&times;</span>
        </button>
    </div>
<% } %>

<!-- Filters -->
<div class="card">
    <div class="card-body">
        <form action="admin-users.jsp" method="get" class="row">
            <div class="col-md-4">
                <div class="form-group">
                    <label for="role" class="form-label">Vai trò</label>
                    <select id="role" name="role" class="form-control">
                        <option value="all" <%= (roleFilter == null || "all".equals(roleFilter)) ? "selected" : "" %>>Tất cả vai trò</option>
                        <option value="Admin" <%= "Admin".equals(roleFilter) ? "selected" : "" %>>Admin</option>
                        <option value="Manager" <%= "Manager".equals(roleFilter) ? "selected" : "" %>>Manager</option>
                        <option value="Employee" <%= "Employee".equals(roleFilter) ? "selected" : "" %>>Employee</option>
                    </select>
                </div>
            </div>
            
            <div class="col-md-4">
                <div class="form-group">
                    <label for="department" class="form-label">Phòng ban</label>
                    <select id="department" name="department" class="form-control">
                        <option value="all" <%= (deptFilter == null || "all".equals(deptFilter)) ? "selected" : "" %>>Tất cả phòng ban</option>
                        <% for (String dept : allDepartments) { %>
                            <option value="<%= dept %>" <%= dept.equals(deptFilter) ? "selected" : "" %>><%= dept %></option>
                        <% } %>
                    </select>
                </div>
            </div>
            
            <div class="col-md-4">
                <div class="form-group" style="display: flex; align-items: flex-end; height: 100%;">
                    <button type="submit" class="btn btn-primary mr-2">
                        <i class="fas fa-filter"></i> Lọc
                    </button>
                    <a href="admin-users.jsp" class="btn btn-secondary" style="margin-left: 10px;">
                        <i class="fas fa-sync"></i> Đặt lại
                    </a>
                </div>
            </div>
        </form>
    </div>
</div>

<!-- Users List -->
<div class="card">
    <div class="card-body">
        <div class="table-container">
            <table class="table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Tên đăng nhập</th>
                        <th>Vai trò</th>
                        <th>Phòng ban</th>
                        <th>Quản lý trực tiếp</th>
                        <th>Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (filteredUsers.isEmpty()) { %>
                        <tr>
                            <td colspan="6" class="text-center" style="text-align: center; padding: 2rem 0;">
                                <div>
                                    <i class="fas fa-users" style="font-size: 3rem; color: #ddd; margin-bottom: 1rem; display: block;"></i>
                                    <p style="color: var(--text-secondary);">Không tìm thấy người dùng nào khớp với điều kiện lọc</p>
                                </div>
                            </td>
                        </tr>
                    <% } else { %>
                        <% for (User u : filteredUsers) { %>
                            <tr>
                                <td><%= u.getId() %></td>
                                <td><%= u.getUsername() %></td>
                                <td>
                                    <span class="badge <%= u.getRole().equals("Admin") ? "badge-danger" : (u.getRole().equals("Manager") ? "badge-primary" : "badge-secondary") %>">
                                        <%= u.getRole() %>
                                    </span>
                                </td>
                                <td><%= u.getDepartment() %></td>
                                <td>
                                    <% 
                                        if (u.getManagerId() > 0) {
                                            User manager = userDAO.getUserById(u.getManagerId());
                                            if (manager != null) {
                                                out.print(manager.getUsername());
                                            } else {
                                                out.print("N/A");
                                            }
                                        } else {
                                            out.print("N/A");
                                        }
                                    %>
                                </td>
                                <td>
                                    <button class="btn btn-sm btn-info" onclick="editUser(<%= u.getId() %>, '<%= u.getUsername() %>', '<%= u.getRole() %>', '<%= u.getDepartment() %>', <%= u.getManagerId() %>)">
                                        <i class="fas fa-edit"></i>
                                    </button>
                                    <% if (!u.isAdmin() || (filteredUsers.stream().filter(usr -> usr.isAdmin()).count() > 1)) { %>
                                        <a href="UserManagementServlet?action=delete&userId=<%= u.getId() %>" class="btn btn-sm btn-danger" onclick="return confirm('Bạn có chắc chắn muốn xóa người dùng này không?')">
                                            <i class="fas fa-trash-alt"></i>
                                        </a>
                                    <% } %>
                                </td>
                            </tr>
                        <% } %>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- Add User Modal -->
<div id="addUserModal" class="modal">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Thêm người dùng mới</h5>
                <button type="button" class="modal-close" onclick="closeModal('addUserModal')">&times;</button>
            </div>
            <form action="UserManagementServlet" method="post">
                <input type="hidden" name="action" value="add">
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="username">Tên đăng nhập <span style="color: #e74c3c;">*</span></label>
                                <input type="text" class="form-control" id="username" name="username" required>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="password">Mật khẩu <span style="color: #e74c3c;">*</span></label>
                                <input type="password" class="form-control" id="password" name="password" required>
                            </div>
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="role">Vai trò <span style="color: #e74c3c;">*</span></label>
                                <select class="form-control" id="role" name="role" required>
                                    <option value="">-- Chọn vai trò --</option>
                                    <option value="Admin">Admin</option>
                                    <option value="Manager">Manager</option>
                                    <option value="Employee">Employee</option>
                                </select>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="department">Phòng ban <span style="color: #e74c3c;">*</span></label>
                                <select class="form-control" id="department" name="department" required>
                                    <option value="">-- Chọn phòng ban --</option>
                                    <% for (String dept : allDepartments) { %>
                                        <option value="<%= dept %>"><%= dept %></option>
                                    <% } %>
                                </select>
                            </div>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="managerId">Quản lý trực tiếp</label>
                        <select class="form-control" id="managerId" name="managerId">
                            <option value="0">-- Không có quản lý trực tiếp --</option>
                            <% for (User manager : allManagers) { %>
                                <option value="<%= manager.getId() %>"><%= manager.getUsername() %> (<%= manager.getDepartment() %>)</option>
                            <% } %>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" onclick="closeModal('addUserModal')">Hủy</button>
                    <button type="submit" class="btn btn-primary">Thêm người dùng</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Edit User Modal -->
<div id="editUserModal" class="modal">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Chỉnh sửa người dùng</h5>
                <button type="button" class="modal-close" onclick="closeModal('editUserModal')">&times;</button>
            </div>
            <form action="UserManagementServlet" method="post">
                <input type="hidden" name="action" value="edit">
                <input type="hidden" name="userId" id="editUserId">
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="editUsername">Tên đăng nhập <span style="color: #e74c3c;">*</span></label>
                                <input type="text" class="form-control" id="editUsername" name="username" required>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="editPassword">Mật khẩu mới (để trống nếu không đổi)</label>
                                <input type="password" class="form-control" id="editPassword" name="password">
                            </div>
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="editRole">Vai trò <span style="color: #e74c3c;">*</span></label>
                                <select class="form-control" id="editRole" name="role" required>
                                    <option value="Admin">Admin</option>
                                    <option value="Manager">Manager</option>
                                    <option value="Employee">Employee</option>
                                </select>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="editDepartment">Phòng ban <span style="color: #e74c3c;">*</span></label>
                                <select class="form-control" id="editDepartment" name="department" required>
                                    <% for (String dept : allDepartments) { %>
                                        <option value="<%= dept %>"><%= dept %></option>
                                    <% } %>
                                </select>
                            </div>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="editManagerId">Quản lý trực tiếp</label>
                        <select class="form-control" id="editManagerId" name="managerId">
                            <option value="0">-- Không có quản lý trực tiếp --</option>
                            <% for (User manager : allManagers) { %>
                                <option value="<%= manager.getId() %>"><%= manager.getUsername() %> (<%= manager.getDepartment() %>)</option>
                            <% } %>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" onclick="closeModal('editUserModal')">Hủy</button>
                    <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- JavaScript for user management operations -->
<script>
    function closeModal(modalId) {
        document.getElementById(modalId).classList.remove('show');
    }
    
    function showModal(modalId) {
        document.getElementById(modalId).classList.add('show');
    }
    
    function editUser(userId, username, role, department, managerId) {
        document.getElementById('editUserId').value = userId;
        document.getElementById('editUsername').value = username;
        document.getElementById('editRole').value = role;
        document.getElementById('editDepartment').value = department;
        document.getElementById('editManagerId').value = managerId || 0;
        
        showModal('editUserModal');
    }
    
    // Auto-close alerts after 5 seconds
    setTimeout(function() {
        const alerts = document.querySelectorAll('.alert');
        alerts.forEach(function(alert) {
            alert.style.display = 'none';
        });
    }, 5000);
</script>

<%-- Include Footer --%>
<%@ include file="footer.jsp" %>