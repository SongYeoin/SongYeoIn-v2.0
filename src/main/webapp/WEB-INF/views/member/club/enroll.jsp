<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>송파여성인력개발센터</title>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>

<style>

/* CSS Reset */
* {
	margin: 0;
	padding: 0;
	box-sizing: border-box;
}

html, body {
	height: 1080px;
}

body {
	font-family: Arial, sans-serif;
	display: flex;
	flex-direction: column;
	/* min-height: 100vh; */
}

main {
	flex: 1;
	margin-left: 250px;
	padding-top: 90px;
	overflow-y: auto;
	top: 120px;
	left: 250px;
}

.box{
	height: 100%;

}
</style>
</head>
<body>

	<!-- 메뉴바 연결 -->
	<%@ include file="../../common/header.jsp"%>

	<!-- 사이드바 연결 -->	
	<%@ include file="../aside.jsp"%>

   <main>
        <!-- Main content -->   
        <div class="box">
        	<h1>게시판 등록</h1>

	<form action="/club/enroll" method="post">
		<div class="input_wrap">
			<!-- <label>작성자</label> <input name="title"> 
		<div class="input_wrap">
        <label>작성자</label>
        <input name="applicant" value="자동으로 로그인한 사용자의 이름을 서버에서 입력" readonly>
    </div>-->
		</div>
		<div class="input_wrap">
			<label>참여자</label> <input type="text" name="join">
		</div>
		<div class="input_wrap">
			<label>활동일</label> <input type="date" name="studyDate">
		</div>
		<div class="input_wrap">
			<label>내용</label>
			<textarea rows="3" name="content"></textarea>
		</div>

		<input type="submit" value="등록">

	</form>
        </div>
    </main>

	<!-- 푸터 연결 -->
	<%@ include file="../../common/footer.jsp"%>

</body>
</html>