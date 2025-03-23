<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User, java.time.LocalDate, java.time.format.DateTimeFormatter" %>

<%-- Include Header --%>
<%@ include file="header.jsp" %>

<%
    // Get current date and default end date (7 days later) for form defaults
    LocalDate currentDate = LocalDate.now();
    LocalDate defaultEndDate = currentDate.plusDays(7);
    
    String fromDateValue = currentDate.toString();
    String toDateValue = defaultEndDate.toString();
    
    DateTimeFormatter displayFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
%>

<!-- Custom Styles for this page -->
<style>
    .leave-form-card {
        border: none;
        border-radius: 0.75rem;
        box-shadow: 0 0.5rem 1.5rem rgba(0, 0, 0, 0.08);
        overflow: hidden;
        background-color: var(--card-bg-color);
        transition: all 0.3s ease;
    }
    
    .leave-form-header {
        background-color: var(--primary-color);
        padding: 1.5rem;
        color: #fff;
        position: relative;
        overflow: hidden;
    }
    
    .leave-form-header h2 {
        margin: 0;
        font-weight: 600;
        display: flex;
        align-items: center;
        position: relative;
        z-index: 2;
    }
    
    .leave-form-header h2 i {
        background-color: rgba(255, 255, 255, 0.2);
        width: 40px;
        height: 40px;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        margin-right: 12px;
    }
    
    .leave-form-header::after {
        content: "";
        position: absolute;
        top: -50%;
        right: -20%;
        width: 300px;
        height: 300px;
        background: radial-gradient(circle, rgba(255,255,255,0.2) 0%, rgba(255,255,255,0) 70%);
        border-radius: 50%;
        z-index: 1;
    }
    
    .leave-form-body {
        padding: 2rem;
    }
    
    .form-group {
        margin-bottom: 1.5rem;
    }
    
    .form-group label {
        display: block;
        font-weight: 500;
        margin-bottom: 0.5rem;
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
    
    .date-input-container {
        position: relative;
    }
    
    .date-input-container .form-control {
        padding-left: 3rem;
    }
    
    .date-input-icon {
        position: absolute;
        left: 1rem;
        top: 50%;
        transform: translateY(-50%);
        color: var(--primary-color);
        font-size: 1.2rem;
    }
    
    textarea.form-control {
        min-height: 120px;
        resize: vertical;
    }
    
    .form-text {
        display: block;
        margin-top: 0.5rem;
        font-size: 0.875rem;
        color: var(--text-secondary);
    }
    
    .notice-box {
        padding: 1.25rem;
        margin: 1.5rem 0;
        border-radius: 0.5rem;
        position: relative;
        padding-left: 4rem;
    }
    
    .notice-box.info {
        background-color: rgba(33, 150, 243, 0.08);
        border-left: 4px solid var(--primary-color);
    }
    
    .notice-box .icon {
        position: absolute;
        left: 1.25rem;
        top: 1.25rem;
        width: 2rem;
        height: 2rem;
        display: flex;
        align-items: center;
        justify-content: center;
        border-radius: 50%;
    }
    
    .notice-box.info .icon {
        background-color: var(--primary-color);
        color: white;
    }
    
    .leave-duration-summary {
        background-color: rgba(52, 152, 219, 0.08);
        border-radius: 0.5rem;
        padding: 1.5rem;
        margin: 1.5rem 0;
    }
    
    .leave-duration-summary h4 {
        margin-top: 0;
        margin-bottom: 1.25rem;
        color: var(--text-color);
        display: flex;
        align-items: center;
    }
    
    .leave-duration-summary h4 i {
        margin-right: 0.75rem;
        color: var(--primary-color);
    }
    
    .leave-stat-item {
        display: flex;
        justify-content: space-between;
        margin-bottom: 0.75rem;
        padding-bottom: 0.75rem;
        border-bottom: 1px solid rgba(0,0,0,0.05);
    }
    
    .leave-stat-item:last-child {
        margin-bottom: 0;
        padding-bottom: 0;
        border-bottom: none;
    }
    
    .leave-stat-value {
        font-weight: 600;
        color: var(--primary-color);
    }
    
    .actions {
        display: flex;
        justify-content: space-between;
        margin-top: 2rem;
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
    
    .btn-secondary {
        color: #fff;
        background-color: #6c757d;
        border-color: #6c757d;
    }
    
    .btn-secondary:hover {
        background-color: #5a6268;
        border-color: #545b62;
        transform: translateY(-2px);
        box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
    }
    
    /* Tooltip styles */
    .tooltip {
        position: relative;
        display: inline-block;
        margin-left: 0.5rem;
        color: var(--text-secondary);
    }
    
    .tooltip .tooltip-text {
        visibility: hidden;
        width: 200px;
        background-color: rgba(0, 0, 0, 0.8);
        color: #fff;
        text-align: center;
        border-radius: 0.25rem;
        padding: 0.5rem;
        position: absolute;
        z-index: 1;
        bottom: 125%;
        left: 50%;
        transform: translateX(-50%);
        opacity: 0;
        transition: opacity 0.3s;
        font-size: 0.875rem;
        font-weight: normal;
    }
    
    .tooltip .tooltip-text::after {
        content: "";
        position: absolute;
        top: 100%;
        left: 50%;
        margin-left: -5px;
        border-width: 5px;
        border-style: solid;
        border-color: rgba(0, 0, 0, 0.8) transparent transparent transparent;
    }
    
    .tooltip:hover .tooltip-text {
        visibility: visible;
        opacity: 1;
    }
    
    @media (max-width: 768px) {
        .leave-form-body {
            padding: 1.5rem;
        }
        
        .actions {
            flex-direction: column;
            gap: 1rem;
        }
        
        .actions .btn {
            width: 100%;
        }
    }
</style>

<!-- Page Content -->
<div class="leave-form-card">
    <div class="leave-form-header">
        <h2><i class="fas fa-plus-circle"></i> Tạo đơn nghỉ phép mới</h2>
    </div>
    
    <div class="leave-form-body">
        <form action="leaveRequest" method="post" accept-charset="UTF-8" id="leaveRequestForm">
            <input type="hidden" name="action" value="create">
            
            <div class="form-group">
                <label for="fromDate">
                    Từ ngày
                    <span class="required-marker">*</span>
                    <span class="tooltip">
                        <i class="fas fa-question-circle"></i>
                        <span class="tooltip-text">Chọn ngày bắt đầu nghỉ phép của bạn</span>
                    </span>
                </label>
                <div class="date-input-container">
                    <i class="fas fa-calendar-alt date-input-icon"></i>
                    <input type="date" id="fromDate" name="fromDate" class="form-control" 
                           value="<%= fromDateValue %>" min="<%= currentDate %>" required>
                </div>
            </div>
            
            <div class="form-group">
                <label for="toDate">
                    Đến ngày
                    <span class="required-marker">*</span>
                    <span class="tooltip">
                        <i class="fas fa-question-circle"></i>
                        <span class="tooltip-text">Chọn ngày kết thúc nghỉ phép của bạn</span>
                    </span>
                </label>
                <div class="date-input-container">
                    <i class="fas fa-calendar-alt date-input-icon"></i>
                    <input type="date" id="toDate" name="toDate" class="form-control" 
                           value="<%= toDateValue %>" min="<%= currentDate %>" required>
                </div>
            </div>
            
            <div class="form-group">
                <label for="reason">
                    Lý do nghỉ phép
                    <span class="required-marker">*</span>
                </label>
                <textarea id="reason" name="reason" class="form-control" rows="5" required 
                          placeholder="Vui lòng cung cấp lý do chi tiết cho đơn nghỉ phép của bạn..."></textarea>
                <small class="form-text">
                    <i class="fas fa-info-circle"></i> Đơn của bạn sẽ được quản lý xem xét. Vui lòng cung cấp đầy đủ thông tin.
                </small>
            </div>
            
            <div class="notice-box info">
                <div class="icon">
                    <i class="fas fa-exclamation"></i>
                </div>
                <strong>Lưu ý:</strong> Đơn nghỉ phép phải được nộp ít nhất 3 ngày làm việc trước để có thể lên kế hoạch phù hợp. 
                Nghỉ khẩn cấp sẽ được xử lý theo từng trường hợp cụ thể.
            </div>
            
            <div class="leave-duration-summary">
                <h4><i class="fas fa-clock"></i> Thời gian nghỉ phép dự kiến</h4>
                <div class="leave-stat-item">
                    <span>Tổng số ngày:</span>
                    <span class="leave-stat-value" id="totalDays">8 ngày</span>
                </div>
                <div class="leave-stat-item">
                    <span>Bao gồm ngày cuối tuần:</span>
                    <span class="leave-stat-value" id="weekendDays">2 ngày</span>
                </div>
                <div class="leave-stat-item">
                    <span>Số ngày làm việc:</span>
                    <span class="leave-stat-value" id="workDays">6 ngày</span>
                </div>
            </div>
            
            <div class="actions">
                <a href="viewLeaves.jsp" class="btn btn-secondary">
                    <i class="fas fa-times"></i> Hủy
                </a>
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-paper-plane"></i> Gửi đơn
                </button>
            </div>
        </form>
    </div>
</div>

<!-- Leave Policies Info Card -->
<div class="leave-form-card" style="margin-top: 2rem;">
    <div class="leave-form-header" style="background-color: #2980b9;">
        <h2><i class="fas fa-info-circle"></i> Quy định nghỉ phép</h2>
    </div>
    
    <div class="leave-form-body">
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 2rem;">
            <div>
                <h4 style="color: var(--primary-color); margin-bottom: 1rem; display: flex; align-items: center;">
                    <i class="fas fa-calendar-check" style="margin-right: 0.75rem;"></i>
                    Ngày nghỉ phép theo năm
                </h4>
                <ul style="padding-left: 1.5rem; margin-bottom: 0;">
                    <li style="margin-bottom: 0.5rem;">Nhân viên thông thường: <strong>12 ngày/năm</strong></li>
                    <li style="margin-bottom: 0.5rem;">Nhân viên cấp cao (>5 năm): <strong>15 ngày/năm</strong></li>
                    <li style="margin-bottom: 0.5rem;">Cấp quản lý: <strong>18 ngày/năm</strong></li>
                </ul>
            </div>
            
            <div>
                <h4 style="color: var(--primary-color); margin-bottom: 1rem; display: flex; align-items: center;">
                    <i class="fas fa-list-alt" style="margin-right: 0.75rem;"></i>
                    Các loại nghỉ phép
                </h4>
                <ul style="padding-left: 1.5rem; margin-bottom: 0;">
                    <li style="margin-bottom: 0.5rem;">Nghỉ phép thường niên</li>
                    <li style="margin-bottom: 0.5rem;">Nghỉ ốm (cần giấy chứng nhận y tế)</li>
                    <li style="margin-bottom: 0.5rem;">Nghỉ việc riêng</li>
                    <li style="margin-bottom: 0.5rem;">Nghỉ học tập</li>
                    <li style="margin-bottom: 0.5rem;">Nghỉ thai sản/chăm con</li>
                </ul>
            </div>
        </div>
    </div>
</div>

<script>
    // Validate date range and calculate leave duration
    document.addEventListener('DOMContentLoaded', function() {
        const fromDateInput = document.getElementById('fromDate');
        const toDateInput = document.getElementById('toDate');
        
        // Update to date min value when from date changes
        fromDateInput.addEventListener('change', function() {
            if (toDateInput.value < fromDateInput.value) {
                toDateInput.value = fromDateInput.value;
            }
            toDateInput.min = fromDateInput.value;
            updateLeaveDuration();
        });
        
        // Update leave duration when to date changes
        toDateInput.addEventListener('change', function() {
            updateLeaveDuration();
        });
        
        // Initial set minimum for to date
        toDateInput.min = fromDateInput.value;
        
        // Initial calculation
        updateLeaveDuration();
        
        // Calculate leave duration
        function updateLeaveDuration() {
            const fromDate = new Date(fromDateInput.value);
            const toDate = new Date(toDateInput.value);
            toDate.setHours(23, 59, 59, 999); // Include end date fully
            
            // Calculate total days
            const timeDiff = toDate - fromDate;
            const totalDays = Math.floor(timeDiff / (1000 * 60 * 60 * 24)) + 1;
            
            // Count weekend days
            let weekendDays = 0;
            let currentDate = new Date(fromDate);
            
            while (currentDate <= toDate) {
                const dayOfWeek = currentDate.getDay();
                if (dayOfWeek === 0 || dayOfWeek === 6) {
                    weekendDays++;
                }
                currentDate.setDate(currentDate.getDate() + 1);
            }
            
            // Calculate work days
            const workDays = totalDays - weekendDays;
            
            // Update summary display
            document.getElementById('totalDays').textContent = totalDays + ' ngày';
            document.getElementById('weekendDays').textContent = weekendDays + ' ngày';
            document.getElementById('workDays').textContent = workDays + ' ngày';
        }
    });
</script>

<%-- Include Footer --%>
<%@ include file="footer.jsp" %>