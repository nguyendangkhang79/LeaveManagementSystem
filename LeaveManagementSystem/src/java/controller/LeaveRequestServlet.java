package controller;

import dao.LeaveRequestDAO;
import model.LeaveRequest;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Date;

@WebServlet("/leaveRequest")
public class LeaveRequestServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Set character encoding for request and response
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession();
        model.User user = (model.User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        LeaveRequestDAO dao = new LeaveRequestDAO();

        if ("create".equals(action)) {
            LeaveRequest leave = new LeaveRequest();
            leave.setUserId(user.getId());
            leave.setFromDate(Date.valueOf(request.getParameter("fromDate")));
            leave.setToDate(Date.valueOf(request.getParameter("toDate")));
            leave.setReason(request.getParameter("reason"));
            dao.createLeaveRequest(leave);
            response.sendRedirect("viewLeaves.jsp");
        } else if ("approve".equals(action) || "reject".equals(action)) {
            int leaveId = Integer.parseInt(request.getParameter("leaveId"));
            String status = "approve".equals(action) ? "Approved" : "Rejected";
            
            // Thêm lấy giá trị approvalNote từ request
            String approvalNote = request.getParameter("approvalNote");
            
            // Gọi phương thức updateLeaveRequest có tham số approvalNote
            dao.updateLeaveRequest(leaveId, status, user.getId(), approvalNote);
            
            response.sendRedirect("viewLeaves.jsp");
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Set character encoding for request and response
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        // Handle GET requests if needed
        response.sendRedirect("viewLeaves.jsp");
    }
}