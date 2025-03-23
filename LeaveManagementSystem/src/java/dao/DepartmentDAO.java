package dao;

import model.Department;
import util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class DepartmentDAO {
    
    // Lấy tất cả các phòng ban
    public List<Department> getAllDepartments() {
        List<Department> departments = new ArrayList<>();
        String sql = "SELECT d.*, u.username as manager_name " +
                     "FROM Departments d " +
                     "LEFT JOIN Users u ON d.manager_id = u.id " +
                     "ORDER BY d.name";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Department dept = new Department();
                dept.setId(rs.getInt("id"));
                dept.setName(rs.getString("name"));
                dept.setDescription(rs.getString("description"));
                dept.setManagerId(rs.getInt("manager_id"));
                dept.setManagerName(rs.getString("manager_name"));
                
                departments.add(dept);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return departments;
    }
    
    // Lấy thông tin chi tiết của một phòng ban
    public Department getDepartmentById(int departmentId) {
        String sql = "SELECT d.*, u.username as manager_name " +
                     "FROM Departments d " +
                     "LEFT JOIN Users u ON d.manager_id = u.id " +
                     "WHERE d.id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, departmentId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                Department dept = new Department();
                dept.setId(rs.getInt("id"));
                dept.setName(rs.getString("name"));
                dept.setDescription(rs.getString("description"));
                dept.setManagerId(rs.getInt("manager_id"));
                dept.setManagerName(rs.getString("manager_name"));
                
                return dept;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    // Lấy phòng ban theo tên
    public Department getDepartmentByName(String departmentName) {
        String sql = "SELECT d.*, u.username as manager_name " +
                     "FROM Departments d " +
                     "LEFT JOIN Users u ON d.manager_id = u.id " +
                     "WHERE d.name = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, departmentName);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                Department dept = new Department();
                dept.setId(rs.getInt("id"));
                dept.setName(rs.getString("name"));
                dept.setDescription(rs.getString("description"));
                dept.setManagerId(rs.getInt("manager_id"));
                dept.setManagerName(rs.getString("manager_name"));
                
                return dept;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    // Tạo phòng ban mới
    public boolean createDepartment(String name, String description, int managerId) {
        // Kiểm tra xem phòng ban đã tồn tại chưa
        if (isDepartmentExists(name)) {
            return false;
        }
        
        String sql = "INSERT INTO Departments (name, description, manager_id) VALUES (?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, name);
            ps.setString(2, description);
            
            if (managerId > 0) {
                ps.setInt(3, managerId);
            } else {
                ps.setNull(3, java.sql.Types.INTEGER);
            }
            
            int result = ps.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Cập nhật thông tin phòng ban
    public boolean updateDepartment(int departmentId, String name, String description, int managerId) {
        // Kiểm tra xem phòng ban có tồn tại không
        Department dept = getDepartmentById(departmentId);
        if (dept == null) {
            return false;
        }
        
        // Kiểm tra xem tên mới có trùng với phòng ban khác không
        if (!dept.getName().equals(name) && isDepartmentExists(name)) {
            return false;
        }
        
        String sql = "UPDATE Departments SET name = ?, description = ?, manager_id = ? WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, name);
            ps.setString(2, description);
            
            if (managerId > 0) {
                ps.setInt(3, managerId);
            } else {
                ps.setNull(3, java.sql.Types.INTEGER);
            }
            
            ps.setInt(4, departmentId);
            
            int result = ps.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Xóa phòng ban
    public boolean deleteDepartment(int departmentId) {
        // Kiểm tra xem phòng ban có nhân viên không
        if (hasDepartmentEmployees(departmentId)) {
            return false;
        }
        
        String sql = "DELETE FROM Departments WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, departmentId);
            
            int result = ps.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Kiểm tra xem phòng ban đã tồn tại chưa
    public boolean isDepartmentExists(String departmentName) {
        String sql = "SELECT COUNT(*) FROM Departments WHERE name = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, departmentName);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    // Kiểm tra xem phòng ban có nhân viên không
    public boolean hasDepartmentEmployees(int departmentId) {
        String sql = "SELECT COUNT(*) FROM Users WHERE department_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, departmentId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    // Đếm số nhân viên trong phòng ban
    public int countDepartmentEmployees(int departmentId) {
        String sql = "SELECT COUNT(*) FROM Users WHERE department_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, departmentId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return 0;
    }
    
    // Chuyển nhân viên từ phòng ban này sang phòng ban khác
    public boolean transferEmployees(int sourceDeptId, int targetDeptId) {
        String sql = "UPDATE Users SET department_id = ? WHERE department_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, targetDeptId);
            ps.setInt(2, sourceDeptId);
            
            int result = ps.executeUpdate();
            return result >= 0; // Có thể không có nhân viên nào được chuyển
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Lấy danh sách nhân viên trong phòng ban
    public List<Integer> getDepartmentEmployeeIds(int departmentId) {
        List<Integer> employeeIds = new ArrayList<>();
        String sql = "SELECT id FROM Users WHERE department_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, departmentId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                employeeIds.add(rs.getInt("id"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return employeeIds;
    }
}