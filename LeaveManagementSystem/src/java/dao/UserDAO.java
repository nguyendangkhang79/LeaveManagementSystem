package dao;

import model.User;
import util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {
    public User getUserByUsername(String username) {
        String sql = "SELECT * FROM Users WHERE username = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                User user = new User(
                    rs.getInt("id"),
                    rs.getString("username"),
                    rs.getString("password"),
                    rs.getString("role"),
                    rs.getString("department"),
                    rs.getInt("manager_id")
                );
                // Thêm department_id nếu có
                try {
                    user.setDepartmentId(rs.getInt("department_id"));
                } catch (SQLException e) {
                    // Trường hợp department_id chưa được thêm vào bảng
                    user.setDepartmentId(0);
                }
                return user;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public List<User> getUsersByDepartment(String department) {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM Users WHERE department = ? ORDER BY username";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, department);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                User user = new User(
                    rs.getInt("id"),
                    rs.getString("username"),
                    rs.getString("password"),
                    rs.getString("role"),
                    rs.getString("department"),
                    rs.getInt("manager_id")
                );
                // Thêm department_id nếu có
                try {
                    user.setDepartmentId(rs.getInt("department_id"));
                } catch (SQLException e) {
                    // Trường hợp department_id chưa được thêm vào bảng
                    user.setDepartmentId(0);
                }
                users.add(user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }
    
    public List<User> getUsersByDepartmentId(int departmentId) {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM Users WHERE department_id = ? ORDER BY username";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, departmentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                User user = new User(
                    rs.getInt("id"),
                    rs.getString("username"),
                    rs.getString("password"),
                    rs.getString("role"),
                    rs.getString("department"),
                    rs.getInt("manager_id")
                );
                user.setDepartmentId(rs.getInt("department_id"));
                users.add(user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }
    
    // Lấy tất cả người dùng cho Super Admin
    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM Users ORDER BY department, username";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                User user = new User(
                    rs.getInt("id"),
                    rs.getString("username"),
                    rs.getString("password"),
                    rs.getString("role"),
                    rs.getString("department"),
                    rs.getInt("manager_id")
                );
                // Thêm department_id nếu có
                try {
                    user.setDepartmentId(rs.getInt("department_id"));
                } catch (SQLException e) {
                    // Trường hợp department_id chưa được thêm vào bảng
                    user.setDepartmentId(0);
                }
                users.add(user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }
    
    // Lấy tất cả phòng ban (cho Super Admin)
    public List<String> getAllDepartments() {
        List<String> departments = new ArrayList<>();
        String sql = "SELECT DISTINCT department FROM Users ORDER BY department";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                departments.add(rs.getString("department"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return departments;
    }
    
    public User getUserById(int userId) {
        String sql = "SELECT * FROM Users WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                User user = new User(
                    rs.getInt("id"),
                    rs.getString("username"),
                    rs.getString("password"),
                    rs.getString("role"),
                    rs.getString("department"),
                    rs.getInt("manager_id")
                );
                // Thêm department_id nếu có
                try {
                    user.setDepartmentId(rs.getInt("department_id"));
                } catch (SQLException e) {
                    // Trường hợp department_id chưa được thêm vào bảng
                    user.setDepartmentId(0);
                }
                return user;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Thêm người dùng mới (cho Super Admin)
    // Thêm người dùng mới (cho Super Admin)
public boolean addUser(User user) {
    String sql = "INSERT INTO Users (username, password, role, department, department_id, manager_id) VALUES (?, ?, ?, ?, ?, ?)";
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setString(1, user.getUsername());
        ps.setString(2, user.getPassword());
        ps.setString(3, user.getRole());
        ps.setString(4, user.getDepartment());
        
        // Xử lý trường hợp departmentId là null
        Integer departmentId = user.getDepartmentId();
        if (departmentId != null && departmentId > 0) {
            ps.setInt(5, departmentId);
        } else {
            ps.setNull(5, java.sql.Types.INTEGER);
        }
        
        // Xử lý trường hợp managerId = 0
        int managerId = user.getManagerId();
        if (managerId > 0) {
            ps.setInt(6, managerId);
        } else {
            ps.setNull(6, java.sql.Types.INTEGER);
        }
        
        int result = ps.executeUpdate();
        return result > 0;
    } catch (SQLException e) {
        e.printStackTrace();
        return false;
    }
}
    
    // Cập nhật thông tin người dùng (cho Super Admin)
    public boolean updateUser(User user) {
        String sql = "UPDATE Users SET username=?, role=?, department=?, manager_id=?, department_id=?";
        
        // Nếu có mật khẩu mới, cập nhật luôn mật khẩu
        if (user.getPassword() != null && !user.getPassword().isEmpty()) {
            sql += ", password=?";
        }
        
        sql += " WHERE id=?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getRole());
            ps.setString(3, user.getDepartment());
            ps.setInt(4, user.getManagerId());
            
            if (user.getDepartmentId() > 0) {
                ps.setInt(5, user.getDepartmentId());
            } else {
                ps.setNull(5, java.sql.Types.INTEGER);
            }
            
            if (user.getPassword() != null && !user.getPassword().isEmpty()) {
                ps.setString(6, user.getPassword());
                ps.setInt(7, user.getId());
            } else {
                ps.setInt(6, user.getId());
            }
            
            int result = ps.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Xóa người dùng (cho Super Admin)
    public boolean deleteUser(int userId) {
        // Kiểm tra xem có ai đang tham chiếu đến người dùng này không
        if (hasReferences(userId)) {
            return false;
        }
        
        String sql = "DELETE FROM Users WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            
            int result = ps.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Kiểm tra xem có ai đang tham chiếu đến người dùng này không
    private boolean hasReferences(int userId) {
        // Kiểm tra trong bảng Users (có ai lấy người này làm manager không)
        String sql1 = "SELECT COUNT(*) FROM Users WHERE manager_id=?";
        // Kiểm tra trong bảng Departments (có ai lấy người này làm manager không)
        String sql2 = "SELECT COUNT(*) FROM Departments WHERE manager_id=?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps1 = conn.prepareStatement(sql1);
             PreparedStatement ps2 = conn.prepareStatement(sql2)) {
            
            // Kiểm tra tham chiếu trong Users
            ps1.setInt(1, userId);
            ResultSet rs1 = ps1.executeQuery();
            if (rs1.next() && rs1.getInt(1) > 0) {
                return true; // Có tham chiếu
            }
            
            // Kiểm tra tham chiếu trong Departments
            ps2.setInt(1, userId);
            ResultSet rs2 = ps2.executeQuery();
            if (rs2.next() && rs2.getInt(1) > 0) {
                return true; // Có tham chiếu
            }
            
            return false; // Không có tham chiếu
        } catch (SQLException e) {
            e.printStackTrace();
            return true; // Mặc định trả về true để tránh xóa không an toàn
        }
    }
    
    // Kiểm tra xem tên người dùng đã tồn tại chưa
    public boolean isUsernameExists(String username) {
        String sql = "SELECT COUNT(*) FROM Users WHERE username=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            return false;
        } catch (SQLException e) {
            e.printStackTrace();
            return true; // Mặc định trả về true để đảm bảo an toàn
        }
    }
}