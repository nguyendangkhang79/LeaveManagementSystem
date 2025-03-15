# Assignment_LeaveManagementSystem
# Hệ thống Quản lý Đơn Nghỉ Phép

## 1. Giới thiệu
Hệ thống giúp nhân viên tạo, theo dõi đơn nghỉ phép và cho phép quản lý xét duyệt đơn của cấp dưới. Hệ thống được xây dựng với **Java Servlet & JSP**, **SQL Server (JDBC)**, và chạy trên **Apache Tomcat 10.1.36** theo mô hình **MVC**.

## 2. Công nghệ sử dụng
- **Backend**: Java Servlet & JSP
- **Frontend**: HTML/CSS, JSP
- **Database**: SQL Server (JDBC)
- **Server**: Apache Tomcat 10.1.36
- **Không sử dụng**: Maven, JSON

## 3. Chức năng chính
- Đăng nhập, phân quyền nhân viên và quản lý.
- Nhân viên tạo đơn nghỉ phép.
- Quản lý xét duyệt đơn.
- Trưởng phòng xem lịch nghỉ của nhân sự.

## 4. Cấu trúc thư mục
```
LeaveRequestSystem/
│── WebContent/ (Giao diện JSP, CSS)
│── src/ (Code Java: Controller, Model, DAO)
│── WEB-INF/ (Cấu hình web.xml)
│── lib/ (Thư viện JDBC)
```

## 5. Cấu trúc Database
```sqlsever
```

## 6. Hướng dẫn cài đặt
### Yêu cầu hệ thống
- **JDK 11+**
- **Apache Tomcat 10.1.36**
- **SQL Server** với JDBC Driver

### Bước 1: Cấu hình cơ sở dữ liệu
1. Tạo database `LeaveSystem` trên SQL Server.
2. Chạy các lệnh SQL trên.

### Bước 2: Cấu hình kết nối JDBC
Mở `DBConnection.java` và sửa thông tin:
```java
private static final String URL = "jdbc:sqlserver://localhost:1433;databaseName=LeaveSystem;encrypt=true;trustServerCertificate=true;";
private static final String USER = "sa";
private static final String PASSWORD = "yourpassword";
```

### Bước 3: Chạy trên Tomcat
1. Copy thư mục vào `webapps` của Tomcat.
2. Khởi động Tomcat, truy cập `http://localhost:8080/LeaveRequestSystem`.

## 7. Hướng dẫn sử dụng
- Nhân viên tạo đơn, theo dõi trạng thái.
- Quản lý duyệt đơn của cấp dưới.
- Trưởng phòng xem lịch nghỉ của nhân sự.

## 8. Liên hệ
- **Email**: khangndhe186523@fpt.edu.vn
---
🚀 *Cảm ơn bạn đã sử dụng hệ thống!*

