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

<style>
    /* Enhanced styles for Department Creation */
    .form-container {
        background-color: var(--card-bg-color);
        border-radius: var(--border-radius);
        box-shadow: var(--box-shadow);
        padding: 1.5rem;
        margin-bottom: 1.5rem;
    }
    
    .page-title {
        font-size: 1.5rem;
        font-weight: 600;
        margin-bottom: 1.5rem;
        color: var(--text-color);
        display: flex;
        align-items: center;
    }
    
    .page-title i {
        margin-right: 0.75rem;
        color: var(--primary-color);
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
    
    .required-marker {
        color: #e74c3c;
        margin-left: 4px;
    }
    
    .form-control {
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
    
    textarea.form-control {
        min-height: 100px;
        resize: vertical;
    }
    
    .form-hint {
        display: block;
        margin-top: 0.25rem;
        font-size: 0.875rem;
        color: var(--text-secondary);
    }
    
    .btn {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        padding: 0.75rem 1.5rem;
        font-size: 1rem;
        font-weight: 500;
        line-height: 1.5;
        text-align: center;
        white-space: nowrap;
        vertical-align: middle;
        cursor: pointer;
        user-select: none;
        border: 1px solid transparent;
        border-radius: 0.5rem;
        transition: all 0.3s ease;
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
        box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
    }
    
    .btn-outline-secondary {
        color: var(--text-secondary);
        background-color: transparent;
        border-color: var(--border-color);
    }
    
    .btn-outline-secondary:hover {
        color: var(--text-color);
        background-color: rgba(0, 0, 0, 0.05);
        transform: translateY(-2px);
        box-shadow: 0 0.25rem 0.5rem rgba(0, 0, 0, 0.15);
    }
    
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
    
    .guide-container {
        margin-top: 1.5rem;
        background-color: #f8f9fa;
        border-radius: var(--border-radius);
        padding: 1.5rem;
    }
    
    .guide-title {
        display: flex;
        align-items: center;
        font-size: 1.25rem;
        font-weight: 600;
        margin-bottom: 1rem;
    }
    
    .guide-title i {
        margin-right: 0.75rem;
        color: var(--primary-color);
    }
    
    .guide-list {
        list-style-type: none;
        padding-left: 1rem;
        margin-bottom: 1rem;
    }
    
    .guide-list li {
        position: relative;
        padding-left: 1.5rem;
        margin-bottom: 0.75rem;
    }
    
    .guide-list li:before {
        content: "•";
        position: absolute;
        left: 0;
        color: var(--primary-color);
        font-weight: bold;
    }
    
    .guide-list li strong {
        font-weight: 600;
        color: var(--text-color);
    }
    
    .guide-note {
        background-color: rgba(33, 150, 243, 0.1);
        border-left: 4px solid var(--primary-color);
        padding: 1rem;
        border-radius: 0.25rem;
    }
    
    .guide-note i {
        color: var(--primary-color);
        margin-right: 0.5rem;
    }
    
    .back-link {
        display: inline-flex;
        align-items: center;
        color: var(--primary-color);
        text-decoration: none;
        font-weight: 500;
        margin-bottom: 1.5rem;
    }
    
    .back-link:hover {
        text-decoration: underline;
    }
    
    .back-link i {
        margin-right: 0.5rem;
    }
    
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
    
    /* Fix dark mode specific issues */
    [data-theme="dark"] .guide-container {
        background-color: rgba(255, 255, 255, 0.05);
    }
    
    [data-theme="dark"] .guide-note {
        background-color: rgba(33, 150, 243, 0.05);
    }
</style>

<!-- Page Header -->
<div class="card">
    <div class="card-header">
        <h2><i class="fas fa-building"></i> Tạo phòng ban mới</h2>
        
        <a href="admin-departments.jsp" class="btn btn-outline-secondary">
            <i class="fas fa-arrow-left"></i> Quay lại danh sách phòng ban
        </a>
    </div>
</div>

<!-- Action Message (if any) -->
<% if (actionMessage != null && !actionMessage.isEmpty()) { %>
    <div class="alert alert-<%= actionType != null && actionType.equals("success") ? "success" : "danger" %> alert-dismissible">
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
                <label for="departmentName" class="form-label">
                    Tên phòng ban <span class="required-marker">*</span>
                </label>
                <input type="text" class="form-control" id="departmentName" name="departmentName" required>
                <small class="form-hint">Nhập tên phòng ban duy nhất.</small>
            </div>
            
            <div class="form-group">
                <label for="description" class="form-label">Mô tả</label>
                <textarea class="form-control" id="description" name="description" rows="3"></textarea>
                <small class="form-hint">Mô tả chi tiết về phòng ban.</small>
            </div>
            
            <div class="form-group">
                <label for="managerId" class="form-label">Quản lý phòng ban</label>
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
                <small class="form-hint">Người quản lý phòng ban này.</small>
            </div>
            
            <button type="submit" class="btn btn-primary">
                <i class="fas fa-save"></i> Tạo phòng ban
            </button>
        </form>
    </div>
</div>

<!-- Department Guidelines -->
<div class="card">
    <div class="card-header">
        <h3><i class="fas fa-info-circle"></i> Hướng dẫn tạo phòng ban</h3>
    </div>
    <div class="card-body">
        <ul class="guide-list">
            <li><strong>Tên phòng ban:</strong> Nên đặt tên ngắn gọn, rõ ràng và mô tả chính xác chức năng của phòng ban.</li>
            <li><strong>Mô tả:</strong> Nên mô tả chi tiết về chức năng, nhiệm vụ của phòng ban.</li>
            <li><strong>Quản lý phòng ban:</strong> Mỗi phòng ban nên có ít nhất một quản lý. Nếu không chọn, bạn có thể chỉ định sau.</li>
        </ul>
        
        <div class="guide-note">
            <i class="fas fa-lightbulb"></i> Sau khi tạo phòng ban, bạn có thể thêm nhân viên vào phòng ban từ màn hình <a href="admin-users.jsp">Quản lý người dùng</a>.
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