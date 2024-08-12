<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WebSocket Chat</title>
</head>
<body>
<form action="/chat/createRoom" method="post">
    <input type="text" name="name" placeholder="채팅방 이름">
    <button type="submit" >방 만들기</button>
</form>

<table>
    <c:forEach items="${roomList}"  var="room">
    	<tr>
    		<td><c:out value="${room.chatRoomName}"></c:out>
    	</tr>
    </c:forEach>
</table>
    <script>
        const chat = document.getElementById('chat');
        const messageInput = document.getElementById('messageInput');
        const sendButton = document.getElementById('sendButton');

        const ws = new WebSocket('ws://localhost:8080/chat');

        ws.onopen = () => {
            console.log('Connected to the server');
        };

        ws.onmessage = (event) => {
            const message = document.createElement('div');
            message.textContent = event.data;

            // 다른 사람이 보낸 메시지
            message.classList.add('other-message');
            chat.appendChild(message);
            chat.scrollTop = chat.scrollHeight;
        };

        ws.onclose = () => {
            console.log('Disconnected from the server');
        };

        sendButton.addEventListener('click', () => {
            const message = messageInput.value;
            if (message) {
                // 서버에 메시지를 보내기
                ws.send(message);

                // 내가 보낸 메시지도 같은 창에 추가
                const myMessage = document.createElement('div');
                myMessage.textContent = message;
                myMessage.classList.add('my-message');
                chat.appendChild(myMessage);
                chat.scrollTop = chat.scrollHeight;

                // 입력 필드 초기화
                messageInput.value = '';
            }
        });

        messageInput.addEventListener('keypress', (e) => {
            if (e.key === 'Enter') {
                sendButton.click();
            }
        });
    </script>
</body>
</html>
