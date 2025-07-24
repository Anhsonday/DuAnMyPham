<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AI Beauty Advisor - Tư vấn & Thanh toán</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            font-family: 'Inter', 'Poppins', Arial, sans-serif;
            background: linear-gradient(135deg, #f093fb 0%, #667eea 100%);
            min-height: 100vh;
            margin: 0;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        body::before {
            content: '';
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: 
                radial-gradient(circle at 20% 80%, rgba(120, 119, 198, 0.3) 0%, transparent 50%),
                radial-gradient(circle at 80% 20%, rgba(255, 119, 198, 0.3) 0%, transparent 50%),
                radial-gradient(circle at 40% 40%, rgba(120, 219, 255, 0.2) 0%, transparent 50%);
            z-index: -1;
        }
        .chat-container {
            width: 90%;
            max-width: 980px;
            height: 700px;
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-radius: 25px;
            box-shadow: 
                0 25px 50px rgba(0,0,0,0.15),
                0 0 0 1px rgba(255,255,255,0.2),
                inset 0 1px 0 rgba(255,255,255,0.5);
            display: flex;
            flex-direction: column;
            overflow: hidden;
            position: relative;
        }

        .chat-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 2px;
            background: linear-gradient(135deg, #ff6b9d, #c471ed, #12c2e9);
        }

        .chat-header {
            background: linear-gradient(135deg, #ff9a9e 0%, #fecfef 50%, #fecfef 100%);
            color: #2d3748;
            padding: 30px 25px;
            text-align: center;
            position: relative;
            overflow: hidden;
        }

        .chat-header::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: 
                radial-gradient(circle, rgba(255,255,255,0.1) 1px, transparent 1px);
            background-size: 20px 20px;
            animation: float 20s linear infinite;
        }

        @keyframes float {
            0% { transform: translate(-50%, -50%) rotate(0deg); }
            100% { transform: translate(-50%, -50%) rotate(360deg); }
        }

        .chat-header .header-content {
            position: relative;
            z-index: 1;
        }

        .header-content {
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .avatar {
            width: 54px;
            height: 54px;
            border-radius: 50%;
            overflow: hidden;
            margin-right: 16px;
            box-shadow: 0 4px 12px rgba(255, 154, 158, 0.15);
            background: #fff;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .avatar img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .header-title {
            font-size: 1.85rem;
            font-weight: 700;
            margin-bottom: 2px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .header-subtitle {
            font-size: 1rem;
            opacity: 0.8;
            font-weight: 400;
        }
        .status-dot {
            width: 10px;
            height: 10px;
            background: #4ade80;
            border-radius: 50%;
            animation: pulse 2s infinite;
        }
        @keyframes pulse {
            0%, 100% { opacity: 1; }
            50% { opacity: 0.5; }
        }
        .chat-body {
            flex: 1;
            padding: 24px 18px 0 18px;
            overflow-y: auto;
            background: linear-gradient(to bottom, #fafafa 0%, #f5f5f5 100%);
        }
        .msg-row {
            display: flex;
            margin-bottom: 18px;
            align-items: flex-end;
        }
        .msg-row.user {
            justify-content: flex-end;
        }
        .msg-bubble {
            max-width: 75%;
            padding: 16px 20px;
            border-radius: 18px;
            font-size: 1rem;
            line-height: 1.5;
            position: relative;
            word-break: break-word;
            box-shadow: 0 4px 16px rgba(102, 126, 234, 0.08);
        }
        .msg-bubble.user {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: #fff;
            border-bottom-right-radius: 6px;
            margin-right: 12px;
        }
        .msg-bubble.ai {
            background: #fff;
            color: #2d3748;
            border-bottom-left-radius: 6px;
            margin-left: 12px;
            border: 1px solid #f3e6f5;
        }
        .msg-time {
            font-size: 11px;
            color: #999;
            margin: 0 8px;
            opacity: 0.7;
        }
        .typing-indicator {
            display: flex;
            align-items: center;
            margin-bottom: 18px;
            margin-left: 62px;
        }
        .typing-dots {
            display: flex;
            gap: 6px;
            padding: 14px 18px;
            background: #fff;
            border-radius: 18px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        }
        .typing-dot {
            width: 10px;
            height: 10px;
            background: linear-gradient(135deg, #ff9a9e, #fad0c4);
            border-radius: 50%;
            animation: typing 1.6s infinite ease-in-out;
        }
        .typing-dot:nth-child(1) { animation-delay: -0.32s; }
        .typing-dot:nth-child(2) { animation-delay: -0.16s; }
        @keyframes typing {
            0%, 80%, 100% { transform: scale(0.8); opacity: 0.5; }
            40% { transform: scale(1.2); opacity: 1; }
        }
        .chat-footer {
            padding: 22px 18px;
            background: #fff;
            border-top: 1px solid #eee;
        }
        .input-container {
            display: flex;
            align-items: center;
            background: #f8f9fa;
            border-radius: 24px;
            padding: 4px;
            border: 2px solid transparent;
            transition: all 0.3s ease;
        }
        .input-container:focus-within {
            border-color: #667eea;
            box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1);
        }
        .chat-input {
            flex: 1;
            padding: 14px 18px;
            border: none;
            background: transparent;
            font-size: 1rem;
            outline: none;
            font-family: inherit;
            color: #333;
        }
        .chat-input::placeholder {
            color: #bbb;
        }
        .chat-send {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: #fff;
            border: none;
            border-radius: 20px;
            padding: 0 22px;
            margin-left: 10px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            height: 44px;
            display: flex;
            align-items: center;
            gap: 8px;
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.18);
            transition: all 0.2s;
        }
        .chat-send:disabled {
            background: #e2e8f0;
            color: #a0aec0;
            cursor: not-allowed;
            box-shadow: none;
        }
        .chat-send.stop {
            background: linear-gradient(135deg, #ff9a9e, #fad0c4);
            color: #c53030;
        }
        .action-buttons {
            display: flex;
            gap: 16px;
            justify-content: center;
            margin: 18px 0 0 0;
        }
        .action-button {
            padding: 12px 24px;
            background: #f3f3f3;
            color: #444;
            border: none;
            border-radius: 18px;
            font-size: 1rem;
            font-weight: 500;
            cursor: pointer;
            box-shadow: 0 2px 8px rgba(102, 126, 234, 0.08);
            transition: all 0.2s;
        }
        .action-button:hover {
            background: #e2e8f0;
        }
        .quick-actions {
            display: flex;
            gap: 8px;
            justify-content: center;
            margin: 12px 0;
            flex-wrap: wrap;
        }
        .quick-action {
            padding: 8px 16px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: #fff;
            border: none;
            border-radius: 16px;
            font-size: 0.9rem;
            font-weight: 500;
            cursor: pointer;
            box-shadow: 0 2px 8px rgba(102, 126, 234, 0.15);
            transition: all 0.2s;
        }
        .quick-action:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.25);
        }
        @media (max-width: 600px) {
            .chat-container { max-width: 100%; height: 100vh; border-radius: 0; }
            .chat-header { padding: 18px 10px 12px 10px; }
            .chat-body { padding: 12px 6px 0 6px; }
            .chat-footer { padding: 12px 6px; }
        }
        .example-question {
            color: #667eea;
            cursor: pointer;
            text-decoration: underline dotted;
            margin: 0 2px;
            transition: color 0.2s;
        }
        .example-question:hover {
            color: #c471ed;
            text-decoration: underline;
        }
        .example-sep {
            color: #bbb;
            margin: 0 4px;
        }
    </style>
</head>
<body>
    <div class="chat-container">
        <div class="chat-header">
            <div class="header-content">
                <div class="avatar"><img src="https://cdn-icons-png.flaticon.com/512/4712/4712035.png" alt="AI"></div>
                <div>
                    <div class="header-title">AI Beauty Advisor <span class="status-dot"></span></div>
                    <div class="header-subtitle">Tư vấn mỹ phẩm & Thanh toán thông minh</div>
                </div>
            </div>
        </div>
        <div class="chat-body" id="chatBody"></div>
        <div class="quick-actions">
            <button class="quick-action" onclick="sendQuickAction('Giỏ hàng của tôi có bao nhiêu sản phẩm?')">
                <i class="fas fa-shopping-cart"></i> Xem giỏ hàng
            </button>
            <button class="quick-action" onclick="sendQuickAction('Tôi muốn thanh toán khi nhận hàng')">
                <i class="fas fa-money-bill-wave"></i> Thanh toán COD
            </button>
            <button class="quick-action" onclick="sendQuickAction('Tôi muốn chuyển khoản VietQR')">
                <i class="fas fa-qrcode"></i> Chuyển khoản QR
            </button>
        </div>
        <div class="action-buttons">
            <button class="action-button" onclick="getSummary()"><i class="fas fa-clipboard-list"></i> Tóm tắt cuộc trò chuyện</button>
            <button class="action-button" onclick="clearChat()"><i class="fas fa-sync-alt"></i> Làm mới</button>
        </div>
        <div class="chat-footer">
            <div class="input-container">
                <input type="text" id="chatInput" class="chat-input" placeholder="Hỏi tôi về mỹ phẩm, skincare, makeup, giỏ hàng, thanh toán..." autocomplete="new-password" autocapitalize="off" spellcheck="false" />
                <button id="chatSend" class="chat-send"><i class="fa fa-paper-plane"></i> Gửi</button>
            </div>
            
        </div>
    </div>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/marked/4.3.0/marked.min.js"></script>
    <script>
        const chatBody = document.getElementById('chatBody');
        const chatInput = document.getElementById('chatInput');
        const chatSend = document.getElementById('chatSend');
        let sessionId = 'session_' + Date.now() + '_' + Math.random().toString(36).substr(2, 9);
        let isTyping = false;
        let isWaitingAI = false;
        let fetchAborted = false;
        let currentController = null;

        function getCurrentTime() {
            const now = new Date();
            return now.toLocaleTimeString('vi-VN', { hour: '2-digit', minute: '2-digit' });
        }

        function addMessage(text, sender) {
            removeTypingIndicator();
            const row = document.createElement('div');
            row.className = 'msg-row ' + sender;
            
            const avatar = document.createElement('div');
            avatar.className = 'avatar';
            if (sender === 'user') {
                avatar.innerHTML = '<img src="https://randomuser.me/api/portraits/men/32.jpg" alt="User">';
            } else {
                avatar.innerHTML = '<img src="https://cdn-icons-png.flaticon.com/512/4712/4712035.png" alt="AI">';
            }
            
            const bubble = document.createElement('div');
            bubble.className = 'msg-bubble ' + sender;
            bubble.innerHTML = marked.parse(text);
            
            const time = document.createElement('span');
            time.className = 'msg-time';
            time.textContent = getCurrentTime();
            
            if (sender === 'user') {
                row.appendChild(time);
                row.appendChild(bubble);
                row.appendChild(avatar);
            } else {
                row.appendChild(avatar);
                row.appendChild(bubble);
                row.appendChild(time);
            }
            
            chatBody.appendChild(row);
            chatBody.scrollTop = chatBody.scrollHeight;
        }

        function showTypingIndicator() {
            if (isTyping) return;
            isTyping = true;
            const typingDiv = document.createElement('div');
            typingDiv.className = 'msg-row';
            typingDiv.id = 'typing-indicator';
            const typingBubble = document.createElement('div');
            typingBubble.className = 'typing-indicator';
            typingBubble.innerHTML = `
                <div class="typing-dots">
                    <div class="typing-dot"></div>
                    <div class="typing-dot"></div>
                    <div class="typing-dot"></div>
                </div>
            `;
            typingDiv.appendChild(typingBubble);
            chatBody.appendChild(typingDiv);
            chatBody.scrollTop = chatBody.scrollHeight;
        }

        function removeTypingIndicator() {
            const typingIndicator = document.getElementById('typing-indicator');
            if (typingIndicator) {
                typingIndicator.remove();
                isTyping = false;
            }
        }

        function sendMessage() {
            const msg = chatInput.value.trim();
            if (!msg || isWaitingAI) return;
            
            addMessage(msg, 'user');
            chatInput.value = '';
            chatSend.classList.add('stop');
            chatSend.innerHTML = '<i class="fa fa-stop"></i> Dừng';
            showTypingIndicator();
            
            currentController = new AbortController();
            isWaitingAI = true;
            fetchAborted = false;

            const requestData = {
                message: msg,
                sessionId: sessionId
            };

            fetch('<%=request.getContextPath()%>/chat-agent/chat', {
                method: 'POST',
                headers: { 
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(requestData),
                signal: currentController.signal
            })
            .then(res => {
                if (fetchAborted) return Promise.reject('aborted');
                return res.json();
            })
            .then(data => {
                if (fetchAborted) return;
                setTimeout(() => {
                    addMessage(data.response, 'ai');
                    chatSend.classList.remove('stop');
                    chatSend.innerHTML = '<i class="fa fa-paper-plane"></i> Gửi';
                    chatInput.focus();
                    currentController = null;
                    isWaitingAI = false;
                }, 500);
            })
            .catch(err => {
                if (fetchAborted || (err && err.name === 'AbortError') || err === 'aborted') {
                    return;
                }
                setTimeout(() => {
                    addMessage('Xin lỗi, có lỗi kết nối. Vui lòng thử lại.', 'ai');
                    chatSend.classList.remove('stop');
                    chatSend.innerHTML = '<i class="fa fa-paper-plane"></i> Gửi';
                    chatInput.focus();
                    currentController = null;
                    isWaitingAI = false;
                }, 500);
            });
        }

        function sendQuickAction(action) {
            chatInput.value = action;
            sendMessage();
        }

        chatSend.onclick = function() {
            if (currentController && isWaitingAI) {
                fetchAborted = true;
                currentController.abort();
                removeTypingIndicator();
                addMessage('Đã dừng phản hồi từ AI.', 'ai');
                chatSend.classList.remove('stop');
                chatSend.innerHTML = '<i class="fa fa-paper-plane"></i> Gửi';
                currentController = null;
                isWaitingAI = false;
            } else {
                sendMessage();
            }
        };

        chatInput.addEventListener('keydown', function(e) {
            if (e.key === 'Enter' && !e.shiftKey) {
                e.preventDefault();
                sendMessage();
            }
        });

        function getSummary() {
            showTypingIndicator();
            const requestData = {
                sessionId: sessionId
            };

            fetch('<%=request.getContextPath()%>/chat-agent/summary', {
                method: 'POST',
                headers: { 
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(requestData)
            })
            .then(res => res.json())
            .then(data => {
                setTimeout(() => {
                    addMessage('📋 <b>Tóm tắt cuộc trò chuyện:</b><br><br>' + data.summary, 'ai');
                }, 500);
            })
            .catch(() => {
                setTimeout(() => {
                    addMessage('Không thể tạo tóm tắt cuộc trò chuyện.', 'ai');
                }, 500);
            });
        }

        function clearChat() {
            chatBody.innerHTML = '';
            chatInput.value = '';
            chatInput.focus();
            sessionId = 'session_' + Date.now() + '_' + Math.random().toString(36).substr(2, 9);
            
            // Gửi greeting mới
            setTimeout(() => {
                showTypingIndicator();
                const requestData = {
                    sessionId: sessionId
                };

                fetch('<%=request.getContextPath()%>/chat-agent/greeting', {
                    method: 'POST',
                    headers: { 
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify(requestData)
                })
                .then(res => res.json())
                .then(data => {
                    setTimeout(() => {
                        addMessage(data.message, 'ai');
                    }, 800);
                })
                .catch(() => {
                    setTimeout(() => {
                        addMessage('Xin chào! Tôi là AI tư vấn mỹ phẩm và hỗ trợ thanh toán. Bạn có thể hỏi tôi về sản phẩm, xem giỏ hàng hoặc thanh toán nhé! 💄✨', 'ai');
                    }, 800);
                });
            }, 300);
        }

        function sendExample(text) {
            chatInput.value = text;
            sendMessage();
        }

        // Khởi tạo greeting khi load trang
        window.addEventListener('load', function() {
            setTimeout(() => {
                showTypingIndicator();
                const requestData = {
                    sessionId: sessionId
                };

                fetch('<%=request.getContextPath()%>/chat-agent/greeting', {
                    method: 'POST',
                    headers: { 
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify(requestData)
                })
                .then(res => res.json())
                .then(data => {
                    setTimeout(() => {
                        addMessage(data.message, 'ai');
                    }, 800);
                })
                .catch(() => {
                    setTimeout(() => {
                        addMessage('Xin chào! Tôi là AI tư vấn mỹ phẩm và hỗ trợ thanh toán. Bạn có thể hỏi tôi về sản phẩm, xem giỏ hàng hoặc thanh toán nhé! 💄✨', 'ai');
                    }, 800);
                });
            }, 300);
        });

        chatInput.focus();
    </script>
</body>
</html> 