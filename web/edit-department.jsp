<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.DepartmentDAO, dao.UserDAO, model.Department, model.User, java.util.List" %>

<%-- Include Header --%>
<%@ include file="header.jsp" %>

<%
    // Security check: Only Super Admin can access this page
    if (user == null || !user.isAdmin()) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Get department ID from request
    String departmentIdStr = request.getParameter("id");
    if (departmentIdStr == null || departmentIdStr.isEmpty()) {
        response.sendRedirect("admin-departments.jsp");
        return;
    }
    
    int departmentId = Integer.parseInt(departmentIdStr);
    
    // Get department details
    DepartmentDAO departmentDAO = new DepartmentDAO();
    Department department = departmentDAO.getDepartmentById(departmentId);
    
    if (department == null) {
        response.sendRedirect("admin-departments.jsp");
        return;
    }
    
    // Get all potential managers
    UserDAO userDAO = new UserDAO();
    List<User> managers = userDAO.getAllUsers().stream()
        .filter(u -> "Manager".equals(u.getRole()) || "Admin".equals(u.getRole()))
        .collect(java.util.stream.Collectors.toList());
    
    // Get action message if any
    String actionMessage = request.getParameter("message");
    String actionType = request.getParameter("type");
%>

<!-- Page Header -->
<div class="card">
    <div class="card-header">
        <h2><i class="fas fa-edit"></i> Chỉnh sửa phòng ban</h2>
        
        <a href="view-department.jsp?id=<%= department.getId() %>" class="btn btn-outline-secondary btn-sm">
            <i class="fas fa-arrow-left"></i> Quay lại
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

<!-- Department Form -->
<div class="card">
    <div class="card-body">
        <form action="DepartmentManagementServlet" method="post">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="departmentId" value="<%= department.getId() %>">
            
            <div class="form-group">
                <label for="departmentName">Tên phòng ban <span class="text-danger">*</span></label>
                <input type="text" class="form-control" id="departmentName" name="departmentName" value="<%= department.getName() %>" required>
            </div>
            
            <div class="form-group">
                <label for="description">Mô tả</label>
                <textarea class="form-control" id="description" name="description" rows="3"><%= department.getDescription() != null ? department.getDescription() : "" %></textarea>
            </div>
            
            <div class="form-group">
                <label for="managerId">Quản lý phòng ban</label>
                <select class="form-control" id="managerId" name="managerId">
                    <option value="0">-- Không có quản lý --</option>
                    <% for (User manager : managers) { %>
                        <option value="<%= manager.getId() %>" <%= manager.getId() == department.getManagerId() ? "selected" : "" %>>
                            <%= manager.getUsername() %> (<%= manager.getDepartment() %>)
                        </option>
                    <% } %>
                </select>
            </div>
            
            <button type="submit" class="btn btn-primary">
                <i class="fas fa-save"></i> Lưu thay đổi
            </button>
            
            <a href="view-department.jsp?id=<%= department.getId() %>" class="btn btn-secondary ml-2">
                <i class="fas fa-times"></i> Hủy
            </a>
        </form>
    </div>
</div>

<!-- Department Employees -->
<div class="card mt-4">
    <div class="card-header">
        <h3><i class="fas fa-users"></i> Quản lý nhân viên</h3>
    </div>
    <div class="card-body">
        <p>Quản lý nhân viên trong phòng ban này:</p>
        <div class="row">
            <div class="col-md-6">
                <a href="admin-users.jsp?department=<%= department.getName() %>" class="btn btn-info btn-block mb-3">
                    <i class="fas fa-user-plus"></i> Thêm nhân viên vào phòng ban
                </a>
            </div>
            <div class="col-md-6">
                <a href="view-department.jsp?id=<%= department.getId() %>" class="btn btn-secondary btn-block mb-3">
                    <i class="fas fa-eye"></i> Xem danh sách nhân viên
                </a>
            </div>
        </div>
        
        <div class="alert alert-info">
            <i class="fas fa-info-circle"></i> Bạn cũng có thể quản lý nhân viên bằng cách truy cập vào trang <a href="admin-users.jsp">Quản lý người dùng</a> và lọc theo phòng ban này.
        </div>
    </div>
</div>

<script>
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