# Hệ Thống Quản Lý Nghỉ Phép 🚀

![Trạng thái](https://img.shields.io/badge/Trạng_thái-Đang_phát_triển-yellow?style=for-the-badge)  
Chào mừng đến với **Hệ Thống Quản Lý Nghỉ Phép** - ứng dụng web giúp quản lý đơn xin nghỉ phép tại Công ty X! Được xây dựng bằng Java Servlet, JSP và SQL Server, dự án sử dụng mô hình MVC để đảm bảo tính mở rộng.

## 🌟 Tổng Quan

Hệ thống hỗ trợ:  
- 📝 Tạo đơn xin nghỉ phép (ngày bắt đầu, kết thúc, lý do).  
- 👀 Xem đơn của bản thân hoặc cấp dưới (dành cho quản lý).  
- ✅ Duyệt/từ chối đơn (dành cho quản lý).  
- 📅 Xem lịch nghỉ phép của phòng ban qua Agenda.  

Chạy trên **Apache Tomcat 10.1.36**, đây là giải pháp nhẹ nhưng mạnh mẽ!

## 🛠️ Công Nghệ

- **Backend**: Java Servlet & JSP  
- **Frontend**: HTML, CSS, JSP  
- **Cơ sở dữ liệu**: SQL Server (kết nối qua JDBC)  
- **Server**: Apache Tomcat 10.1.36  
- **Kiến trúc**: MVC  

> **Lưu ý**: Không dùng Maven hay JSON - thuần Java web! 😎

## 📂 Cấu Trúc Dự Án
LeaveManagement/
├── src/
│   ├── model/      # Lớp dữ liệu (User, LeaveRequest,...)
│   ├── dao/        # Truy cập dữ liệu (UserDAO,...)
│   └── servlet/    # Điều khiển (LoginServlet,...)
├── web/
│   ├── WEB-INF/    # Cấu hình (web.xml)
│   ├── css/        # CSS (style.css)
│   └── *.jsp       # Giao diện (Login.jsp,...)

## 🚀 Hướng Dẫn Cài Đặt

1. **Clone dự án**: `git clone https://github.com/username/LeaveManagement.git`  
2. **Tạo database**: Tạo `LeaveManagement` trong SQL Server, chạy script bảng `Users`, `LeaveRequests`,...  
3. **Cấu hình JDBC**: Cập nhật thông tin kết nối trong DAO.  
4. **Triển khai**: Copy file `.war` vào `Tomcat/webapps/`, khởi động server.  
5. **Truy cập**: Mở `http://localhost:8080/LeaveManagement`.

## 🎯 Tính Năng

- 🔐 Đăng nhập an toàn.  
- ✍️ Tạo đơn xin nghỉ phép.  
- 👓 Xem danh sách đơn.  
- ✔️ Duyệt/từ chối đơn.  
- 📆 Lịch nghỉ phép phòng ban.

## 🤝 Đóng Góp

1. Fork repo 🍴  
2. Tạo branch mới: `git checkout -b feature/tinh-nang-moi`  
3. Commit: `git commit -m "Thêm tính năng mới"`  
4. Push: `git push origin feature/tinh-nang-moi`  
5. Tạo Pull Request 🚀  

## 📜 Giấy Phép

Dự án dùng giấy phép MIT.

## 👨‍💻 Tác Giả

- **Contact**: [khangndhe186523@fpt.edu.vn]  

⭐ **Thả sao nếu bạn thấy hữu ích!** ⭐  
🚀 Cảm ơn bạn đã sử dụng hệ thống!


