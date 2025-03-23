package dao;

import model.LeaveRequest;
import util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;

public class LeaveRequestDAO {
    public void createLeaveRequest(LeaveRequest request) {
        String sql = "INSERT INTO LeaveRequests (user_id, from_date, to_date, reason, status) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, request.getUserId());
            ps.setDate(2, request.getFromDate());
            ps.setDate(3, request.getToDate());
            ps.setString(4, request.getReason());
            ps.setString(5, "Inprogress");
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<LeaveRequest> getLeaveRequestsByUserId(int userId) {
        List<LeaveRequest> requests = new ArrayList<>();
        String sql = "SELECT * FROM LeaveRequests WHERE user_id = ? OR user_id IN (SELECT id FROM Users WHERE manager_id = ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                requests.add(new LeaveRequest(
                    rs.getInt("id"),
                    rs.getInt("user_id"),
                    rs.getDate("from_date"),
                    rs.getDate("to_date"),
                    rs.getString("reason"),
                    rs.getString("status"),
                    rs.getObject("processed_by") != null ? rs.getInt("processed_by") : null
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return requests;
    }
    
    // Phương thức mới để lấy tất cả đơn nghỉ phép (cho Super Admin)
    public List<LeaveRequest> getAllLeaveRequests() {
        List<LeaveRequest> requests = new ArrayList<>();
        String sql = "SELECT * FROM LeaveRequests ORDER BY status, from_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                requests.add(new LeaveRequest(
                    rs.getInt("id"),
                    rs.getInt("user_id"),
                    rs.getDate("from_date"),
                    rs.getDate("to_date"),
                    rs.getString("reason"),
                    rs.getString("status"),
                    rs.getObject("processed_by") != null ? rs.getInt("processed_by") : null
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return requests;
    }

    public void updateLeaveRequest(int id, String status, int processedBy) {
        String sql = "UPDATE LeaveRequests SET status = ?, processed_by = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, processedBy);
            ps.setInt(3, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    public LeaveRequest getLeaveRequestById(int id) {
        String sql = "SELECT * FROM LeaveRequests WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new LeaveRequest(
                    rs.getInt("id"),
                    rs.getInt("user_id"),
                    rs.getDate("from_date"),
                    rs.getDate("to_date"),
                    rs.getString("reason"),
                    rs.getString("status"),
                    rs.getObject("processed_by") != null ? rs.getInt("processed_by") : null
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public List<LeaveRequest> getApprovedLeavesByDepartment(String department, Date startDate, Date endDate) {
        List<LeaveRequest> requests = new ArrayList<>();
        
        // Đây là SQL chính xác để lấy tất cả đơn nghỉ phép được phê duyệt trong phòng ban và khoảng thời gian
        String sql = "SELECT lr.* FROM LeaveRequests lr " +
                     "JOIN Users u ON lr.user_id = u.id " +
                     "WHERE u.department = ? " +
                     "AND lr.status = 'Approved' " +
                     "AND (" +
                     "  (lr.from_date <= ? AND lr.to_date >= ?) OR " + // Trường hợp 1: Thời gian nghỉ bao gồm ngày bắt đầu
                     "  (lr.from_date <= ? AND lr.to_date >= ?) OR " + // Trường hợp 2: Thời gian nghỉ bao gồm ngày kết thúc
                     "  (lr.from_date >= ? AND lr.to_date <= ?)" +     // Trường hợp 3: Thời gian nghỉ nằm trong khoảng
                     ")";
                     
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, department);
            ps.setDate(2, startDate);
            ps.setDate(3, startDate);
            ps.setDate(4, endDate);
            ps.setDate(5, endDate);
            ps.setDate(6, startDate);
            ps.setDate(7, endDate);
            
            System.out.println("SQL: " + sql); // Debug SQL
            System.out.println("Department: " + department + ", Start: " + startDate + ", End: " + endDate); // Debug params
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                LeaveRequest req = new LeaveRequest(
                    rs.getInt("id"),
                    rs.getInt("user_id"),
                    rs.getDate("from_date"),
                    rs.getDate("to_date"),
                    rs.getString("reason"),
                    rs.getString("status"),
                    rs.getObject("processed_by") != null ? rs.getInt("processed_by") : null
                );
                requests.add(req);
                System.out.println("Found leave: " + req.getId() + " for user " + req.getUserId() + 
                                   " from " + req.getFromDate() + " to " + req.getToDate()); // Debug results
            }
        } catch (SQLException e) {
            System.out.println("Error in getApprovedLeavesByDepartment: " + e.getMessage());
            e.printStackTrace();
        }
        
        return requests;
    }
    
    // Phương thức mới để lấy tất cả đơn nghỉ phép được phê duyệt trong khoảng thời gian (cho tất cả phòng ban)
    public List<LeaveRequest> getAllApprovedLeaves(Date startDate, Date endDate) {
        List<LeaveRequest> requests = new ArrayList<>();
        String sql = "SELECT lr.* FROM LeaveRequests lr " +
                     "WHERE lr.status = 'Approved' " +
                     "AND (" +
                     "  (lr.from_date <= ? AND lr.to_date >= ?) OR " +
                     "  (lr.from_date <= ? AND lr.to_date >= ?) OR " +
                     "  (lr.from_date >= ? AND lr.to_date <= ?)" +
                     ")";
                     
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDate(1, startDate);
            ps.setDate(2, startDate);
            ps.setDate(3, endDate);
            ps.setDate(4, endDate);
            ps.setDate(5, startDate);
            ps.setDate(6, endDate);
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                requests.add(new LeaveRequest(
                    rs.getInt("id"),
                    rs.getInt("user_id"),
                    rs.getDate("from_date"),
                    rs.getDate("to_date"),
                    rs.getString("reason"),
                    rs.getString("status"),
                    rs.getObject("processed_by") != null ? rs.getInt("processed_by") : null
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return requests;
    }
}