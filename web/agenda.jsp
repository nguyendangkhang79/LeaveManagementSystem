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
%>

<!-- Page Header -->
<div class="card">
    <div class="card-header">
        <h2><i class="fas fa-calendar"></i> <%= user.isAdmin() ? "Lịch nghỉ phép toàn công ty" : "Lịch nghỉ phép phòng ban" %></h2>
        
        <a href="viewLeaves.jsp" class="btn btn-outline-primary btn-sm">
            <i class="fas fa-arrow-left"></i> Quay lại danh sách đơn
        </a>
    </div>
</div>

<!-- Date Selection and Department Filter -->
<div class="card">
    <div class="card-body">
        <form action="agenda.jsp" method="get" class="mb-4">
            <div class="row">
                <% if (user.isAdmin()) { %>
                <div class="col-md-3">
                    <div class="form-group">
                        <label for="department" class="form-label">Phòng ban</label>
                        <select id="department" name="department" class="form-control">
                            <option value="all" <%= "all".equals(departmentFilter) ? "selected" : "" %>>Tất cả các phòng ban</option>
                            <% for (String dept : allDepartments) { %>
                                <option value="<%= dept %>" <%= dept.equals(departmentFilter) && !"all".equals(departmentFilter) ? "selected" : "" %>><%= dept %></option>
                            <% } %>
                        </select>
                    </div>
                </div>
                <% } %>
                
                <div class="col-md-<%= user.isAdmin() ? "3" : "4" %>">
                    <div class="form-group">
                        <label for="startDate" class="form-label">Từ ngày</label>
                        <input type="date" id="startDate" name="startDate" value="<%= startDate %>" class="form-control" required>
                    </div>
                </div>
                
                <div class="col-md-<%= user.isAdmin() ? "3" : "4" %>">
                    <div class="form-group">
                        <label for="endDate" class="form-label">Đến ngày</label>
                        <input type="date" id="endDate" name="endDate" value="<%= endDate %>" class="form-control" required>
                    </div>
                </div>
                
                <div class="col-md-<%= user.isAdmin() ? "3" : "4" %>">
                    <div class="form-group" style="display: flex; align-items: flex-end; height: 100%;">
                        <button type="submit" class="btn btn-primary w-100">
                            <i class="fas fa-search"></i> Xem lịch
                        </button>
                    </div>
                </div>
            </div>
        </form>
        
        <div class="calendar-header">
            <h3 class="calendar-title">
                <i class="far fa-calendar-alt"></i> <%= periodDisplay %>
                <% if (user.isAdmin() && !"all".equals(departmentFilter)) { %>
                    - Phòng ban: <%= departmentFilter %>
                <% } %>
            </h3>
            
            <div class="calendar-navigation">
                <a href="agenda.jsp?startDate=<%= previousPeriodStart %>&endDate=<%= previousPeriodStart.plusDays(13) %><%= user.isAdmin() ? "&department=" + departmentFilter : "" %>" 
                   class="btn btn-outline-secondary btn-sm">
                    <i class="fas fa-chevron-left"></i> Kỳ trước
                </a>
                
                <a href="agenda.jsp?startDate=<%= today %>&endDate=<%= today.plusDays(13) %><%= user.isAdmin() ? "&department=" + departmentFilter : "" %>" 
                   class="btn btn-outline-primary btn-sm">
                    Kỳ hiện tại
                </a>
                
                <a href="agenda.jsp?startDate=<%= nextPeriodStart %>&endDate=<%= nextPeriodStart.plusDays(13) %><%= user.isAdmin() ? "&department=" + departmentFilter : "" %>" 
                   class="btn btn-outline-secondary btn-sm">
                    Kỳ sau <i class="fas fa-chevron-right"></i>
                </a>
            </div>
        </div>
    </div>
</div>

<!-- Legend -->
<div class="legend" style="display: flex; gap: 20px; margin-bottom: 15px;">
    <div class="legend-item" style="display: flex; align-items: center; gap: 5px;">
        <div style="width: 15px; height: 15px; border-radius: 3px; background-color: #e8f5e9;"></div>
        <span>Ngày làm việc</span>
    </div>
    <div class="legend-item" style="display: flex; align-items: center; gap: 5px;">
        <div style="width: 15px; height: 15px; border-radius: 3px; background-color: #ffebee;"></div>
        <span>Ngày nghỉ phép</span>
    </div>
    <div class="legend-item" style="display: flex; align-items: center; gap: 5px;">
        <div style="width: 15px; height: 15px; border-radius: 3px; background-color: #f5f5f5;"></div>
        <span>Cuối tuần</span>
    </div>
    <div class="legend-item" style="display: flex; align-items: center; gap: 5px;">
        <div style="width: 15px; height: 15px; border-radius: 3px; background-color: #e3f2fd;"></div>
        <span>Hôm nay</span>
    </div>
</div>

<!-- Calendar View -->
<div class="card">
    <div class="card-body">
        <div style="overflow-x: auto;">
            <table class="table table-bordered calendar-table">
                <thead>
                    <tr>
                        <th style="min-width: 150px; position: sticky; left: 0; background-color: #f5f5f5; z-index: 1;">Nhân viên</th>
                        <% 
                        for (LocalDate date = startDate; !date.isAfter(endDate); date = date.plusDays(1)) {
                            String formattedDate = date.format(dateFormatter);
                            String dayOfWeek = date.getDayOfWeek().toString().substring(0, 3);
                            boolean isWeekend = date.getDayOfWeek() == DayOfWeek.SATURDAY || date.getDayOfWeek() == DayOfWeek.SUNDAY;
                            boolean isToday = date.equals(today);
                            
                            String headerClass = isWeekend ? "background-color: #f5f5f5;" : "";
                            if (isToday) headerClass += "background-color: #e3f2fd;";
                            
                            int todayLeaveCount = dailyLeaveCount.getOrDefault(date, 0);
                            String countColor = "color: inherit;";
                            if (todayLeaveCount > 0) {
                                countColor = todayLeaveCount > departmentEmployees.size() / 3 ? "color: #e74c3c;" : "color: #f39c12;";
                            }
                        %>
                            <th style="<%= headerClass %> text-align: center;">
                                <div style="font-weight: bold;"><%= formattedDate %></div>
                                <div style="font-size: 12px;"><%= dayOfWeek %></div>
                                <% if (!isWeekend) { %>
                                    <div style="margin-top: 3px; font-size: 11px; <%= countColor %> font-weight: bold;">
                                        <i class="fas fa-user-minus"></i> <%= todayLeaveCount %>
                                    </div>
                                <% } %>
                            </th>
                        <% } %>
                    </tr>
                </thead>
                <tbody>
                    <% 
                    boolean hasEmployees = false;
                    for (User employee : departmentEmployees) {
                        // Skip showing current user in the table if they are Manager
                        if (employee.getId() == user.getId() && user.isManager() && !user.isAdmin()) continue;
                        
                        hasEmployees = true;
                        List<LocalDate> employeeLeaves = employeeLeaveDays.getOrDefault(employee.getId(), new ArrayList<>());
                    %>
                    <tr>
                        <td style="position: sticky; left: 0; background-color: #f9f9f9; font-weight: 500; z-index: 1;">
                            <%= employee.getUsername() %>
                            <span style="font-size: 11px; color: #777; display: block;"><%= employee.getRole() %></span>
                        </td>
                        <% 
                        for (LocalDate date = startDate; !date.isAfter(endDate); date = date.plusDays(1)) {
                            boolean isWeekend = date.getDayOfWeek() == DayOfWeek.SATURDAY || date.getDayOfWeek() == DayOfWeek.SUNDAY;
                            boolean isToday = date.equals(today);
                            boolean isLeaveDay = employeeLeaves.contains(date);
                            
                            String cellStyle = "";
                            if (isWeekend) {
                                cellStyle = "background-color: #f5f5f5;";
                            } else if (isLeaveDay) {
                                cellStyle = "background-color: #ffebee;";
                            } else {
                                cellStyle = "background-color: #e8f5e9;";
                            }
                            
                            if (isToday) cellStyle += "background-color: #e3f2fd;";
                        %>
                            <td style="<%= cellStyle %> text-align: center;">
                                <% if (isLeaveDay) { %>
                                    <i class="fas fa-check" style="color: #e74c3c;"></i>
                                <% } %>
                            </td>
                        <% } %>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
        
        <% if (!hasEmployees) { %>
            <div style="text-align: center; padding: 30px;">
                <i class="fas fa-users" style="font-size: 3rem; color: #ddd; margin-bottom: 15px;"></i>
                <h3>Không có nhân viên</h3>
                <p style="color: #777;">
                    <% if (user.isAdmin() && !"all".equals(departmentFilter)) { %>
                        Không có nhân viên nào trong phòng ban <%= departmentFilter %>.
                    <% } else { %>
                        Không có nhân viên nào trong phòng ban của bạn.
                    <% } %>
                </p>
            </div>
        <% } %>
    </div>
</div>

<!-- Department Overview -->
<div class="card">
    <div class="card-header">
        <h3><i class="fas fa-chart-pie"></i> Thống kê nhân sự</h3>
    </div>
    <div class="card-body">
        <div class="row">
            <div class="col-md-4">
                <div class="card mb-0">
                    <div class="card-body text-center">
                        <h3 class="mb-3">Tổng nhân viên</h3>
                        <div style="font-size: 2.5rem; font-weight: bold; color: #3498db;">
                            <%= hasEmployees ? departmentEmployees.size() - (user.getRole().equals("Manager") && !user.isAdmin() ? 1 : 0) : 0 %>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4">
                <div class="card mb-0">
                    <div class="card-body text-center">
                        <h3 class="mb-3">Nghỉ phép hôm nay</h3>
                        <% 
                            int onLeaveToday = dailyLeaveCount.getOrDefault(today, 0);
                        %>
                        <div style="font-size: 2.5rem; font-weight: bold; color: #e74c3c;">
                            <%= onLeaveToday %>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4">
                <div class="card mb-0">
                    <div class="card-body text-center">
                        <h3 class="mb-3">Đi làm hôm nay</h3>
                        <% 
                            int availableToday = hasEmployees ? departmentEmployees.size() - onLeaveToday : 0;
                            if (user.getRole().equals("Manager") && !user.isAdmin()) availableToday--;
                        %>
                        <div style="font-size: 2.5rem; font-weight: bold; color: #2ecc71;">
                            <%= availableToday %>
                        </div>
                    </div>
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
    });
</script>

<%-- Include Footer --%>
<%@ include file="footer.jsp" %>