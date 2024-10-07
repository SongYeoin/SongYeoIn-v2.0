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
	height: auto; /* 고정 높이 제거 */
}

body {
	font-family: Arial, sans-serif;
	display: flex;
	flex-direction: column;
	min-height: 100vh; /* 최소 높이를 뷰포트 높이로 설정 */
    overflow-y: auto; /* 전체 페이지에 대한 스크롤 추가 */
}

main {
	flex: 1;
	margin-left: 300px;
	margin-top: 110px;
}

.form-container {
    max-width: 600px;
    margin: 2rem auto;
    padding: 2rem;
    background-color: #fff;
    border-radius: 8px;
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
}

.form-title {
    text-align: center;
    color: #333;
    margin-bottom: 2rem;
}

.form-group {
    margin-bottom: 1.5rem;
}

.form-group label {
    display: block;
    margin-bottom: 0.5rem;
    color: #555;
    font-weight: bold;
}

.writer,
.form-group input[type="text"],
.form-group input[type="date"],
.form-group textarea {
    width: 100%;
    padding: 0.5rem;
    border: 1px solid #ddd;
    border-radius: 4px;
    font-size: 1rem;
}

.warn-message {
    display: block;
    color: red;
    font-size: 0.875rem;
    margin-top: 0.25rem;
}

.btn_group {
    display: flex;
    justify-content: flex-end;
    gap: 1rem;
    margin-top: 2rem;
}

.btn {
    padding: 0.5rem 1rem;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    font-size: 1rem;
    transition: background-color 0.3s;
}

.btn:focus{
	box-shadow: none !important;
}

.btn.enroll {
	border-color: #0d6efd;
    background-color: #0d6efd;
    color: white !important;
}

.btn.enroll:hover {
	border-color: #0b5ed7;
    background-color: #0b5ed7;
}

.btn.cancel {
	border-color: #6c757d;
    background-color: #6c757d;
    color: white !important;
}

.btn.cancel:hover {
	border-color: #5c636a;
    background-color: #5c636a;
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
        <div class="form-container">
        	<h1 class="form-title">동아리실 신청 등록</h1>
		<div class="form-group">
			<label>작성자</label>
			<input class="writer" name="memberName" readonly="readonly" value="${sessionScope.loginMember.memberName }">
		</div>
	<form action="/member/club/enroll" method="post" onsubmit="return validateForm()">
		<input type="hidden" name="classNo" value="${param.classNo }">
		<div class="form-group">
			<label>참여자</label>
			<input type="text" name="join" id="joinInput" placeholder="본인 포함 참여자를 입력하세요">
			<span id="joinWarn" class="warn-message"></span>
		</div>
		<div class="form-group">
			<label>활동일</label>
			<input type="date" name="studyDate" id="studyDateInput">
			<span id="dateWarn" class="warn-message"></span>
		</div>
		<div class="form-group">
			<label>내용</label>
			<textarea rows="3" name="content"></textarea>
		</div>
		<div class="btn_group">
		<input type="submit" value="등록" class="btn enroll">
		<button type="button" class="btn cancel" onclick="cancelForm()">취소</button>
		</div>
	</form>
        </div>
    </main>

	<!-- 푸터 연결 -->
	<%@ include file="../../common/footer.jsp"%>

	<script>
		function validateForm() {
			// 에러 메시지 초기화
            document.getElementById('joinWarn').textContent = '';
            document.getElementById('dateWarn').textContent = '';
            
            var joinInput = document.getElementById('joinInput').value.trim(); // 공백 제거
		    var studyDateInput = document.getElementById('studyDateInput').value;
			var isValid = true;
			
			if(!joinInput){
				document.getElementById('joinWarn').textContent = '본인 포함 참여자를 입력해 주세요';
                isValid = false;
			}
			
			if(!studyDateInput){
				document.getElementById('dateWarn').textContent = '날짜를 선택해 주세요';
                isValid = false;
			}
			
			return isValid;
		}
		
		function cancelForm() {			
			var classNo = document.querySelector("input[name='classNo']").value;
            window.location.href = '/member/club/list?classNo=' + encodeURIComponent(classNo); // 목록 페이지로 이동하며 classNo를 유지합니다.      
		}
	</script>
</body>
</html>
