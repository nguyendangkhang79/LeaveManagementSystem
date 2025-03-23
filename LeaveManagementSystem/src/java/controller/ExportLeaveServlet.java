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
import java.io.PrintWriter;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

@WebServlet("/ExportLeaveServlet")
public class ExportLeaveServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Set character encoding
            request.setCharacterEncoding("UTF-8");
            
            // Get current user from session
            HttpSession session = request.getSession();
            User currentUser = (User) session.getAttribute("user");
            
            // Check if user is logged in
            if (currentUser == null) {
                response.sendRedirect("login.jsp");
                return;
            }
            
            // Get filter parameters
            String statusFilter = request.getParameter("status");
            if (statusFilter == null) {
                statusFilter = "all"; // Default to all
            }
            
            String searchTerm = request.getParameter("search");
            if (searchTerm == null) {
                searchTerm = "";
            }
            
            // Get leave requests
            LeaveRequestDAO leaveDAO = new LeaveRequestDAO();
            List<LeaveRequest> allRequests;
            
            // Get requests based on user role
            if (currentUser.isAdmin()) {
                allRequests = leaveDAO.getAllLeaveRequests();
            } else {
                allRequests = leaveDAO.getLeaveRequestsByUserId(currentUser.getId());
            }
            
            // Filter requests based on status and search term
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
            
            // Get user information for display
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
                    } else {
                        usernames.put(req.getProcessedBy(), "Unknown User");
                    }
                }
            }
            
            // Thiết lập CSV response
            response.setContentType("text/csv");
            response.setCharacterEncoding("UTF-8");
            response.setHeader("Content-Disposition", "attachment; filename=DanhSachDonNghiPhep.csv");
            
            PrintWriter writer = response.getWriter();
            
            // Viết BOM cho UTF-8
            writer.write('\ufeff');
            
            // Viết tiêu đề cột
            if (currentUser.isAdmin()) {
                writer.println("ID,Nhân viên,Phòng ban,Từ ngày,Đến ngày,Lý do,Trạng thái,Người duyệt,Ghi chú");
            } else {
                writer.println("ID,Nhân viên,Từ ngày,Đến ngày,Lý do,Trạng thái,Người duyệt,Ghi chú");
            }
            
            // Viết dữ liệu
            for (LeaveRequest req : filteredRequests) {
                StringBuilder line = new StringBuilder();
                
                // ID
                line.append(req.getId()).append(",");
                
                // Employee name
                line.append(escapeCSV(usernames.getOrDefault(req.getUserId(), "ID: " + req.getUserId()))).append(",");
                
                // Department (admin only)
                if (currentUser.isAdmin()) {
                    line.append(escapeCSV(departments.getOrDefault(req.getUserId(), ""))).append(",");
                }
                
                // From date
                line.append(req.getFromDate().toString()).append(",");
                
                // To date
                line.append(req.getToDate().toString()).append(",");
                
                // Reason
                String reason = req.getReason();
                if (reason.length() > 100) {
                    reason = reason.substring(0, 100) + "...";
                }
                line.append(escapeCSV(reason)).append(",");
                
                // Status
                line.append(escapeCSV(req.getStatus())).append(",");
                
                // Processed by
                if (req.getProcessedBy() != null) {
                    line.append(escapeCSV(usernames.getOrDefault(req.getProcessedBy(), "ID: " + req.getProcessedBy())));
                } else {
                    line.append("-");
                }
                line.append(",");
                
                // Approval note
                if (req.getApprovalNote() != null && !req.getApprovalNote().isEmpty()) {
                    line.append(escapeCSV(req.getApprovalNote()));
                } else {
                    line.append("-");
                }
                
                writer.println(line.toString());
            }
            
            writer.flush();
            writer.close();
            
        } catch (Exception e) {
            // Xử lý lỗi - hiển thị thông tin lỗi để gỡ rối
            response.setContentType("text/html;charset=UTF-8");
            PrintWriter out = response.getWriter();
            out.println("<html><body>");
            out.println("<h1>Lỗi khi xuất CSV</h1>");
            out.println("<p>Lỗi: " + e.getMessage() + "</p>");
            out.println("<p>Stack trace:</p>");
            out.println("<pre>");
            e.printStackTrace(out);
            out.println("</pre>");
            out.println("</body></html>");
        }
    }
    
    // Hàm hỗ trợ: Escape các ký tự đặc biệt trong CSV
    private String escapeCSV(String input) {
        if (input == null) {
            return "";
        }
        
        // Nếu có dấu phẩy, dấu nháy kép hoặc xuống dòng, bọc chuỗi trong dấu nháy kép
        if (input.contains(",") || input.contains("\"") || input.contains("\n")) {
            // Thay thế dấu nháy kép thành hai dấu nháy kép (quy tắc CSV)
            return "\"" + input.replace("\"", "\"\"") + "\"";
        }
        
        return input;
    }
}