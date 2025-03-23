<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.UserDAO, dao.DepartmentDAO, model.User, model.Department, java.util.List, java.util.Map, java.util.HashMap" %>

<%-- Include Header --%>
<%@ include file="header.jsp" %>

<%
    // Security check: Only Super Admin can access this page
    if (user == null || !user.isAdmin()) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Get all departments
    DepartmentDAO departmentDAO = new DepartmentDAO();
    List<Department> allDepartments = departmentDAO.getAllDepartments();
    
    // Get all users
    UserDAO userDAO = new UserDAO();
    List<User> allUsers = userDAO.getAllUsers();
    
    // Count users in each department
    Map<Integer, Integer> departmentCounts = new HashMap<>();
    Map<Integer, Integer> managerCounts = new HashMap<>();
    
    for (Department dept : allDepartments) {
        departmentCounts.put(dept.getId(), 0);
        managerCounts.put(dept.getId(), 0);
    }
    
    for (User u : allUsers) {
        Integer deptId = u.getDepartmentId();
        if (deptId != null && deptId > 0) {
            departmentCounts.put(deptId, departmentCounts.getOrDefault(deptId, 0) + 1);
            
            if (u.isManager()) {
                managerCounts.put(deptId, managerCounts.getOrDefault(deptId, 0) + 1);
            }
        }
    }
    
    // Get action message if any
    String actionMessage = request.getParameter("message");
    String actionType = request.getParameter("type");
%>

<style>
    /* Enhanced styles for Department Management */
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
    
    .card-header h2, .card-header h3 {
        margin: 0;
        font-weight: 600;
        color: var(--text-color);
        display: flex;
        align-items: center;
    }
    
    .card-header h2 i, .card-header h3 i {
        margin-right: 0.75rem;
        color: var(--primary-color);
    }
    
    .card-body {
        padding: 1.5rem;
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
    
    /* Dashboard Cards */
    .dashboard-stats {
        display: flex;
        flex-wrap: wrap;
        margin: 0 -0.75rem;
    }
    
    .stat-card {
        flex: 1;
        min-width: 200px;
        margin: 0 0.75rem;
    }
    
    .stat-card .card-body {
        text-align: center;
        padding: 1.5rem;
    }
    
    .stat-card h3 {
        font-size: 1.1rem;
        margin-bottom: 1rem;
        color: var(--text-color);
    }
    
    .stat-value {
        font-size: 2.5rem;
        font-weight: 600;
        margin-bottom: 0;
        line-height: 1;
    }
    
    .stat-blue {
        color: #3498db;
    }
    
    .stat-green {
        color: #2ecc71;
    }
    
    .stat-red {
        color: #e74c3c;
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
    
    .badge-info {
        background-color: #3498db;
        color: #fff;
    }
    
    /* Alert styles */
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
    
    /* Chart styling */
    .chart-container {
        height: 300px;
        display: flex;
        align-items: flex-end;
        margin-top: 1.5rem;
    }
    
    .chart-bar {
        display: flex;
        flex-direction: column;
        align-items: center;
        padding: 0 0.625rem;
        position: relative;
    }
    
    .chart-bar-value {
        background-color: #3498db;
        width: 80%;
        border-radius: 0.25rem 0.25rem 0 0;
        position: relative;
        min-height: 20px;
    }
    
    .chart-bar-label {
        margin-top: 0.625rem;
        text-align: center;
        font-size: 0.75rem;
        word-wrap: break-word;
        max-width: 100%;
    }
    
    .chart-bar-count {
        position: absolute;
        top: -1.5625rem;
        width: 100%;
        text-align: center;
        font-weight: bold;
    }
    
    /* Transfer form */
    .transfer-form {
        margin-top: 1.5rem;
    }
    
    .transfer-form .row {
        display: flex;
        flex-wrap: wrap;
        margin: 0 -0.75rem;
    }
    
    .transfer-form .col {
        padding: 0 0.75rem;
        flex: 1;
    }
    
    .transfer-warning {
        margin-top: 1rem;
        background-color: rgba(241, 196, 15, 0.1);
        border-left: 4px solid #f39c12;
        padding: 1rem;
        border-radius: 0.25rem;
    }
    
    @media (max-width: 768px) {
        .dashboard-stats, .transfer-form .row {
            flex-direction: column;
        }
        
        .stat-card, .transfer-form .col {
            margin-bottom: 1rem;
        }
        
        .card-header {
            flex-direction: column;
            align-items: flex-start;
        }
        
        .card-header h2 {
            margin-bottom: 1rem;
        }
    }
</style>

<!-- Page Header -->
<div class="card">
    <div class="card-header">
        <h2><i class="fas fa-building"></i> Quản lý phòng ban</h2>
        
        <a href="create-department.jsp" class="btn btn-primary">
            <i class="fas fa-plus-circle"></i> Thêm phòng ban mới
        </a>
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

<!-- Department Overview -->
<div class="card">
    <div class="card-body">
        <div class="dashboard-stats">
            <div class="stat-card">
                <div class="card-body">
                    <h3>Tổng số phòng ban</h3>
                    <div class="stat-value stat-blue">
                        <%= allDepartments.size() %>
                    </div>
                </div>
            </div>
            
            <div class="stat-card">
                <div class="card-body">
                    <h3>Tổng số nhân viên</h3>
                    <div class="stat-value stat-green">
                        <%= allUsers.size() %>
                    </div>
                </div>
            </div>
            
            <div class="stat-card">
                <div class="card-body">
                    <h3>Số quản lý</h3>
                    <div class="stat-value stat-red">
                        <%= allUsers.stream().filter(u -> u.isManager()).count() %>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Departments List -->
<div class="card">
    <div class="card-body">
        <div class="table-container">
            <table class="table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Tên phòng ban</th>
                        <th>Mô tả</th>
                        <th>Quản lý</th>
                        <th>Số nhân viên</th>
                        <th>Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (allDepartments.isEmpty()) { %>
                        <tr>
                            <td colspan="6" style="text-align: center; padding: 2rem 0;">
                                <div>
                                    <i class="fas fa-building" style="font-size: 3rem; color: #ddd; margin-bottom: 1rem; display: block;"></i>
                                    <p style="color: var(--text-secondary);">Không có phòng ban nào</p>
                                    <a href="create-department.jsp" class="btn btn-primary" style="margin-top: 1rem;">
                                        <i class="fas fa-plus-circle"></i> Thêm phòng ban mới
                                    </a>
                                </div>
                            </td>
                        </tr>
                    <% } else { %>
                        <% for (Department dept : allDepartments) { %>
                            <tr>
                                <td><%= dept.getId() %></td>
                                <td><strong><%= dept.getName() %></strong></td>
                                <td><%= dept.getDescription() != null ? dept.getDescription() : "" %></td>
                                <td>
                                    <% if (dept.getManagerId() > 0 && dept.getManagerName() != null) { %>
                                        <%= dept.getManagerName() %>
                                    <% } else { %>
                                        <span style="color: var(--text-secondary);">Chưa có quản lý</span>
                                    <% } %>
                                </td>
                                <td>
                                    <span class="badge badge-info">
                                        <%= departmentCounts.getOrDefault(dept.getId(), 0) %>
                                    </span>
                                </td>
                                <td>
                                    <a href="view-department.jsp?id=<%= dept.getId() %>" class="btn btn-sm btn-info" title="Xem chi tiết">
                                        <i class="fas fa-eye"></i>
                                    </a>
                                    <a href="edit-department.jsp?id=<%= dept.getId() %>" class="btn btn-sm btn-primary" title="Chỉnh sửa">
                                        <i class="fas fa-edit"></i>
                                    </a>
                                    <% if (departmentCounts.getOrDefault(dept.getId(), 0) == 0) { %>
                                        <a href="DepartmentManagementServlet?action=delete&id=<%= dept.getId() %>" 
                                           class="btn btn-sm btn-danger" 
                                           title="Xóa phòng ban"
                                           onclick="return confirm('Bạn có chắc chắn muốn xóa phòng ban này không?')">
                                            <i class="fas fa-trash-alt"></i>
                                        </a>
                                    <% } else { %>
                                        <button class="btn btn-sm btn-secondary" 
                                                title="Không thể xóa phòng ban có nhân viên"
                                                disabled>
                                            <i class="fas fa-trash-alt"></i>
                                        </button>
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

<!-- Transfer Employees Form -->
<div class="card">
    <div class="card-header">
        <h3><i class="fas fa-exchange-alt"></i> Chuyển nhân viên giữa các phòng ban</h3>
    </div>
    <div class="card-body">
        <form action="DepartmentManagementServlet" method="post" class="transfer-form">
            <input type="hidden" name="action" value="transfer">
            
            <div class="row">
                <div class="col">
                    <div class="form-group">
                        <label for="sourceDeptId">Phòng ban nguồn</label>
                        <select class="form-control" id="sourceDeptId" name="sourceDeptId" required>
                            <option value="">-- Chọn phòng ban nguồn --</option>
                            <% for (Department dept : allDepartments) { 
                                int empCount = departmentCounts.getOrDefault(dept.getId(), 0);
                                if (empCount > 0) {
                            %>
                                <option value="<%= dept.getId() %>"><%= dept.getName() %> (<%= empCount %> nhân viên)</option>
                            <% } } %>
                        </select>
                    </div>
                </div>
                
                <div class="col">
                    <div class="form-group">
                        <label for="targetDeptId">Phòng ban đích</label>
                        <select class="form-control" id="targetDeptId" name="targetDeptId" required>
                            <option value="">-- Chọn phòng ban đích --</option>
                            <% for (Department dept : allDepartments) { %>
                                <option value="<%= dept.getId() %>"><%= dept.getName() %></option>
                            <% } %>
                        </select>
                    </div>
                </div>
                
                <div class="col" style="flex: 0 0 auto; align-self: flex-end;">
                    <button type="submit" class="btn btn-primary" onclick="return validateTransfer()">
                        <i class="fas fa-exchange-alt"></i> Chuyển
                    </button>
                </div>
            </div>
            
            <div class="transfer-warning">
                <i class="fas fa-exclamation-triangle"></i> Lưu ý: Hành động này sẽ chuyển tất cả nhân viên từ phòng ban nguồn sang phòng ban đích.
            </div>
        </form>
    </div>
</div>

<!-- Department Employees Chart -->
<div class="card">
    <div class="card-header">
        <h3><i class="fas fa-chart-bar"></i> Phân bố nhân viên theo phòng ban</h3>
    </div>
    <div class="card-body">
        <div class="chart-container">
            <% 
                int maxCount = 0;
                for (Integer count : departmentCounts.values()) {
                    if (count > maxCount) maxCount = count;
                }
                
                for (Department dept : allDepartments) {
                    int deptCount = departmentCounts.getOrDefault(dept.getId(), 0);
                    
                    // Calculate percentage height based on max count
                    int heightPercentage = maxCount > 0 ? (deptCount * 100) / maxCount : 0;
                    
                    // Calculate width based on number of departments
                    int width = 100 / (allDepartments.size() > 0 ? allDepartments.size() : 1);
                    width = Math.max(10, Math.min(width, 20)); // between 10% and 20%
            %>
                <div class="chart-bar" style="width: <%= width %>%;">
                    <div class="chart-bar-value" style="height: <%= heightPercentage %>%;">
                        <div class="chart-bar-count"><%= deptCount %></div>
                    </div>
                    <div class="chart-bar-label"><%= dept.getName() %></div>
                </div>
            <% } %>
        </div>
    </div>
</div>

<script>
    function validateTransfer() {
        const sourceDeptId = document.getElementById('sourceDeptId').value;
        const targetDeptId = document.getElementById('targetDeptId').value;
        
        if (!sourceDeptId || !targetDeptId) {
            alert('Vui lòng chọn cả phòng ban nguồn và phòng ban đích.');
            return false;
        }
        
        if (sourceDeptId === targetDeptId) {
            alert('Phòng ban nguồn và phòng ban đích không thể giống nhau.');
            return false;
        }
        
        return confirm('Bạn có chắc chắn muốn chuyển tất cả nhân viên từ phòng ban này sang phòng ban kia không?');
    }
    
    // Auto-close alerts after 5 seconds
    setTimeout(function() {
        const alerts = document.querySelectorAll('.alert-dismissible');
        alerts.forEach(function(alert) {
            alert.style.display = 'none';
        });
    }, 5000);
</script>

<%-- Include Footer --%>
<%@ include file="footer.jsp" %>