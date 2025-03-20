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
    
    // Get department manager
    User manager = null;
    if (department.getManagerId() > 0) {
        UserDAO userDAO = new UserDAO();
        manager = userDAO.getUserById(department.getManagerId());
    }
    
    // Get all users in department
    UserDAO userDAO = new UserDAO();
    List<User> departmentUsers = userDAO.getUsersByDepartmentId(departmentId);
    
    // Count employees by role
    int managerCount = 0;
    int employeeCount = 0;
    
    for (User u : departmentUsers) {
        if (u.isManager()) {
            managerCount++;
        } else if (u.isEmployee()) {
            employeeCount++;
        }
    }
%>

<!-- Page Header -->
<div class="card">
    <div class="card-header">
        <h2><i class="fas fa-building"></i> Chi tiết phòng ban</h2>
        
        <div>
            <a href="edit-department.jsp?id=<%= department.getId() %>" class="btn btn-primary btn-sm">
                <i class="fas fa-edit"></i> Chỉnh sửa
            </a>
            <a href="admin-departments.jsp" class="btn btn-outline-secondary btn-sm ml-2">
                <i class="fas fa-arrow-left"></i> Quay lại
            </a>
        </div>
    </div>
</div>

<!-- Department Information -->
<div class="row">
    <div class="col-md-6">
        <div class="card">
            <div class="card-header">
                <h3>Thông tin phòng ban</h3>
            </div>
            <div class="card-body">
                <div class="form-group row">
                    <label class="col-sm-4 col-form-label font-weight-bold">ID:</label>
                    <div class="col-sm-8">
                        <p class="form-control-plaintext"><%= department.getId() %></p>
                    </div>
                </div>
                
                <div class="form-group row">
                    <label class="col-sm-4 col-form-label font-weight-bold">Tên phòng ban:</label>
                    <div class="col-sm-8">
                        <p class="form-control-plaintext"><%= department.getName() %></p>
                    </div>
                </div>
                
                <div class="form-group row">
                    <label class="col-sm-4 col-form-label font-weight-bold">Mô tả:</label>
                    <div class="col-sm-8">
                        <p class="form-control-plaintext">
                            <%= department.getDescription() != null && !department.getDescription().isEmpty() ? department.getDescription() : "Không có mô tả" %>
                        </p>
                    </div>
                </div>
                
                <div class="form-group row">
                    <label class="col-sm-4 col-form-label font-weight-bold">Quản lý:</label>
                    <div class="col-sm-8">
                        <p class="form-control-plaintext">
                            <% if (manager != null) { %>
                                <%= manager.getUsername() %> (ID: <%= manager.getId() %>)
                            <% } else { %>
                                <span class="text-muted">Chưa có quản lý</span>
                            <% } %>
                        </p>
                    </div>
                </div>
                
                <div class="form-group row">
                    <label class="col-sm-4 col-form-label font-weight-bold">Số nhân viên:</label>
                    <div class="col-sm-8">
                        <p class="form-control-plaintext"><%= departmentUsers.size() %></p>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <div class="col-md-6">
        <div class="card">
            <div class="card-header">
                <h3>Thống kê nhân sự</h3>
            </div>
            <div class="card-body">
                <div class="row text-center">
                    <div class="col-md-4">
                        <div class="mb-3" style="font-size: 2.5rem; font-weight: bold; color: #3498db;">
                            <%= departmentUsers.size() %>
                        </div>
                        <p>Tổng số</p>
                    </div>
                    
                    <div class="col-md-4">
                        <div class="mb-3" style="font-size: 2.5rem; font-weight: bold; color: #e74c3c;">
                            <%= managerCount %>
                        </div>
                        <p>Quản lý</p>
                    </div>
                    
                    <div class="col-md-4">
                        <div class="mb-3" style="font-size: 2.5rem; font-weight: bold; color: #2ecc71;">
                            <%= employeeCount %>
                        </div>
                        <p>Nhân viên</p>
                    </div>
                </div>
                
                <div class="progress mt-4" style="height: 25px;">
                    <% 
                        int total = departmentUsers.size();
                        int managerPercent = total > 0 ? (managerCount * 100) / total : 0;
                        int employeePercent = total > 0 ? (employeeCount * 100) / total : 0;
                        int otherPercent = 100 - managerPercent - employeePercent;
                    %>
                    <div class="progress-bar bg-danger" role="progressbar" style="width: <%= managerPercent %>%;" 
                         aria-valuenow="<%= managerPercent %>" aria-valuemin="0" aria-valuemax="100">
                        <%= managerPercent %>% Quản lý
                    </div>
                    <div class="progress-bar bg-success" role="progressbar" style="width: <%= employeePercent %>%;" 
                         aria-valuenow="<%= employeePercent %>" aria-valuemin="0" aria-valuemax="100">
                        <%= employeePercent %>% Nhân viên
                    </div>
                    <% if (otherPercent > 0) { %>
                    <div class="progress-bar bg-info" role="progressbar" style="width: <%= otherPercent %>%;" 
                         aria-valuenow="<%= otherPercent %>" aria-valuemin="0" aria-valuemax="100">
                        <%= otherPercent %>% Khác
                    </div>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Department Employees -->
<div class="card mt-4">
    <div class="card-header">
        <h3><i class="fas fa-users"></i> Danh sách nhân viên</h3>
        
        <a href="admin-users.jsp?department=<%= department.getName() %>" class="btn btn-primary btn-sm">
            <i class="fas fa-user-plus"></i> Thêm nhân viên
        </a>
    </div>
    <div class="card-body">
        <% if (departmentUsers.isEmpty()) { %>
            <div class="alert alert-info">
                <i class="fas fa-info-circle"></i> Phòng ban này chưa có nhân viên nào.
            </div>
        <% } else { %>
            <div class="table-responsive">
                <table class="table table-striped table-hover">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Tên đăng nhập</th>
                            <th>Vai trò</th>
                            <th>Quản lý trực tiếp</th>
                            <th>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (User emp : departmentUsers) { %>
                            <tr>
                                <td><%= emp.getId() %></td>
                                <td><%= emp.getUsername() %></td>
                                <td>
                                    <span class="badge <%= emp.getRole().equals("Admin") ? "badge-danger" : (emp.getRole().equals("Manager") ? "badge-primary" : "badge-secondary") %>"
                                          style="padding: 5px 10px;">
                                        <%= emp.getRole() %>
                                    </span>
                                </td>
                                <td>
                                    <% 
                                        if (emp.getManagerId() > 0) {
                                            User empManager = userDAO.getUserById(emp.getManagerId());
                                            if (empManager != null) {
                                                out.print(empManager.getUsername());
                                            } else {
                                                out.print("N/A");
                                            }
                                        } else {
                                            out.print("N/A");
                                        }
                                    %>
                                </td>
                                <td>
                                    <a href="#" class="btn btn-sm btn-info" title="Xem chi tiết" onclick="viewUserDetails(<%= emp.getId() %>)">
                                        <i class="fas fa-eye"></i>
                                    </a>
                                    <a href="admin-users.jsp?edit=<%= emp.getId() %>" class="btn btn-sm btn-primary" title="Chỉnh sửa">
                                        <i class="fas fa-edit"></i>
                                    </a>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        <% } %>
    </div>
</div>

<script>
    function viewUserDetails(userId) {
        alert('Chức năng xem chi tiết người dùng sẽ được phát triển trong phiên bản tiếp theo.');
    }
</script>

<%-- Include Footer --%>
<%@ include file="footer.jsp" %>