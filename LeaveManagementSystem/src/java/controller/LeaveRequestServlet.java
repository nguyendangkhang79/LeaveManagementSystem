package controller;

import dao.LeaveRequestDAO;
import dao.UserDAO;
import model.LeaveRequest;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Date;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

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
        UserDAO userDAO = new UserDAO();

        if ("create".equals(action)) {
            LeaveRequest leave = new LeaveRequest();
            leave.setUserId(user.getId());
            leave.setFromDate(Date.valueOf(request.getParameter("fromDate")));
            leave.setToDate(Date.valueOf(request.getParameter("toDate")));
            leave.setReason(request.getParameter("reason"));
            dao.createLeaveRequest(leave);
            response.sendRedirect("viewLeaves.jsp");
        } else if ("approve".equals(action) || "reject".equals(action)) {
            try {
                int leaveId = Integer.parseInt(request.getParameter("leaveId"));
                
                // Lấy thông tin về đơn nghỉ phép
                LeaveRequest leaveRequest = dao.getLeaveRequestById(leaveId);
                
                if (leaveRequest == null) {
                    response.sendRedirect("viewLeaves.jsp?message=" + URLEncoder.encode("Không tìm thấy đơn nghỉ phép.", StandardCharsets.UTF_8) + "&type=error");
                    return;
                }
                
                // Lấy thông tin về người tạo đơn
                User requestUser = userDAO.getUserById(leaveRequest.getUserId());
                String requestUserDepartment = requestUser != null ? requestUser.getDepartment() : "";
                
                // Kiểm tra quyền duyệt đơn
                boolean canApprove = false;
                
                // Admin có thể duyệt mọi đơn (ngoại trừ đơn của chính họ)
                if (user.isAdmin() && leaveRequest.getUserId() != user.getId()) {
                    canApprove = true;
                } 
                // Manager có thể duyệt đơn của nhân viên trong phòng ban của họ (không phải đơn của chính họ)
                else if (user.isManager() && 
                         user.getDepartment().equals(requestUserDepartment) && 
                         leaveRequest.getUserId() != user.getId()) {
                    canApprove = true;
                }
                
                if (!canApprove) {
                    String message = leaveRequest.getUserId() == user.getId() 
                        ? "Bạn không thể duyệt đơn nghỉ phép của chính mình." 
                        : "Bạn không có quyền duyệt đơn nghỉ phép này.";
                    response.sendRedirect("viewLeaves.jsp?message=" + URLEncoder.encode(message, StandardCharsets.UTF_8) + "&type=error");
                    return;
                }
                
                // Tiến hành phê duyệt hoặc từ chối đơn
                String status = "approve".equals(action) ? "Approved" : "Rejected";
                String approvalNote = request.getParameter("approvalNote");
                
                dao.updateLeaveRequest(leaveId, status, user.getId(), approvalNote);
                
                String successMsg = "approve".equals(action) ? "Đơn nghỉ phép đã được phê duyệt thành công." : "Đơn nghỉ phép đã bị từ chối.";
                response.sendRedirect("viewLeaves.jsp?message=" + URLEncoder.encode(successMsg, StandardCharsets.UTF_8) + "&type=success");
            } catch (NumberFormatException e) {
                response.sendRedirect("viewLeaves.jsp?message=" + URLEncoder.encode("ID đơn nghỉ phép không hợp lệ.", StandardCharsets.UTF_8) + "&type=error");
            } catch (Exception e) {
                response.sendRedirect("viewLeaves.jsp?message=" + URLEncoder.encode("Đã xảy ra lỗi: " + e.getMessage(), StandardCharsets.UTF_8) + "&type=error");
            }
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