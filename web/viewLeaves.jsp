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

<!-- Page Header -->
<div class="card">
    <div class="card-header">
        <h2><i class="fas fa-list"></i> Danh sách đơn nghỉ phép</h2>
        
        <!-- Search Box -->
        <div class="search-box">
            <form action="viewLeaves.jsp" method="get">
                <div class="input-group">
                    <i class="fas fa-search" style="position: absolute; left: 10px; top: 10px; color: #777;"></i>
                    <input type="text" name="search" value="<%= searchTerm %>" 
                           class="form-control" placeholder="Tìm kiếm theo ID hoặc lý do..." 
                           style="padding-left: 35px;">
                    <input type="hidden" name="status" value="<%= statusFilter %>">
                    <button type="submit" class="btn btn-primary" style="margin-left: 10px;">Tìm kiếm</button>
                    <% if (!searchTerm.isEmpty()) { %>
                        <a href="viewLeaves.jsp?status=<%= statusFilter %>" class="btn btn-secondary" style="margin-left: 5px;">Xóa</a>
                    <% } %>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Filters -->
<div class="card">
    <div class="card-body" style="padding: 15px;">
        <div style="display: flex; flex-wrap: wrap; align-items: center; justify-content: space-between;">
            <div style="display: flex; gap: 10px; margin-bottom: 10px;">
                <a href="viewLeaves.jsp?status=all<%= searchTerm.isEmpty() ? "" : "&search=" + searchTerm %>" 
                   class="btn <%= "all".equals(statusFilter) ? "btn-primary" : "btn-outline-secondary" %>">
                    Tất cả
                </a>
                <a href="viewLeaves.jsp?status=Inprogress<%= searchTerm.isEmpty() ? "" : "&search=" + searchTerm %>" 
                   class="btn <%= "Inprogress".equals(statusFilter) ? "btn-primary" : "btn-outline-secondary" %>">
                    Đang chờ duyệt
                </a>
                <a href="viewLeaves.jsp?status=Approved<%= searchTerm.isEmpty() ? "" : "&search=" + searchTerm %>" 
                   class="btn <%= "Approved".equals(statusFilter) ? "btn-primary" : "btn-outline-secondary" %>">
                    Đã duyệt
                </a>
                <a href="viewLeaves.jsp?status=Rejected<%= searchTerm.isEmpty() ? "" : "&search=" + searchTerm %>" 
                   class="btn <%= "Rejected".equals(statusFilter) ? "btn-primary" : "btn-outline-secondary" %>">
                    Từ chối
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
            <div style="text-align: center; padding: 50px 20px;">
                <i class="fas fa-clipboard-list" style="font-size: 3rem; color: #ddd; margin-bottom: 20px;"></i>
                <h3>Không tìm thấy đơn nghỉ phép</h3>
                <p style="color: #777; margin-bottom: 20px;">
                    <%= searchTerm.isEmpty() && "all".equals(statusFilter) ? 
                        "Bạn chưa có đơn nghỉ phép nào." : 
                        "Không có đơn nghỉ phép nào khớp với điều kiện lọc." %>
                </p>
                <a href="createLeave.jsp" class="btn btn-primary">
                    <i class="fas fa-plus"></i> Tạo đơn mới
                </a>
            </div>
        <% } else { %>
            <div style="overflow-x: auto;">
                <table class="table table-striped table-hover">
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
                            <td><%= req.getReason() %></td>
                            <td>
                                <span class="badge <%= badgeClass %>" style="padding: 5px 10px; border-radius: 20px;">
                                    <%= req.getStatus() %>
                                </span>
                            </td>
                            <td>
                                <% if (req.getProcessedBy() != null) { %>
                                    <%= usernames.getOrDefault(req.getProcessedBy(), "ID: " + req.getProcessedBy()) %>
                                <% } else { %>
                                    <span style="color: #999;">-</span>
                                <% } %>
                            </td>
                            <td>
                                <% if ((user.isManager() || user.isAdmin()) && "Inprogress".equals(req.getStatus())) { %>
                                    <% if (user.isAdmin() || user.getDepartment().equals(departments.get(req.getUserId()))) { %>
                                        <a href="approveLeave.jsp?leaveId=<%= req.getId() %>" class="btn btn-sm btn-info">
                                            <i class="fas fa-check-circle"></i> Duyệt
                                        </a>
                                    <% } else { %>
                                        <span style="color: #999;">-</span>
                                    <% } %>
                                <% } else { %>
                                    <span style="color: #999;">-</span>
                                <% } %>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
            
            <% if (totalPages > 1) { %>
                <div style="display: flex; justify-content: center; margin-top: 20px;">
                    <ul style="display: flex; list-style: none; padding: 0;">
                        <li style="margin: 0 5px;">
                            <a href="viewLeaves.jsp?page=<%= Math.max(1, currentPage - 1) %>&status=<%= statusFilter %><%= searchTerm.isEmpty() ? "" : "&search=" + searchTerm %>" 
                               style="padding: 8px 12px; border: 1px solid #ddd; border-radius: 4px; text-decoration: none; <%= currentPage == 1 ? "color: #999;" : "" %>">
                                &laquo;
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
                            <li style="margin: 0 5px;">
                                <a href="viewLeaves.jsp?page=<%= i %>&status=<%= statusFilter %><%= searchTerm.isEmpty() ? "" : "&search=" + searchTerm %>" 
                                   style="padding: 8px 12px; border: 1px solid <%= (i == currentPage) ? "#3498db" : "#ddd" %>; 
                                         background-color: <%= (i == currentPage) ? "#3498db" : "transparent" %>; 
                                         color: <%= (i == currentPage) ? "white" : "#333" %>; 
                                         border-radius: 4px; text-decoration: none;">
                                    <%= i %>
                                </a>
                            </li>
                        <% } %>
                        
                        <li style="margin: 0 5px;">
                            <a href="viewLeaves.jsp?page=<%= Math.min(totalPages, currentPage + 1) %>&status=<%= statusFilter %><%= searchTerm.isEmpty() ? "" : "&search=" + searchTerm %>" 
                               style="padding: 8px 12px; border: 1px solid #ddd; border-radius: 4px; text-decoration: none; <%= currentPage == totalPages ? "color: #999;" : "" %>">
                                &raquo;
                            </a>
                        </li>
                    </ul>
                </div>
            <% } %>
        <% } %>
    </div>
</div>

<%-- Include Footer --%>
<%@ include file="footer.jsp" %>