</div><!-- End of content-container -->
        </div><!-- End of main-content -->
    </div><!-- End of app-container -->
    
    <script>
        // Toggle sidebar on mobile
        document.getElementById('sidebar-toggle').addEventListener('click', function() {
            const sidebar = document.getElementById('sidebar');
            sidebar.classList.toggle('show');
            
            // Add overlay when opening sidebar on mobile
            if (window.innerWidth <= 768) {
                if (sidebar.classList.contains('show')) {
                    const overlay = document.createElement('div');
                    overlay.className = 'sidebar-overlay';
                    overlay.style.position = 'fixed';
                    overlay.style.top = '0';
                    overlay.style.left = '0';
                    overlay.style.width = '100%';
                    overlay.style.height = '100%';
                    overlay.style.backgroundColor = 'rgba(0,0,0,0.5)';
                    overlay.style.zIndex = '999';
                    document.body.appendChild(overlay);
                    
                    overlay.addEventListener('click', function() {
                        sidebar.classList.remove('show');
                        document.body.removeChild(overlay);
                    });
                } else {
                    const overlay = document.querySelector('.sidebar-overlay');
                    if (overlay) {
                        document.body.removeChild(overlay);
                    }
                }
            }
        });
        
        // Toggle user dropdown
        function toggleDropdown() {
            document.getElementById('user-dropdown').classList.toggle('show');
        }
        
        // Dark mode toggle
        document.getElementById('theme-toggle').addEventListener('change', function() {
            if (this.checked) {
                document.documentElement.setAttribute('data-theme', 'dark');
                setCookie('theme', 'dark', 365);
            } else {
                document.documentElement.setAttribute('data-theme', 'light');
                setCookie('theme', 'light', 365);
            }
        });
        
        // Cookie utilities
        function setCookie(name, value, days) {
            let expires = "";
            if (days) {
                const date = new Date();
                date.setTime(date.getTime() + (days*24*60*60*1000));
                expires = "; expires=" + date.toUTCString();
            }
            document.cookie = name + "=" + (value || "")  + expires + "; path=/";
        }
        
        function getCookie(name) {
            const nameEQ = name + "=";
            const ca = document.cookie.split(';');
            for(let i=0; i < ca.length; i++) {
                let c = ca[i];
                while (c.charAt(0) === ' ') c = c.substring(1, c.length);
                if (c.indexOf(nameEQ) === 0) return c.substring(nameEQ.length, c.length);
            }
            return null;
        }
        
        // Close dropdown when clicking outside
        window.addEventListener('click', function(event) {
            if (!event.target.matches('.user-profile') && !event.target.closest('.user-profile')) {
                const dropdown = document.getElementById('user-dropdown');
                if (dropdown && dropdown.classList.contains('show')) {
                    dropdown.classList.remove('show');
                }
            }
        });
        
        // Load theme preference on page load
        (function() {
            const savedTheme = getCookie('theme');
            if (savedTheme === 'dark') {
                document.documentElement.setAttribute('data-theme', 'dark');
                const themeToggle = document.getElementById('theme-toggle');
                if (themeToggle) themeToggle.checked = true;
            }
        })();
    </script>
    <!-- Popup Chatbot -->
<style>
/* Nút chat và popup container */
#chat-button {
    position: fixed;
    bottom: 20px;
    right: 20px;
    width: 50px;
    height: 50px;
    border-radius: 50%;
    background-color: #1565c0;
    color: white;
    border: none;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    box-shadow: 0 2px 10px rgba(0,0,0,0.2);
    z-index: 9998;
    font-size: 20px;
}

#chat-button:hover {
    background-color: #0d47a1;
}

#chat-popup {
    display: none;
    position: fixed;
    bottom: 80px;
    right: 20px;
    width: 350px;
    height: 450px;
    z-index: 9999;
    border-radius: 10px;
    overflow: hidden;
    box-shadow: 0 5px 25px rgba(0,0,0,0.2);
    transition: all 0.3s ease;
}

#chat-popup iframe {
    width: 100%;
    height: 100%;
    border: none;
}

/* ??m b?o responsive */
@media (max-width: 480px) {
    #chat-popup {
        width: calc(100vw - 40px);
        height: 400px;
    }
}
</style>

<!-- Nút chat và popup -->
<button id="chat-button">
    <i class="fas fa-comments"></i>
</button>
<div id="chat-popup">
    <iframe src="${pageContext.request.contextPath}/chatbot.jsp" title="ELMS Chatbot"></iframe>
</div>

<script>
// X? lý hi?n th? chatbot
document.addEventListener('DOMContentLoaded', function() {
    const chatButton = document.getElementById('chat-button');
    const chatPopup = document.getElementById('chat-popup');
    
    if (chatButton && chatPopup) {
        chatButton.addEventListener('click', function() {
            // Toggle hi?n th? popup
            if (chatPopup.style.display === 'block') {
                chatPopup.style.display = 'none';
            } else {
                chatPopup.style.display = 'block';
            }
        });
        
        // ?óng popup khi click bên ngoài
        document.addEventListener('click', function(event) {
            if (!chatPopup.contains(event.target) && event.target !== chatButton) {
                chatPopup.style.display = 'none';
            }
        });
    }
});
</script>

</body>
</html>