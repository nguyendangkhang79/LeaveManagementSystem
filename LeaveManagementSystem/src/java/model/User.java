package model;

public class User {
    private int id;
    private String username;
    private String password;
    private String role;  // 'Employee', 'Manager', hoặc 'Admin'
    private String department;
    private int managerId;
    private Integer departmentId; // ID của phòng ban trong bảng Departments

    // Constructor, Getters, Setters
    public User() {}
    
    public User(int id, String username, String password, String role, String department, int managerId) {
        this.id = id;
        this.username = username;
        this.password = password;
        this.role = role;
        this.department = department;
        this.managerId = managerId;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    
    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }
    
    public String getDepartment() { return department; }
    public void setDepartment(String department) { this.department = department; }
    
    public int getManagerId() { return managerId; }
    public void setManagerId(int managerId) { this.managerId = managerId; }
    
    public Integer getDepartmentId() { return departmentId; }
    public void setDepartmentId(Integer departmentId) { this.departmentId = departmentId; }
    
    // Phương thức kiểm tra quyền Super Admin
    public boolean isAdmin() {
        return "Admin".equals(this.role);
    }
    
    // Phương thức kiểm tra quyền Manager
    public boolean isManager() {
        return "Manager".equals(this.role);
    }
    
    // Phương thức kiểm tra quyền Employee
    public boolean isEmployee() {
        return "Employee".equals(this.role);
    }
}