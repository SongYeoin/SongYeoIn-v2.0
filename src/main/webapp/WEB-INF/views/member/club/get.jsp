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
    background-color: #f8f9fa;
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
    background-color: #0d6efd; /* 파란색 */
    color: #ffffff !important; /* 흰색 글자 */
}

.btn.modify:hover {
	border-color: #0b5ed7;
    background-color: #0b5ed7; /* 호버 시 약간 더 진한 색 */
}

.btn.delete {
	border-color: #dc3545;
    background-color: #dc3545; /* 빨간색 */
    color: #ffffff !important; /* 흰색 글자 */
}

.btn.delete:hover {
	border-color: #bb2d3b;
    background-color: #bb2d3b; /* 호버 시 약간 더 진한 색 */
}

.btn.list {
	border-color: #6c757d;
    background-color: #6c757d; /* 회색 */
    color: #ffffff !important; /* 흰색 글자 */
}

.btn.list:hover {
	border-color: #5c636a;
    background-color: #5c636a; /* 호버 시 약간 더 진한 색 */
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
			<h1 class="form-title">강의실 신청 상세</h1>
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
				<input name="studyDate" readonly="readonly" value='<fmt:formatDate pattern="yyyy/MM/dd" value="${pageInfo.studyDate }"/>'>
			</div>
			<div class="form-group">
				<label>작성일</label>
				<input name="regDate" readonly="readonly" value='<fmt:formatDate pattern="yyyy/MM/dd" value="${pageInfo.regDate }"/>'>
			</div>
			
			<div class="form-group">
				<label>첨부파일</label>
				<c:choose>
				<c:when test="${pageInfo.fileName != null && !pageInfo.fileName.isEmpty() }">
				<input name="file" readonly="readonly" class="large-input" value='<c:out value="${pageInfo.fileName }"/>'>
				</c:when>
				<c:otherwise>
				<input name="file" readonly="readonly" value="첨부파일 없음">
				</c:otherwise>
			</c:choose>
			</div>
			
			<div class="btn_group">
				<a class="btn list" id="list_btn">목록</a>
				<c:if test="${pageInfo.enroll.member.memberNo == sessionScope.loginMember.memberNo }">
				<c:if test="${pageInfo.checkStatus != 'N' }">
				<a class="btn modify" id="modify_btn">수정</a>
				<a class="btn delete" id="delete_btn">삭제</a>
				</c:if>
				</c:if>
			</div>
			<form id="infoForm" action="/member/club/modify" method="get">
				<input type="hidden" id="clubNo" name="clubNo" value='<c:out value="${pageInfo.clubNo }"/>'>
				<input type="hidden" id="keyword" name="keyword" value="${cri.keyword}">
				<input type="hidden" id="type" name="type" value="${cri.type}">
				<input type="hidden" id="rn" name="rn" value='<c:out value="${param.rn }"/>'>
				<input type="hidden" id="classNo" name="classNo" value="${param.classNo}">
			</form>
		</div>
	</main>

	<!-- 푸터 연결 -->
	<%@ include file="../../common/footer.jsp"%>

	<script>
		let form = $("#infoForm");

		$("#list_btn").on("click", function(e) {
			form.find("#clubNo").remove();
			form.find("#rn").remove();
			form.find("#keyword").remove();
			form.find("#type").remove();
			form.attr("action", "/member/club/list");
			form.submit();
		});

		$("#modify_btn").on("click", function(e) {
			form.find("#keyword").remove();
			form.find("#type").remove();
			form.attr("action", "/member/club/modify");
			form.submit();
		});
		
		$("#delete_btn").on("click", function(e){
			e.preventDefault(); // 폼의 기본 제출을 방지
	        if (confirm("정말로 삭제하시겠습니까?")) {
	            form.attr("action", "/member/club/delete");
	            form.attr("method", "post");
	            form.submit();
	        }
		});
		
	</script>

</body>
</html>