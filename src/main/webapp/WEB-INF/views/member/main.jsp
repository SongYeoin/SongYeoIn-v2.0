<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>송파여성인력개발센터</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>

<style>
/* CSS Reset */
* {
	margin: 0;
	padding: 0;
	box-sizing: border-box;
}

body {
	font-family: Arial, sans-serif;
	display: flex;
	flex-direction: column;
	min-height: 100vh;
	align-items: stretch;
}

.total {
	display: flex;
	align-items: flex-start;
	flex-direction: column;
}

.part1 {
    display:grid;
    grid-template-columns: 1fr 1fr;
    width: 100%;
    height: 573px;
}

.part2 {
    display:grid;
    grid-template-columns: 1fr 1fr 1fr;
    width: 100%;
    height: 403px;
}

.section {
	margin: 0;
	padding: 0;
	color: white;
	text-align: center;
	display: flex;
	justify-content: center;
	align-items: center;
	position: relative;
	background-color: gray; /* Default background color */
	overflow: hidden; /* 내용이 섹션을 넘치지 않도록 설정 */
	width: 100%;
	cursor: pointer; /* 클릭 가능한 커서 표시 */
}

/* 섹션별 배경색 */
.section1 {
	background-color: #E3E3D1;
	padding-top: 70px;
}

.section2 {
	background-color: #FC5000;
	padding-top: 70px;
}

.section3 {
	background-color: #68EF97;
}

.section4 {
	background-color: #FCEF70;
}

.section5 {
	background-color: #98E5FC;
}

/* 메뉴 제목 스타일 */
.menu-title {
	font-size: 1.5em;
	font-weight: bold;
	font-size: 2em;
	color: black;
	padding: 0 auto;
}

/* 소메뉴 스타일 */
.submenu {
	display: none;
	position: absolute;
	top: 0; /* 섹션의 상단에 위치 */
	left: 0; /* 섹션의 왼쪽에 위치 */
	width: 100%; /* 섹션의 전체 너비 */
	height: 100%; /* 섹션의 전체 높이 */
	background-color: rgba(0, 0, 0, 0.8); /* 반투명 배경 */
	color: #fff;
	padding: 20px; /* 여백 설정 */
	box-sizing: border-box; /* 박스 모델 설정 */
	z-index: 10; /* 다른 요소들보다 위에 표시되도록 설정 */
	flex-direction: column; /* 세로 정렬 */
	justify-content: flex-start; /* 왼쪽 정렬 */
	align-items: flex-start; /* 왼쪽 정렬 */
	text-align: right; /* 소메뉴 내용의 텍스트 정렬 */
}

.pd-top{
	padding-top: 100px;
}

/* 소메뉴 글자 스타일 */
.submenu p {
	margin: 20px 0; /* 위아래 여백 설정 */
	font-size: 1.25em; /* 폰트 크기 증가 */
	font-weight: bold;
	color: white;
	cursor: pointer; /* 클릭 가능한 커서 표시 */
}

/* 마우스 오버 시 소메뉴 표시 */
.section:hover .submenu {
	display: block;
}
    
</style>
</head>
<body>
	<!-- 메뉴바 연결 -->
	<%@ include file="../common/header.jsp"%>	

	<div class="total">
      <div class="part1">
		<div class="section section1">
			<div class="menu-title">Attendance <br>출석</div>
			<div class="submenu pd-top" onclick="location.href='${pageContext.servletContext.contextPath}/member/attendance/enroll'">
				<p>출석부 조회</p>
				<p>출석하기</p>
			</div>
		</div>
		<div class="section section2">
			<div class="menu-title">Daily Log Submission <br>교육일지</div>
			<div class="submenu pd-top" onclick="location.href='${pageContext.servletContext.contextPath}/journal/journalList'">
				<p>교육일지 제출</p>
				<p>교육일지 조회</p>
				<p>교육일정 조회</p>
			</div>
		</div>
      </div>
      <div class="part2">
		<div class="section section3">
			<div class="menu-title">Room Booking <br>동아리</div>
			<div class="submenu" onclick="location.href='${pageContext.servletContext.contextPath}/member/club/list'">
				<p>동아리실 신청</p>
				<p>동아리일지 제출</p>
			</div>
		</div>
		<div class="section section4">
			<div class="menu-title">Anonymous Board <br>익명게시판</div>
			<div class="submenu" onclick="location.href='${pageContext.servletContext.contextPath}/member/board/list'">
				<p>익명게시판</p>
			</div>
		</div>
		<div class="section section5">
			<div class="menu-title">Notices <br>공지사항</div>
			<div class="submenu" onclick="location.href='${pageContext.servletContext.contextPath}/member/notice/list'">
			<p>공지사항</p>
              </div>
        </div>
      </div>
     </div>

	<!-- 푸터 연결 -->
	<%@ include file="../common/footer.jsp"%>

</body>
</html>
