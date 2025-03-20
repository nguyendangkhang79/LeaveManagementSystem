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

<!-- Page Header -->
<div class="card">
    <div class="card-header">
        <h2><i class="fas fa-check-circle"></i> Duyệt đơn nghỉ phép</h2>
        
        <a href="viewLeaves.jsp" class="btn btn-outline-primary btn-sm">
            <i class="fas fa-arrow-left"></i> Quay lại danh sách
        </a>
    </div>
</div>

<!-- Leave Request Details -->
<div class="row">
    <div class="col-md-8">
        <div class="card">
            <div class="card-header">
                <h3>Chi tiết đơn nghỉ phép</h3>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label class="form-label">Mã đơn</label>
                            <p style="font-weight: bold;">#<%= req.getId() %></p>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group">
                            <label class="form-label">Trạng thái</label>
                            <span style="background-color: #f39c12; color: white; padding: 5px 10px; border-radius: 20px; font-size: 14px;">
                                <%= req.getStatus() %>
                            </span>
                        </div>
                    </div>
                </div>
                
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label class="form-label">Từ ngày</label>
                            <p style="font-weight: bold;"><%= req.getFromDate() %></p>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group">
                            <label class="form-label">Đến ngày</label>
                            <p style="font-weight: bold;"><%= req.getToDate() %></p>
                        </div>
                    </div>
                </div>
                
                <div class="form-group">
                    <label class="form-label">Số ngày nghỉ</label>
                    <p style="font-weight: bold;"><%= leaveDuration %> ngày</p>
                </div>
                
                <div class="form-group">
                    <label class="form-label">Lý do nghỉ phép</label>
                    <div style="background-color: #f8f9fa; padding: 15px; border-radius: 5px; border: 1px solid #eee;">
                        <%= req.getReason() %>
                    </div>
                </div>
                
                <!-- Phần Quyết định với ghi chú -->
                <div class="form-group" style="margin-top: 30px;">
                    <label class="form-label">Quyết định</label>
                    
                    <!-- Thêm trường ghi chú phê duyệt -->
                    <div class="form-group mb-4">
                        <label for="approvalNote">Ghi chú phê duyệt</label>
                        <textarea class="form-control" id="approvalNote" rows="3" placeholder="Nhập ghi chú về quyết định của bạn (tùy chọn)"></textarea>
                        <small class="text-muted">Ghi chú này sẽ được hiển thị cho nhân viên khi xem trạng thái đơn.</small>
                    </div>
                    
                    <div style="display: flex; gap: 15px;">
                        <form action="leaveRequest" method="post" onsubmit="return copyNoteToForm('approve')">
                            <input type="hidden" name="action" value="approve">
                            <input type="hidden" name="leaveId" value="<%= req.getId() %>">
                            <input type="hidden" name="approvalNote" id="approveNote">
                            <button type="submit" class="btn btn-success" style="min-width: 150px;">
                                <i class="fas fa-check"></i> Phê duyệt
                            </button>
                        </form>
                        
                        <form action="leaveRequest" method="post" onsubmit="return copyNoteToForm('reject')">
                            <input type="hidden" name="action" value="reject">
                            <input type="hidden" name="leaveId" value="<%= req.getId() %>">
                            <input type="hidden" name="approvalNote" id="rejectNote">
                            <button type="submit" class="btn btn-danger" style="min-width: 150px;">
                                <i class="fas fa-times"></i> Từ chối
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <div class="col-md-4">
        <div class="card">
            <div class="card-header">
                <h3>Thông tin nhân viên</h3>
            </div>
            <div class="card-body">
                <div class="form-group">
                    <label class="form-label">Họ tên</label>
                    <p style="font-weight: bold;"><%= employeeName %></p>
                </div>
                
                <div class="form-group">
                    <label class="form-label">Phòng ban</label>
                    <p><%= employeeDepartment %></p>
                </div>
                
                <div class="form-group">
                    <label class="form-label">Mã nhân viên</label>
                    <p>#<%= req.getUserId() %></p>
                </div>
                
                <div class="form-group">
                    <label class="form-label">Vai trò</label>
                    <p><%= employee != null ? employee.getRole() : "Unknown" %></p>
                </div>
            </div>
        </div>
        
        <div class="card mt-4">
            <div class="card-header">
                <h3>Thống kê ngày nghỉ</h3>
            </div>
            <div class="card-body">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px; padding-bottom: 10px; border-bottom: 1px solid #eee;">
                    <span>Tổng ngày nghỉ trong năm</span>
                    <span style="padding: 2px 10px; background-color: #3498db; color: white; border-radius: 20px; font-size: 14px;">12 ngày</span>
                </div>
                
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px; padding-bottom: 10px; border-bottom: 1px solid #eee;">
                    <span>Đã sử dụng</span>
                    <span style="padding: 2px 10px; background-color: #95a5a6; color: white; border-radius: 20px; font-size: 14px;">5 ngày</span>
                </div>
                
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px;">
                    <span>Còn lại</span>
                    <span style="padding: 2px 10px; background-color: #2ecc71; color: white; border-radius: 20px; font-size: 14px;">7 ngày</span>
                </div>
                
                <div style="background-color: #f8f9fc; padding: 10px; border-radius: 5px; margin-top: 15px; font-size: 13px;">
                    <i class="fas fa-info-circle"></i> Đơn này đăng ký nghỉ <strong><%= leaveDuration %> ngày</strong>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Leave History -->
<div class="card mt-4">
    <div class="card-header">
        <h3><i class="fas fa-history"></i> Lịch sử nghỉ phép</h3>
    </div>
    <div class="card-body">
        <div style="padding: 30px 0; text-align: center; color: #777;">
            <i class="fas fa-info-circle" style="font-size: 24px; margin-bottom: 10px; display: block;"></i>
            Tính năng xem lịch sử nghỉ phép sẽ được phát triển trong phiên bản tiếp theo.
        </div>
    </div>
</div>

<!-- Script để sao chép ghi chú vào form tương ứng -->
<script>
    function copyNoteToForm(action) {
        var noteValue = document.getElementById('approvalNote').value;
        if (action === 'approve') {
            document.getElementById('approveNote').value = noteValue;
        } else {
            document.getElementById('rejectNote').value = noteValue;
        }
        return true;
    }
</script>

<%-- Include Footer --%>
<%@ include file="footer.jsp" %>