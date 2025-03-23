# Enterprise Leave Management System (ELMS)

## Tổng quan

Enterprise Leave Management System (ELMS) là một ứng dụng web hiện đại cho phép doanh nghiệp quản lý quy trình xin nghỉ phép của nhân viên một cách hiệu quả. Hệ thống hỗ trợ nhiều vai trò người dùng, quản lý phê duyệt đơn nghỉ phép, theo dõi lịch nghỉ phép phòng ban và các tính năng quản trị khác.

## Tính năng chính

### Cho tất cả người dùng
- Đăng nhập/xác thực theo vai trò
- Tạo đơn xin nghỉ phép với lý do, ngày bắt đầu và kết thúc
- Xem trạng thái đơn xin nghỉ phép cá nhân
- Xem lịch sử nghỉ phép và số ngày nghỉ còn lại

### Cho quản lý (Manager)
- Nhận thông báo khi có đơn nghỉ phép mới
- Phê duyệt hoặc từ chối đơn nghỉ phép của nhân viên trong phòng ban
- Xem lịch nghỉ phép của phòng ban để quản lý nhân lực

### Cho quản trị viên (Admin)
- Quản lý người dùng: thêm, sửa, xóa người dùng
- Quản lý phòng ban: thêm, sửa, xóa phòng ban
- Thiết lập quản lý cho phòng ban
- Xem lịch nghỉ phép toàn công ty
- Phê duyệt đơn nghỉ phép của tất cả nhân viên

## Kiến trúc hệ thống

### Công nghệ sử dụng
- **Ngôn ngữ lập trình**: Java
- **Framework web**: Jakarta EE (Servlet, JSP)
- **Cơ sở dữ liệu**: SQL Server
- **Frontend**: HTML, CSS, JavaScript
- **Thư viện**: Font Awesome, jQuery

### Cấu trúc dự án
```
/LeaveManagementSystem
│
├── /WEB-INF
│   ├── /classes
│   │   ├── /controller     # Các Servlet điều khiển luồng ứng dụng
│   │   ├── /dao            # Các lớp truy cập dữ liệu
│   │   ├── /model          # Các lớp mô hình dữ liệu
│   │   └── /util           # Các lớp tiện ích
│   ├── /lib                # Thư viện JAR
│   └── web.xml             # Cấu hình ứng dụng web
│
├── /css                    # Các file CSS
│   └── custom-style.css    # File CSS chính
│
├── /js                     # Các file JavaScript
│   └── scripts.js          # File JavaScript chính
│
├── header.jsp              # Header chung cho tất cả trang
├── footer.jsp              # Footer chung cho tất cả trang
├── login.jsp               # Trang đăng nhập
├── viewLeaves.jsp          # Trang xem danh sách đơn nghỉ phép
├── createLeave.jsp         # Trang tạo đơn nghỉ phép mới
├── approveLeave.jsp        # Trang duyệt đơn nghỉ phép
├── agenda.jsp              # Trang xem lịch nghỉ phép phòng ban
├── admin-users.jsp         # Trang quản lý người dùng (cho Admin)
├── admin-departments.jsp   # Trang quản lý phòng ban (cho Admin)
├── create-department.jsp   # Trang tạo phòng ban mới (cho Admin)
├── edit-department.jsp     # Trang chỉnh sửa phòng ban (cho Admin)
└── view-department.jsp     # Trang xem chi tiết phòng ban (cho Admin)
```

## Cơ sở dữ liệu

### Mô hình quan hệ
Hệ thống sử dụng cơ sở dữ liệu SQL Server với các bảng chính:
- **Departments**: Quản lý thông tin phòng ban
- **Users**: Quản lý thông tin người dùng
- **LeaveRequests**: Lưu trữ đơn xin nghỉ phép
- **LeaveHistory**: Lưu trữ lịch sử nghỉ phép theo năm
- **Notifications**: Quản lý thông báo cho người dùng

### Script tạo cơ sở dữ liệu
File `complete-database.sql` chứa script đầy đủ để tạo cấu trúc cơ sở dữ liệu và dữ liệu mẫu.

## Thiết lập và triển khai

### Yêu cầu hệ thống
- JDK 11 trở lên
- Apache Tomcat 9.0 trở lên
- SQL Server 2019 trở lên

### Các bước thiết lập
1. **Cài đặt cơ sở dữ liệu**:
   - Mở SQL Server Management Studio
   - Chạy script `complete-database.sql` để tạo cơ sở dữ liệu và dữ liệu mẫu

2. **Cấu hình kết nối cơ sở dữ liệu**:
   - Mở file `DBConnection.java` trong package `util`
   - Cập nhật thông tin kết nối (URL, username, password) phù hợp với môi trường của bạn

3. **Biên dịch và đóng gói ứng dụng**:
   - Sử dụng IDE (Eclipse, IntelliJ) hoặc Maven để biên dịch và đóng gói ứng dụng thành file WAR

4. **Triển khai ứng dụng**:
   - Sao chép file WAR vào thư mục `webapps` của Tomcat
   - Khởi động hoặc khởi động lại Tomcat

### Cấu hình khác
- **Đường dẫn ứng dụng**: Mặc định là `/LeaveManagementSystem`
- **Trang mặc định**: `login.jsp`
- **Encoding**: UTF-8 cho tất cả các trang

## Tài khoản mặc định

### Quản trị viên (Admin)
- **Tài khoản**: superadmin
- **Mật khẩu**: admin123

### Quản lý (Manager)
- **Tài khoản**: nguyenvanminh
- **Mật khẩu**: Minh@123

### Nhân viên (Employee)
- **Tài khoản**: tranquoctuan
- **Mật khẩu**: Tuan@123

## Sử dụng hệ thống

### Quy trình tạo và duyệt đơn nghỉ phép
1. Nhân viên đăng nhập và tạo đơn nghỉ phép từ trang "Tạo đơn mới"
2. Đơn được gửi đến quản lý phòng ban hoặc quản trị viên
3. Quản lý/Quản trị viên xem xét và phê duyệt hoặc từ chối đơn
4. Nhân viên nhận được thông báo về trạng thái đơn

### Quản lý phòng ban và người dùng (dành cho Admin)
1. Đăng nhập với tài khoản Admin
2. Sử dụng menu "Quản lý người dùng" để thêm, sửa, xóa người dùng
3. Sử dụng menu "Quản lý phòng ban" để thêm, sửa, xóa phòng ban

### Xem lịch nghỉ phép phòng ban (dành cho Manager và Admin)
1. Đăng nhập với tài khoản Manager hoặc Admin
2. Truy cập vào mục "Lịch nghỉ phép"
3. Chọn khoảng thời gian cần xem
4. Admin có thể chọn xem lịch của bất kỳ phòng ban nào

## Hỗ trợ và liên hệ

Nếu bạn gặp vấn đề khi cài đặt hoặc sử dụng hệ thống, vui lòng liên hệ:
- **Email**: admin@company.com
- **Điện thoại**: (84) 123-456-789

## Roadmap phát triển

Các tính năng dự kiến phát triển trong tương lai:
- Tích hợp thông báo qua email
- Ứng dụng di động cho iOS và Android
- Báo cáo và phân tích dữ liệu nâng cao
- Tích hợp với hệ thống chấm công
- Hỗ trợ đa ngôn ngữ

---

© 2025 Enterprise Leave Management System. All rights reserved.