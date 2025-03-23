package controller;

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

@WebServlet("/UserManagementServlet")
public class UserManagementServlet extends HttpServlet {
    
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
            handleDeleteUser(request, response);
        } else {
            // Default action is to view the user management page
            response.sendRedirect("admin-users.jsp");
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
        
        if ("add".equals(action)) {
            handleAddUser(request, response);
        } else if ("edit".equals(action)) {
            handleEditUser(request, response);
        } else {
            // Default action is to view the user management page
            response.sendRedirect("admin-users.jsp");
        }
    }
    
    private void handleAddUser(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get parameters
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");
        String department = request.getParameter("department");
        String managerIdParam = request.getParameter("managerId");
        
        int managerId = 0;
        try {
            // Safely parse managerId, default to 0 if invalid
            if (managerIdParam != null && !managerIdParam.trim().isEmpty()) {
                managerId = Integer.parseInt(managerIdParam.trim());
            }
        } catch (NumberFormatException e) {
            managerId = 0; // Default to 0 if parsing fails
        }
        
        // Validate input
        if (username == null || username.trim().isEmpty() || 
            password == null || password.trim().isEmpty() ||
            role == null || role.trim().isEmpty() ||
            department == null || department.trim().isEmpty()) {
            
            String message = "Vui lòng điền đầy đủ thông tin bắt buộc.";
            response.sendRedirect("admin-users.jsp?message=" + URLEncoder.encode(message, StandardCharsets.UTF_8) + "&type=error");
            return;
        }
        
        // Create new user
        User newUser = new User();
        newUser.setUsername(username);
        newUser.setPassword(password);
        newUser.setRole(role);
        newUser.setDepartment(department);
        newUser.setManagerId(managerId > 0 ? managerId : 0);
        
        // Add user to database
        UserDAO userDAO = new UserDAO();
        boolean success = userDAO.addUser(newUser);
        
        // Redirect with appropriate message
        String message;
        String type;
        
        if (success) {
            message = "Người dùng mới đã được thêm thành công.";
            type = "success";
        } else {
            message = "Không thể thêm người dùng mới. Tên đăng nhập có thể đã tồn tại.";
            type = "error";
        }
        
        response.sendRedirect("admin-users.jsp?message=" + URLEncoder.encode(message, StandardCharsets.UTF_8) + "&type=" + type);
    }
    
    private void handleEditUser(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get parameters
        int userId = Integer.parseInt(request.getParameter("userId"));
        String username = request.getParameter("username");
        String password = request.getParameter("password"); // Optional, can be empty
        String role = request.getParameter("role");
        String department = request.getParameter("department");
        int managerId = Integer.parseInt(request.getParameter("managerId"));
        
        // Validate input
        if (username == null || username.trim().isEmpty() ||
            role == null || role.trim().isEmpty() ||
            department == null || department.trim().isEmpty()) {
            
            String message = "Vui lòng điền đầy đủ thông tin bắt buộc.";
            response.sendRedirect("admin-users.jsp?message=" + URLEncoder.encode(message, StandardCharsets.UTF_8) + "&type=error");
            return;
        }
        
        // Get existing user
        UserDAO userDAO = new UserDAO();
        User existingUser = userDAO.getUserById(userId);
        
        if (existingUser == null) {
            String message = "Không tìm thấy người dùng với ID: " + userId;
            response.sendRedirect("admin-users.jsp?message=" + URLEncoder.encode(message, StandardCharsets.UTF_8) + "&type=error");
            return;
        }
        
        // Update user details
        existingUser.setUsername(username);
        if (password != null && !password.trim().isEmpty()) {
            existingUser.setPassword(password);
        }
        existingUser.setRole(role);
        existingUser.setDepartment(department);
        existingUser.setManagerId(managerId > 0 ? managerId : 0);
        
        // Update user in database
        boolean success = userDAO.updateUser(existingUser);
        
        // Redirect with appropriate message
        String message;
        String type;
        
        if (success) {
            message = "Thông tin người dùng đã được cập nhật thành công.";
            type = "success";
        } else {
            message = "Không thể cập nhật thông tin người dùng.";
            type = "error";
        }
        
        response.sendRedirect("admin-users.jsp?message=" + URLEncoder.encode(message, StandardCharsets.UTF_8) + "&type=" + type);
    }
    
    private void handleDeleteUser(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get user ID
        int userId = Integer.parseInt(request.getParameter("userId"));
        
        // Delete user
        UserDAO userDAO = new UserDAO();
        boolean success = userDAO.deleteUser(userId);
        
        // Redirect with appropriate message
        String message;
        String type;
        
        if (success) {
            message = "Người dùng đã được xóa thành công.";
            type = "success";
        } else {
            message = "Không thể xóa người dùng. Người dùng có thể đang có đơn nghỉ phép hoặc là quản lý của người khác.";
            type = "error";
        }
        
        response.sendRedirect("admin-users.jsp?message=" + URLEncoder.encode(message, StandardCharsets.UTF_8) + "&type=" + type);
    }
}