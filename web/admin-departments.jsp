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
    <div class="alert alert-<%= actionType != null && actionType.equals("success") ? "success" : "danger" %> alert-dismissible fade show" role="alert">
        <%= actionMessage %>
        <button type="button" class="close" data-dismiss="alert" aria-label="Close" onclick="this.parentElement.style.display='none';">
            <span aria-hidden="true">&times;</span>
        </button>
    </div>
<% } %>

<!-- Department Overview -->
<div class="card">
    <div class="card-body">
        <div class="row">
            <div class="col-md-4">
                <div class="card mb-0">
                    <div class="card-body text-center">
                        <h3 class="mb-3">Tổng số phòng ban</h3>
                        <div style="font-size: 2.5rem; font-weight: bold; color: #3498db;">
                            <%= allDepartments.size() %>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4">
                <div class="card mb-0">
                    <div class="card-body text-center">
                        <h3 class="mb-3">Tổng số nhân viên</h3>
                        <div style="font-size: 2.5rem; font-weight: bold; color: #2ecc71;">
                            <%= allUsers.size() %>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4">
                <div class="card mb-0">
                    <div class="card-body text-center">
                        <h3 class="mb-3">Số quản lý</h3>
                        <div style="font-size: 2.5rem; font-weight: bold; color: #e74c3c;">
                            <%= allUsers.stream().filter(u -> u.isManager()).count() %>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Departments List -->
<div class="card">
    <div class="card-body">
        <div class="table-responsive">
            <table class="table table-striped table-hover">
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
                            <td colspan="6" class="text-center">Không có phòng ban nào</td>
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
                                        <span class="text-muted">Chưa có quản lý</span>
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
        <form action="DepartmentManagementServlet" method="post">
            <input type="hidden" name="action" value="transfer">
            
            <div class="row">
                <div class="col-md-5">
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
                
                <div class="col-md-5">
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
                
                <div class="col-md-2 d-flex align-items-end">
                    <button type="submit" class="btn btn-primary btn-block" onclick="return validateTransfer()">
                        <i class="fas fa-exchange-alt"></i> Chuyển
                    </button>
                </div>
            </div>
            
            <div class="alert alert-warning mt-3">
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
        <div style="height: 300px; display: flex; align-items: flex-end;">
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
                    int width = allDepartments.size() > 0 ? 100 / allDepartments.size() : 100;
                    if (width < 10) width = 10; // Minimum width
                    if (width > 30) width = 30; // Maximum width
            %>
                <div style="display: flex; flex-direction: column; align-items: center; width: <%= width %>%; padding: 0 10px;">
                    <div style="height: <%= heightPercentage %>%; background-color: #3498db; width: 80%; min-height: 20px; border-radius: 5px 5px 0 0; position: relative;">
                        <div style="position: absolute; top: -25px; width: 100%; text-align: center; font-weight: bold;">
                            <%= deptCount %>
                        </div>
                    </div>
                    <div style="margin-top: 10px; text-align: center; font-size: 12px; word-wrap: break-word; width: 100%;">
                        <%= dept.getName() %>
                    </div>
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