
# Hệ Thống Quản Lý Đơn Nghỉ Phép  
![Trạng thái](https table://img.shields.io/badge/Trạng_thái-Đang_phát_triển-blueviolet?style=flat-square)

## 1. 🏢 Giới thiệu
Hệ thống giúp nhân viên tạo, theo dõi đơn nghỉ phép và cho phép quản lý xét duyệt đơn của cấp dưới. Hệ thống được xây dựng với **Java Servlet & JSP**, **SQL Server (JDBC)**, và chạy trên **Apache Tomcat 10.1.36** theo mô hình **MVC**.

## 2. ⚙️ Công nghệ sử dụng
- **Backend**: Java Servlet & JSP
- **Frontend**: HTML/CSS, JSP
- **Database**: SQL Server (JDBC)
- **Server**: Apache Tomcat 10.1.36
- **Không sử dụng**: Maven, JSON

## 3. 🔹 Chức năng chính
- **Đăng nhập & phân quyền**: Nhân viên và quản lý có các quyền khác nhau.
- **Quản lý đơn nghỉ phép**: Nhân viên tạo đơn nghỉ, theo dõi trạng thái.
- **Xét duyệt đơn**: Quản lý có thể duyệt hoặc từ chối đơn.
- **Xem lịch nghỉ**: Trưởng phòng theo dõi tình hình nhân sự.

## 4. 📂 Cấu trúc thư mục
```
LeaveRequestSystem/
│── WebContent/ (Giao diện JSP, CSS)
│── src/ (Code Java: Controller, Model, DAO)
│── WEB-INF/ (Cấu hình web.xml)
│── lib/ (Thư viện JDBC)
```

## 5. 🗄️ Cấu trúc Database
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
```

## 6. 🚀 Hướng dẫn cài đặt
### 🔧 Yêu cầu hệ thống
- **JDK 11+**
- **Apache Tomcat 10.1.36**
- **SQL Server** với JDBC Driver

### 🔹 Bước 1: Cấu hình cơ sở dữ liệu
1. Tạo database `LeaveSystem` trên SQL Server.
2. Chạy các lệnh SQL trên.

### 🔹 Bước 2: Cấu hình kết nối JDBC
Mở `DBConnection.java` và sửa thông tin:
```java
private static final String URL = "jdbc:sqlserver://localhost:1433;databaseName=LeaveSystem;encrypt=true;trustServerCertificate=true;";
private static final String USER = "sa";
private static final String PASSWORD = "yourpassword";
```

### 🔹 Bước 3: Chạy trên Tomcat
1. Copy thư mục vào `webapps` của Tomcat.
2. Khởi động Tomcat, truy cập `http://localhost:8080/LeaveRequestSystem`.

## 7. 📌 Hướng dẫn sử dụng
- **Nhân viên**: Đăng nhập, tạo đơn nghỉ, theo dõi trạng thái.
- **Quản lý**: Duyệt hoặc từ chối đơn nghỉ của cấp dưới.
- **Trưởng phòng**: Xem lịch nghỉ của nhân viên trong phòng.

## 8. 📞 Liên hệ
- **Email**: khangndhe186523@fpt.edu.vn
---
**Cảm ơn bạn đã sử dụng hệ thống!**

