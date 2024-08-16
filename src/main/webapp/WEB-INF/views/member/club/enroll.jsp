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

.btn {
	display: inline-block;
	font-size: 22px;
	padding: 6px 12px;
	background-color: #fff;
	border: 1px solid #ddd;
	font-weight: 600;
	width: 140px;
	height: 41px;
	line-height: 39px;
	text-align: center;
	margin-left: 30px;
	cursor: pointer;
}

.btn_wrap {
	padding-left: 80px;
	margin-top: 50px;
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
        	<h1>강의실 신청 등록</h1>

		<div class="input_wrap">
			<label>작성자</label><input name="memberName" readonly="readonly" value="${sessionScope.loginMember.memberName }">
		</div>
	<form action="/member/club/enroll" method="post" onsubmit="return validateForm()">
		<%-- <input type="hidden" name="classNo" value="${param.classNo }"> --%>
		<div class="input_wrap">
			<label>참여자</label> <input type="text" name="join" id="joinInput">
		</div>
		<div class="input_wrap">
			<label>활동일</label> <input type="date" name="studyDate" id="studyDateInput">
		</div>
		<div class="input_wrap">
			<label>내용</label>
			<textarea rows="3" name="content"></textarea>
		</div>
		<div class="btn_wrap">
		<input type="submit" value="등록" class="btn">
		<button type="button" class="btn" onclick="cancelForm()">취소</button>
		</div>
	</form>
        </div>
    </main>

	<!-- 푸터 연결 -->
	<%@ include file="../../common/footer.jsp"%>

	
	<script>
		function validateForm() {
		    var joinInput = document.getElementById('joinInput').value;
		    var studyDateInput = document.getElementById('studyDateInput').value;

		    if (!joinInput || !studyDateInput) {
		        alert('참여 또는 활동일을 입력해 주세요.');
		        return false; // 폼 제출을 막습니다.
		    }
		    return true; // 폼 제출을 허용합니다.
		}
		
		function cancelForm() {
			window.location.href = '/member/club/list'; // 목록 페이지로 이동
		}
	</script>
</body>
</html>