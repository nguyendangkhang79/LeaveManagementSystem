![Trạng thái](https://img.shields.io/badge/Trạng_thái-Đang_phát_triển-yellow?style=for-the-badge)
# Hệ Thống Quản Lý Đơn Nghỉ Phép
## 1. 🏢 Giới thiệu
Hệ thống Quản lý Đơn Nghỉ Phép giúp nhân viên dễ dàng gửi yêu cầu nghỉ phép và cho phép quản lý theo dõi, phê duyệt đơn từ cấp dưới một cách hiệu quả. Hệ thống hỗ trợ quy trình xét duyệt rõ ràng, giúp minh bạch hóa việc quản lý nhân sự và tối ưu hóa nguồn lực trong doanh nghiệp.

## 2. ⚙️ Công nghệ sử dụng
- **Backend**: Java Servlet & JSP
- **Frontend**: HTML/CSS, JSP
- **Database**: SQL Server (JDBC)
- **Server**: Apache Tomcat 10.1.36

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

## 5. 🚀 Hướng dẫn cài đặt
### 🔧 Yêu cầu hệ thống
- **JDK 11+**
- **Apache Tomcat 10.1.36**
- **SQL Server** với JDBC Driver

### 🔹 Bước 1: Cấu hình cơ sở dữ liệu
1. Tạo database `LeaveManagementDB` trên SQL Server.
2. Chạy các lệnh SQL trên.

### 🔹 Bước 2: Cấu hình kết nối JDBC
Mở `DBConnection.java` và sửa thông tin:
```java
private static final String URL = "jdbc:sqlserver://localhost:1433;databaseName=LeaveSystem;encrypt=true;trustServerCertificate=true;";
private static final String USER = "sa";
private static final String PASSWORD = "yourpassword";
```

### 🔹 Bước 3: Run
 Khởi động Tomcat trên Netbean, và nhấn Run để chạy dự án.

## 6. 📌 Hướng dẫn sử dụng
- **Nhân viên**: Đăng nhập, tạo đơn nghỉ, theo dõi trạng thái.
- **Quản lý**: Duyệt hoặc từ chối đơn nghỉ của cấp dưới.
- **Trưởng phòng**: Xem lịch nghỉ của nhân viên trong phòng.

## 7. 📞 Liên hệ
- **Email**: khangndhe186523@fpt.edu.vn
---
**Cảm ơn bạn đã sử dụng hệ thống!**

