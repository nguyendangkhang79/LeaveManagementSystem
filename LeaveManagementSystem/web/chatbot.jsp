<%-- Cập nhật nội dung file chatbot.jsp với các tính năng nâng cao --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ELMS Chatbot</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        :root {
            --elms-primary: #1565c0;
            --elms-secondary: #0d47a1;
            --elms-accent: #42a5f5;
            --elms-light: #f5f7fa;
            --elms-dark: #333333;
            --elms-border: #e9ecef;
            --elms-success: #4caf50;
            --elms-warning: #ff9800;
            --elms-danger: #f44336;
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
        }
        
        body {
            height: 100vh;
            background-color: #f5f5f5;
            display: flex;
            flex-direction: column;
        }
        
        .elms-chat {
            width: 100%;
            height: 100%;
            display: flex;
            flex-direction: column;
            overflow: hidden;
            background-color: white;
        }
        
        .elms-chat-header {
            background-color: var(--elms-primary);
            color: white;
            padding: 15px;
            font-weight: 600;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            z-index: 10;
        }
        
        .elms-chat-title {
            display: flex;
            align-items: center;
        }
        
        .elms-chat-title i {
            margin-right: 8px;
            font-size: 18px;
        }

        .elms-status {
            width: 8px;
            height: 8px;
            background-color: var(--elms-success);
            border-radius: 50%;
            margin-left: 8px;
        }
        
        .elms-chat-messages {
            flex: 1;
            overflow-y: auto;
            padding: 15px;
            background-color: white;
            scroll-behavior: smooth;
        }
        
        .elms-message {
            max-width: 85%;
            margin-bottom: 15px;
            clear: both;
            position: relative;
            word-wrap: break-word;
            animation: fadeIn 0.3s ease;
        }
        
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        .elms-bot {
            float: left;
        }
        
        .elms-user {
            float: right;
        }
        
        .elms-bubble {
            padding: 12px 15px;
            border-radius: 18px;
            display: inline-block;
            box-shadow: 0 1px 2px rgba(0, 0, 0, 0.1);
            line-height: 1.5;
        }
        
        .elms-bot .elms-bubble {
            background-color: #f1f1f1;
            color: var(--elms-dark);
            border-top-left-radius: 4px;
        }
        
        .elms-user .elms-bubble {
            background-color: var(--elms-primary);
            color: white;
            border-top-right-radius: 4px;
        }
        
        .elms-time {
            font-size: 11px;
            color: #999;
            margin-top: 5px;
            display: inline-block;
        }
        
        .elms-bot .elms-time {
            margin-left: 10px;
        }
        
        .elms-user .elms-time {
            margin-right: 10px;
            text-align: right;
            float: right;
        }
        
        .elms-chat-input {
            padding: 15px;
            background-color: white;
            border-top: 1px solid var(--elms-border);
            box-shadow: 0 -2px 5px rgba(0,0,0,0.05);
        }
        
        .elms-form {
            display: flex;
            align-items: center;
        }
        
        .elms-input {
            flex: 1;
            padding: 12px 15px;
            border: 1px solid var(--elms-border);
            border-radius: 24px;
            font-size: 14px;
            outline: none;
            transition: all 0.3s;
        }
        
        .elms-input:focus {
            border-color: var(--elms-primary);
            box-shadow: 0 0 0 3px rgba(21, 101, 192, 0.1);
        }
        
        .elms-send {
            background-color: var(--elms-primary);
            border: none;
            margin-left: 10px;
            color: white;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s;
        }
        
        .elms-send:hover {
            background-color: var(--elms-secondary);
            transform: scale(1.05);
        }
        
        .elms-send:disabled {
            background-color: #ccc;
            cursor: not-allowed;
        }
        
        /* Typing animation */
        .elms-typing {
            display: inline-flex;
            align-items: center;
            background-color: #f1f1f1;
            padding: 12px 15px;
            border-radius: 18px;
            border-top-left-radius: 4px;
        }
        
        .elms-dot {
            width: 8px;
            height: 8px;
            background-color: #999;
            border-radius: 50%;
            margin: 0 2px;
            animation: elmsDotFlashing 1s infinite alternate;
        }
        
        .elms-dot:nth-child(2) {
            animation-delay: 0.2s;
        }
        
        .elms-dot:nth-child(3) {
            animation-delay: 0.4s;
        }
        
        @keyframes elmsDotFlashing {
            0% {
                opacity: 0.2;
            }
            100% {
                opacity: 1;
            }
        }
        
        /* Suggested questions */
        .elms-suggestions {
            margin-top: 20px;
            margin-bottom: 10px;
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
        }
        
        .elms-suggestion {
            background-color: rgba(21, 101, 192, 0.1);
            color: var(--elms-primary);
            border: 1px solid rgba(21, 101, 192, 0.2);
            border-radius: 18px;
            padding: 8px 15px;
            font-size: 13px;
            cursor: pointer;
            transition: all 0.3s;
            white-space: nowrap;
            display: inline-block;
            max-width: 200px;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        
        .elms-suggestion:hover {
            background-color: rgba(21, 101, 192, 0.2);
            border-color: rgba(21, 101, 192, 0.3);
        }
        
        /* Quick replies */
        .elms-quick-replies {
            clear: both;
            padding-top: 10px;
            padding-bottom: 5px;
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
        }
        
        .elms-quick-reply {
            background-color: white;
            border: 1px solid var(--elms-primary);
            color: var(--elms-primary);
            border-radius: 20px;
            padding: 8px 16px;
            font-size: 13px;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .elms-quick-reply:hover {
            background-color: var(--elms-primary);
            color: white;
        }
        
        /* Card */
        .elms-card {
            max-width: 100%;
            background-color: white;
            border-radius: 10px;
            overflow: hidden;
            border: 1px solid var(--elms-border);
            margin-top: 10px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        
        .elms-card-img {
            width: 100%;
            height: 150px;
            background-color: #f5f5f5;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--elms-primary);
            font-size: 30px;
        }
        
        .elms-card-body {
            padding: 15px;
        }
        
        .elms-card-title {
            font-weight: 600;
            margin-bottom: 8px;
            color: var(--elms-dark);
        }
        
        .elms-card-text {
            color: #666;
            font-size: 14px;
            margin-bottom: 15px;
        }
        
        .elms-card-action {
            background-color: var(--elms-primary);
            color: white;
            border: none;
            padding: 8px 15px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 13px;
            transition: all 0.3s;
        }
        
        .elms-card-action:hover {
            background-color: var(--elms-secondary);
        }
        
        /* Buttons */
        .elms-buttons {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            margin-top: 8px;
        }
        
        .elms-btn {
            background-color: var(--elms-primary);
            color: white;
            border: none;
            padding: 8px 15px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 13px;
            transition: all 0.3s;
        }
        
        .elms-btn-outline {
            background-color: white;
            color: var(--elms-primary);
            border: 1px solid var(--elms-primary);
        }
        
        .elms-btn:hover {
            opacity: 0.9;
            transform: translateY(-2px);
        }
        
        /* List */
        .elms-list {
            list-style: none;
            margin-top: 10px;
        }
        
        .elms-list-item {
            background-color: #f9f9f9;
            margin-bottom: 5px;
            padding: 10px;
            border-radius: 5px;
            display: flex;
            align-items: center;
        }
        
        .elms-list-item i {
            margin-right: 10px;
            color: var(--elms-primary);
        }
        
        /* Table */
        .elms-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
            font-size: 14px;
        }
        
        .elms-table th, .elms-table td {
            padding: 8px 12px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }
        
        .elms-table th {
            background-color: #f5f5f5;
            font-weight: 600;
        }
        
        /* Badge */
        .elms-badge {
            display: inline-block;
            padding: 3px 8px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 500;
            margin-left: 5px;
        }
        
        .elms-badge-success {
            background-color: rgba(76, 175, 80, 0.2);
            color: var(--elms-success);
        }
        
        .elms-badge-warning {
            background-color: rgba(255, 152, 0, 0.2);
            color: var(--elms-warning);
        }
        
        .elms-badge-danger {
            background-color: rgba(244, 67, 54, 0.2);
            color: var(--elms-danger);
        }
        
        /* Modals and Tooltips */
        .elms-tooltip {
            position: relative;
            display: inline-block;
            cursor: help;
            border-bottom: 1px dotted var(--elms-primary);
        }
        
        .elms-tooltip-text {
            visibility: hidden;
            width: 200px;
            background-color: #555;
            color: #fff;
            text-align: center;
            border-radius: 6px;
            padding: 5px;
            position: absolute;
            z-index: 1;
            bottom: 125%;
            left: 50%;
            margin-left: -100px;
            opacity: 0;
            transition: opacity 0.3s;
            font-size: 12px;
            pointer-events: none;
        }
        
        .elms-tooltip:hover .elms-tooltip-text {
            visibility: visible;
            opacity: 1;
        }
        
        /* Markdown styling */
        .elms-markdown {
            line-height: 1.6;
        }
        
        .elms-markdown h1, .elms-markdown h2, .elms-markdown h3 {
            margin-top: 10px;
            margin-bottom: 5px;
            font-weight: 600;
        }
        
        .elms-markdown p {
            margin-bottom: 10px;
        }
        
        .elms-markdown ul {
            padding-left: 20px;
            margin-bottom: 10px;
        }
        
        .elms-markdown code {
            background-color: #f5f5f5;
            padding: 2px 4px;
            border-radius: 3px;
            font-family: monospace;
        }
    </style>
</head>
<body>
    <div class="elms-chat">
        <div class="elms-chat-header">
            <div class="elms-chat-title">
                <i class="fas fa-robot"></i> Trợ lý ELMS
                <div class="elms-status"></div>
            </div>
            <div>
                <span id="elms-chat-time"></span>
            </div>
        </div>
        
        <div class="elms-chat-messages" id="elmsMessages">
            <!-- Tin nhắn sẽ hiển thị ở đây -->
        </div>
        
        <div class="elms-chat-input">
            <form class="elms-form" id="elmsForm" onsubmit="return false;">
                <input type="text" class="elms-input" id="elmsInput" placeholder="Nhập câu hỏi của bạn..." autocomplete="off">
                <button type="button" class="elms-send" id="elmsSend">
                    <i class="fas fa-paper-plane"></i>
                </button>
            </form>
        </div>
    </div>
    
    <script>
        /**
         * Cơ sở dữ liệu kiến thức của chatbot ELMS
         * Được tổ chức thành các nhóm với các câu trả lời chi tiết và liên kết
         */
        const elmsKnowledgeBase = {
            // Thông tin chung về hệ thống
            systemInfo: {
                id: "systemInfo",
                title: "Thông tin chung về ELMS",
                description: "Enterprise Leave Management System (ELMS) là hệ thống quản lý nghỉ phép doanh nghiệp, giúp tự động hóa quá trình xin nghỉ phép, phê duyệt, và theo dõi ngày nghỉ.",
                answers: {
                    what_is_elms: {
                        title: "ELMS là gì?",
                        content: "ELMS (Enterprise Leave Management System) là hệ thống quản lý nghỉ phép doanh nghiệp, được thiết kế để giúp công ty quản lý, theo dõi và tự động hóa quy trình nghỉ phép của nhân viên. Hệ thống giúp nhân viên dễ dàng đăng ký nghỉ phép, quản lý duyệt đơn và theo dõi số ngày nghỉ phép còn lại.",
                        relatedTopics: ["how_to_login", "system_features", "user_roles"]
                    },
                    system_features: {
                        title: "Tính năng chính của hệ thống",
                        content: "ELMS cung cấp nhiều tính năng quản lý nghỉ phép:\n• Tạo và quản lý đơn nghỉ phép\n• Phê duyệt đơn nghỉ phép tự động theo cấp quản lý\n• Theo dõi ngày nghỉ đã sử dụng và còn lại\n• Xem lịch nghỉ phép theo phòng ban\n• Nhận thông báo về trạng thái đơn\n• Quản lý phòng ban và nhân viên\n• Thống kê báo cáo về tình hình nghỉ phép",
                        relatedTopics: ["user_roles", "leave_quota"]
                    },
                    how_to_login: {
                        title: "Cách đăng nhập hệ thống",
                        content: "Để đăng nhập vào hệ thống ELMS:\n1. Truy cập địa chỉ website của hệ thống\n2. Nhập tên đăng nhập (thường là tên email công ty)\n3. Nhập mật khẩu đã được cấp\n4. Nhấn nút 'Đăng nhập'\n\nNếu quên mật khẩu, bạn có thể sử dụng tính năng 'Quên mật khẩu' trên trang đăng nhập hoặc liên hệ với quản trị viên hệ thống.",
                        relatedTopics: ["forgot_password", "account_issues"],
                        buttons: [
                            { text: "Quên mật khẩu", value: "forgot_password" }
                        ]
                    },
                    forgot_password: {
                        title: "Quên mật khẩu",
                        content: "Nếu bạn quên mật khẩu đăng nhập ELMS, vui lòng thực hiện các bước sau:\n1. Trên trang đăng nhập, nhấp vào liên kết 'Quên mật khẩu'\n2. Nhập email công ty của bạn\n3. Kiểm tra email để nhận hướng dẫn đặt lại mật khẩu\n4. Nhấp vào liên kết trong email và tạo mật khẩu mới\n\nNếu bạn không nhận được email hoặc cần hỗ trợ thêm, vui lòng liên hệ với bộ phận IT theo số 0123-456-789.",
                        relatedTopics: ["how_to_login", "account_issues"]
                    },
                    account_issues: {
                        title: "Vấn đề về tài khoản",
                        content: "Nếu bạn gặp sự cố với tài khoản ELMS như không đăng nhập được, thông tin hiển thị không chính xác, hoặc quyền truy cập không đúng, vui lòng thực hiện các bước sau:\n\n1. Kiểm tra kết nối mạng và thử đăng nhập lại\n2. Xóa cache trình duyệt và thử lại\n3. Đảm bảo Caps Lock không bật khi nhập mật khẩu\n4. Liên hệ bộ phận IT qua email support@company.com hoặc số điện thoại 0123-456-789\n\nKhi liên hệ hỗ trợ, vui lòng cung cấp tên đăng nhập và mô tả chi tiết vấn đề bạn gặp phải.",
                        relatedTopics: ["how_to_login", "forgot_password"]
                    },
                    user_roles: {
                        title: "Các vai trò người dùng",
                        content: "ELMS có 3 vai trò người dùng chính với các quyền khác nhau:\n\n<b>1. Nhân viên (Employee):</b>\n• Tạo đơn nghỉ phép\n• Xem trạng thái đơn và lịch sử nghỉ phép\n• Xem số ngày nghỉ còn lại\n\n<b>2. Quản lý (Manager):</b>\n• Có tất cả quyền của nhân viên\n• Duyệt đơn nghỉ phép của nhân viên trong phòng ban\n• Xem lịch nghỉ phép phòng ban\n• Xuất báo cáo nghỉ phép của phòng ban\n\n<b>3. Quản trị viên (Admin):</b>\n• Có tất cả quyền của quản lý\n• Quản lý người dùng và phòng ban\n• Thiết lập cấu hình hệ thống\n• Xem và xuất báo cáo toàn công ty",
                        relatedTopics: ["manager_features", "admin_features"]
                    }
                }
            },
            
            // Quy trình nghỉ phép
            leaveProcess: {
                id: "leaveProcess",
                title: "Quy trình nghỉ phép",
                description: "Tìm hiểu về quy trình xin nghỉ phép, phê duyệt và các loại nghỉ phép trong ELMS.",
                answers: {
                    leave_request: {
                        title: "Cách tạo đơn nghỉ phép",
                        content: "Để tạo đơn nghỉ phép mới trong ELMS, bạn thực hiện các bước sau:\n\n1. Đăng nhập vào hệ thống ELMS\n2. Từ menu bên trái, chọn 'Tạo đơn mới' hoặc từ trang danh sách đơn, nhấp vào nút 'Tạo đơn mới'\n3. Điền thông tin vào form:\n   - Chọn ngày bắt đầu nghỉ\n   - Chọn ngày kết thúc nghỉ\n   - Chọn loại nghỉ phép (nếu có)\n   - Nhập lý do nghỉ phép\n4. Nhấn nút 'Gửi đơn' để hoàn tất\n\nĐơn của bạn sẽ được chuyển đến quản lý trực tiếp để phê duyệt. Bạn sẽ nhận được thông báo khi đơn được duyệt hoặc từ chối.",
                        relatedTopics: ["leave_types", "leave_status", "leave_policy"],
                        buttons: [
                            { text: "Xem loại nghỉ phép", value: "leave_types" },
                            { text: "Chính sách nghỉ phép", value: "leave_policy" }
                        ]
                    },
                    leave_approval: {
                        title: "Quy trình phê duyệt đơn nghỉ phép",
                        content: "Quy trình phê duyệt đơn nghỉ phép trong ELMS như sau:\n\n1. Nhân viên tạo đơn nghỉ phép\n2. Hệ thống gửi thông báo cho quản lý trực tiếp\n3. Quản lý xem xét đơn và thực hiện một trong các hành động:\n   - Phê duyệt: Đơn được chấp nhận\n   - Từ chối: Đơn bị từ chối (có thể kèm lý do)\n   - Yêu cầu thông tin bổ sung: Đơn cần được điều chỉnh\n4. Hệ thống gửi thông báo cho nhân viên về kết quả\n5. Nếu được duyệt, số ngày nghỉ phép sẽ được cập nhật tự động\n\nQuản lý có thể thêm ghi chú khi phê duyệt hoặc từ chối đơn để giải thích quyết định của mình.",
                        relatedTopics: ["manager_features", "leave_status"]
                    },
                    leave_types: {
                        title: "Các loại nghỉ phép",
                        content: "ELMS hỗ trợ nhiều loại nghỉ phép khác nhau:\n\n<b>1. Nghỉ phép thường niên:</b> Ngày nghỉ có lương theo quy định\n<b>2. Nghỉ ốm:</b> Nghỉ do bệnh tật (cần giấy xác nhận y tế)\n<b>3. Nghỉ không lương:</b> Nghỉ không hưởng lương\n<b>4. Nghỉ việc riêng:</b> Nghỉ để giải quyết việc cá nhân\n<b>5. Nghỉ bù:</b> Nghỉ bù cho làm thêm giờ hoặc làm ngày nghỉ\n<b>6. Nghỉ thai sản:</b> Nghỉ thai sản theo quy định pháp luật\n<b>7. Nghỉ kết hôn:</b> Nghỉ kết hôn theo quy định\n<b>8. Nghỉ tang:</b> Nghỉ khi có người thân mất\n<b>9. Nghỉ học tập:</b> Nghỉ để học tập, đào tạo\n\nMỗi loại nghỉ có chính sách và số ngày tối đa khác nhau theo quy định công ty.",
                        relatedTopics: ["leave_policy", "leave_quota"]
                    },
                    leave_status: {
                        title: "Theo dõi trạng thái đơn nghỉ phép",
                        content: "Để xem trạng thái đơn nghỉ phép của bạn:\n\n1. Đăng nhập vào hệ thống ELMS\n2. Từ menu bên trái, chọn 'Danh sách đơn'\n3. Bạn sẽ thấy danh sách tất cả đơn nghỉ phép của mình\n\nCác trạng thái đơn nghỉ phép bao gồm:\n• <b>Đang chờ duyệt (Inprogress):</b> Đơn đã được gửi và đang chờ quản lý xem xét\n• <b>Đã duyệt (Approved):</b> Đơn đã được phê duyệt\n• <b>Từ chối (Rejected):</b> Đơn đã bị từ chối\n\nBạn có thể nhấp vào mỗi đơn để xem chi tiết, bao gồm lý do từ chối (nếu có) hoặc ghi chú từ người duyệt.",
                        relatedTopics: ["leave_request", "cancel_leave"]
                    },
                    leave_policy: {
                        title: "Chính sách nghỉ phép công ty",
                        content: "Chính sách nghỉ phép của công ty như sau:\n\n<b>Số ngày nghỉ phép theo năm:</b>\n• Nhân viên thông thường: 12 ngày/năm\n• Nhân viên cấp cao (>5 năm): 15 ngày/năm\n• Cấp quản lý: 18 ngày/năm\n\n<b>Quy định đăng ký nghỉ phép:</b>\n• Nghỉ phép thường niên: Đăng ký trước ít nhất 3 ngày làm việc\n• Nghỉ khẩn cấp: Thông báo sớm nhất có thể, bổ sung giấy tờ nếu cần\n• Nghỉ dài ngày (>3 ngày): Đăng ký trước ít nhất 7 ngày làm việc\n\n<b>Quy định về ngày nghỉ:</b>\n• Có thể tích lũy tối đa 5 ngày sang năm sau\n• Ngày nghỉ không sử dụng và không được tích lũy sẽ mất\n• Nhân viên trong thời gian thử việc được hưởng nghỉ phép theo tỷ lệ\n\nLưu ý: Trong những thời điểm đặc biệt bận rộn hoặc cao điểm, công ty có thể yêu cầu sắp xếp lịch nghỉ phù hợp.",
                        relatedTopics: ["leave_types", "leave_quota", "leave_calculation"]
                    },
                    leave_quota: {
                        title: "Số ngày nghỉ phép và hạn mức",
                        content: "Hạn mức nghỉ phép được tính như sau:\n\n1. Hạn mức cơ bản theo vị trí:\n   • Nhân viên: 12 ngày/năm\n   • Quản lý: 18 ngày/năm\n   • Giám đốc: 22 ngày/năm\n\n2. Điều chỉnh theo thâm niên:\n   • >2 năm: +2 ngày\n   • >5 năm: +3 ngày\n   • >10 năm: +5 ngày\n\n3. Cách tính số ngày nghỉ còn lại:\n   • Số ngày được cấp - Số ngày đã sử dụng = Số ngày còn lại\n   • Năm hiện tại + Ngày tích lũy từ năm trước (tối đa 5 ngày)\n\nBạn có thể xem số ngày nghỉ phép còn lại của mình trên Dashboard hoặc trang Thông tin cá nhân trong hệ thống ELMS.",
                        relatedTopics: ["leave_policy", "leave_calculation"]
                    },
                    leave_calculation: {
                        title: "Cách tính ngày nghỉ phép",
                        content: "ELMS tính toán ngày nghỉ phép như sau:\n\n<b>1. Cách tính ngày nghỉ:</b>\n• Ngày làm việc: Tính 1 ngày phép\n• Cuối tuần (thứ 7, CN): Không tính ngày phép\n• Ngày lễ: Không tính ngày phép\n\n<b>2. Tính toán số ngày:</b>\n• Thời gian nghỉ phép = Ngày kết thúc - Ngày bắt đầu + 1\n• Số ngày phép = Thời gian nghỉ phép - (Số ngày cuối tuần + Số ngày lễ)\n\n<b>3. Ví dụ:</b>\nNếu bạn đăng ký nghỉ từ thứ Sáu (01/03) đến thứ Ba (05/03):\n• Tổng thời gian: 5 ngày\n• Trừ cuối tuần (thứ 7, CN): -2 ngày\n• Số ngày phép thực tế: 3 ngày\n\nHệ thống sẽ tự động tính toán số ngày phép chính xác khi bạn chọn ngày bắt đầu và kết thúc trong form đăng ký.",
                        relatedTopics: ["leave_policy", "leave_quota"]
                    },
                    cancel_leave: {
                        title: "Cách hủy đơn nghỉ phép",
                        content: "Để hủy đơn nghỉ phép đã gửi:\n\n1. Truy cập vào trang 'Danh sách đơn' trong menu\n2. Tìm đơn nghỉ phép bạn muốn hủy\n3. Chỉ có thể hủy đơn ở trạng thái 'Đang chờ duyệt'\n4. Nhấp vào nút 'Hủy đơn' (hoặc biểu tượng X) bên cạnh đơn\n5. Xác nhận việc hủy đơn\n\nLưu ý:\n• Đơn đã được duyệt không thể hủy trực tiếp trên hệ thống\n• Nếu cần hủy đơn đã duyệt, bạn cần liên hệ trực tiếp với quản lý\n• Quản lý có thể giúp hủy đơn đã duyệt trong hệ thống",
                        relatedTopics: ["leave_request", "leave_status"]
                    }
                }
            },
            
            // Tính năng quản lý
            managerFeatures: {
                id: "managerFeatures",
                title: "Tính năng cho quản lý",
                description: "Các tính năng dành cho quản lý trong hệ thống ELMS.",
                answers: {
                    manager_features: {
                        title: "Tổng quan tính năng quản lý",
                        content: "Quản lý có các tính năng đặc biệt trong ELMS:\n\n<b>1. Duyệt đơn nghỉ phép:</b>\n• Xem và duyệt đơn nghỉ phép của nhân viên trong phòng ban\n• Thêm ghi chú khi duyệt hoặc từ chối đơn\n• Yêu cầu điều chỉnh thông tin đơn\n\n<b>2. Quản lý lịch nghỉ:</b>\n• Xem lịch nghỉ phép toàn bộ phòng ban\n• Theo dõi số nhân viên đi làm/nghỉ phép hàng ngày\n• Thống kê tình hình nghỉ phép theo tháng/quý\n\n<b>3. Báo cáo:</b>\n• Xuất báo cáo nghỉ phép của phòng ban\n• Xem thống kê về tình hình nghỉ phép\n• Nhận cảnh báo khi có nhiều người nghỉ cùng lúc\n\nQuản lý cũng có thể xem tổng quan về tình hình nghỉ phép, số ngày nghỉ còn lại của nhân viên từ Dashboard.",
                        relatedTopics: ["approve_leave", "team_calendar", "manager_reports"]
                    },
                    approve_leave: {
                        title: "Cách duyệt đơn nghỉ phép",
                        content: "Quy trình duyệt đơn nghỉ phép dành cho quản lý:\n\n1. Đăng nhập vào hệ thống ELMS\n2. Truy cập 'Danh sách đơn' từ menu chính\n3. Xem danh sách đơn đang chờ duyệt\n4. Nhấp vào đơn để xem chi tiết\n5. Thực hiện một trong các hành động sau:\n   • Nhấp 'Phê duyệt' để chấp nhận đơn\n   • Nhấp 'Từ chối' để từ chối đơn\n   • Thêm ghi chú nếu cần (bắt buộc khi từ chối)\n\nKhi phê duyệt hoặc từ chối, hệ thống sẽ tự động gửi thông báo cho nhân viên và cập nhật trạng thái đơn. Quản lý nên xem xét lịch nghỉ phép của phòng ban trước khi đưa ra quyết định để tránh quá nhiều người nghỉ cùng lúc.",
                        relatedTopics: ["team_calendar", "leave_approval_criteria"]
                    },
                    team_calendar: {
                        title: "Xem lịch nghỉ phép phòng ban",
                        content: "Để xem lịch nghỉ phép của phòng ban:\n\n1. Đăng nhập vào hệ thống ELMS với tài khoản quản lý\n2. Chọn 'Lịch nghỉ phép' từ menu bên trái\n3. Màn hình sẽ hiển thị lịch với các thông tin:\n   • Danh sách nhân viên theo hàng\n   • Ngày nghỉ được đánh dấu theo màu\n   • Thống kê số người đi làm/nghỉ mỗi ngày\n\nTính năng bổ sung:\n• Lọc theo khoảng thời gian cụ thể\n• Xuất lịch ra Excel hoặc PDF\n• Xem biểu đồ phân bố nghỉ phép\n\nLịch này giúp quản lý điều phối nhân sự, đảm bảo luôn đủ người làm việc và tránh tình trạng quá nhiều người nghỉ cùng lúc.",
                        relatedTopics: ["approve_leave", "manager_reports"]
                    },
                    leave_approval_criteria: {
                        title: "Tiêu chí duyệt đơn nghỉ phép",
                        content: "Khi duyệt đơn nghỉ phép, quản lý nên xem xét các tiêu chí sau:\n\n1. <b>Tính khả thi:</b>\n   • Số lượng nhân viên hiện có đủ để duy trì công việc không?\n   • Có nhân viên thay thế được không?\n\n2. <b>Độ ưu tiên:</b>\n   • Thứ tự ưu tiên: Nghỉ ốm > Nghỉ việc gia đình > Nghỉ thường niên\n   • Đơn gửi sớm hơn được ưu tiên hơn\n\n3. <b>Thời điểm:</b>\n   • Tránh duyệt quá nhiều đơn vào giai đoạn cao điểm\n   • Ưu tiên đơn vào thời điểm thấp điểm\n\n4. <b>Lịch sử nghỉ phép:</b>\n   • Nhân viên có thường xuyên nghỉ đột xuất không?\n   • Nhân viên có tuân thủ quy định đăng ký trước không?\n\nMột nguyên tắc tốt là duy trì tối thiểu 70% nhân sự làm việc trong mọi thời điểm và ưu tiên nhân viên chưa sử dụng nhiều ngày nghỉ trong năm.",
                        relatedTopics: ["approve_leave", "team_calendar"]
                    },
                    manager_reports: {
                        title: "Báo cáo dành cho quản lý",
                        content: "ELMS cung cấp các báo cáo cho quản lý để theo dõi tình hình nghỉ phép:\n\n1. <b>Báo cáo tổng hợp nghỉ phép:</b>\n   • Tổng số ngày nghỉ của từng nhân viên\n   • Số ngày nghỉ còn lại của từng nhân viên\n   • Thống kê theo loại nghỉ phép\n\n2. <b>Báo cáo xu hướng:</b>\n   • Biểu đồ nghỉ phép theo tháng/quý\n   • Ngày có nhiều người nghỉ nhất\n   • Thời gian cao điểm nghỉ phép\n\n3. <b>Báo cáo tuân thủ:</b>\n   • Tỷ lệ đăng ký đúng hạn/muộn\n   • Tần suất nghỉ đột xuất\n\nĐể truy cập báo cáo:\n1. Vào mục 'Báo cáo & Thống kê' trong menu\n2. Chọn loại báo cáo cần xem\n3. Thiết lập các bộ lọc (nếu cần)\n4. Xuất báo cáo ra Excel, PDF hoặc in nếu cần",
                        relatedTopics: ["team_calendar", "approve_leave"]
                    }
                }
            },
            
            // Tính năng quản trị
            adminFeatures: {
                id: "adminFeatures",
                title: "Tính năng cho quản trị viên",
                description: "Các tính năng dành cho quản trị viên trong hệ thống ELMS.",
                answers: {
                    admin_features: {
                        title: "Tổng quan tính năng quản trị",
                        content: "Quản trị viên (Admin) có toàn quyền trong hệ thống ELMS với các tính năng sau:\n\n<b>1. Quản lý người dùng:</b>\n• Thêm, sửa, xóa người dùng\n• Phân quyền và gán vai trò\n• Đặt lại mật khẩu\n\n<b>2. Quản lý phòng ban:</b>\n• Tạo, chỉnh sửa, xóa phòng ban\n• Gán quản lý cho phòng ban\n• Chuyển nhân viên giữa các phòng ban\n\n<b>3. Cấu hình hệ thống:</b>\n• Thiết lập các loại nghỉ phép\n• Cấu hình hạn mức nghỉ phép\n• Thiết lập quy trình phê duyệt\n\n<b>4. Báo cáo và thống kê:</b>\n• Xem báo cáo toàn công ty\n• Phân tích dữ liệu nghỉ phép\n• Xuất báo cáo tổng hợp\n\nQuản trị viên có thể truy cập tất cả đơn nghỉ phép và dữ liệu trong hệ thống.",
                        relatedTopics: ["manage_users", "manage_departments", "system_settings"]
                    },
                    manage_users: {
                        title: "Quản lý người dùng",
                        content: "Quản trị viên có thể quản lý người dùng trong ELMS như sau:\n\n<b>1. Thêm người dùng mới:</b>\n• Vào 'Quản lý người dùng' từ menu\n• Nhấp 'Thêm người dùng mới'\n• Điền thông tin: tên đăng nhập, mật khẩu, vai trò, phòng ban\n• Chọn quản lý trực tiếp (nếu cần)\n• Lưu thông tin\n\n<b>2. Chỉnh sửa người dùng:</b>\n• Tìm người dùng cần chỉnh sửa\n• Nhấp 'Chỉnh sửa'\n• Thay đổi thông tin cần thiết\n• Lưu thay đổi\n\n<b>3. Xóa người dùng:</b>\n• Tìm người dùng cần xóa\n• Nhấp 'Xóa'\n• Xác nhận xóa\n\n<b>4. Đặt lại mật khẩu:</b>\n• Tìm người dùng\n• Chọn 'Đặt lại mật khẩu'\n• Nhập mật khẩu mới\n\nLưu ý: Khi xóa người dùng, hãy đảm bảo không còn đơn nghỉ phép đang xử lý và dữ liệu lịch sử đã được lưu trữ.",
                        relatedTopics: ["user_roles", "manage_departments"]
                    },
                    manage_departments: {
                        title: "Quản lý phòng ban",
                        content: "Cách quản lý phòng ban trong ELMS:\n\n<b>1. Tạo phòng ban mới:</b>\n• Vào 'Quản lý phòng ban' từ menu\n• Nhấp 'Thêm phòng ban mới'\n• Nhập tên và mô tả phòng ban\n• Chọn quản lý phòng ban (nếu có)\n• Lưu thông tin\n\n<b>2. Chỉnh sửa phòng ban:</b>\n• Tìm phòng ban cần sửa\n• Nhấp 'Chỉnh sửa'\n• Thay đổi thông tin cần thiết\n• Lưu thay đổi\n\n<b>3. Xóa phòng ban:</b>\n• Chỉ có thể xóa phòng ban không có nhân viên\n• Tìm phòng ban cần xóa\n• Nhấp 'Xóa'\n• Xác nhận xóa\n\n<b>4. Chuyển nhân viên:</b>\n• Sử dụng tính năng 'Chuyển nhân viên' trong màn hình phòng ban\n• Chọn phòng ban nguồn và đích\n• Xác nhận chuyển\n\nPhòng ban là đơn vị tổ chức cơ bản trong ELMS, giúp phân nhóm nhân viên, gán quản lý và phân quyền phê duyệt.",
                        relatedTopics: ["manage_users", "team_calendar"]
                    },
                    system_settings: {
                        title: "Cấu hình hệ thống",
                        content: "Quản trị viên có thể thiết lập cấu hình hệ thống ELMS:\n\n<b>1. Thiết lập loại nghỉ phép:</b>\n• Thêm, sửa, xóa các loại nghỉ phép\n• Cấu hình quy tắc tính ngày cho mỗi loại\n• Thiết lập hạn mức cho từng loại\n\n<b>2. Cấu hình nghỉ phép:</b>\n• Thiết lập hạn mức nghỉ phép theo vai trò, thâm niên\n• Cấu hình quy tắc tích lũy và reset ngày nghỉ\n• Thiết lập quy tắc tính ngày nghỉ\n\n<b>3. Quy trình phê duyệt:</b>\n• Cấu hình luồng phê duyệt (1 cấp/nhiều cấp)\n• Thiết lập quy tắc thông báo\n• Cấu hình email tự động\n\n<b>4. Cài đặt chung:</b>\n• Định dạng hiển thị ngày tháng\n• Ngôn ngữ mặc định\n• Múi giờ\n• Logo và thương hiệu công ty\n\nĐể truy cập, vào menu 'Cấu hình hệ thống' trong giao diện quản trị.",
                        relatedTopics: ["leave_policy", "leave_types"]
                    },
                    admin_reports: {
                        title: "Báo cáo dành cho quản trị viên",
                        content: "Quản trị viên có thể truy cập các báo cáo toàn diện trong ELMS:\n\n<b>1. Báo cáo tổng hợp toàn công ty:</b>\n• Tổng số ngày nghỉ phép đã sử dụng/còn lại\n• Phân tích theo phòng ban, vai trò\n• Xu hướng nghỉ phép theo thời gian\n\n<b>2. Báo cáo chi tiết:</b>\n• Thống kê nghỉ phép theo từng nhân viên\n• Chi tiết lịch sử phê duyệt\n• Thống kê theo loại nghỉ phép\n\n<b>3. Báo cáo tuân thủ:</b>\n• Tỷ lệ đơn đăng ký đúng hạn/muộn\n• Thời gian phê duyệt trung bình\n• Tỷ lệ đơn được phê duyệt/từ chối\n\n<b>4. Báo cáo tùy chỉnh:</b>\n• Tạo báo cáo với các bộ lọc tùy chỉnh\n• Lưu mẫu báo cáo để sử dụng lại\n• Lên lịch gửi báo cáo tự động\n\nBáo cáo có thể được xuất ra nhiều định dạng như Excel, PDF, CSV hoặc trực quan hóa qua biểu đồ.",
                        relatedTopics: ["manager_reports", "system_settings"]
                    }
                }
            },
            
            // Thông tin về tài khoản
            accountInfo: {
                id: "accountInfo",
                title: "Thông tin tài khoản",
                description: "Quản lý thông tin tài khoản cá nhân trong hệ thống ELMS.",
                answers: {
                    view_profile: {
                        title: "Xem và cập nhật thông tin cá nhân",
                        content: "Để xem và cập nhật thông tin cá nhân trong ELMS:\n\n1. Nhấp vào tên người dùng hoặc ảnh đại diện ở góc trên bên phải\n2. Chọn 'Thông tin cá nhân' từ menu dropdown\n3. Trang thông tin cá nhân sẽ hiển thị:\n   • Thông tin cơ bản: Tên, email, số điện thoại\n   • Thông tin công việc: Phòng ban, vị trí, quản lý trực tiếp\n   • Thông tin nghỉ phép: Số ngày đã sử dụng, còn lại\n\nĐể cập nhật thông tin:\n1. Nhấp 'Chỉnh sửa' hoặc biểu tượng bút\n2. Cập nhật thông tin cần thiết\n3. Nhấp 'Lưu thay đổi'\n\nLưu ý: Một số thông tin như vai trò, phòng ban chỉ có thể được thay đổi bởi quản trị viên.",
                        relatedTopics: ["change_password", "account_issues"]
                    },
                    change_password: {
                        title: "Đổi mật khẩu",
                        content: "Để thay đổi mật khẩu tài khoản ELMS:\n\n1. Nhấp vào tên người dùng hoặc ảnh đại diện ở góc trên bên phải\n2. Chọn 'Đổi mật khẩu' từ menu dropdown\n3. Nhập mật khẩu hiện tại\n4. Nhập mật khẩu mới (phải đáp ứng các yêu cầu bảo mật)\n5. Xác nhận mật khẩu mới\n6. Nhấp 'Lưu thay đổi'\n\nYêu cầu về mật khẩu:\n• Tối thiểu 8 ký tự\n• Bao gồm chữ hoa, chữ thường\n• Có ít nhất 1 số và 1 ký tự đặc biệt\n• Không sử dụng thông tin cá nhân dễ đoán\n\nSau khi đổi mật khẩu, hệ thống sẽ yêu cầu bạn đăng nhập lại với mật khẩu mới.",
                        relatedTopics: ["forgot_password", "account_issues"]
                    },
                    notification_settings: {
                        title: "Thiết lập thông báo",
                        content: "Bạn có thể tùy chỉnh thông báo trong ELMS:\n\n1. Truy cập phần 'Cài đặt' từ menu người dùng\n2. Chọn tab 'Thông báo'\n3. Cấu hình các loại thông báo:\n   • <b>Thông báo trên hệ thống:</b> Hiển thị trực tiếp trên giao diện\n   • <b>Thông báo qua email:</b> Gửi email cho các sự kiện\n   • <b>Thông báo di động:</b> Push notification trên ứng dụng di động (nếu có)\n\nCác sự kiện có thể cấu hình:\n• Đơn nghỉ phép được duyệt/từ chối\n• Có đơn nghỉ phép mới cần duyệt (cho quản lý)\n• Nhắc nhở về ngày nghỉ sắp tới\n• Thông báo hạn mức nghỉ phép sắp hết\n\nMỗi loại thông báo có thể bật/tắt riêng biệt tùy theo nhu cầu cá nhân.",
                        relatedTopics: ["view_profile", "change_password"]
                    },
                    mobile_access: {
                        title: "Truy cập hệ thống từ thiết bị di động",
                        content: "ELMS có thể truy cập từ thiết bị di động qua hai phương pháp:\n\n<b>1. Truy cập qua trình duyệt di động:</b>\n• Mở trình duyệt trên điện thoại/tablet\n• Truy cập URL của hệ thống ELMS\n• Đăng nhập bình thường\n• Giao diện sẽ tự động điều chỉnh để phù hợp với thiết bị\n\n<b>2. Ứng dụng di động (nếu công ty triển khai):</b>\n• Tải ứng dụng ELMS từ App Store (iOS) hoặc Google Play (Android)\n• Đăng nhập với tài khoản công ty\n• Truy cập các tính năng chính như tạo đơn, xem trạng thái\n\nTính năng chính trên di động:\n• Tạo và xem đơn nghỉ phép\n• Nhận thông báo về trạng thái đơn\n• Xem lịch nghỉ phép\n• Duyệt đơn (dành cho quản lý)\n\nLưu ý: Một số tính năng phức tạp chỉ có trên phiên bản desktop.",
                        relatedTopics: ["notification_settings", "system_features"]
                    }
                }
            },
            
            // Hướng dẫn và hỗ trợ
            helpAndSupport: {
                id: "helpAndSupport",
                title: "Hướng dẫn và hỗ trợ",
                description: "Tìm kiếm hướng dẫn và hỗ trợ khi sử dụng hệ thống ELMS.",
                answers: {
                  help_guides: {
                        title: "Hướng dẫn sử dụng hệ thống",
                        content: "ELMS cung cấp nhiều tài liệu hướng dẫn giúp bạn sử dụng hệ thống hiệu quả:\n\n<b>1. Truy cập hướng dẫn trực tuyến:</b>\n• Nhấp vào biểu tượng '?' ở góc trên bên phải màn hình\n• Chọn 'Hướng dẫn sử dụng' từ menu dropdown\n• Tìm kiếm chủ đề bạn cần hỗ trợ\n\n<b>2. Video hướng dẫn:</b>\n• Truy cập mục 'Video hướng dẫn' từ menu Trợ giúp\n• Xem các video giải thích từng tính năng\n\n<b>3. Câu hỏi thường gặp (FAQ):</b>\n• Truy cập mục 'Câu hỏi thường gặp' từ menu Trợ giúp\n• Tìm câu trả lời cho các vấn đề phổ biến\n\n<b>4. Hướng dẫn trong ứng dụng:</b>\n• Các tooltip và hướng dẫn hiển thị khi rê chuột\n• Tour hướng dẫn cho người dùng mới\n\nNếu không tìm thấy thông tin cần thiết, bạn có thể liên hệ bộ phận hỗ trợ.",
                        relatedTopics: ["contact_support", "troubleshooting"]
                    },
                    contact_support: {
                        title: "Liên hệ hỗ trợ kỹ thuật",
                        content: "Khi cần hỗ trợ kỹ thuật về hệ thống ELMS, bạn có thể liên hệ qua các kênh sau:\n\n<b>1. Hỗ trợ trực tiếp:</b>\n• Email: support@company.com\n• Điện thoại: 0123-456-789 (giờ hành chính)\n• Ticket hỗ trợ: Tạo ticket từ menu 'Hỗ trợ' trong hệ thống\n\n<b>2. Thông tin cần cung cấp khi yêu cầu hỗ trợ:</b>\n• Tên đăng nhập và phòng ban\n• Mô tả chi tiết vấn đề gặp phải\n• Ảnh chụp màn hình lỗi (nếu có)\n• Các bước tái hiện lỗi\n• Thời gian xảy ra sự cố\n\n<b>3. Thời gian phản hồi:</b>\n• Vấn đề nghiêm trọng: 2-4 giờ làm việc\n• Vấn đề thông thường: 24 giờ làm việc\n\nĐội ngũ IT sẽ liên hệ với bạn qua email hoặc điện thoại để giải quyết vấn đề.",
                        relatedTopics: ["troubleshooting", "help_guides"]
                    },
                    troubleshooting: {
                        title: "Xử lý sự cố thường gặp",
                        content: "Một số sự cố thường gặp và cách khắc phục trong hệ thống ELMS:\n\n<b>1. Không đăng nhập được:</b>\n• Kiểm tra lại tên đăng nhập và mật khẩu\n• Xóa cache trình duyệt và thử lại\n• Sử dụng tính năng 'Quên mật khẩu'\n\n<b>2. Không thể tạo đơn nghỉ phép:</b>\n• Kiểm tra xem còn ngày phép không\n• Đảm bảo đã điền đầy đủ thông tin bắt buộc\n• Đảm bảo không có đơn trùng lặp trong cùng thời gian\n\n<b>3. Không nhận được thông báo:</b>\n• Kiểm tra cài đặt thông báo trong hệ thống\n• Kiểm tra thư mục spam trong email\n• Cập nhật thông tin liên hệ\n\n<b>4. Lỗi hiển thị giao diện:</b>\n• Thử làm mới trang (F5)\n• Xóa cache trình duyệt\n• Thử với trình duyệt khác\n\n<b>5. Vấn đề về phê duyệt đơn:</b>\n• Kiểm tra quyền của tài khoản\n• Đảm bảo bạn đang ở đúng vai trò\n• Kiểm tra cấu hình luồng phê duyệt\n\nNếu vấn đề vẫn tiếp diễn, vui lòng liên hệ bộ phận hỗ trợ kỹ thuật.",
                        relatedTopics: ["contact_support", "help_guides"]
                    },
                    data_privacy: {
                        title: "Bảo mật dữ liệu và quyền riêng tư",
                        content: "ELMS cam kết bảo vệ dữ liệu cá nhân và thông tin nghỉ phép của bạn:\n\n<b>1. Bảo mật thông tin:</b>\n• Dữ liệu được mã hóa trong quá trình truyền tải và lưu trữ\n• Áp dụng các biện pháp bảo mật tiêu chuẩn ngành\n• Kiểm soát truy cập theo phân quyền\n\n<b>2. Quyền riêng tư:</b>\n• Chỉ những người được cấp quyền mới có thể xem thông tin của bạn\n• Quản lý trực tiếp: Chỉ xem được đơn nghỉ phép, không xem được lý do cụ thể nếu được đánh dấu riêng tư\n• Admin: Truy cập đầy đủ nhưng có nhật ký truy cập\n\n<b>3. Lưu trữ dữ liệu:</b>\n• Dữ liệu nghỉ phép được lưu trữ trong thời gian làm việc và thêm 2 năm sau khi nghỉ việc\n• Bạn có thể yêu cầu xuất dữ liệu cá nhân\n\n<b>4. Đăng xuất tự động:</b>\n• Hệ thống tự động đăng xuất sau 30 phút không hoạt động\n• Luôn đăng xuất khi sử dụng máy tính công cộng\n\nĐể tìm hiểu thêm, bạn có thể xem Chính sách Bảo mật trong phần Điều khoản sử dụng.",
                        relatedTopics: ["account_issues", "view_profile"]
                    }
                }
            }
        };
        
        /**
         * Đề xuất câu hỏi dựa trên context
         * Được tổ chức theo nhóm với context cụ thể
         */
        const suggestedQuestions = {
            // Đề xuất câu hỏi mặc định khi bắt đầu
            initial: [
                "ELMS là gì?",
                "Làm thế nào để tạo đơn nghỉ phép?",
                "Tôi có bao nhiêu ngày nghỉ phép?",
                "Làm sao để xem trạng thái đơn nghỉ phép?"
            ],
            
            // Đề xuất sau khi hỏi về thông tin hệ thống
            systemInfo: [
                "Hệ thống có những tính năng gì?",
                "Cách đăng nhập vào hệ thống?",
                "Quên mật khẩu phải làm sao?",
                "Các vai trò người dùng trong hệ thống?"
            ],
            
            // Đề xuất sau khi hỏi về quy trình nghỉ phép
            leaveProcess: [
                "Có những loại nghỉ phép nào?",
                "Làm sao để hủy đơn nghỉ phép?",
                "Cách tính ngày nghỉ phép như thế nào?",
                "Chính sách nghỉ phép của công ty?"
            ],
            
            // Đề xuất sau khi hỏi về tính năng quản lý
            managerFeatures: [
                "Làm sao để duyệt đơn nghỉ phép?",
                "Cách xem lịch nghỉ phép phòng ban?",
                "Tiêu chí duyệt đơn nghỉ phép?",
                "Báo cáo dành cho quản lý?"
            ],
            
            // Đề xuất sau khi hỏi về tính năng quản trị
            adminFeatures: [
                "Cách quản lý người dùng?",
                "Cách quản lý phòng ban?",
                "Thiết lập cấu hình hệ thống?",
                "Báo cáo cho quản trị viên?"
            ],
            
            // Đề xuất sau khi hỏi về thông tin tài khoản
            accountInfo: [
                "Cách đổi mật khẩu?",
                "Thiết lập thông báo?",
                "Cập nhật thông tin cá nhân?",
                "Truy cập từ thiết bị di động?"
            ],
            
            // Đề xuất sau khi hỏi về hỗ trợ
            helpAndSupport: [
                "Cách liên hệ hỗ trợ kỹ thuật?",
                "Xử lý các sự cố thường gặp?",
                "Bảo mật dữ liệu cá nhân?",
                "Tìm hướng dẫn sử dụng ở đâu?"
            ]
        };
        
        /**
         * Đề xuất trả lời nhanh dựa trên context của câu hỏi
         */
        const quickReplies = {
            what_is_elms: ["Các tính năng chính?", "Cách đăng nhập?", "Vai trò người dùng?"],
            leave_request: ["Các loại nghỉ phép?", "Chính sách nghỉ phép?", "Theo dõi trạng thái đơn?"],
            leave_policy: ["Hạn mức nghỉ phép?", "Cách tính ngày nghỉ?", "Các loại nghỉ phép?"],
            approve_leave: ["Tiêu chí duyệt đơn?", "Xem lịch nghỉ phép phòng ban?", "Báo cáo quản lý?"],
            leave_status: ["Cách hủy đơn?", "Tạo đơn mới?", "Chính sách nghỉ phép?"],
            forgot_password: ["Vấn đề về tài khoản?", "Liên hệ hỗ trợ?", "Đổi mật khẩu?"],
            contact_support: ["Xử lý sự cố?", "Hướng dẫn sử dụng?", "Bảo mật dữ liệu?"]
        };
        
        // Các pattern regex để phát hiện ý định và các thực thể phổ biến
        const patterns = {
            greeting: /\b(xin chào|chào|hello|hi|hey|chào buổi)\b/i,
            leave_request: /\b(tạo đơn|đăng ký|xin nghỉ|làm đơn|đơn nghỉ phép)\b/i,
            leave_status: /\b(trạng thái|tình trạng|theo dõi|xem đơn|đơn của tôi)\b/i,
            leave_policy: /\b(quy định|chính sách|số ngày|hạn mức|ngày phép)\b/i,
            help: /\b(giúp đỡ|hướng dẫn|hỗ trợ|cách sử dụng|help)\b/i,
            thanks: /\b(cảm ơn|cám ơn|thank|thanks)\b/i
        };
        
        document.addEventListener('DOMContentLoaded', function() {
            const messagesContainer = document.getElementById('elmsMessages');
            const messageInput = document.getElementById('elmsInput');
            const sendButton = document.getElementById('elmsSend');
            const form = document.getElementById('elmsForm');
            const chatTimeElement = document.getElementById('elms-chat-time');
            
            // Cập nhật thời gian
            function updateTime() {
                const now = new Date();
                const hours = now.getHours().toString().padStart(2, '0');
                const minutes = now.getMinutes().toString().padStart(2, '0');
                chatTimeElement.textContent = `${hours}:${minutes}`;
            }
            
            // Cập nhật thời gian mỗi phút
            updateTime();
            setInterval(updateTime, 60000);
            
            // Hiển thị tin nhắn chào mừng và đề xuất ban đầu
            setTimeout(() => {
                addMessage("Xin chào! Tôi là trợ lý ảo của hệ thống ELMS. Tôi có thể giúp gì cho bạn?", "bot");
                
                // Hiển thị các đề xuất câu hỏi ban đầu
                addSuggestions(suggestedQuestions.initial);
            }, 500);
            
            // Sự kiện gửi tin nhắn
            form.addEventListener('submit', sendMessage);
            sendButton.addEventListener('click', sendMessage);
            
            // Xử lý khi nhấn Enter
            messageInput.addEventListener('keypress', function(e) {
                if (e.key === 'Enter') {
                    e.preventDefault();
                    sendMessage();
                }
            });
            
            // Hàm gửi tin nhắn
            function sendMessage(e) {
                if (e) e.preventDefault();
                
                const message = messageInput.value.trim();
                if (!message) return;
                
                // Hiển thị tin nhắn người dùng
                addMessage(message, "user");
                messageInput.value = '';
                
                // Hiển thị trạng thái "đang gõ"
                showTyping();
                
                // Sau 1 giây sẽ hiển thị câu trả lời
                setTimeout(() => {
                    hideTyping();
                    
                    // Xử lý câu trả lời dựa trên tin nhắn người dùng
                    processUserMessage(message);
                }, 1000);
            }
            
            // Xử lý tin nhắn người dùng để trả về câu trả lời phù hợp
            function processUserMessage(message) {
                const lowerMessage = message.toLowerCase();
                
                // Xác định ý định (intent) từ tin nhắn
                let detectedIntent = null;
                let answerKey = null;
                let category = null;
                
                // Kiểm tra các pattern cụ thể trước
                for (const [intent, regex] of Object.entries(patterns)) {
                    if (regex.test(lowerMessage)) {
                        detectedIntent = intent;
                        break;
                    }
                }
                
                // Xử lý ý định đã phát hiện
                if (detectedIntent === 'greeting') {
                    const greetings = [
                        "Chào bạn! Tôi có thể giúp gì cho bạn?",
                        "Xin chào! Bạn cần hỗ trợ gì về hệ thống nghỉ phép?",
                        "Chào mừng bạn! Tôi là trợ lý ảo của ELMS. Tôi có thể trả lời các câu hỏi về nghỉ phép."
                    ];
                    const randomIndex = Math.floor(Math.random() * greetings.length);
                    addMessage(greetings[randomIndex], "bot");
                    addSuggestions(suggestedQuestions.initial);
                    return;
                }
                
                if (detectedIntent === 'thanks') {
                    addMessage("Không có gì! Rất vui được hỗ trợ bạn. Bạn có câu hỏi nào khác không?", "bot");
                    return;
                }
                
                // Tìm kiếm câu trả lời phù hợp trong cơ sở kiến thức
                for (const [categoryId, categoryData] of Object.entries(elmsKnowledgeBase)) {
                    for (const [key, answerData] of Object.entries(categoryData.answers)) {
                        // Tạo mẫu tìm kiếm từ tiêu đề và nội dung
                        const searchText = `${answerData.title} ${answerData.content}`.toLowerCase();
                        
                        // Kiểm tra xem tin nhắn có chứa từ khóa phù hợp không
                        if (messageMatchesContent(lowerMessage, searchText, key)) {
                            answerKey = key;
                            category = categoryId;
                            break;
                        }
                    }
                    if (answerKey) break;
                }
                
                // Nếu tìm thấy câu trả lời phù hợp
                if (answerKey && category) {
                    const answer = elmsKnowledgeBase[category].answers[answerKey];
                    
                    // Hiển thị câu trả lời
                    addMessage(answer.content, "bot");
                    
                    // Hiển thị quick replies nếu có
                    if (quickReplies[answerKey]) {
                        addQuickReplies(quickReplies[answerKey]);
                    }
                    
                    // Hiển thị các chủ đề liên quan
                    if (answer.relatedTopics && answer.relatedTopics.length > 0) {
                        const relatedQuestions = answer.relatedTopics.map(topic => {
                            for (const categoryData of Object.values(elmsKnowledgeBase)) {
                                if (categoryData.answers[topic]) {
                                    return categoryData.answers[topic].title;
                                }
                            }
                            return null;
                        }).filter(title => title !== null);
                        
                        if (relatedQuestions.length > 0) {
                            addSuggestions(relatedQuestions);
                        }
                    } else {
                        // Nếu không có chủ đề liên quan, hiển thị đề xuất theo danh mục
                        addSuggestions(suggestedQuestions[category] || suggestedQuestions.initial);
                    }
                    
                    return;
                }
                
                // Nếu không tìm thấy câu trả lời cụ thể
                if (detectedIntent === 'leave_request') {
                    addMessage(elmsKnowledgeBase.leaveProcess.answers.leave_request.content, "bot");
                    addQuickReplies(quickReplies.leave_request || []);
                    return;
                }
                
                if (detectedIntent === 'leave_status') {
                    addMessage(elmsKnowledgeBase.leaveProcess.answers.leave_status.content, "bot");
                    addQuickReplies(quickReplies.leave_status || []);
                    return;
                }
                
                if (detectedIntent === 'leave_policy') {
                    addMessage(elmsKnowledgeBase.leaveProcess.answers.leave_policy.content, "bot");
                    addQuickReplies(quickReplies.leave_policy || []);
                    return;
                }
                
                if (detectedIntent === 'help') {
                    addMessage(elmsKnowledgeBase.helpAndSupport.answers.help_guides.content, "bot");
                    addSuggestions(suggestedQuestions.helpAndSupport);
                    return;
                }
                
                // Trả lời mặc định
                addMessage("Xin lỗi, tôi không hiểu câu hỏi của bạn. Bạn có thể hỏi về cách tạo đơn nghỉ phép, xem lịch nghỉ phép, hoặc các quy định nghỉ phép. Hoặc chọn một trong các chủ đề dưới đây:", "bot");
                addSuggestions(suggestedQuestions.initial);
            }
            
            // Kiểm tra xem tin nhắn có khớp với nội dung không
            function messageMatchesContent(message, content, key) {
                // Kiểm tra keyword trực tiếp
                const keywordParts = key.split('_');
                for (const part of keywordParts) {
                    if (part.length > 3 && message.includes(part)) {
                        return true;
                    }
                }
                
                // Các từ khóa quan trọng để kiểm tra
                const messageWords = message.split(/\s+/);
                
                for (const word of messageWords) {
                    // Bỏ qua các từ quá ngắn
                    if (word.length <= 3) continue;
                    
                    // Kiểm tra xem từ có trong nội dung không
                    if (content.includes(word)) {
                        return true;
                    }
                }
                
                return false;
            }
            
            // Thêm tin nhắn vào khung chat
            function addMessage(text, sender) {
                const messageDiv = document.createElement('div');
                messageDiv.className = `elms-message elms-${sender}`;
                
                const bubbleDiv = document.createElement('div');
                bubbleDiv.className = 'elms-bubble';
                
                // Xử lý xuống dòng và định dạng HTML cơ bản
                text = formatMessage(text);
                bubbleDiv.innerHTML = text;
                
                messageDiv.appendChild(bubbleDiv);
                
                // Thêm timestamp
                const timeDiv = document.createElement('div');
                timeDiv.className = 'elms-time';
                const now = new Date();
                timeDiv.textContent = `${now.getHours().toString().padStart(2, '0')}:${now.getMinutes().toString().padStart(2, '0')}`;
                messageDiv.appendChild(timeDiv);
                
                messagesContainer.appendChild(messageDiv);
                
                // Cuộn xuống dưới
                messagesContainer.scrollTop = messagesContainer.scrollHeight;
            }
            
            // Định dạng tin nhắn với HTML cơ bản
            function formatMessage(text) {
                // Xử lý xuống dòng
                text = text.replace(/\n/g, '<br>');
                
                // Giữ nguyên thẻ HTML cơ bản
                return text;
            }
            
            // Hiển thị quick replies
            function addQuickReplies(replies) {
                if (!replies || replies.length === 0) return;
                
                const repliesContainer = document.createElement('div');
                repliesContainer.className = 'elms-quick-replies';
                
                for (const reply of replies) {
                    const replyButton = document.createElement('button');
                    replyButton.className = 'elms-quick-reply';
                    replyButton.textContent = reply;
                    replyButton.addEventListener('click', function() {
                        // Khi nhấp vào quick reply, thêm vào khung chat như tin nhắn người dùng
                        addMessage(reply, "user");
                        
                        // Xử lý câu trả lời
                        showTyping();
                        setTimeout(() => {
                            hideTyping();
                            processUserMessage(reply);
                        }, 1000);
                    });
                    repliesContainer.appendChild(replyButton);
                }
                
                messagesContainer.appendChild(repliesContainer);
                messagesContainer.scrollTop = messagesContainer.scrollHeight;
            }
            
            // Hiển thị gợi ý câu hỏi
            function addSuggestions(suggestions) {
                if (!suggestions || suggestions.length === 0) return;
                
                const suggestionsDiv = document.createElement('div');
                suggestionsDiv.className = 'elms-suggestions';
                
                for (const suggestion of suggestions) {
                    const suggestionButton = document.createElement('button');
                    suggestionButton.className = 'elms-suggestion';
                    suggestionButton.textContent = suggestion;
                    suggestionButton.addEventListener('click', function() {
                        // Khi nhấp vào gợi ý, thêm vào khung chat như tin nhắn người dùng
                        addMessage(suggestion, "user");
                        
                        // Xử lý câu trả lời
                        showTyping();
                        setTimeout(() => {
                            hideTyping();
                            processUserMessage(suggestion);
                        }, 1000);
                    });
                    suggestionsDiv.appendChild(suggestionButton);
                }
                
                messagesContainer.appendChild(suggestionsDiv);
                messagesContainer.scrollTop = messagesContainer.scrollHeight;
            }
            
            // Hiển thị trạng thái đang gõ
            function showTyping() {
                const typingDiv = document.createElement('div');
                typingDiv.className = 'elms-message elms-bot';
                typingDiv.id = 'elmsTyping';
                
                const typingAnimation = document.createElement('div');
                typingAnimation.className = 'elms-typing';
                
                for (let i = 0; i < 3; i++) {
                    const dot = document.createElement('div');
                    dot.className = 'elms-dot';
                    typingAnimation.appendChild(dot);
                }
                
                typingDiv.appendChild(typingAnimation);
                messagesContainer.appendChild(typingDiv);
                
                // Cuộn xuống dưới
                messagesContainer.scrollTop = messagesContainer.scrollHeight;
            }
            
            // Ẩn trạng thái đang gõ
            function hideTyping() {
                const typingElement = document.getElementById('elmsTyping');
                if (typingElement) {
                    typingElement.remove();
                }
            }
        });
    </script>
</body>
</html>

