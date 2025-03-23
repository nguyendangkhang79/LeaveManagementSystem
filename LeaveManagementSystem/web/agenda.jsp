<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.LeaveRequestDAO, dao.UserDAO, model.LeaveRequest, model.User, java.util.List, java.util.Map, java.util.HashMap, java.util.ArrayList, java.time.LocalDate, java.time.format.DateTimeFormatter, java.time.DayOfWeek, java.sql.Date" %>

<%-- Include Header --%>
<%@ include file="header.jsp" %>

<%
    // Security check: Only managers and admins can access this page
    if (user == null || (!user.isManager() && !user.isAdmin())) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Get date parameters from request or use defaults
    String startDateStr = request.getParameter("startDate");
    String endDateStr = request.getParameter("endDate");
    String departmentFilter = request.getParameter("department");
    
    LocalDate today = LocalDate.now();
    LocalDate startDate = (startDateStr != null && !startDateStr.isEmpty()) 
                        ? LocalDate.parse(startDateStr) 
                        : today.withDayOfMonth(1);
    
    LocalDate endDate = (endDateStr != null && !endDateStr.isEmpty()) 
                      ? LocalDate.parse(endDateStr)
                      : startDate.plusDays(13); // Show 2 weeks by default
    
    // Limit to max 31 days view to prevent performance issues
    if (startDate.plusDays(31).isBefore(endDate)) {
        endDate = startDate.plusDays(30);
    }
    
    // Format for display
    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM");
    DateTimeFormatter monthFormatter = DateTimeFormatter.ofPattern("MMMM yyyy");
    String periodDisplay = startDate.format(DateTimeFormatter.ofPattern("dd MMM yyyy")) + 
                           " - " + 
                           endDate.format(DateTimeFormatter.ofPattern("dd MMM yyyy"));
    
    // Navigation dates
    LocalDate previousPeriodStart = startDate.minusDays(14);
    LocalDate nextPeriodStart = startDate.plusDays(14);
    
    // For Super Admin, allow filtering by department
    UserDAO userDAO = new UserDAO();
    List<String> allDepartments = new ArrayList<>();
    
    if (user.isAdmin()) {
        allDepartments = userDAO.getAllDepartments();
        
        // If no department filter is selected, use the first one
        if (departmentFilter == null || departmentFilter.isEmpty()) {
            departmentFilter = allDepartments.isEmpty() ? "" : allDepartments.get(0);
        }
    } else {
        // For normal managers, use their own department
        departmentFilter = user.getDepartment();
        allDepartments.add(departmentFilter);
    }
    
    // Get employees for the selected department
    List<User> departmentEmployees = userDAO.getUsersByDepartment(departmentFilter);
    
    // Get approved leave requests for the department and period
    LeaveRequestDAO leaveDAO = new LeaveRequestDAO();
    List<LeaveRequest> approvedLeaves;
    
    if (user.isAdmin() && "all".equals(departmentFilter)) {
        // For Super Admin showing all departments
        approvedLeaves = leaveDAO.getAllApprovedLeaves(
            Date.valueOf(startDate), 
            Date.valueOf(endDate)
        );
    } else {
        // For filtered department view
        approvedLeaves = leaveDAO.getApprovedLeavesByDepartment(
            departmentFilter, 
            Date.valueOf(startDate), 
            Date.valueOf(endDate)
        );
    }
    
    // Create map for quick lookup of leave days by user
    Map<Integer, List<LocalDate>> employeeLeaveDays = new HashMap<>();
    
    for (LeaveRequest leave : approvedLeaves) {
        if (!"Approved".equals(leave.getStatus())) {
            continue;
        }
        
        List<LocalDate> leaveDays = employeeLeaveDays.getOrDefault(leave.getUserId(), new ArrayList<>());
        
        LocalDate leaveStart = leave.getFromDate().toLocalDate();
        LocalDate leaveEnd = leave.getToDate().toLocalDate();
        
        // Add all days in the leave range
        for (LocalDate date = leaveStart; !date.isAfter(leaveEnd); date = date.plusDays(1)) {
            if (!date.isBefore(startDate) && !date.isAfter(endDate)) {
                leaveDays.add(date);
            }
        }
        
        employeeLeaveDays.put(leave.getUserId(), leaveDays);
    }
    
    // Count employees on leave for each day
    Map<LocalDate, Integer> dailyLeaveCount = new HashMap<>();
    for (LocalDate date = startDate; !date.isAfter(endDate); date = date.plusDays(1)) {
        int count = 0;
        for (Map.Entry<Integer, List<LocalDate>> entry : employeeLeaveDays.entrySet()) {
            if (entry.getValue().contains(date)) {
                count++;
            }
        }
        dailyLeaveCount.put(date, count);
    }
    
    // Calculate available employees
    int totalEmployees = departmentEmployees.size();
    if (user.getRole().equals("Manager") && !user.isAdmin()) {
        totalEmployees--; // Don't count the manager
    }
    int onLeaveToday = dailyLeaveCount.getOrDefault(today, 0);
    int availableToday = totalEmployees - onLeaveToday;
    if (availableToday < 0) availableToday = 0;
%>

<style>
    /* Card styles */
    .leave-calendar-card {
        background-color: white;
        border-radius: 8px;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        margin-bottom: 20px;
        overflow: hidden;
    }
    
    .leave-calendar-header {
        background-color: #f8f9fa;
        padding: 15px 20px;
        border-bottom: 1px solid #e9ecef;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }
    
    .leave-calendar-title {
        margin: 0;
        font-size: 18px;
        font-weight: 600;
        color: #333;
        display: flex;
        align-items: center;
    }
    
    .leave-calendar-title i {
        margin-right: 10px;
        color: #3498db;
    }
    
    .leave-calendar-body {
        padding: 20px;
    }
    
    /* Form styles */
    .leave-filter-form {
        display: flex;
        flex-wrap: wrap;
        margin-bottom: 20px;
        gap: 15px;
    }
    
    .filter-group {
        flex: 1;
        min-width: 200px;
    }
    
    .filter-label {
        display: block;
        margin-bottom: 8px;
        font-weight: 500;
        color: #555;
    }
    
    .filter-control {
        width: 100%;
        padding: 8px 12px;
        border: 1px solid #ddd;
        border-radius: 4px;
        background-color: white;
    }
    
    .filter-button {
        margin-top: 25px;
        padding: 8px 16px;
        background-color: #3498db;
        color: white;
        border: none;
        border-radius: 4px;
        cursor: pointer;
        font-weight: 500;
        display: flex;
        align-items: center;
        justify-content: center;
    }
    
    .filter-button i {
        margin-right: 8px;
    }
    
    /* Period display */
    .period-display {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-top: 20px;
        flex-wrap: wrap;
    }
    
    .period-text {
        font-size: 16px;
        font-weight: 600;
        color: #333;
        display: flex;
        align-items: center;
    }
    
    .period-text i {
        margin-right: 10px;
        color: #3498db;
    }
    
    .period-navigation {
        display: flex;
        gap: 10px;
        margin-top: 10px;
    }
    
    .period-nav-button {
        padding: 6px 12px;
        border: 1px solid #ddd;
        border-radius: 4px;
        background-color: white;
        color: #333;
        text-decoration: none;
        font-size: 14px;
        display: flex;
        align-items: center;
    }
    
    .period-nav-button:hover {
        background-color: #f8f9fa;
    }
    
    .period-nav-button i {
        margin-right: 5px;
    }
    
    .period-nav-button.current {
        background-color: #e3f2fd;
        border-color: #3498db;
        color: #3498db;
    }
    
    /* Legend */
    .leave-legend {
        display: flex;
        flex-wrap: wrap;
        gap: 15px;
        margin: 20px 0;
    }
    
    .legend-item {
        display: flex;
        align-items: center;
        gap: 8px;
    }
    
    .legend-color {
        width: 16px;
        height: 16px;
        border-radius: 4px;
    }
    
    .legend-work {
        background-color: #e8f5e9;
    }
    
    .legend-leave {
        background-color: #ffebee;
    }
    
    .legend-weekend {
        background-color: #f5f5f5;
    }
    
    .legend-today {
        background-color: #e3f2fd;
    }
    
    /* Calendar table */
    .calendar-container {
        overflow-x: auto;
        margin-top: 20px;
    }
    
    .calendar-table {
        width: 100%;
        border-collapse: separate;
        border-spacing: 0;
        min-width: 800px;
    }
    
    .calendar-table th,
    .calendar-table td {
        padding: 10px;
        text-align: center;
        border-bottom: 1px solid #eee;
    }
    
    .calendar-table th {
        background-color: #f8f9fa;
        font-weight: 600;
        color: #555;
        position: sticky;
        top: 0;
    }
    
    .calendar-table th:first-child {
        text-align: left;
    }
    
    .calendar-table td:first-child {
        text-align: left;
        background-color: #f9f9f9;
        position: sticky;
        left: 0;
        font-weight: 500;
    }
    
    .user-role {
        display: block;
        font-size: 12px;
        color: #777;
        font-weight: normal;
    }
    
    .date-head {
        display: flex;
        flex-direction: column;
    }
    
    .date-number {
        font-weight: bold;
    }
    
    .date-day {
        font-size: 12px;
        color: #777;
    }
    
    .date-count {
        margin-top: 5px;
        font-size: 11px;
        font-weight: bold;
    }
    
    .count-high {
        color: #e74c3c;
    }
    
    .count-medium {
        color: #f39c12;
    }
    
    .today-cell {
        background-color: #e3f2fd;
    }
    
    .weekend-cell {
        background-color: #f5f5f5;
    }
    
    .leave-cell {
        background-color: #ffebee;
    }
    
    .work-cell {
        background-color: #e8f5e9;
    }
    
    .leave-check {
        color: #e74c3c;
    }
    
    /* Stats cards */
    .stats-container {
        display: flex;
        flex-wrap: wrap;
        gap: 20px;
        margin-top: 20px;
    }
    
    .stat-card {
        flex: 1;
        min-width: 200px;
        background-color: white;
        border-radius: 8px;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        padding: 20px;
        text-align: center;
    }
    
    .stat-title {
        font-size: 16px;
        font-weight: 600;
        color: #555;
        margin-bottom: 15px;
    }
    
    .stat-value {
        font-size: 36px;
        font-weight: 700;
        line-height: 1;
    }
    
    .stat-blue {
        color: #3498db;
    }
    
    .stat-red {
        color: #e74c3c;
    }
    
    .stat-green {
        color: #2ecc71;
    }
    
    /* Empty state */
    .empty-state {
        text-align: center;
        padding: 40px 20px;
    }
    
    .empty-state i {
        font-size: 48px;
        color: #ddd;
        margin-bottom: 20px;
    }
    
    .empty-state h3 {
        font-size: 20px;
        color: #555;
        margin-bottom: 10px;
    }
    
    .empty-state p {
        color: #777;
        margin-bottom: 20px;
        max-width: 400px;
        margin-left: auto;
        margin-right: auto;
    }
    
    /* Responsive styles */
    @media (max-width: 768px) {
        .leave-calendar-header {
            flex-direction: column;
            align-items: flex-start;
        }
        
        .filter-group {
            flex: 0 0 100%;
        }
        
        .period-display {
            flex-direction: column;
            align-items: flex-start;
        }
        
        .stats-container {
            flex-direction: column;
        }
    }
</style>

<!-- Page Container -->
<div class="leave-calendar-card">
    <div class="leave-calendar-header">
        <h2 class="leave-calendar-title">
            <i class="fas fa-calendar"></i> <%= user.isAdmin() ? "Lịch nghỉ phép toàn công ty" : "Lịch nghỉ phép phòng ban" %>
        </h2>
        
        <a href="viewLeaves.jsp" style="color: #3498db; text-decoration: none; display: flex; align-items: center;">
            <i class="fas fa-arrow-left" style="margin-right: 5px;"></i> Quay lại danh sách đơn
        </a>
    </div>
    
    <div class="leave-calendar-body">
        <!-- Filter Form -->
        <form action="agenda.jsp" method="get" class="leave-filter-form">
            <% if (user.isAdmin()) { %>
            <div class="filter-group">
                <label for="department" class="filter-label">Phòng ban</label>
                <select id="department" name="department" class="filter-control">
                    <option value="all" <%= "all".equals(departmentFilter) ? "selected" : "" %>>Tất cả các phòng ban</option>
                    <% for (String dept : allDepartments) { %>
                        <option value="<%= dept %>" <%= dept.equals(departmentFilter) && !"all".equals(departmentFilter) ? "selected" : "" %>><%= dept %></option>
                    <% } %>
                </select>
            </div>
            <% } %>
            
            <div class="filter-group">
                <label for="startDate" class="filter-label">Từ ngày</label>
                <input type="date" id="startDate" name="startDate" value="<%= startDate %>" class="filter-control" required>
            </div>
            
            <div class="filter-group">
                <label for="endDate" class="filter-label">Đến ngày</label>
                <input type="date" id="endDate" name="endDate" value="<%= endDate %>" class="filter-control" required>
            </div>
            
            <button type="submit" class="filter-button">
                <i class="fas fa-search"></i> Xem lịch
            </button>
        </form>
        
        <!-- Period Display and Navigation -->
        <div class="period-display">
            <div class="period-text">
                <i class="far fa-calendar-alt"></i> <%= periodDisplay %>
                <% if (user.isAdmin() && !"all".equals(departmentFilter)) { %>
                    - Phòng ban: <%= departmentFilter %>
                <% } %>
            </div>
            
            <div class="period-navigation">
                <a href="agenda.jsp?startDate=<%= previousPeriodStart %>&endDate=<%= previousPeriodStart.plusDays(13) %><%= user.isAdmin() ? "&department=" + departmentFilter : "" %>" 
                   class="period-nav-button">
                    <i class="fas fa-chevron-left"></i> Kỳ trước
                </a>
                
                <a href="agenda.jsp?startDate=<%= today %>&endDate=<%= today.plusDays(13) %><%= user.isAdmin() ? "&department=" + departmentFilter : "" %>" 
                   class="period-nav-button current">
                    Kỳ hiện tại
                </a>
                
                <a href="agenda.jsp?startDate=<%= nextPeriodStart %>&endDate=<%= nextPeriodStart.plusDays(13) %><%= user.isAdmin() ? "&department=" + departmentFilter : "" %>" 
                   class="period-nav-button">
                    Kỳ sau <i class="fas fa-chevron-right"></i>
                </a>
            </div>
        </div>
        
        <!-- Legend -->
        <div class="leave-legend">
            <div class="legend-item">
                <div class="legend-color legend-work"></div>
                <span>Ngày làm việc</span>
            </div>
            <div class="legend-item">
                <div class="legend-color legend-leave"></div>
                <span>Ngày nghỉ phép</span>
            </div>
            <div class="legend-item">
                <div class="legend-color legend-weekend"></div>
                <span>Cuối tuần</span>
            </div>
            <div class="legend-item">
                <div class="legend-color legend-today"></div>
                <span>Hôm nay</span>
            </div>
        </div>
        
        <!-- Calendar Table -->
        <% if (departmentEmployees.isEmpty()) { %>
            <div class="empty-state">
                <i class="fas fa-users"></i>
                <h3>Không có nhân viên</h3>
                <p>
                    <% if (user.isAdmin() && !"all".equals(departmentFilter)) { %>
                        Không có nhân viên nào trong phòng ban <%= departmentFilter %>.
                    <% } else { %>
                        Không có nhân viên nào trong phòng ban của bạn.
                    <% } %>
                </p>
            </div>
        <% } else { %>
            <div class="calendar-container">
                <table class="calendar-table">
                    <thead>
                        <tr>
                            <th>Nhân viên</th>
                            <% 
                            for (LocalDate date = startDate; !date.isAfter(endDate); date = date.plusDays(1)) {
                                String formattedDate = date.format(dateFormatter);
                                String dayOfWeek = date.getDayOfWeek().toString().substring(0, 3);
                                boolean isWeekend = date.getDayOfWeek() == DayOfWeek.SATURDAY || date.getDayOfWeek() == DayOfWeek.SUNDAY;
                                boolean isToday = date.equals(today);
                                
                                String headerClass = isToday ? "today-cell" : (isWeekend ? "weekend-cell" : "");
                                
                                int todayLeaveCount = dailyLeaveCount.getOrDefault(date, 0);
                                String countClass = "";
                                if (todayLeaveCount > 0) {
                                    countClass = todayLeaveCount > departmentEmployees.size() / 3 ? "count-high" : "count-medium";
                                }
                            %>
                                <th class="<%= headerClass %>">
                                    <div class="date-head">
                                        <span class="date-number"><%= formattedDate %></span>
                                        <span class="date-day"><%= dayOfWeek %></span>
                                        <% if (!isWeekend && todayLeaveCount > 0) { %>
                                            <span class="date-count <%= countClass %>">
                                                <i class="fas fa-user-minus"></i> <%= todayLeaveCount %>
                                            </span>
                                        <% } %>
                                    </div>
                                </th>
                            <% } %>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                        for (User employee : departmentEmployees) {
                            // Skip showing current user in the table if they are Manager
                            if (employee.getId() == user.getId() && user.isManager() && !user.isAdmin()) continue;
                            
                            List<LocalDate> employeeLeaves = employeeLeaveDays.getOrDefault(employee.getId(), new ArrayList<>());
                        %>
                        <tr>
                            <td>
                                <%= employee.getUsername() %>
                                <span class="user-role"><%= employee.getRole() %></span>
                            </td>
                            <% 
                            for (LocalDate date = startDate; !date.isAfter(endDate); date = date.plusDays(1)) {
                                boolean isWeekend = date.getDayOfWeek() == DayOfWeek.SATURDAY || date.getDayOfWeek() == DayOfWeek.SUNDAY;
                                boolean isToday = date.equals(today);
                                boolean isLeaveDay = employeeLeaves.contains(date);
                                
                                String cellClass = isToday ? "today-cell" : (isWeekend ? "weekend-cell" : (isLeaveDay ? "leave-cell" : "work-cell"));
                            %>
                                <td class="<%= cellClass %>">
                                    <% if (isLeaveDay) { %>
                                        <i class="fas fa-check leave-check"></i>
                                    <% } %>
                                </td>
                            <% } %>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        <% } %>
    </div>
</div>

<!-- Stats Section -->
<div class="leave-calendar-card">
    <div class="leave-calendar-header">
        <h3 class="leave-calendar-title">
            <i class="fas fa-chart-pie"></i> Thống kê nhân sự
        </h3>
    </div>
    
    <div class="leave-calendar-body">
        <div class="stats-container">
            <div class="stat-card">
                <h4 class="stat-title">Tổng nhân viên</h4>
                <div class="stat-value stat-blue">
                    <%= totalEmployees %>
                </div>
            </div>
            
            <div class="stat-card">
                <h4 class="stat-title">Nghỉ phép hôm nay</h4>
                <div class="stat-value stat-red">
                    <%= onLeaveToday %>
                </div>
            </div>
            
            <div class="stat-card">
                <h4 class="stat-title">Đi làm hôm nay</h4>
                <div class="stat-value stat-green">
                    <%= availableToday %>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    // Validate date range
    document.addEventListener('DOMContentLoaded', function() {
        const startDateInput = document.getElementById('startDate');
        const endDateInput = document.getElementById('endDate');
        
        startDateInput.addEventListener('change', function() {
            if (endDateInput.value < startDateInput.value) {
                endDateInput.value = startDateInput.value;
            }
            endDateInput.min = startDateInput.value;
        });
        
        endDateInput.addEventListener('change', function() {
            if (endDateInput.value < startDateInput.value) {
                startDateInput.value = endDateInput.value;
            }
            
            // Limit to max 31 days
            const startDate = new Date(startDateInput.value);
            const endDate = new Date(endDateInput.value);
            const diffTime = Math.abs(endDate - startDate);
            const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
            
            if (diffDays > 30) {
                const maxEndDate = new Date(startDate);
                maxEndDate.setDate(startDate.getDate() + 30);
                endDateInput.value = maxEndDate.toISOString().split('T')[0];
                alert('Để tối ưu hiệu suất, khoảng thời gian xem được giới hạn tối đa 31 ngày.');
            }
        });
        
        // Set initial min value for end date
        endDateInput.min = startDateInput.value;
    });
</script>

<%-- Include Footer --%>
<%@ include file="footer.jsp" %>