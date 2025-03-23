package model;

public class Department {
    private int id;
    private String name;
    private String description;
    private int managerId;
    private String managerName; // Không lưu vào DB, chỉ để hiển thị

    // Constructor
    public Department() {
    }

    public Department(int id, String name, String description, int managerId) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.managerId = managerId;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getManagerId() {
        return managerId;
    }

    public void setManagerId(int managerId) {
        this.managerId = managerId;
    }

    public String getManagerName() {
        return managerName;
    }

    public void setManagerName(String managerName) {
        this.managerName = managerName;
    }

    @Override
    public String toString() {
        return "Department{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", managerId=" + managerId +
                '}';
    }
}