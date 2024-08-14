<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>채팅방</title>

<style>
body{
width: 100vw;  
height: 100vh; 
}

* {
    box-sizing: border-box;
}

html, body {
    overflow-x: hidden;
    overflow-y: auto; /* 수직 스크롤 보이기 */
}
.content{
	padding:80px 0 0;
}


.grid-rows{
	display:grid;
	grid-template-columns: 1.3fr 3fr;
	gap: 10px; /* 열 사이의 간격 */
}


.scrollable-div{
	 width: 380px; /* 너비 설정 */
     height: 650px; /* 높이 설정 */
     border: 1px solid #ccc; /* 테두리 설정 */
     overflow: auto; /* 스크롤을 자동으로 추가 */
}

a.custom{
	 text-decoration: none !important;
}

/* styles.css */

/* 모달 창을 숨깁니다. */
.modal {
    display: none; /* 숨김 */
    position: fixed; /* 고정 위치 */
    z-index: 1; /* 위쪽에 표시 */
    left: 0;
    top: 0;
    width: 50%; /* 전체 너비 */
    height: 50%; /* 전체 높이 */
    overflow: auto; /* 스크롤 가능 */
    background-color: rgb(0,0,0); /* 배경 색 */
    background-color: rgba(0,0,0,0.4); /* 반투명 배경 색 */
}

/* 모달 내용 스타일 */
.modal-content {
    background-color: #fefefe;
    margin: 15% auto; /* 가운데 정렬 */
    padding: 20px;
    border: 1px solid #888;
    width: 80%; /* 너비 설정 */
}

/* 닫기 버튼 스타일 */
.close {
    color: #aaa;
    float: right;
    font-size: 15px;
    font-weight: bold;
}

.close:hover,
.close:focus {
    color: black;
    text-decoration: none;
    cursor: pointer;
}

#chat {
    max-height: 100vh; /* 화면 높이의 50%로 설정하여 반응형 처리 */
    max-width: 100vw;
    overflow-y: auto;  /* 수직 스크롤 추가 */
    padding: 0;
    list-style: none;  /* 기본 불릿 스타일 제거 */
    margin: 0;
}

</style>

<!-- Font Awesome -->
<link
  href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"
  rel="stylesheet"
/>
<!-- Google Fonts -->
<link
  href="https://fonts.googleapis.com/css?family=Roboto:300,400,500,700&display=swap"
  rel="stylesheet"
/>
<!-- MDB -->
<link
  href="https://cdnjs.cloudflare.com/ajax/libs/mdb-ui-kit/7.3.2/mdb.min.css"
  rel="stylesheet"
/>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

</head>
<body>
	<!-- 메뉴바 연결 -->
	<%@ include file="../../common/header.jsp"%>
	<section class="content">
		<div class="w-100 h-100 p-3 py-4">

			<div class="grid-rows">
				<div class="d-flex align-items-start">
				<div class="w-100 h-100  p-3 border --bs-light-border-subtle rounded-3">
				
					<select class="form-select" aria-label="Default select example">
					  <option selected>Open this select menu</option>
					  <option value="1">One</option>
					  <option value="2">Two</option>
					  <option value="3">Three</option>
					</select>
					
					<form class="d-flex align-items-center" role="search">
				        <input class="form-control" type="search" placeholder="학생 이름을 검색해주세요." aria-label="Search">
				        <button class="my-3  ms-2 btn btn-outline-dark text-nowrap" type="submit">검색</button>
				     </form>
					
					<button id="openModalBtn">채팅방 생성</button>
					 <!--모달구조  -->
					 <div id="myModal" class="modal">
					 	<div class="modal-content">
					 		<span class="close">닫기</span>
					 		<h5>수강생을 선택해주세요</h5>
							 <form action="${pageContext.servletContext.contextPath}/admin/chatroom/createroom" method="post" id="createRoomForm">
							    <table border="1">
							        <!-- 테이블 헤더 -->
							        <tr>
							            <th>수강생명</th>
							            <th>수강과목명</th>
							            <th>선택</th> <!-- 라디오 버튼을 위한 열 -->
							        </tr>
							
							        <!-- 이전에 출력된 memberNo 값을 저장할 변수 -->
							        <c:set var="previousMemberNo" value=""/>
							
							        <!-- 리스트 항목을 반복해서 출력 -->
							        <c:forEach items="${classList}" var="enroll">
							            <tr>
							                <!-- 수강생명 출력 -->
							                <td>
							                    <c:out value="${enroll.member.memberName}"/>
							                </td>
							                <!-- 수강과목명 출력 -->
							                <td>
							                    <c:out value="${enroll.syclass.className}"/>
							                </td>
							                <!-- 라디오 버튼 -->
							                <td>
							                    <c:choose>
							                        <c:when test="${previousMemberNo != enroll.member.memberNo}">
							                            <input type="radio" name="memberNo" value="${enroll.member.memberNo}"/>
							                            <c:set var="previousMemberNo" value="${enroll.member.memberNo}"/>
							                        </c:when>
							                        <c:otherwise>
							                        </c:otherwise>
							                    </c:choose>
							                </td>
							            </tr>
							        </c:forEach>
							    </table>
							
							    <!-- 제출 버튼 -->
							    <input type="submit" value="생성하기">
							</form>
					 	</div>
					 </div>
					
					<!-- 채팅방 목록 보기 -->
					<div class="card">
						<div class="card-body w-auto scrollable-div">

							<ul class="list-unstyled mb-0">
								<c:forEach items="${roomList}"  var="room">
								<li class="p-2 border-bottom bg-body-tertiary" 
								data-chat-room-no="${room.chatRoomNo}"
								onclick="selectChatRoom('${room.chatRoomNo}')"
								 ><a
									class="custom d-flex justify-content-between">
										<div class="d-flex flex-row">
											<img
												src="https://mdbcdn.b-cdn.net/img/Photos/Avatars/avatar-8.webp"
												alt="avatar"
												class="rounded-circle d-flex align-self-center me-3 shadow-1-strong"
												width="60">
											<div class="pt-1">
												<p class="fw-bold mb-0"><c:out value="${room.member.memberName}"/></p>
												<p class="d-inline-block text-truncate small text-muted" style="max-width: 150px;">Hello, Are you there?????????????</p>
											</div>
										</div>
										<div class="pt-1">
											<p class="small text-muted mb-1">Just now</p>
											<span class="badge bg-danger float-end">1</span>
										</div>
								</a></li>
							</c:forEach>
							</ul>

						</div>
					</div>

				</div>
				</div>
				
				<!--메시지 보내고 보이는 공간  -->
                <div class="chat-placeholder" id="chatPlaceholder">
                    <h4>채팅방을 선택해주세요</h4>
                </div>
				<div class="col-md-8 chat-box w-100 h-100" id="chatBox">
				<div class="d-flex align-items-start">
				<div class="w-100 h-100 col-md-6 col-lg-7 col-xl-8 p-3 border --bs-light-border-subtle rounded-3">
					<!--메시지가 추가되는 공간  -->
					<ul class="list-unstyled" id="chat">
					</ul>
						<div id="sendDiv" class="active">
						<li class="list-unstyled bg-white mb-3">
							<div data-mdb-input-init class="form-outline">
								<textarea class="form-control bg-body-tertiary mb-4"
									id="messageInput" rows="4"></textarea>
								<label class="form-label" for="messageInput">메시지</label>
							</div>
						</li>
						<button type="button" data-mdb-button-init data-mdb-ripple-init
							class="btn btn-info btn-rounded float-end" id="sendButton">보내기</button>
						</div>
					</div>
				</div>
			</div>
			</div>

		</div>
	</section>
	<!-- 푸터 연결 -->
	<%@ include file="../../common/footer.jsp"%>
	
	
<script
  type="text/javascript"
  src="https://cdnjs.cloudflare.com/ajax/libs/mdb-ui-kit/7.3.2/mdb.umd.min.js"
></script>	


<script>

//모달과 버튼을 변수에 저장합니다.
var modal = document.getElementById("myModal");
var btn = document.getElementById("openModalBtn");
var span = document.getElementsByClassName("close")[0];

//버튼을 클릭하면 모달을 열어줍니다.
btn.onclick = function() {
modal.style.display = "block";
}

//<span> (닫기 버튼)을 클릭하면 모달을 닫아줍니다.
span.onclick = function() {
modal.style.display = "none";
}

//모달 밖을 클릭하면 모달을 닫아줍니다.
window.onclick = function(event) {
if (event.target == modal) {
   modal.style.display = "none";
}
}
</script>

<script>

document.addEventListener('DOMContentLoaded', function () {
	var chatBox = document.getElementById("chatBox");
	chatBox.style.visibility = "hidden";
});
</script>

<script type="text/javascript">
// 로그인한 사용자 정보 (서버에서 JSP에 전달된 경우)
const loginMemberNo = "${loginMember.memberNo}";
const loginMemberName = "${loginMember.memberName}";


let currentChatRoomNo = null; // 현재 선택된 채팅방의 chatRoomNo

//채팅방 클릭 시 호출되는 함수
function selectChatRoom(chatRoomNo) {
    currentChatRoomNo = chatRoomNo;
    console.log('Selected Chat Room No:', currentChatRoomNo);
    
    $.ajax({
        url: '/member/chatroom/chats/' + currentChatRoomNo,
        method: 'GET',
        dataType: 'json',
        success: function(data) {
        	displayMessages(data);
        },
        error: function(error) {
            console.error('AJAX 오류:', error);
        }
    });
    
 // JSON 데이터를 HTML로 변환하여 표시하는 함수
    function displayMessages(messages) {
        var chatContainer = $('#chat');
        chatContainer.empty(); // 기존 내용을 제거
        
        console.log(messages);
        
        var chatBox = document.getElementById("chatBox");
        chatBox.style.visibility = "visible";
        var chatPlaceholder = document.getElementById("chatPlaceholder");
        chatPlaceholder.style.display = "none";
        
        
        $.each(messages, function(index, message) {
        	
        	if(message.memberNo === loginMemberNo){//나-오른쪽에 와야 햐는 사람
        		
        		var messageItem = $('<li>', { class: 'd-flex justify-content-end mb-6'})
        	    .append($('<div>', { class: 'card w-100' })
        	        .append($('<div>', { class: 'card-header d-flex justify-content-between p-3' })
        	            .append($('<p>', { class: 'fw-bold mb-0' }).text(message.memberName)) // 송신자 이름
        	            .append($('<p>', { class: 'text-muted small mb-0' })
        	                .append($('<i>', { class: 'far fa-clock' }).text(message.regDateTime)) // 타임스탬프
        	            )
        	        )
        	        .append($('<div>', { class: 'card-body' })
        	            .append($('<p>', { class: 'mb-0' }).text(message.message)) // 메시지 내용
        	        )
        	    )
        	    .append($('<img>', {
        	        src: 'https://mdbcdn.b-cdn.net/img/Photos/Avatars/avatar-6.webp', // 다른 사람 이미지 URL
        	        alt: 'avatar',
        	        class: 'rounded-circle d-flex align-self-start ms-3 shadow-1-strong', // 왼쪽 여백
        	        width: '60'
        	    }));

        		
        	}else {/* 남-왼쪽에 와야 하는 사람  */
        		var messageItem = $('<li>', { class: 'd-flex justify-content-start mb-6'})
        	    .append($('<img>', {
        	        src: 'https://mdbcdn.b-cdn.net/img/Photos/Avatars/avatar-6.webp', // 다른 사람 이미지 URL
        	        alt: 'avatar',
        	        class: 'rounded-circle d-flex align-self-start me-3 shadow-1-strong', // 왼쪽 여백
        	        width: '60'
        	    }))
        	    .append($('<div>', { class: 'card w-100'})
        	        .append($('<div>', { class: 'card-header d-flex justify-content-between p-3' })
        	            .append($('<p>', { class: 'fw-bold mb-0' }).text(message.memberName)) // 송신자 이름
        	            .append($('<p>', { class: 'text-muted small mb-0' })
        	                .append($('<i>', { class: 'far fa-clock' }).text(message.regDateTime)) // 타임스탬프
        	            )
        	        )
        	        .append($('<div>', { class: 'card-body' })
        	            .append($('<p>', { class: 'mb-0' }).text(message.message)) // 메시지 내용
        	        )
        	    );


        	}
        	
        	// 메시지 아이템을 채팅 공간에 추가
            chatContainer.append(messageItem);
        });
    }
}

const chat = document.getElementById('chat');
const messageInput = document.getElementById('messageInput');
const sendButton = document.getElementById('sendButton');

// WebSocket 연결 설정
const ws = new WebSocket('ws://localhost:8080/ws');

ws.onopen = () => {
    console.log('서버에 연결되었습니다.');
};

ws.onmessage = (event) => {
    // 서버로부터 받은 메시지를 화면에 표시
    // 상대방이 나한테 보낸 메시지
    const messageData = JSON.parse(event.data);

    console.log(messageData);
    
    const message = document.createElement('li');
    message.classList.add('d-flex', 'justify-content-between', 'mb-6');

    const avatar = document.createElement('img');
    avatar.src = "https://mdbcdn.b-cdn.net/img/Photos/Avatars/avatar-6.webp";
    avatar.alt = "avatar";
    avatar.classList.add('rounded-circle', 'd-flex', 'align-self-start', 'me-3', 'shadow-1-strong');
    avatar.width = 60;

    const messageCard = document.createElement('div');
    messageCard.classList.add('card');

    const cardHeader = document.createElement('div');
    cardHeader.classList.add('card-header', 'd-flex', 'justify-content-between', 'p-3');

    const senderName = document.createElement('p');
    senderName.classList.add('fw-bold', 'mb-0');
    senderName.textContent = messageData.memberName;

    const timestamp = document.createElement('p');
    timestamp.classList.add('text-muted', 'small', 'mb-0');
    timestamp.innerHTML = `<i class="far fa-clock"></i>`;
    timestamp.textContent = messageData.regDateTime;
    
    cardHeader.appendChild(senderName);
    cardHeader.appendChild(timestamp);

    const cardBody = document.createElement('div');
    cardBody.classList.add('card-body');

    const messageText = document.createElement('p');
    messageText.classList.add('mb-0');
    messageText.textContent = messageData.message;

    cardBody.appendChild(messageText);
    messageCard.appendChild(cardHeader);
    messageCard.appendChild(cardBody);

    message.appendChild(avatar);
    message.appendChild(messageCard);
    chat.appendChild(message);
    chat.scrollTop = chat.scrollHeight;
};



sendButton.addEventListener('click', () => {
    const messageContent = messageInput.value;
    if (messageContent) {
        
		const messageData = {
            chatRoomNo: currentChatRoomNo,  
            memberNo:  loginMemberNo,  
            memberName: loginMemberName,  
            message: messageContent
        };

        // JSON 형식으로 메시지 데이터를 문자열로 변환하여 서버로 전송
        ws.send(JSON.stringify(messageData));

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

ws.onclose = () => {
    console.log('서버 연결이 끊어졌습니다.');
};

ws.onerror = (error) => {
    console.error('WebSocket error:', error);
};
</script>

</body>
</html>