<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>송파여성인력센터</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<style>
/* 초기화 */
* {
	margin: 0;
	padding: 0;
	box-sizing: border-box; /* 박스 모델 설정 */
}

body {
	font-family: Arial, sans-serif;
	margin: 0;
	padding: 0;
}

/* 메인 스타일 */
main {
	display: flex;
	justify-content: center;
	align-items: center;
	height: 100vh; 
	background-color: #f0f0f0;
}

.button-container {
	display: flex;
	justify-content: center;
	gap: 100px; /* 버튼 사이의 간격 조정 */
}

.mode-button {
	display: flex; /* Flexbox를 사용하여 내부 내용 정렬 */
	flex-direction: column; /* 아이콘과 텍스트 세로 정렬 */
	justify-content: center; /* 수직 중앙 정렬 */
	align-items: center; /* 수평 중앙 정렬 */
	padding: 20px 40px;
	font-size: 1.5em;
	font-weight: bold;
	color: #fff;
	background-color: #007BFF;
	border: none;
	border-radius: 5px;
	cursor: pointer;
	transition: background-color 0.3s;
	text-decoration: none; /* 링크 기본 스타일 제거 */
	text-align: center; /* 텍스트 중앙 정렬 */
	width: 400px;
	height: 450px;
}

.mode-button:hover {
	background-color: #0056b3;
}

.mode-button.admin {
	background-color: #000000;
}

.mode-button.admin:hover {
	background-color: #b3b3b3;
}

.mode-button.student {
	background-color: #3b619b;
}

.mode-button.student:hover {
	background-color: #b3b3b3;
}

/* 아이콘 스타일 */
.mode-button i {
	font-size: 4em; /* 아이콘 크기 조정 */
	margin-bottom: 20px; /* 아이콘과 텍스트 사이의 간격 조정 */
}
</style>


</head>
<body>

	<!-- 메뉴바 연결 -->
	<%-- <%@ include file="common/header.jsp"%> --%>

	<main>
    <div class="button-container">
        <a href="${ pageContext.servletContext.contextPath }/member/login" class="mode-button student">
            <i class="fas fa-user-graduate"></i> <!-- Font Awesome 아이콘 추가 -->
            <br>수강생 모드
        </a>
        <a href="${ pageContext.servletContext.contextPath }/admin/login" class="mode-button admin">
            <i class="fas fa-user-cog"></i> <!-- Font Awesome 아이콘 추가 -->
            <br>관리자 모드
        </a>
    </div>
	</main>

	<!-- 푸터 연결 -->
	<%-- <%@ include file="common/footer.jsp"%> --%>

</body>
<script>
$(document).ready(function() {
	var delete_result = '${delete_result}';
	var logout_result = '${logout_result}';

	
	if(delete_result === 'success') {
		alert("회원 탈퇴에 성공하였습니다.");
	}
	if(logout_result === 'success') {
		alert("로그아웃되었습니다.");
	}
});
</script>
</html>