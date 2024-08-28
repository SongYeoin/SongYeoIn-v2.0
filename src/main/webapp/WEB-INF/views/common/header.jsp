<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>송파여성인력센터</title>

<style>
header {
	background-color: black;
	color: white;
	padding: 20px; /* 헤더 높이 줄임 */
	display: flex;
	align-items: center;
	position: fixed;
	top: 0;
	left: 0;
	width: 100%;
	z-index: 1000;
	justify-content: space-between;
}

.header-left {
	display: flex;
	align-items: center;
}

.menu-button {
	font-size: 24px;
	cursor: pointer;
	margin-right: 20px;
}

.logo {
	font-size: 24px;
	cursor: pointer;
}

.logo .highlight {
	font-weight: bold;
}


.header-right {
	display: flex;
    align-items: center;
    gap: 30px;
}

.btns {
	display: flex;
	gap: 10px;
}

.fs-3 {
	cursor: pointer;
}

.member {
    display: flex;            
    align-items: center;      
    gap: 10px;                
}
/* 모달창  */
/* Modal Background */
.modal {
    display: none; /* Hidden by default */
    position: fixed; /* Stay in place */
    z-index: 1; /* Sit on top */
    left: 0;
    top: 0;
    width: 100%; /* Full width */
    height: 100%; /* Full height */
    overflow: auto; /* Enable scroll if needed */
    background-color: rgb(0,0,0); /* Fallback color */
    background-color: rgba(0,0,0,0.4); /* Black w/ opacity */
}

/* Modal Content */
.modal-content {
    background-color: #fefefe;
    margin: 15% auto; /* 15% from the top and centered */
    padding: 20px;
    border: 1px solid #888;
    width: 80%; /* Could be more or less, depending on screen size */
    max-width: 500px;
    text-align: center;
    border-radius: 8px;
}

/* Close Button */
.close {
    color: #aaa;
    float: right;
    font-size: 28px;
    font-weight: bold;
}

.close:hover,
.close:focus {
    color: black;
    text-decoration: none;
    cursor: pointer;
}

/* Profile Image */
.profile-image img {
    width: 100px;
    height: 100px;
    border-radius: 50%;
    object-fit: cover;
}

/* Profile Actions */
.profile-actions button {
    background-color: #4CAF50; /* Green */
    border: none;
    color: white;
    padding: 10px 20px;
    text-align: center;
    text-decoration: none;
    display: inline-block;
    font-size: 16px;
    margin: 10px 5px;
    cursor: pointer;
    border-radius: 5px;
}

.profile-actions button:hover {
    background-color: #45a049;
}

#deleteProfileBtn {
    background-color: #f44336; /* Red */
}

#deleteProfileBtn:hover {
    background-color: #e53935;
}



</style>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.0/font/bootstrap-icons.css">
</head>
<body>

	<!-- header 영역 -->
	<header>
	<div class="header-left">
        <div class="menu-button">
            &#9776;
        </div>
        <c:choose>
			<c:when test="${sessionScope.loginMember.memberRole == 'ROLE_MEMBER'}">
		        <div class="logo" onclick="location.href='${pageContext.servletContext.contextPath}/member/main'">
	            	<span class="highlight">S</span>ongpa <span class="highlight">W</span>oman
		        </div>
			</c:when>
			<c:when test="${sessionScope.loginMember.memberRole == 'ROLE_ADMIN'}">
	            <div class="logo" onclick="location.href='${pageContext.servletContext.contextPath}/admin/main'">
	            	<span class="highlight">S</span>ongpa <span class="highlight">W</span>oman
		        </div>
			</c:when>
		</c:choose>
     </div>
        
        
        <!--모달창  -->
        <div id="profileModal" class="modal">
	        <div class="modal-content">
	            <span id="closeModalBtn" class="close">&times;</span>
	            <div class="profile-image">
	            	<c:choose>
	            		<c:when test="${not empty sessionScope.loginMember.memberProfileUrl }">
			                <img src="${sessionScope.loginMember.memberProfileUrl}" alt="Profile Image" id="profileImg">
	            		</c:when>
	            		<c:otherwise>
	            			<i class="bi bi-person-circle fs-2"></i>
	            		</c:otherwise>
	            	</c:choose>
	            	<form action="${pageContext.servletContext.contextPath}/member/profile/upload" method="post" enctype="multipart/form-data">
		            	<label for="profileImage">프로필 이미지를 선택하세요 (JPG, PNG 형식만 가능):</label>
		            	<input type="file" id="profileImage" name="file" accept="image/*" required>
						<input type="hidden" name="memberNo" value="${sessionScope.loginMember.memberNo}"> 	
			            <div class="profile-actions">
			                <button id="editProfileBtn" type="submit">프로필 수정</button>
			                <button id="deleteProfileBtn" type="submit">프로필 삭제</button>
			            </div>
	            	</form>
	            </div>
	        </div>
	    </div>
        
        
        
        
        <div class="header-right">
	        <div class="member">
		        <c:choose>
					<c:when test="${not empty sessionScope.loginMember && sessionScope.loginMember.memberRole == 'ROLE_MEMBER' && not empty sessionScope.loginMember.memberProfileUrl}">
				        	<div class="flex-shrink-0">
				              <img id="showProfileDetail" src="${sessionScope.loginMember.memberProfileUrl}"
				                alt="memberProfile" class="img-fluid" style="width: 40px; height: 40px; border-radius: 10px; cursor: pointer;">
				            </div>
		        	</c:when>
					<c:when test="${not empty sessionScope.loginMember && sessionScope.loginMember.memberRole == 'ROLE_ADMIN' && not empty sessionScope.loginMember.memberProfileUrl}">
		        		<div class="flex-shrink-0">
			              <img id="showProfileDetail" src="${sessionScope.loginMember.memberProfileUrl}"
			                alt="memberProfile" class="img-fluid" style="width: 40px; height: 40px; border-radius: 10px; cursor: pointer;">
			            </div>
		        	</c:when>
		        	<c:otherwise> 
		        		<i id="showProfileDetail" class="bi bi-person-circle fs-2" style="cursor: pointer;" onclick="location.href='${pageContext.servletContext.contextPath}/member/chatroom/main'"></i>
					 </c:otherwise>
		        </c:choose> 
	        
		        <c:if test="${ !empty sessionScope.loginMember }"><c:out value="${ sessionScope.loginMember.memberName }"/> 님</c:if>
	        </div>
	        <div class="btns">
				<c:choose>
					<c:when test="${sessionScope.loginMember.memberRole == 'ROLE_MEMBER'}">
						<c:choose>
							<c:when  test="${sessionScope.unreadRoomCount gt 0 }">
								<i class="bi bi-chat-fill fs-3 chat-move" style="color:red" onclick="location.href='${pageContext.servletContext.contextPath}/member/chatroom/main'"></i>
							</c:when>
							<c:otherwise>
								<i class="bi bi-chat fs-3 chat-move" onclick="location.href='${pageContext.servletContext.contextPath}/member/chatroom/main'"></i>
							</c:otherwise>
						</c:choose>
						<i class="bi bi-person fs-3" onclick="location.href='${pageContext.servletContext.contextPath}/member/mypage'"></i>
					</c:when>
					<c:when test="${sessionScope.loginMember.memberRole == 'ROLE_ADMIN'}">
						<c:choose>
							<c:when  test="${sessionScope.unreadRoomCount gt 0 }">
								<i class="bi bi-chat-fill fs-3 chat-move" style="color:red" onclick="location.href='${pageContext.servletContext.contextPath}/admin/chatroom/main'"></i>
							</c:when>
							<c:otherwise>
								<i class="bi bi-chat fs-3 chat-move" onclick="location.href='${pageContext.servletContext.contextPath}/admin/chatroom/main'"></i>
							</c:otherwise>
						</c:choose>
						<i class="bi bi-person fs-3" onclick="location.href='${pageContext.servletContext.contextPath}/admin/mypage'"></i>
					</c:when>
				</c:choose>
	        <i class="bi bi-box-arrow-right fs-3" onclick="location.href='${pageContext.servletContext.contextPath}/member/logout'"></i> <!-- 로그아웃 아이콘 -->
	        </div>
        </div>
    </header>
    
<script type="text/javascript">
const profileModal = document.getElementById('profileModal');
const showProfileDetail = document.getElementById('showProfileDetail');
const closeModalBtn = document.getElementById('closeModalBtn');
// Open modal
showProfileDetail.onclick = function() {
	profileModal.style.display = 'block';
}

// Close modal
closeModalBtn.onclick = function() {
	profileModal.style.display = 'none';
}

// Close modal when clicking outside the modal content
window.onclick = function(event) {
    if (event.target === profileModal) {
    	profileModal.style.display = 'none';
    }
}

document.getElementById('profileImage').addEventListener('change', function(event) {
    const file = event.target.files[0];
    if (file) {
        const reader = new FileReader();
        reader.onload = function(e) {
            // Set the src attribute of the image to the file's data URL
            document.getElementById('profileImg').src = e.target.result;
        };
        // Read the image file as a data URL
        reader.readAsDataURL(file);
    }
});
</script>
</body>
</html>
