<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.LeaveRequestDAO, dao.UserDAO, model.LeaveRequest, model.User, java.util.List, java.time.LocalDate, java.time.temporal.ChronoUnit" %>

<%-- Include Header --%>
<%@ include file="header.jsp" %>

<%
    // Security check: Only managers and admins can access this page
    if (user == null || (!user.isManager() && !user.isAdmin())) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Get leave request ID from parameter
    int leaveId = 0;
    try {
        leaveId = Integer.parseInt(request.getParameter("leaveId"));
    } catch (NumberFormatException e) {
        // Invalid ID parameter
        response.sendRedirect("viewLeaves.jsp");
        return;
    }
    
    // Get the leave request details
    LeaveRequestDAO dao = new LeaveRequestDAO();
    UserDAO userDAO = new UserDAO();
    
    // For admin, get all requests or for regular manager get filtered requests
    LeaveRequest req = null;
    if (user.isAdmin()) {
        req = dao.getLeaveRequestById(leaveId);
    } else {
        List<LeaveRequest> requests = dao.getLeaveRequestsByUserId(user.getId());
        for (LeaveRequest r : requests) {
            if (r.getId() == leaveId) {
                req = r;
                break;
            }
        }
    }
    
    // If request not found or not in "Inprogress" status, redirect back to list
    if (req == null || !"Inprogress".equals(req.getStatus())) {
        response.sendRedirect("viewLeaves.jsp");
        return;
    }
    
    // For regular managers, check if they manage the employee's department
    if (!user.isAdmin()) {
        User employee = userDAO.getUserById(req.getUserId());
        if (employee == null || !user.getDepartment().equals(employee.getDepartment())) {
            response.sendRedirect("viewLeaves.jsp");
            return;
        }
    }
    
    // Get employee information
    User employee = userDAO.getUserById(req.getUserId());
    String employeeName = (employee != null) ? employee.getUsername() : "Unknown Employee";
    String employeeDepartment = (employee != null) ? employee.getDepartment() : "Unknown Department";
    
    // Calculate leave duration
    long leaveDuration = ChronoUnit.DAYS.between(
        req.getFromDate().toLocalDate(),
        req.getToDate().toLocalDate()
    ) + 1; // inclusive of both start and end dates
%>

<style>
    /* Enhanced styles for approval page */
    .approval-container {
        margin-bottom: 30px;
    }
    
    .card {
        border: none;
        border-radius: 12px;
        box-shadow: 0 5px 15px rgba(0, 0, 0, 0.08);
        margin-bottom: 24px;
        overflow: hidden;
        transition: transform 0.2s, box-shadow 0.2s;
    }
    
    .card:hover {
        box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
    }
    
    .card-header {
        background-color: var(--card-bg-color);
        border-bottom: 1px solid var(--border-color);
        padding: 20px 24px;
    }
    
    .card-header h3 {
        margin: 0;
        font-size: 18px;
        font-weight: 600;
        display: flex;
        align-items: center;
    }
    
    .card-header h3 i {
        margin-right: 10px;
        color: var(--primary-color);
    }
    
    .card-body {
        padding: 24px;
    }
    
    .info-item {
        margin-bottom: 16px;
        display: flex;
        flex-wrap: wrap;
    }
    
    .info-label {
        width: 180px;
        font-weight: 600;
        color: var(--text-secondary);
        margin-bottom: 6px;
    }
    
    .info-value {
        flex: 1;
        min-width: 200px;
        font-weight: 500;
    }
    
    .badge {
        padding: 6px 12px;
        border-radius: 20px;
        font-weight: 500;
        font-size: 12px;
        display: inline-block;
    }
    
    .badge-warning {
        background-color: #fff3cd;
        color: #856404;
        border: 1px solid #ffeeba;
    }
    
    .request-badge {
        font-size: 14px;
        padding: 8px 16px;
    }
    
    .reason-box {
        background-color: #f8f9fa;
        padding: 16px;
        border-radius: 8px;
        margin-top: 8px;
        border-left: 4px solid #dee2e6;
    }
    
    .approval-form {
        margin-top: 24px;
        padding: 24px;
        background-color: #f8f9fc;
        border-radius: 12px;
    }
    
    .form-group {
        margin-bottom: 20px;
    }
    
    .form-label {
        font-weight: 600;
        margin-bottom: 8px;
        display: block;
    }
    
    .form-control {
        width: 100%;
        padding: 12px 16px;
        font-size: 14px;
        border: 1px solid #ced4da;
        border-radius: 8px;
        transition: border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
    }
    
    .form-control:focus {
        border-color: var(--primary-color);
        box-shadow: 0 0 0 0.25rem rgba(13, 110, 253, 0.25);
        outline: 0;
    }
    
    textarea.form-control {
        min-height: 120px;
        resize: vertical;
    }
    
    .text-muted {
        color: #6c757d;
        font-size: 13px;
        margin-top: 6px;
    }
    
    .action-buttons {
        display: flex;
        gap: 16px;
        margin-top: 24px;
    }
    
    .btn {
        padding: 12px 24px;
        font-size: 15px;
        font-weight: 500;
        border-radius: 8px;
        cursor: pointer;
        border: none;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        transition: all 0.2s;
        min-width: 160px;
    }
    
    .btn i {
        margin-right: 8px;
        font-size: 16px;
    }
    
    .btn-success {
        background-color: #28a745;
        color: white;
    }
    
    .btn-success:hover {
        background-color: #218838;
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(40, 167, 69, 0.2);
    }
    
    .btn-danger {
        background-color: #dc3545;
        color: white;
    }
    
    .btn-danger:hover {
        background-color: #c82333;
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(220, 53, 69, 0.2);
    }
    
    .btn-outline-primary {
        background-color: transparent;
        border: 1px solid var(--primary-color);
        color: var(--primary-color);
    }
    
    .btn-outline-primary:hover {
        background-color: var(--primary-color);
        color: white;
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(13, 110, 253, 0.2);
    }
    
    .nav-link-back {
        display: inline-flex;
        align-items: center;
        color: var(--primary-color);
        text-decoration: none;
        font-weight: 500;
        margin-bottom: 20px;
        transition: color 0.2s;
    }
    
    .nav-link-back:hover {
        color: var(--secondary-color);
    }
    
    .nav-link-back i {
        margin-right: 8px;
    }
    
    .approval-notes {
        background-color: #fff;
        border: 1px solid #e9ecef;
        border-radius: 8px;
        padding: 20px;
        margin-bottom: 20px;
    }
    
    .approval-notes h4 {
        margin-top: 0;
        margin-bottom: 16px;
        font-size: 16px;
        font-weight: 600;
        display: flex;
        align-items: center;
    }
    
    .approval-notes h4 i {
        margin-right: 8px;
        color: var(--primary-color);
    }
    
    .employee-stats {
        display: flex;
        flex-wrap: wrap;
        gap: 15px;
        margin: 20px 0;
    }
    
    .stat-item {
        flex: 1;
        min-width: 150px;
        padding: 15px;
        background-color: #fff;
        border-radius: 8px;
        text-align: center;
        border: 1px solid #e9ecef;
    }
    
    .stat-label {
        font-size: 13px;
        color: #6c757d;
        margin-bottom: 5px;
    }
    
    .stat-value {
        font-size: 24px;
        font-weight: 600;
        color: var(--primary-color);
    }
    
    .leave-alert {
        padding: 12px 16px;
        background-color: #e8f4fd;
        border-left: 4px solid #3498db;
        border-radius: 4px;
        margin: 16px 0;
        display: flex;
        align-items: flex-start;
    }
    
    .leave-alert i {
        color: #3498db;
        margin-right: 12px;
        font-size: 18px;
        margin-top: 2px;
    }
    
    /* Page header */
    .page-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 24px;
        padding-bottom: 16px;
        border-bottom: 1px solid var(--border-color);
    }
    
    .page-title {
        font-size: 24px;
        font-weight: 600;
        margin: 0;
        color: var(--text-color);
        display: flex;
        align-items: center;
    }
    
    .page-title i {
        margin-right: 12px;
        color: var(--primary-color);
    }
    
    @media (max-width: 768px) {
        .info-label, .info-value {
            width: 100%;
        }
        
        .action-buttons {
            flex-direction: column;
        }
        
        .btn {
            width: 100%;
        }
    }
    
    /* Modal Popup Styles */
    .modal-overlay {
        display: none;
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(0, 0, 0, 0.5);
        z-index: 1000;
        justify-content: center;
        align-items: center;
        opacity: 0;
        transition: opacity 0.3s ease;
    }
    
    @keyframes fadeIn {
        from { opacity: 0; }
        to { opacity: 1; }
    }
    
    @keyframes floatCircle {
        0% { transform: translate(0, 0) rotate(0deg); }
        25% { transform: translate(10px, -10px) rotate(5deg); }
        50% { transform: translate(0, 5px) rotate(0deg); }
        75% { transform: translate(-10px, -5px) rotate(-5deg); }
        100% { transform: translate(0, 0) rotate(0deg); }
    }
    
    .modal-container {
        background-color: var(--card-bg-color);
        width: 90%;
        max-width: 480px;
        border-radius: 12px;
        overflow: hidden;
        box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
        animation: slideIn 0.4s ease forwards;
        position: relative;
    }
    
    @keyframes slideIn {
        from { transform: translateY(-50px); opacity: 0; }
        to { transform: translateY(0); opacity: 1; }
    }
    
    .modal-header {
        position: relative;
        padding: 0;
        height: 120px;
        display: flex;
        align-items: center;
        justify-content: center;
        overflow: hidden;
    }
    
    .modal-header-success {
        background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
    }
    
    .modal-header-reject {
        background: linear-gradient(135deg, #dc3545 0%, #fd7e14 100%);
    }
    
    .modal-icon {
        position: relative;
        z-index: 2;
        width: 80px;
        height: 80px;
        border-radius: 50%;
        background-color: white;
        display: flex;
        align-items: center;
        justify-content: center;
        box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
    }
    
    .modal-icon i {
        font-size: 36px;
    }
    
    .modal-icon-success i {
        color: #28a745;
    }
    
    .modal-icon-reject i {
        color: #dc3545;
    }
    
    .modal-circles {
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        overflow: hidden;
    }
    
    .modal-circle {
        position: absolute;
        background-color: rgba(255, 255, 255, 0.1);
        border-radius: 50%;
    }
    
    .modal-body {
        padding: 30px 24px;
        text-align: center;
    }
    
    .modal-title {
        font-size: 22px;
        font-weight: 600;
        margin-bottom: 16px;
        color: var(--text-color);
    }
    
    .modal-message {
        color: var(--text-secondary);
        font-size: 16px;
        line-height: 1.6;
        margin-bottom: 24px;
    }
    
    .modal-info {
        background-color: rgba(0, 0, 0, 0.03);
        border-radius: 8px;
        padding: 16px;
        margin-bottom: 24px;
        text-align: left;
    }
    
    .modal-info-item {
        display: flex;
        margin-bottom: 8px;
    }
    
    .modal-info-label {
        min-width: 120px;
        font-weight: 600;
        color: var(--text-secondary);
    }
    
    .modal-info-value {
        font-weight: 500;
    }
    
    .modal-footer {
        padding: 20px 24px;
        text-align: center;
        border-top: 1px solid var(--border-color);
    }
    
    .modal-btn {
        padding: 12px 24px;
        font-size: 16px;
        font-weight: 500;
        border-radius: 8px;
        border: none;
        cursor: pointer;
        min-width: 150px;
        transition: all 0.2s;
    }
    
    .modal-btn-success {
        background-color: #28a745;
        color: white;
    }
    
    .modal-btn-success:hover {
        background-color: #218838;
        box-shadow: 0 4px 10px rgba(40, 167, 69, 0.3);
    }
    
    .modal-btn-reject {
        background-color: #dc3545;
        color: white;
    }
    
    .modal-btn-reject:hover {
        background-color: #c82333;
        box-shadow: 0 4px 10px rgba(220, 53, 69, 0.3);
    }
    
    .modal-btn-outline {
        background-color: transparent;
        border: 1px solid var(--border-color);
        color: var(--text-color);
        margin-left: 12px;
    }
    
    .modal-btn-outline:hover {
        background-color: rgba(0, 0, 0, 0.03);
    }
    
    .modal-close {
        position: absolute;
        top: 15px;
        right: 15px;
        width: 30px;
        height: 30px;
        border-radius: 50%;
        background-color: rgba(255, 255, 255, 0.3);
        display: flex;
        align-items: center;
        justify-content: center;
        cursor: pointer;
        z-index: 3;
        border: none;
        color: white;
        font-size: 16px;
        transition: background-color 0.2s;
    }
    
    .modal-close:hover {
        background-color: rgba(255, 255, 255, 0.4);
    }
</style>

<!-- Page Navigation -->
<a href="viewLeaves.jsp" class="nav-link-back">
    <i class="fas fa-arrow-left"></i> Quay lại danh sách đơn
</a>

<!-- Page Header -->
<div class="page-header">
    <h2 class="page-title">
        <i class="fas fa-clipboard-check"></i> Phê duyệt đơn nghỉ phép
    </h2>
</div>

<div class="approval-container">
    <div class="row">
        <div class="col-md-8">
            <!-- Leave Request Details Card -->
            <div class="card">
                <div class="card-header">
                    <h3><i class="fas fa-info-circle"></i> Chi tiết đơn nghỉ phép</h3>
                </div>
                <div class="card-body">
                    <div class="info-item">
                        <div class="info-label">Mã đơn</div>
                        <div class="info-value">#<%= req.getId() %></div>
                    </div>
                    
                    <div class="info-item">
                        <div class="info-label">Trạng thái</div>
                        <div class="info-value">
                            <span class="badge badge-warning request-badge">
                                <i class="fas fa-hourglass-half"></i> <%= req.getStatus() %>
                            </span>
                        </div>
                    </div>
                    
                    <div class="info-item">
                        <div class="info-label">Thời gian nghỉ</div>
                        <div class="info-value">
                            <div><strong>Từ ngày:</strong> <%= req.getFromDate() %></div>
                            <div><strong>Đến ngày:</strong> <%= req.getToDate() %></div>
                            <div><strong>Tổng số ngày:</strong> <%= leaveDuration %> ngày</div>
                        </div>
                    </div>
                    
                    <div class="info-item">
                        <div class="info-label">Lý do nghỉ phép</div>
                        <div class="info-value">
                            <div class="reason-box">
                                <%= req.getReason() %>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Approval Decision Form -->
                    <div class="approval-notes">
                        <h4><i class="fas fa-comment-dots"></i> Ghi chú phê duyệt</h4>
                        <div class="form-group">
                            <textarea class="form-control" id="approvalNote" rows="4" placeholder="Nhập ghi chú về quyết định của bạn (tùy chọn)"></textarea>
                            <div class="text-muted">
                                <i class="fas fa-info-circle"></i> Ghi chú này sẽ được hiển thị cho nhân viên khi xem trạng thái đơn.
                            </div>
                        </div>
                        
                        <div class="action-buttons">
                            <form action="leaveRequest" method="post" onsubmit="return copyNoteToForm('approve')">
                                <input type="hidden" name="action" value="approve">
                                <input type="hidden" name="leaveId" value="<%= req.getId() %>">
                                <input type="hidden" name="approvalNote" id="approveNote">
                                <button type="button" class="btn btn-success" id="approveBtn">
                                    <i class="fas fa-check-circle"></i> Phê duyệt
                                </button>
                            </form>
                            
                            <form action="leaveRequest" method="post" onsubmit="return copyNoteToForm('reject')">
                                <input type="hidden" name="action" value="reject">
                                <input type="hidden" name="leaveId" value="<%= req.getId() %>">
                                <input type="hidden" name="approvalNote" id="rejectNote">
                                <button type="button" class="btn btn-danger" id="rejectBtn">
                                    <i class="fas fa-times-circle"></i> Từ chối
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="col-md-4">
            <!-- Employee Information Card -->
            <div class="card">
                <div class="card-header">
                    <h3><i class="fas fa-user"></i> Thông tin nhân viên</h3>
                </div>
                <div class="card-body">
                    <div class="info-item">
                        <div class="info-label">Họ tên</div>
                        <div class="info-value"><strong><%= employeeName %></strong></div>
                    </div>
                    
                    <div class="info-item">
                        <div class="info-label">Phòng ban</div>
                        <div class="info-value"><%= employeeDepartment %></div>
                    </div>
                    
                    <div class="info-item">
                        <div class="info-label">Mã nhân viên</div>
                        <div class="info-value">#<%= req.getUserId() %></div>
                    </div>
                    
                    <div class="info-item">
                        <div class="info-label">Vai trò</div>
                        <div class="info-value"><%= employee != null ? employee.getRole() : "Unknown" %></div>
                    </div>
                </div>
            </div>
            
            <!-- Leave Statistics Card -->
            <div class="card">
                <div class="card-header">
                    <h3><i class="fas fa-chart-bar"></i> Thống kê ngày nghỉ</h3>
                </div>
                <div class="card-body">
                    <div class="employee-stats">
                        <div class="stat-item">
                            <div class="stat-label">Tổng ngày nghỉ</div>
                            <div class="stat-value">12</div>
                        </div>
                        
                        <div class="stat-item">
                            <div class="stat-label">Đã sử dụng</div>
                            <div class="stat-value">5</div>
                        </div>
                        
                        <div class="stat-item">
                            <div class="stat-label">Còn lại</div>
                            <div class="stat-value">7</div>
                        </div>
                    </div>
                    
                    <div class="leave-alert">
                        <i class="fas fa-info-circle"></i>
                        <div>
                            Đơn này đăng ký nghỉ <strong><%= leaveDuration %> ngày</strong>. Nhân viên sẽ còn lại 
                            <strong><%= 7 - leaveDuration < 0 ? 0 : 7 - leaveDuration %> ngày</strong> nếu được phê duyệt.
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Success Modal -->
<div class="modal-overlay" id="successModal">
    <div class="modal-container">
        <div class="modal-header modal-header-success">
            <button class="modal-close" onclick="closeAndRedirect()">×</button>
            <div class="modal-icon modal-icon-success">
                <i class="fas fa-check"></i>
            </div>
            <div class="modal-circles">
                <div class="modal-circle" style="width: 120px; height: 120px; top: -30px; left: -30px; opacity: 0.2;"></div>
                <div class="modal-circle" style="width: 160px; height: 160px; bottom: -40px; right: -30px; opacity: 0.2;"></div>
                <div class="modal-circle" style="width: 80px; height: 80px; bottom: 20px; left: 40%; opacity: 0.1;"></div>
            </div>
        </div>
        <div class="modal-body">
            <h3 class="modal-title">Phê duyệt thành công!</h3>
            <p class="modal-message">Đơn nghỉ phép đã được phê duyệt. Nhân viên sẽ nhận được thông báo về quyết định của bạn.</p>
            
            <div class="modal-info">
                <div class="modal-info-item">
                    <div class="modal-info-label">Mã đơn:</div>
                    <div class="modal-info-value">#<%= req.getId() %></div>
                </div>
                <div class="modal-info-item">
                    <div class="modal-info-label">Nhân viên:</div>
                    <div class="modal-info-value"><%= employeeName %></div>
                </div>
                <div class="modal-info-item">
                    <div class="modal-info-label">Trạng thái mới:</div>
                    <div class="modal-info-value" style="color: #28a745; font-weight: 600;">Approved</div>
                </div>
            </div>
        </div>
        <div class="modal-footer">
            <button class="modal-btn modal-btn-success" onclick="completeApproval(true)">
                <i class="fas fa-check"></i> Xác nhận
            </button>
            <button class="modal-btn modal-btn-outline" onclick="closeAndRedirect()">
                <i class="fas fa-times"></i> Đóng
            </button>
        </div>
    </div>
</div>

<!-- Reject Modal -->
<div class="modal-overlay" id="rejectModal">
    <div class="modal-container">
        <div class="modal-header modal-header-reject">
            <button class="modal-close" onclick="closeAndRedirect()">×</button>
            <div class="modal-icon modal-icon-reject">
                <i class="fas fa-times"></i>
            </div>
            <div class="modal-circles">
                <div class="modal-circle" style="width: 120px; height: 120px; top: -30px; left: -30px; opacity: 0.2;"></div>
                <div class="modal-circle" style="width: 160px; height: 160px; bottom: -40px; right: -30px; opacity: 0.2;"></div>
                <div class="modal-circle" style="width: 80px; height: 80px; bottom: 20px; left: 40%; opacity: 0.1;"></div>
            </div>
        </div>
        <div class="modal-body">
            <h3 class="modal-title">Từ chối đơn nghỉ phép?</h3>
            <p class="modal-message">Bạn có chắc chắn muốn từ chối đơn nghỉ phép này không?</p>
            
            <div class="modal-info">
                <div class="modal-info-item">
                    <div class="modal-info-label">Mã đơn:</div>
                    <div class="modal-info-value">#<%= req.getId() %></div>
                </div>
                <div class="modal-info-item">
                    <div class="modal-info-label">Nhân viên:</div>
                    <div class="modal-info-value"><%= employeeName %></div>
                </div>
                <div class="modal-info-item">
                    <div class="modal-info-label">Trạng thái mới:</div>
                    <div class="modal-info-value" style="color: #dc3545; font-weight: 600;">Rejected</div>
                </div>
            </div>
        </div>
        <div class="modal-footer">
<button class="modal-btn modal-btn-reject" onclick="completeApproval(false)">
                <i class="fas fa-times"></i> Xác nhận từ chối
            </button>
            <button class="modal-btn modal-btn-outline" onclick="closeAndRedirect()">
                <i class="fas fa-times"></i> Đóng
            </button>
        </div>
    </div>
</div>

<!-- Script để xử lý hiển thị popup khi nhấn nút duyệt/từ chối -->
<script>
document.addEventListener('DOMContentLoaded', function() {
    // Tìm các nút phê duyệt và từ chối
    const approveButton = document.getElementById('approveBtn');
    const rejectButton = document.getElementById('rejectBtn');
    
    // Ngăn form submit mặc định để hiển thị popup trước
    if (approveButton) {
        approveButton.addEventListener('click', function(e) {
            e.preventDefault();
            // Lưu giá trị note từ textarea
            document.getElementById('approveNote').value = document.getElementById('approvalNote').value;
            // Hiển thị modal thành công
            showModal('successModal');
            return false;
        });
    }
    
    if (rejectButton) {
        rejectButton.addEventListener('click', function(e) {
            e.preventDefault();
            // Lưu giá trị note từ textarea
            document.getElementById('rejectNote').value = document.getElementById('approvalNote').value;
            // Hiển thị modal từ chối
            showModal('rejectModal');
            return false;
        });
    }
});

// Hiển thị modal
function showModal(modalId) {
    const modal = document.getElementById(modalId);
    if (modal) {
        modal.style.display = 'flex';
        setTimeout(function() {
            modal.style.opacity = '1';
        }, 10);
    }
}

// Đóng modal
function closeModal(modalId) {
    const modal = document.getElementById(modalId);
    if (modal) {
        modal.style.opacity = '0';
        setTimeout(function() {
            modal.style.display = 'none';
        }, 300);
    }
}

// Chuyển hướng đến danh sách sau khi xử lý
function redirectToList() {
    window.location.href = 'viewLeaves.jsp';
}

// Đóng modal và chuyển về trang danh sách
function closeAndRedirect() {
    closeModal('successModal');
    closeModal('rejectModal');
    window.location.href = 'viewLeaves.jsp';
}

// Hoàn tất quá trình phê duyệt và submit form
function completeApproval(isApprove) {
    // Lấy form tương ứng
    const formAction = isApprove ? 'approve' : 'reject';
    const forms = document.querySelectorAll('form');
    
    // Tìm form có action phù hợp
    for (let i = 0; i < forms.length; i++) {
        if (forms[i].querySelector('input[name="action"][value="' + formAction + '"]')) {
            forms[i].submit();
            break;
        }
    }
}

// Copy note to form input
function copyNoteToForm(action) {
    var note = document.getElementById('approvalNote').value;
    if (action === 'approve') {
        document.getElementById('approveNote').value = note;
    } else if (action === 'reject') {
        document.getElementById('rejectNote').value = note;
    }
    return true;
}
</script>

<%@ include file="footer.jsp" %>