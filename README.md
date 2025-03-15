# Hệ Thống Quản Lý Đơn Nghỉ Phép  
![Trạng thái](https://img.shields.io/badge/Trạng_thái-Đang_phát_triển-blue?style=for-the-badge)

## 1. Giới thiệu  
Hệ thống này hỗ trợ nhân viên **tạo và theo dõi đơn nghỉ phép**, đồng thời cho phép quản lý **xét duyệt đơn** của cấp dưới. Được phát triển với **Java Servlet & JSP**, kết nối **SQL Server** qua JDBC, chạy trên **Apache Tomcat 10.1.36** và tuân theo mô hình **MVC**.

## 2. Công nghệ sử dụng  
- **Backend**: Java Servlet & JSP  
- **Frontend**: HTML/CSS, JSP  
- **Database**: SQL Server (JDBC)  
- **Server**: Apache Tomcat 10.1.36  
- **Không sử dụng**: Maven, JSON  

## 3. Chức năng chính  
- **Đăng nhập và phân quyền**: Nhân viên và quản lý.  
- **Tạo đơn nghỉ phép**: Gửi yêu cầu nghỉ với thông tin chi tiết.  
- **Xét duyệt đơn**: Quản lý duyệt hoặc từ chối đơn.  
- **Xem lịch nghỉ**: Trưởng phòng theo dõi tình hình nhân sự.  

## 4. Cấu trúc thư mục  
LeaveRequestSystem/
│── WebContent/ (Giao diện JSP, CSS)
│── src/ (Code Java: Controller, Model, DAO)
│── WEB-INF/ (Cấu hình web.xml)
│── lib/ (Thư viện JDBC)

## 5. Cấu trúc Database  
```sql
CREATE TABLE Users (
    user_id INT PRIMARY KEY IDENTITY(1,1),
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL,
    department VARCHAR(50) NOT NULL
);

CREATE TABLE LeaveRequests (
    request_id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT FOREIGN KEY REFERENCES Users(user_id),
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
    reason TEXT NOT NULL,
    status VARCHAR(20) DEFAULT 'Inprogress',
    processed_by INT FOREIGN KEY REFERENCES Users(user_id) NULL
);
##6. Hướng dẫn cài đặt
Yêu cầu hệ thống
JDK 11+
Apache Tomcat 10.1.36
SQL Server với JDBC Driver
Bước 1: Cấu hình cơ sở dữ liệu
Tạo database LeaveSystem trên SQL Server.
Thực thi các lệnh SQL ở trên để tạo bảng.
Bước 2: Cấu hình kết nối JDBC
Chỉnh sửa thông tin kết nối trong DBConnection.java:
private static final String URL = "jdbc:sqlserver://localhost:1433;databaseName=LeaveSystem;encrypt=true;trustServerCertificate=true;";
private static final String USER = "sa";
private static final String PASSWORD = "yourpassword";
Bước 3: Chạy trên Tomcat
Sao chép thư mục dự án vào webapps của Tomcat.
Khởi động Tomcat và truy cập:
http://localhost:8080/LeaveRequestSystem
##7. Hướng dẫn sử dụng
Nhân viên: Tạo đơn và xem trạng thái.
Quản lý: Duyệt/từ chối đơn của cấp dưới.
Trưởng phòng: Xem lịch nghỉ của toàn bộ nhân sự.
##8. Liên hệ
Email: khangndhe186523@fpt.edu.vn
Cảm ơn bạn đã sử dụng hệ thống!

text
