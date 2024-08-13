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
}

.logo .highlight {
	font-weight: bold;
}

.btns {
	display: flex;
	gap: 10px;
}

.fs-3 {
	cursor: pointer;
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
        <div class="logo">
            <span class="highlight">S</span>ongpa <span class="highlight">W</span>oman
        </div>
        </div>
        <div class="btns">
        <p>${sessionScope.loginMember.memberName} 님</p>
		<i class="bi bi-chat fs-3 chat-move" onclick="location.href='${pageContext.servletContext.contextPath}chatroom/main'"></i> <!-- 채팅방 아이콘 -->
		<c:choose>
			<c:when test="${sessionScope.loginMember.memberRole == 'ROLE_MEMBER'}">
				<i class="bi bi-person fs-3" onclick="location.href='${pageContext.servletContext.contextPath}/member/mypage'"></i> <!-- 마이페이지 아이콘 -->
			</c:when>
			<c:when test="${sessionScope.loginMember.memberRole == 'ROLE_ADMIN'}">
				<i class="bi bi-person fs-3" onclick="location.href='${pageContext.servletContext.contextPath}/admin/mypage'"></i>
			</c:when>
		</c:choose>
        <i class="bi bi-box-arrow-right fs-3" onclick="location.href='${pageContext.servletContext.contextPath}/member/logout'"></i> <!-- 로그아웃 아이콘 -->
        </div>
    </header>

</body>
</html>
