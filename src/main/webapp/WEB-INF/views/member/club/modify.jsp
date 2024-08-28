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
	margin-left: 300px;
	margin-top: 110px;
	overflow-y: auto;
	height: 100%;
}

.input_wrap {
	padding: 5px 20px;
}

label {
	display: block;
	margin: 10px 0;
	font-size: 20px;
}

input {
	padding: 5px;
	font-size: 17px;
}

.large-input{
	width: 500px;
}

textarea {
	width: 800px;
	height: 95px;
	font-size: 15px;
	padding: 10px;
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
		<div>
			<h1>수정 페이지</h1>
			<form id="modifyForm" action="/member/club/modify" method="post" enctype="multipart/form-data">
			
			<c:if test="${pageInfo.checkStatus == 'W' }">
			<div class="input_wrap">
				<label>번호</label> <input name="rn" readonly="readonly"
					value='<c:out value="${pageInfo.rn }"/>'>
			</div>
			<div class="input_wrap">
				<label>작성자</label> <input name="memberName" readonly="readonly"
					value='<c:out value="${pageInfo.enroll.member.memberName }"/>'>
			</div>
			<div class="input_wrap">
				<label>참여</label> <input name="join" class="large-input" id="joinInput"
					value='<c:out value="${pageInfo.join}"/>'>
			</div>
			<div class="input_wrap">
				<label>내용</label>
				<textarea rows="3" name="content" ><c:out
						value="${pageInfo.content}" /></textarea>
			</div>
			<div class="input_wrap">
				<label>승인상태</label> <input name="checkStatus" readonly="readonly" id="checkStatusInput"
					value="${pageInfo.checkStatus == 'W' ? '대기' :
                  (pageInfo.checkStatus == 'Y' ? '승인' :
                  (pageInfo.checkStatus == 'N' ? '미승인' : '알 수 없음'))}">
			</div>
                  
			<div class="input_wrap">
				<label>승인메시지</label> <input name="checkCmt" readonly="readonly"
					value='<c:out value="${pageInfo.checkCmt }"/>'>
			</div>
			<div class="input_wrap">
				<label>활동일</label> <input type="date" name="studyDate" id="studyDateInput"
					value='<fmt:formatDate pattern="yyyy-MM-dd" value="${pageInfo.studyDate }"/>'>
			</div>
			<div class="input_wrap">
				<label>작성일</label> <input name="regDate" readonly="readonly"
					value='<fmt:formatDate pattern="yyyy-MM-dd" value="${currentDate }"/>'>
			</div>
		
			<div class="input_wrap">
				<label>첨부파일</label>
				<input name="file" readonly="readonly" value="첨부파일 없음">
			</div>
			</c:if>
			
			
			<c:if test="${pageInfo.checkStatus == 'Y' }">
			<div class="input_wrap">
				<label>번호</label> <input name="rn" readonly="readonly"
					value='<c:out value="${pageInfo.rn }"/>'>
			</div>
			<div class="input_wrap">
				<label>작성자</label> <input name="memberName" readonly="readonly"
					value='<c:out value="${pageInfo.enroll.member.memberName }"/>'>
			</div>
			<div class="input_wrap">
				<label>참여</label> <input name="join" readonly="readonly" class="large-input"
					value='<c:out value="${pageInfo.join}"/>'>
			</div>
			<div class="input_wrap">
				<label>내용</label>
				<textarea rows="3" name="content" readonly="readonly"><c:out
						value="${pageInfo.content}" /></textarea>
			</div>
			<div class="input_wrap">
				<label>승인상태</label> <input name="checkStatus" readonly="readonly"
					value="${pageInfo.checkStatus == 'W' ? '대기' :
                  (pageInfo.checkStatus == 'Y' ? '승인' :
                  (pageInfo.checkStatus == 'N' ? '미승인' : '알 수 없음'))}">
			</div>
                  
			<div class="input_wrap">
				<label>승인메시지</label> <input name="checkCmt" readonly="readonly"
					value='<c:out value="${pageInfo.checkCmt }"/>'>
			</div>
			<div class="input_wrap">
				<label>활동일</label> <input name="studyDate" readonly="readonly"
					value='<fmt:formatDate pattern="yyyy-MM-dd" value="${pageInfo.studyDate }"/>'>
			</div>
			<div class="input_wrap">
				<label>작성일</label> <input name="regDate" readonly="readonly"
					value='<fmt:formatDate pattern="yyyy-MM-dd" value="${currentDate }"/>'>
			</div>
		
			<div class="input_wrap">
				<label>첨부파일</label>
				<input type="file" name="file" id="fileInput" value='<c:out value="${pageInfo.fileName }"/>'>
			</div>
			</c:if>
			</form>
			
			<div class="btn_wrap">
				<a class="btn" id="modify_btn">수정</a>
				<a class="btn" id="list_btn">취소</a>
			</div>
			<form id="infoForm" action="/member/club/modify" method="get">
				<input type="hidden" id="clubNo" name="clubNo"
					value='<c:out value="${pageInfo.clubNo }"/>'> <input
					type="hidden" name="keyword" value="${cri.keyword}"> <input
					type="hidden" name="type" value="${cri.type}">
			</form>


		</div>

	</main>

	<!-- 푸터 연결 -->
	<%@ include file="../../common/footer.jsp"%>


	<script>
	$(document).ready(function() {
		let form = $("#infoForm"); //리스트, 조회
		let mForm = $("#modifyForm"); //수정

		$("#list_btn").on("click", function(e) {
			e.preventDefault();
			form.find("#clubNo").remove();
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
		    /* var checkStatus = document.getElementById('checkStatusInput').value;
		    var joinInput = document.getElementById('joinInput').value;
		    var studyDateInput = document.getElementById('studyDateInput').value;
		    var fileInput = document.getElementById('fileInput').files.length;
		     */
		     
		     let checkStatus = $("#checkStatusInput").val();
	         let joinInput = $("#joinInput").val();
	         let studyDateInput = $("#studyDateInput").val();
	         let fileInputElement = $("#fileInput").get(0);
	         let fileInput = fileInputElement ? fileInputElement.files.length : 0;
		    //let fileInput = $("#fileInput").files.length;
	         
		    console.log(checkStatus);
		    
		    
		    // checkStatus가 '승인대기'인 경우에만 검증 수행
		    if (checkStatus === '대기') {
		        if (!joinInput || !studyDateInput) {
		            alert('참여 또는 활동일을 입력해 주세요.');
		            return false; // 폼 제출을 막습니다.
		        }
		    }else if(checkStatus === '승인'){
		    	if (fileInput === 0) {
			        alert('파일을 선택해 주세요.');
			        return false; // 폼 제출을 막습니다.
			    }
		    }
		    return true; // 폼 제출을 허용합니다.
		}
	});
		
	</script>

</body>
</html>