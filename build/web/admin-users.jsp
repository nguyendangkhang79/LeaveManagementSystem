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

<!-- Page Header -->
<div class="card">
    <div class="card-header">
        <h2><i class="fas fa-users"></i> Quản lý người dùng</h2>
        
        <button class="btn btn-primary" data-toggle="modal" data-target="#addUserModal">
            <i class="fas fa-user-plus"></i> Thêm người dùng mới
        </button>
    </div>
</div>

<!-- Action Message (if any) -->
<% if (actionMessage != null && !actionMessage.isEmpty()) { %>
    <div class="alert alert-<%= actionType != null && actionType.equals("success") ? "success" : "danger" %> alert-dismissible fade show" role="alert">
        <%= actionMessage %>
        <button type="button" class="close" data-dismiss="alert" aria-label="Close" onclick="this.parentElement.style.display='none';">
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
        <div class="table-responsive">
            <table class="table table-striped table-hover">
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
                            <td colspan="6" class="text-center">Không tìm thấy người dùng nào khớp với điều kiện lọc</td>
                        </tr>
                    <% } else { %>
                        <% for (User u : filteredUsers) { %>
                            <tr>
                                <td><%= u.getId() %></td>
                                <td><%= u.getUsername() %></td>
                                <td>
                                    <span class="badge <%= u.getRole().equals("Admin") ? "badge-danger" : (u.getRole().equals("Manager") ? "badge-primary" : "badge-secondary") %>"
                                          style="padding: 5px 10px;">
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
<div class="modal fade" id="addUserModal" tabindex="-1" role="dialog" aria-labelledby="addUserModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="addUserModalLabel">Thêm người dùng mới</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close" onclick="closeModal('addUserModal')">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <form action="UserManagementServlet" method="post">
                <input type="hidden" name="action" value="add">
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="username">Tên đăng nhập <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="username" name="username" required>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="password">Mật khẩu <span class="text-danger">*</span></label>
                                <input type="password" class="form-control" id="password" name="password" required>
                            </div>
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="role">Vai trò <span class="text-danger">*</span></label>
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
                                <label for="department">Phòng ban <span class="text-danger">*</span></label>
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
                    <button type="button" class="btn btn-secondary" data-dismiss="modal" onclick="closeModal('addUserModal')">Hủy</button>
                    <button type="submit" class="btn btn-primary">Thêm người dùng</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Edit User Modal -->
<div class="modal fade" id="editUserModal" tabindex="-1" role="dialog" aria-labelledby="editUserModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="editUserModalLabel">Chỉnh sửa người dùng</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close" onclick="closeModal('editUserModal')">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <form action="UserManagementServlet" method="post">
                <input type="hidden" name="action" value="edit">
                <input type="hidden" name="userId" id="editUserId">
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="editUsername">Tên đăng nhập <span class="text-danger">*</span></label>
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
                                <label for="editRole">Vai trò <span class="text-danger">*</span></label>
                                <select class="form-control" id="editRole" name="role" required>
                                    <option value="Admin">Admin</option>
                                    <option value="Manager">Manager</option>
                                    <option value="Employee">Employee</option>
                                </select>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="editDepartment">Phòng ban <span class="text-danger">*</span></label>
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
                    <button type="button" class="btn btn-secondary" data-dismiss="modal" onclick="closeModal('editUserModal')">Hủy</button>
                    <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- JavaScript for user management operations -->
<script>
    function closeModal(modalId) {
        document.getElementById(modalId).style.display = 'none';
        document.body.classList.remove('modal-open');
        document.getElementsByClassName('modal-backdrop')[0]?.remove();
    }
    
    function showModal(modalId) {
        const modal = document.getElementById(modalId);
        modal.style.display = 'block';
        modal.classList.add('show');
        document.body.classList.add('modal-open');
        
        const backdrop = document.createElement('div');
        backdrop.className = 'modal-backdrop fade show';
        document.body.appendChild(backdrop);
    }
    
    function editUser(userId, username, role, department, managerId) {
        document.getElementById('editUserId').value = userId;
        document.getElementById('editUsername').value = username;
        document.getElementById('editRole').value = role;
        document.getElementById('editDepartment').value = department;
        document.getElementById('editManagerId').value = managerId || 0;
        
        showModal('editUserModal');
    }
    
    // Open modals when buttons are clicked
    document.addEventListener('DOMContentLoaded', function() {
        const addBtn = document.querySelector('[data-target="#addUserModal"]');
        if (addBtn) {
            addBtn.addEventListener('click', function() {
                showModal('addUserModal');
            });
        }
    });
    
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