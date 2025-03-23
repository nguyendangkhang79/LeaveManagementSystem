<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.UserDAO, model.User, java.util.List" %>

<%-- Include Header --%>
<%@ include file="header.jsp" %>

<%
    // Security check: Only Super Admin can access this page
    if (user == null || !user.isAdmin()) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Get action message if any
    String actionMessage = request.getParameter("message");
    String actionType = request.getParameter("type");
%>

<!-- Page Header -->
<div class="card">
    <div class="card-header">
        <h2><i class="fas fa-building"></i> Tạo phòng ban mới</h2>
        
        <a href="admin-departments.jsp" class="btn btn-outline-primary btn-sm">
            <i class="fas fa-arrow-left"></i> Quay lại danh sách phòng ban
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
            <input type="hidden" name="action" value="create">
            
            <div class="form-group">
                <label for="departmentName">Tên phòng ban <span class="text-danger">*</span></label>
                <input type="text" class="form-control" id="departmentName" name="departmentName" required>
                <small class="form-text text-muted">Nhập tên phòng ban duy nhất.</small>
            </div>
            
            <div class="form-group">
                <label for="description">Mô tả</label>
                <textarea class="form-control" id="description" name="description" rows="3"></textarea>
                <small class="form-text text-muted">Mô tả chi tiết về phòng ban.</small>
            </div>
            
            <div class="form-group">
                <label for="managerId">Quản lý phòng ban</label>
                <select class="form-control" id="managerId" name="managerId">
                    <option value="0">-- Chọn quản lý --</option>
                    <% 
                        UserDAO userDAO = new UserDAO();
                        List<User> managers = userDAO.getAllUsers().stream()
                            .filter(u -> "Manager".equals(u.getRole()) || "Admin".equals(u.getRole()))
                            .collect(java.util.stream.Collectors.toList());
                        
                        for (User manager : managers) {
                    %>
                        <option value="<%= manager.getId() %>"><%= manager.getUsername() %></option>
                    <% } %>
                </select>
                <small class="form-text text-muted">Người quản lý phòng ban này.</small>
            </div>
            
            <button type="submit" class="btn btn-primary">
                <i class="fas fa-save"></i> Tạo phòng ban
            </button>
        </form>
    </div>
</div>

<!-- Department Guidelines -->
<div class="card mt-4">
    <div class="card-header">
        <h3><i class="fas fa-info-circle"></i> Hướng dẫn tạo phòng ban</h3>
    </div>
    <div class="card-body">
        <ul>
            <li><strong>Tên phòng ban:</strong> Nên đặt tên ngắn gọn, rõ ràng và mô tả chính xác chức năng của phòng ban.</li>
            <li><strong>Mô tả:</strong> Nên mô tả chi tiết về chức năng, nhiệm vụ của phòng ban.</li>
            <li><strong>Quản lý phòng ban:</strong> Mỗi phòng ban nên có ít nhất một quản lý. Nếu không chọn, bạn có thể chỉ định sau.</li>
        </ul>
        
        <div class="alert alert-info">
            <i class="fas fa-lightbulb"></i> Sau khi tạo phòng ban, bạn có thể thêm nhân viên vào phòng ban từ màn hình <a href="admin-users.jsp">Quản lý người dùng</a>.
        </div>
    </div>
</div>

<%-- Include Footer --%>
<%@ include file="footer.jsp" %>