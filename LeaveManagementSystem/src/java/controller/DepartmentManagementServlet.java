package controller;

import dao.DepartmentDAO;
import dao.UserDAO;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@WebServlet("/DepartmentManagementServlet")
public class DepartmentManagementServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Set character encoding
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        // Get current user from session
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        // Security check: only Admin can access this servlet
        if (currentUser == null || !currentUser.isAdmin()) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("delete".equals(action)) {
            handleDeleteDepartment(request, response);
        } else {
            // Default action is to view the department management page
            response.sendRedirect("admin-departments.jsp");
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Set character encoding
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        // Get current user from session
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        // Security check: only Admin can access this servlet
        if (currentUser == null || !currentUser.isAdmin()) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("create".equals(action)) {
            handleCreateDepartment(request, response);
        } else if ("update".equals(action)) {
            handleUpdateDepartment(request, response);
        } else if ("transfer".equals(action)) {
            handleTransferEmployees(request, response);
        } else {
            // Default action is to view the department management page
            response.sendRedirect("admin-departments.jsp");
        }
    }
    
    private void handleCreateDepartment(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get parameters
        String departmentName = request.getParameter("departmentName");
        String description = request.getParameter("description");
        String managerIdStr = request.getParameter("managerId");
        
        int managerId = 0;
        if (managerIdStr != null && !managerIdStr.isEmpty()) {
            try {
                managerId = Integer.parseInt(managerIdStr);
            } catch (NumberFormatException e) {
                // Invalid manager ID, use default 0
                managerId = 0;
            }
        }
        
        // Validate department name
        if (departmentName == null || departmentName.trim().isEmpty()) {
            String message = "Tên phòng ban không được để trống.";
            response.sendRedirect("create-department.jsp?message=" + URLEncoder.encode(message, StandardCharsets.UTF_8) + "&type=error");
            return;
        }
        
        // Check if manager exists
        if (managerId > 0) {
            UserDAO userDAO = new UserDAO();
            User manager = userDAO.getUserById(managerId);
            if (manager == null) {
                String message = "Không tìm thấy quản lý với ID: " + managerId;
                response.sendRedirect("create-department.jsp?message=" + URLEncoder.encode(message, StandardCharsets.UTF_8) + "&type=error");
                return;
            }
            
            // Ensure manager has appropriate role
            if (!"Manager".equals(manager.getRole()) && !"Admin".equals(manager.getRole())) {
                String message = "Người được chọn không có vai trò quản lý.";
                response.sendRedirect("create-department.jsp?message=" + URLEncoder.encode(message, StandardCharsets.UTF_8) + "&type=error");
                return;
            }
        }
        
        // Create department
        DepartmentDAO departmentDAO = new DepartmentDAO();
        boolean success = departmentDAO.createDepartment(departmentName, description, managerId);
        
        // Redirect with appropriate message
        if (success) {
            String message = "Phòng ban mới đã được tạo thành công.";
            response.sendRedirect("admin-departments.jsp?message=" + URLEncoder.encode(message, StandardCharsets.UTF_8) + "&type=success");
        } else {
            String message = "Không thể tạo phòng ban mới. Phòng ban có thể đã tồn tại.";
            response.sendRedirect("create-department.jsp?message=" + URLEncoder.encode(message, StandardCharsets.UTF_8) + "&type=error");
        }
    }
    
    private void handleUpdateDepartment(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get parameters
        String departmentId = request.getParameter("departmentId");
        String departmentName = request.getParameter("departmentName");
        String description = request.getParameter("description");
        String managerIdStr = request.getParameter("managerId");
        
        int managerId = 0;
        if (managerIdStr != null && !managerIdStr.isEmpty()) {
            try {
                managerId = Integer.parseInt(managerIdStr);
            } catch (NumberFormatException e) {
                // Invalid manager ID, use default 0
                managerId = 0;
            }
        }
        
        // Validate department name
        if (departmentName == null || departmentName.trim().isEmpty()) {
            String message = "Tên phòng ban không được để trống.";
            response.sendRedirect("edit-department.jsp?id=" + departmentId + "&message=" + URLEncoder.encode(message, StandardCharsets.UTF_8) + "&type=error");
            return;
        }
        
        // Update department
        DepartmentDAO departmentDAO = new DepartmentDAO();
        boolean success = departmentDAO.updateDepartment(Integer.parseInt(departmentId), departmentName, description, managerId);
        
        // Redirect with appropriate message
        if (success) {
            String message = "Phòng ban đã được cập nhật thành công.";
            response.sendRedirect("admin-departments.jsp?message=" + URLEncoder.encode(message, StandardCharsets.UTF_8) + "&type=success");
        } else {
            String message = "Không thể cập nhật phòng ban.";
            response.sendRedirect("edit-department.jsp?id=" + departmentId + "&message=" + URLEncoder.encode(message, StandardCharsets.UTF_8) + "&type=error");
        }
    }
    
    private void handleDeleteDepartment(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get department ID
        String departmentId = request.getParameter("id");
        
        // Validate department ID
        if (departmentId == null || departmentId.trim().isEmpty()) {
            String message = "ID phòng ban không hợp lệ.";
            response.sendRedirect("admin-departments.jsp?message=" + URLEncoder.encode(message, StandardCharsets.UTF_8) + "&type=error");
            return;
        }
        
        // Delete department
        DepartmentDAO departmentDAO = new DepartmentDAO();
        boolean success = departmentDAO.deleteDepartment(Integer.parseInt(departmentId));
        
        // Redirect with appropriate message
        if (success) {
            String message = "Phòng ban đã được xóa thành công.";
            response.sendRedirect("admin-departments.jsp?message=" + URLEncoder.encode(message, StandardCharsets.UTF_8) + "&type=success");
        } else {
            String message = "Không thể xóa phòng ban. Phòng ban có thể đang có nhân viên.";
            response.sendRedirect("admin-departments.jsp?message=" + URLEncoder.encode(message, StandardCharsets.UTF_8) + "&type=error");
        }
    }
    
    private void handleTransferEmployees(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get parameters
        String sourceDeptId = request.getParameter("sourceDeptId");
        String targetDeptId = request.getParameter("targetDeptId");
        
        // Validate department IDs
        if (sourceDeptId == null || sourceDeptId.trim().isEmpty() || targetDeptId == null || targetDeptId.trim().isEmpty()) {
            String message = "ID phòng ban không hợp lệ.";
            response.sendRedirect("admin-departments.jsp?message=" + URLEncoder.encode(message, StandardCharsets.UTF_8) + "&type=error");
            return;
        }
        
        // Transfer employees
        DepartmentDAO departmentDAO = new DepartmentDAO();
        boolean success = departmentDAO.transferEmployees(Integer.parseInt(sourceDeptId), Integer.parseInt(targetDeptId));
        
        // Redirect with appropriate message
        if (success) {
            String message = "Chuyển nhân viên thành công.";
            response.sendRedirect("admin-departments.jsp?message=" + URLEncoder.encode(message, StandardCharsets.UTF_8) + "&type=success");
        } else {
            String message = "Không thể chuyển nhân viên.";
            response.sendRedirect("admin-departments.jsp?message=" + URLEncoder.encode(message, StandardCharsets.UTF_8) + "&type=error");
        }
    }
}