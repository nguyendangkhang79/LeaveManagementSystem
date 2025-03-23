<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.LeaveRequestDAO, dao.UserDAO, model.LeaveRequest, model.User, java.util.List, java.util.Map, java.util.HashMap" %>

<%-- Include Header --%>
<%@ include file="header.jsp" %>

<%
    // Lấy tham số lọc từ request
    String statusFilter = request.getParameter("status");
    if (statusFilter == null) {
        statusFilter = "all"; // Mặc định hiển thị tất cả
    }
    
    // Lấy tham số phân trang
    int currentPage = 1;
    int recordsPerPage = 10;
    if (request.getParameter("page") != null) {
        currentPage = Integer.parseInt(request.getParameter("page"));
    }
    
    // Lấy tham số tìm kiếm
    String searchTerm = request.getParameter("search");
    if (searchTerm == null) {
        searchTerm = "";
    }
    
    // Lấy danh sách đơn nghỉ phép
    LeaveRequestDAO leaveDAO = new LeaveRequestDAO();
    List<LeaveRequest> allRequests;
    
    // Nếu là Super Admin, lấy tất cả các đơn
    if (user.isAdmin()) {
        allRequests = leaveDAO.getAllLeaveRequests();
    } else {
        allRequests = leaveDAO.getLeaveRequestsByUserId(user.getId());
    }
    
    // Lọc theo trạng thái và tìm kiếm
    List<LeaveRequest> filteredRequests = new java.util.ArrayList<>();
    for (LeaveRequest req : allRequests) {
        boolean statusMatch = "all".equals(statusFilter) || req.getStatus().equalsIgnoreCase(statusFilter);
        boolean searchMatch = searchTerm.isEmpty() || 
                              String.valueOf(req.getId()).contains(searchTerm) || 
                              String.valueOf(req.getUserId()).contains(searchTerm) || 
                              req.getReason().toLowerCase().contains(searchTerm.toLowerCase());
        
        if (statusMatch && searchMatch) {
            filteredRequests.add(req);
        }
    }
    
    // Tính toán phân trang
    int totalRecords = filteredRequests.size();
    int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);
    
    int startIdx = (currentPage - 1) * recordsPerPage;
    int endIdx = Math.min(startIdx + recordsPerPage, totalRecords);
    
    // Lấy danh sách người dùng để hiển thị tên thay vì ID
    UserDAO userDAO = new UserDAO();
    Map<Integer, String> usernames = new HashMap<>();
    Map<Integer, String> departments = new HashMap<>();
    for (LeaveRequest req : filteredRequests) {
        if (!usernames.containsKey(req.getUserId())) {
            User reqUser = userDAO.getUserById(req.getUserId());
            if (reqUser != null) {
                usernames.put(req.getUserId(), reqUser.getUsername());
                departments.put(req.getUserId(), reqUser.getDepartment());
            } else {
                usernames.put(req.getUserId(), "Unknown User");
                departments.put(req.getUserId(), "Unknown");
            }
        }
        
        if (req.getProcessedBy() != null && !usernames.containsKey(req.getProcessedBy())) {
            User processedByUser = userDAO.getUserById(req.getProcessedBy());
            if (processedByUser != null) {
                usernames.put(req.getProcessedBy(), processedByUser.getUsername());
                departments.put(req.getProcessedBy(), processedByUser.getDepartment());
            } else {
                usernames.put(req.getProcessedBy(), "Unknown User");
                departments.put(req.getProcessedBy(), "Unknown");
            }
        }
    }
%>

<style>
    /* Enhanced styles for Leave Requests List */
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
    
    /* Search box */
    .search-box {
        max-width: 500px;
    }
    
    .input-group {
        position: relative;
        display: flex;
        align-items: center;
    }
    
    .form-control {
        padding: 0.75rem 1rem 0.75rem 2.5rem;
        border-radius: 0.5rem;
        border: 1px solid var(--border-color);
        background-color: var(--card-bg-color);
        color: var(--text-color);
        width: 100%;
        transition: all 0.3s;
    }
    
    .form-control:focus {
        border-color: var(--primary-color);
        box-shadow: 0 0 0 0.2rem rgba(21, 101, 192, 0.25);
        outline: none;
    }
    
    /* Filter buttons */
    .filter-buttons {
        display: flex;
        flex-wrap: wrap;
        gap: 0.5rem;
        margin-bottom: 1rem;
    }
    
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
    
    .btn-success {
        color: #fff;
        background-color: #2ecc71;
        border-color: #2ecc71;
    }
    
    .btn-success:hover {
        background-color: #27ae60;
        border-color: #27ae60;
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
    
    /* Status badges */
    .badge {
        padding: 0.4rem 0.8rem;
        border-radius: 50rem;
        font-weight: 500;
        font-size: 0.75rem;
        display: inline-block;
        text-align: center;
        white-space: nowrap;
        vertical-align: baseline;
    }
    
    .badge-warning {
        background-color: #f39c12;
        color: white;
    }
    
    .badge-success {
        background-color: #2ecc71;
        color: white;
    }
    
    .badge-danger {
        background-color: #e74c3c;
        color: white;
    }
    
    /* Note tooltip */
    .note-tooltip {
        position: relative;
        color: var(--primary-color);
        text-decoration: none;
        font-size: 0.85rem;
        font-weight: 500;
        display: inline-flex;
        align-items: center;
        cursor: pointer; 
        padding: 4px 8px; 
        border-radius: 4px; 
        transition: background-color 0.2s;
    }

    .note-tooltip:hover {
        text-decoration: none; 
        background-color: rgba(0, 0, 0, 0.05);
    }

    .note-tooltip:active {
        background-color: rgba(0, 0, 0, 0.1); 
    }

    .note-tooltip i {
        margin-right: 0.4rem;
        color: #3498db; 
    }
    
    /* Tooltip custom styles */
    .custom-tooltip {
        position: absolute;
        background-color: rgba(0, 0, 0, 0.85);
        color: white;
        padding: 12px 16px;
        border-radius: 6px;
        font-size: 14px;
        z-index: 9999;
        max-width: 300px;
        line-height: 1.5;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
        opacity: 0;
        visibility: hidden;
        transition: opacity 0.2s ease;
        word-wrap: break-word;
        text-align: left;
    }
    
    /* Pagination */
    .pagination {
        display: flex;
        justify-content: center;
        padding: 0;
        margin: 1.5rem 0 0.5rem;
        list-style: none;
    }
    
    .pagination li {
        margin: 0 0.25rem;
    }
    
    .pagination a {
        display: flex;
        align-items: center;
        justify-content: center;
        height: 2.5rem;
        min-width: 2.5rem;
        padding: 0 0.75rem;
        text-decoration: none;
        background-color: var(--card-bg-color);
        color: var(--text-color);
        border-radius: 0.375rem;
        border: 1px solid var(--border-color);
        transition: all 0.3s;
    }
    
    .pagination a:hover {
        background-color: var(--primary-color);
        color: white;
        border-color: var(--primary-color);
    }
    
    .pagination a.active {
        background-color: var(--primary-color);
        color: white;
        border-color: var(--primary-color);
    }
    
    .pagination a.disabled {
        color: var(--text-secondary);
        pointer-events: none;
    }
    
    /* Empty state */
    .empty-state {
        text-align: center;
        padding: 3rem 1.5rem;
    }
    
    .empty-state i {
        font-size: 3rem;
        color: #ddd;
        margin-bottom: 1.5rem;
    }
    
    .empty-state h3 {
        font-size: 1.5rem;
        margin-bottom: 1rem;
        color: var(--text-color);
    }
    
    .empty-state p {
        color: var(--text-secondary);
        margin-bottom: 1.5rem;
        max-width: 500px;
        margin-left: auto;
        margin-right: auto;
    }
    
    /* Responsive adjustments */
    @media (max-width: 991px) {
        .filter-container {
            flex-direction: column;
        }
        
        .filter-container > div {
            width: 100%;
            margin-bottom: 1rem;
        }
        
        .search-box {
            max-width: 100%;
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
        
        .search-box {
            width: 100%;
        }
    }
</style>

<!-- Page Header -->
<div class="card">
    <div class="card-header">
        <h2><i class="fas fa-list"></i> Danh sách đơn nghỉ phép</h2>
        
        <!-- Search Box -->
        <div class="search-box">
            <form action="viewLeaves.jsp" method="get">
                <div class="input-group">
                    <i class="fas fa-search" style="position: absolute; left: 1rem; top: 50%; transform: translateY(-50%); color: var(--text-secondary);"></i>
                    <input type="text" name="search" value="<%= searchTerm %>" 
                           class="form-control" placeholder="Tìm kiếm theo ID hoặc lý do...">
                    <input type="hidden" name="status" value="<%= statusFilter %>">
                    <button type="submit" class="btn btn-primary" style="margin-left: 0.5rem;">
                        <i class="fas fa-search"></i> Tìm kiếm
                    </button>
                    <% if (!searchTerm.isEmpty()) { %>
                        <a href="viewLeaves.jsp?status=<%= statusFilter %>" class="btn btn-outline-secondary" style="margin-left: 0.5rem;">
                            <i class="fas fa-times"></i> Xóa
                        </a>
                    <% } %>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Filters -->
<div class="card">
    <div class="card-body">
        <div class="d-flex justify-content-between align-items-center flex-wrap">
            <div class="filter-buttons">
                <a href="viewLeaves.jsp?status=all<%= searchTerm.isEmpty() ? "" : "&search=" + searchTerm %>" 
                   class="btn <%= "all".equals(statusFilter) ? "btn-primary" : "btn-outline-secondary" %>">
                    <i class="fas fa-list"></i> Tất cả
                </a>
                <a href="viewLeaves.jsp?status=Inprogress<%= searchTerm.isEmpty() ? "" : "&search=" + searchTerm %>" 
                   class="btn <%= "Inprogress".equals(statusFilter) ? "btn-primary" : "btn-outline-secondary" %>">
                    <i class="fas fa-clock"></i> Đang chờ duyệt
                </a>
                <a href="viewLeaves.jsp?status=Approved<%= searchTerm.isEmpty() ? "" : "&search=" + searchTerm %>" 
                   class="btn <%= "Approved".equals(statusFilter) ? "btn-primary" : "btn-outline-secondary" %>">
                    <i class="fas fa-check-circle"></i> Đã duyệt
                </a>
                <a href="viewLeaves.jsp?status=Rejected<%= searchTerm.isEmpty() ? "" : "&search=" + searchTerm %>" 
                   class="btn <%= "Rejected".equals(statusFilter) ? "btn-primary" : "btn-outline-secondary" %>">
                    <i class="fas fa-times-circle"></i> Từ chối
                </a>
            </div>
            
            <a href="createLeave.jsp" class="btn btn-success">
                <i class="fas fa-plus"></i> Tạo đơn mới
            </a>
        </div>
    </div>
</div>

<!-- Results -->
<div class="card">
    <div class="card-body">
        <% if (filteredRequests.isEmpty()) { %>
            <div class="empty-state">
                <i class="fas fa-clipboard-list"></i>
                <h3>Không tìm thấy đơn nghỉ phép</h3>
                <p>
                    <%= searchTerm.isEmpty() && "all".equals(statusFilter) ? 
                        "Bạn chưa có đơn nghỉ phép nào." : 
                        "Không có đơn nghỉ phép nào khớp với điều kiện lọc." %>
                </p>
                <a href="createLeave.jsp" class="btn btn-primary">
                    <i class="fas fa-plus"></i> Tạo đơn mới
                </a>
            </div>
        <% } else { %>
            <div class="table-container">
                <table class="table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Nhân viên</th>
                            <% if (user.isAdmin()) { %>
                                <th>Phòng ban</th>
                            <% } %>
                            <th>Từ ngày</th>
                            <th>Đến ngày</th>
                            <th>Lý do</th>
                            <th>Trạng thái</th>
                            <th>Người duyệt</th>
                            <th>Ghi chú</th>
                            <th>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                        for (int i = startIdx; i < endIdx; i++) {
                            LeaveRequest req = filteredRequests.get(i);
                            String badgeClass = "";
                            if ("Inprogress".equals(req.getStatus())) {
                                badgeClass = "badge-warning";
                            } else if ("Approved".equals(req.getStatus())) {
                                badgeClass = "badge-success";
                            } else if ("Rejected".equals(req.getStatus())) {
                                badgeClass = "badge-danger";
                            }
                            
                            String empName = usernames.getOrDefault(req.getUserId(), "ID: " + req.getUserId());
                            String empDept = departments.getOrDefault(req.getUserId(), "");
                        %>
                        <tr>
                            <td><%= req.getId() %></td>
                            <td><%= empName %></td>
                            <% if (user.isAdmin()) { %>
                                <td><%= empDept %></td>
                            <% } %>
                            <td><%= req.getFromDate() %></td>
                            <td><%= req.getToDate() %></td>
                            <td>
                                <% 
                                    String reason = req.getReason();
                                    if (reason.length() > 50) {
                                        reason = reason.substring(0, 50) + "...";
                                    }
                                %>
                                <%= reason %>
                            </td>
                            <td>
                                <span class="badge <%= badgeClass %>">
                                    <%= req.getStatus() %>
                                </span>
                            </td>
                            <td>
                                <% if (req.getProcessedBy() != null) { %>
                                    <%= usernames.getOrDefault(req.getProcessedBy(), "ID: " + req.getProcessedBy()) %>
                                <% } else { %>
                                    <span style="color: var(--text-secondary);">-</span>
                                <% } %>
                            </td>
                            <td>
                                <% if (req.getApprovalNote() != null && !req.getApprovalNote().isEmpty()) { %>
                                    <a href="#" class="note-tooltip" data-note="<%= req.getApprovalNote() %>">
                                        <i class="fas fa-comment-dots"></i> Xem ghi chú
                                    </a>
                                <% } else { %>
                                    <span style="color: var(--text-secondary);">-</span>
                                <% } %>
                            </td>
                            <td>
                                <% if ((user.isManager() || user.isAdmin()) && "Inprogress".equals(req.getStatus())) { %>
                                    <% if (user.isAdmin() || (user.getDepartment().equals(departments.get(req.getUserId())) && req.getUserId() != user.getId())) { %>
                                        <a href="approveLeave.jsp?leaveId=<%= req.getId() %>" class="btn btn-info btn-sm">
                                            <i class="fas fa-check-circle"></i> Duyệt
                                        </a>
                                    <% } else { %>
                                        <span style="color: var(--text-secondary);">-</span>
                                    <% } %>
                                <% } else { %>
                                    <span style="color: var(--text-secondary);">-</span>
                                <% } %>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
            
            <% if (totalPages > 1) { %>
                <ul class="pagination">
                    <li>
                        <a href="viewLeaves.jsp?page=<%= Math.max(1, currentPage - 1) %>&status=<%= statusFilter %><%= searchTerm.isEmpty() ? "" : "&search=" + searchTerm %>" 
                           class="<%= currentPage == 1 ? "disabled" : "" %>">
                            <i class="fas fa-chevron-left"></i>
                        </a>
                    </li>
                    
                    <% 
                    int startPage = Math.max(1, currentPage - 2);
                    int endPage = Math.min(totalPages, startPage + 4);
                    if (endPage - startPage < 4) {
                        startPage = Math.max(1, endPage - 4);
                    }
                    
                    for (int i = startPage; i <= endPage; i++) { 
                    %>
                        <li>
                            <a href="viewLeaves.jsp?page=<%= i %>&status=<%= statusFilter %><%= searchTerm.isEmpty() ? "" : "&search=" + searchTerm %>" 
                               class="<%= (i == currentPage) ? "active" : "" %>">
                                <%= i %>
                            </a>
                        </li>
                    <% } %>
                    
                    <li>
                        <a href="viewLeaves.jsp?page=<%= Math.min(totalPages, currentPage + 1) %>&status=<%= statusFilter %><%= searchTerm.isEmpty() ? "" : "&search=" + searchTerm %>" 
                           class="<%= currentPage == totalPages ? "disabled" : "" %>">
                            <i class="fas fa-chevron-right"></i>
                        </a>
                    </li>
                </ul>
            <% } %>
        <% } %>
    </div>
</div>

<!-- Script for tooltips -->
<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Thêm sự kiện click cho tất cả các note-tooltip
        const tooltips = document.querySelectorAll('.note-tooltip');
        let currentTooltip = null;
        
        // Hàm để đóng tooltip hiện tại
        function closeCurrentTooltip() {
            if (currentTooltip) {
                currentTooltip.style.opacity = '0';
                currentTooltip.style.visibility = 'hidden';
                
                setTimeout(() => {
                    if (currentTooltip && currentTooltip.parentNode) {
                        currentTooltip.parentNode.removeChild(currentTooltip);
                    }
                    currentTooltip = null;
                }, 200);
            }
        }
        
        // Đóng tooltip khi click vào bất kỳ đâu trên trang
        document.addEventListener('click', function(e) {
            if (!e.target.closest('.note-tooltip')) {
                closeCurrentTooltip();
            }
        });
        
        tooltips.forEach(function(tooltipElement) {
            tooltipElement.addEventListener('click', function(e) {
                e.preventDefault(); // Ngăn chặn hành vi mặc định của thẻ a
                e.stopPropagation(); // Ngăn chặn sự kiện lan truyền lên các phần tử cha
                
                // Nếu đã có tooltip hiện tại, đóng nó trước
                closeCurrentTooltip();
                
                const noteText = this.getAttribute('data-note');
                if (!noteText) return; // Đảm bảo có dữ liệu ghi chú
                
                // Tạo phần tử tooltip
                const tooltip = document.createElement('div');
                tooltip.className = 'custom-tooltip';
                tooltip.innerHTML = noteText; // Sử dụng innerHTML thay vì textContent để hỗ trợ định dạng
                document.body.appendChild(tooltip);
                
                // Lấy vị trí của phần tử được nhấp
                const rect = this.getBoundingClientRect();
                
                // Đặt vị trí tooltip ngay dưới phần tử
                tooltip.style.top = (rect.bottom + window.scrollY + 10) + 'px';
                tooltip.style.left = (rect.left + window.scrollX) + 'px';
                
                // Kiểm tra và điều chỉnh vị trí nếu tooltip sẽ vượt ra ngoài màn hình
                setTimeout(() => {
                    const tooltipRect = tooltip.getBoundingClientRect();
                    
                    // Điều chỉnh theo chiều ngang nếu cần
                    if (tooltipRect.right > window.innerWidth) {
                        const newLeft = window.innerWidth - tooltipRect.width - 20;
                        tooltip.style.left = Math.max(20, newLeft) + 'px';
                    }
                    
                    // Điều chỉnh theo chiều dọc nếu cần
                    if (tooltipRect.bottom > window.innerHeight) {
                        tooltip.style.top = (rect.top + window.scrollY - tooltipRect.height - 10) + 'px';
                    }
                }, 0);
                
                // Lưu trữ tham chiếu đến tooltip
                currentTooltip = tooltip;
                
                // Hiển thị tooltip
                setTimeout(() => {
                    tooltip.style.opacity = '1';
                    tooltip.style.visibility = 'visible';
                }, 10);
            });
        });
    });
</script>

<%-- Include Footer --%>
<%@ include file="footer.jsp" %>