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
}

main {
	flex: 1;
	margin-left: 300px;
	margin-top: 110px;
	overflow-y: auto;
	height: 100%;
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

.form-group input,
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

.btn.modify {
    border-color: #0d6efd;
    background-color: #0d6efd;
    color: white !important;
}

.btn.modify:hover {
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
			<h1 class="form-title">강의실 신청 수정</h1>
			<form id="modifyForm" action="/member/club/modify" method="post" enctype="multipart/form-data">
			<input type="hidden" name="classNo" value="${param.classNo }"> 
			<input type="hidden" name="clubNo" value='<c:out value="${pageInfo.clubNo }"/>'>
			
			
			<c:if test="${pageInfo.checkStatus == 'W' }">
			<div class="form-group">
				<label>번호</label>
				<input name="rn" readonly="readonly" value='<c:out value="${param.rn }"/>'>
			</div>
			<div class="form-group">
				<label>작성자</label>
				<input name="memberName" readonly="readonly" value='<c:out value="${pageInfo.enroll.member.memberName }"/>'>
			</div>
			<div class="form-group">
				<label>참여자</label>
				<input name="join" class="large-input" id="joinInput" value='<c:out value="${pageInfo.join}"/>'>
				<span id="joinWarn" class="warn-message"></span>
			</div>
			<div class="form-group">
				<label>내용</label>
				<textarea rows="3" name="content" ><c:out value="${pageInfo.content}" /></textarea>
			</div>
			<div class="form-group">
				<label>승인상태</label>
				<input name="checkStatus" readonly="readonly" id="checkStatusInput"
					value="${pageInfo.checkStatus == 'W' ? '대기' :
                  (pageInfo.checkStatus == 'Y' ? '승인' :
                  (pageInfo.checkStatus == 'N' ? '미승인' : '알 수 없음'))}">
			</div>
                  
			<div class="form-group">
				<label>승인메시지</label>
				<input name="checkCmt" readonly="readonly" value='<c:out value="${pageInfo.checkCmt }"/>'>
			</div>
			<div class="form-group">
				<label>활동일</label>
				<input type="date" name="studyDate" id="studyDateInput" value='<fmt:formatDate pattern="yyyy-MM-dd" value="${pageInfo.studyDate }"/>'>
				<span id="dateWarn" class="warn-message"></span>
			</div>
			<div class="form-group">
				<label>작성일</label>
				<input name="regDate" readonly="readonly" value='<fmt:formatDate pattern="yyyy-MM-dd" value="${currentDate }"/>'>
			</div>
		
			<div class="form-group">
				<label>첨부파일</label>
				<input name="file" readonly="readonly" value="첨부파일 없음">
			</div>
			</c:if>
			
			
			<c:if test="${pageInfo.checkStatus == 'Y' }">
			<div class="form-group">
				<label>번호</label>
				<input name="rn" readonly="readonly" value='<c:out value="${param.rn }"/>'>
			</div>
			<div class="form-group">
				<label>작성자</label>
				<input name="memberName" readonly="readonly" value='<c:out value="${pageInfo.enroll.member.memberName }"/>'>
			</div>
			<div class="form-group">
				<label>참여자</label>
				<input name="join" readonly="readonly" class="large-input" value='<c:out value="${pageInfo.join}"/>'>
			</div>
			<div class="form-group">
				<label>내용</label>
				<textarea rows="3" name="content" readonly="readonly"><c:out value="${pageInfo.content}" /></textarea>
			</div>
			<div class="form-group">
				<label>승인상태</label>
				<input name="checkStatus" readonly="readonly"
					value="${pageInfo.checkStatus == 'W' ? '대기' :
                  (pageInfo.checkStatus == 'Y' ? '승인' :
                  (pageInfo.checkStatus == 'N' ? '미승인' : '알 수 없음'))}">
			</div>
                  
			<div class="form-group">
				<label>승인메시지</label>
				<input name="checkCmt" readonly="readonly" value='<c:out value="${pageInfo.checkCmt }"/>'>
			</div>
			<div class="form-group">
				<label>활동일</label>
				<input name="studyDate" readonly="readonly" value='<fmt:formatDate pattern="yyyy-MM-dd" value="${pageInfo.studyDate }"/>'>
			</div>
			<div class="form-group">
				<label>작성일</label>
				<input name="regDate" readonly="readonly" value='<fmt:formatDate pattern="yyyy-MM-dd" value="${currentDate }"/>'>
			</div>
		
			<div class="form-group">
				<label>첨부파일</label>
				<input type="file" name="file" id="fileInput" value='<c:out value="${pageInfo.fileName }"/>'>
				<span id="fileWarn" class="warn-message">
					<!-- 서버에서 전달된 오류 메시지를 표시합니다. -->
			        <c:if test="${not empty fileError}">
			            ${fileError}
			        </c:if>
				</span>
			</div>
			</c:if>
			</form>
			
			<div class="btn_group">
				<a class="btn modify" id="modify_btn">수정</a>
				<a class="btn cancel" id="list_btn">취소</a>
			</div>
			
			<form id="infoForm" action="/member/club/list" method="get">
				<input type="hidden" id="clubNo" name="clubNo" value='<c:out value="${pageInfo.clubNo }"/>'>
				<input type="hidden" id="classNo" name="classNo" value='<c:out value="${param.classNo }"/>'>
				<input type="hidden" id="keyword" name="keyword" value="${cri.keyword}">
				<input type="hidden" id="type" name="type" value="${cri.type}">
			</form>
		</div>

	</main>

	<!-- 푸터 연결 -->
	<%@ include file="../../common/footer.jsp"%>

	<script>
	$(document).ready(function() {
		let form = $("#infoForm"); //리스트
		let mForm = $("#modifyForm"); //수정

		$("#list_btn").on("click", function(e) {
			e.preventDefault();
			form.find("#clubNo").remove();
			form.find("#keyword").remove();
			form.find("#type").remove();
			form.attr("action", "/member/club/list");
			form.submit();	
		});
	
		$("#modify_btn").on("click", function(e) {
			e.preventDefault();
			
			if (validateForm()) {
		        mForm.submit(); // 검증 통과 시 폼 제출
		    }
		});
		
		function validateForm() {
		    let checkStatus = $("#checkStatusInput").val();
            let joinInput = $("#joinInput").val();
	        let studyDateInput = $("#studyDateInput").val();
	     
	     	// 에러 메시지 초기화
            $("#joinWarn").text('');
            $("#dateWarn").text('');
            
         	// null 또는 undefined가 아닌지 확인한 후 trim() 호출
            if (typeof joinInput === 'string') {
                joinInput = joinInput.trim(); // 공백 제거
            } else {
                joinInput = ''; // joinInput이 정의되지 않은 경우 빈 문자열로 설정
            }
         
		    // checkStatus가 '대기'인 경우에만 검증 수행
		    if (checkStatus === '대기') {
		        if (!joinInput) {
		        	 $("#joinWarn").text('본인 포함 참여자를 입력해 주세요');
	                 return false; // 폼 제출을 막습니다.
	            }
	            if (!studyDateInput) {
	                 $("#dateWarn").text('날짜를 선택해 주세요');
	                 return false; // 폼 제출을 막습니다.
	            }
	            
		    }
		    return true; // 폼 제출을 허용합니다.
		}
		
		$("#fileWarn").text('');
		
		// 서버에서 전달된 오류 메시지를 표시합니다.
		let fileError = "${fileError}";
		if (fileError) {
            $("#fileWarn").text(fileError);
        }
		
	});
		
	</script>

</body>
</html>