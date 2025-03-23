package model;

import java.sql.Date;

public class LeaveRequest {
    private int id;
    private int userId;
    private Date fromDate;
    private Date toDate;
    private String reason;
    private String status;
    private Integer processedBy;

    // Constructor, Getters, Setters
    public LeaveRequest() {}
    public LeaveRequest(int id, int userId, Date fromDate, Date toDate, String reason, String status, Integer processedBy) {
        this.id = id;
        this.userId = userId;
        this.fromDate = fromDate;
        this.toDate = toDate;
        this.reason = reason;
        this.status = status;
        this.processedBy = processedBy;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public Date getFromDate() { return fromDate; }
    public void setFromDate(Date fromDate) { this.fromDate = fromDate; }
    public Date getToDate() { return toDate; }
    public void setToDate(Date toDate) { this.toDate = toDate; }
    public String getReason() { return reason; }
    public void setReason(String reason) { this.reason = reason; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public Integer getProcessedBy() { return processedBy; }
    public void setProcessedBy(Integer processedBy) { this.processedBy = processedBy; }
}