<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User, java.time.LocalDate" %>

<%-- Include Header --%>
<%@ include file="header.jsp" %>

<%
    // Get current date and default end date (7 days later) for form defaults
    LocalDate currentDate = LocalDate.now();
    LocalDate defaultEndDate = currentDate.plusDays(7);
    
    String fromDateValue = currentDate.toString();
    String toDateValue = defaultEndDate.toString();
%>

<!-- Page Content -->
<div class="card">
    <div class="card-header">
        <h2><i class="fas fa-plus-circle"></i> Create Leave Request</h2>
    </div>
    <div class="card-body">
        <form action="leaveRequest" method="post" accept-charset="UTF-8">
            <input type="hidden" name="action" value="create">
            
            <div class="form-group">
                <label for="fromDate" class="form-label">From Date</label>
                <input type="date" id="fromDate" name="fromDate" class="form-control" 
                       value="<%= fromDateValue %>" min="<%= currentDate %>" required>
            </div>
            
            <div class="form-group">
                <label for="toDate" class="form-label">To Date</label>
                <input type="date" id="toDate" name="toDate" class="form-control" 
                       value="<%= toDateValue %>" min="<%= currentDate %>" required>
            </div>
            
            <div class="form-group">
                <label for="reason" class="form-label">Reason for Leave</label>
                <textarea id="reason" name="reason" class="form-control" rows="5" required 
                          placeholder="Please provide a detailed reason for your leave request..."></textarea>
                <div style="font-size: 14px; color: #777; margin-top: 5px;">
                    Your request will be reviewed by your manager. Please provide sufficient details.
                </div>
            </div>
            
            <div class="form-group" style="margin-top: 20px; background-color: #e1f5fe; padding: 15px; border-radius: 5px;">
                <p style="margin: 0;"><i class="fas fa-info-circle"></i> 
                    Please note that leave requests must be submitted at least 3 working days in advance 
                    for proper planning. Emergency leaves are handled on a case-by-case basis.
                </p>
            </div>
            
            <div style="display: flex; justify-content: space-between; margin-top: 20px;">
                <a href="viewLeaves.jsp" class="btn btn-secondary">
                    <i class="fas fa-arrow-left"></i> Cancel
                </a>
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-paper-plane"></i> Submit Request
                </button>
            </div>
        </form>
    </div>
</div>

<!-- Leave Policy Info -->
<div class="card">
    <div class="card-header">
        <h3><i class="fas fa-info-circle"></i> Leave Policy Guidelines</h3>
    </div>
    <div class="card-body">
        <div style="display: flex; flex-wrap: wrap; gap: 30px;">
            <div style="flex: 1; min-width: 250px;">
                <h4>Annual Leave Entitlements</h4>
                <ul>
                    <li>Regular employees: 12 days per year</li>
                    <li>Senior employees (>5 years): 15 days per year</li>
                    <li>Management: 18 days per year</li>
                </ul>
            </div>
            <div style="flex: 1; min-width: 250px;">
                <h4>Leave Types</h4>
                <ul>
                    <li>Annual Leave</li>
                    <li>Sick Leave (requires medical certificate)</li>
                    <li>Compassionate Leave</li>
                    <li>Study Leave</li>
                    <li>Maternity/Paternity Leave</li>
                </ul>
            </div>
        </div>
    </div>
</div>

<script>
    // Validate date range
    document.addEventListener('DOMContentLoaded', function() {
        const fromDateInput = document.getElementById('fromDate');
        const toDateInput = document.getElementById('toDate');
        
        fromDateInput.addEventListener('change', function() {
            if (toDateInput.value < fromDateInput.value) {
                toDateInput.value = fromDateInput.value;
            }
            toDateInput.min = fromDateInput.value;
        });
        
        toDateInput.min = fromDateInput.value;
    });
</script>

<%-- Include Footer --%>
<%@ include file="footer.jsp" %>