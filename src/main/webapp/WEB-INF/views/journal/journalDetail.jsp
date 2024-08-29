<!-- 교육일지 상세보기 페이지 -->
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>교육일지 상세보기</title>
<style>
/* 기본 스타일 및 CSS Reset */
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
	margin-top: 160px;
	overflow-y: auto;
	height: 100%;
}

.classroom-header {
	background-color: #f1f1f1;
	padding: 10px 20px;
	border-bottom: 2px solid #ccc;
	text-align: left;
	padding-top: 91px;
	position: fixed;
	width: 100%;
	z-index: 999;
	display: flex;
	align-items: center;
}

.classroom-header .title {
	font-size: 20px;
	font-weight: bold;
	/* margin-bottom: 10px; */
	margin-left: 10px;
}

.classroom-header .details {
	font-size: 12px;
	margin-left: 10px;
}


/* journalEnroll과 동일한 스타일 적용 */
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

.form-group p {
    padding: 0.5rem;
    border: 1px solid #ddd;
    border-radius: 4px;
    font-size: 1rem;
    background-color: #f8f9fa;
}

.button-group {
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
    transition: background-color 0.3s, color 0.3s;
    text-decoration: none;
}

.btn-primary {
    background-color: #b8d8ff; /* 매우 옅은 파란색 */
    color: #ffffff; /* 흰색 글자 */
}

.btn-primary:hover {
    background-color: #8fc1ff; /* 호버 시 약간 더 진한 색 */
}

.btn-danger {
    background-color: #ffd6d6; /* 매우 옅은 빨간색 */
    color: #ff4d4d; /* 진한 빨간색 글자 */
}

.btn-danger:hover {
    background-color: #ffb3b3; /* 호버 시 약간 더 진한 색 */
    color: #ff0000; /* 호버 시 더 진한 빨간색 글자 */
}

.btn-secondary {
    background-color: #e0e0e0; /* 매우 옅은 회색 */
    color: #333333; /* 어두운 회색 글자 */
}

.btn-secondary:hover {
    background-color: #cccccc; /* 호버 시 약간 더 진한 색 */
    color: #000000; /* 호버 시 검은색 글자 */
}
</style>
</head>
<body>

	<!-- 메뉴바 연결 -->
	<%@ include file="../common/header.jsp"%>

	<!-- 사용자 역할일 때 사이드바 -->
	<c:if test="${sessionScope.loginMember.memberRole eq 'ROLE_MEMBER'}">
		<%@ include file="../member/aside.jsp"%>
	</c:if>
	<!-- 관리자 역할일 때 사이드바 -->
	<c:if test="${sessionScope.loginMember.memberRole eq 'ROLE_ADMIN'}">

		<div class="classroom-header">
			<i class="bi bi-house-fill"
				onclick="location.href='${pageContext.servletContext.contextPath}/admin/class/getClassList'"></i>
			<div class="title">${syclass.className}</div>
			<div class="details">담당자: ${syclass.managerName} | 강사명:
				${syclass.teacherName}</div>
		</div>

		<!-- 사이드바 연결 -->
		<%@ include file="../admin/class/aside.jsp"%>
	</c:if>


	<main>
	    <div class="form-container">
	        <h1 class="form-title">교육일지 상세보기</h1>
	        <div class="form-group">
	            <label>제목</label>
	            <p><c:out value="${journalDetail.journalTitle}" /></p>
	        </div>
	        <div class="form-group">
	            <label>작성일자</label>
	            <p><fmt:formatDate pattern="yyyy/MM/dd" value="${journalDetail.journalWriteDate}" /></p>
	        </div>
	        <c:if test="${not empty journalDetail.fileName}">
	            <div class="form-group">
	                <label>첨부파일</label>
	                <p>
	                    <a href="${pageContext.request.contextPath}/journal/downloadFile?fileName=${journalDetail.fileName}" download>
	                        <c:out value="${journalDetail.fileName}" />
	                    </a>
	                </p>
	            </div>
	        </c:if>
	        <div class="button-group">
	            <button type="button" class="btn btn-secondary" onclick="goToList()">목록</button>
	            <c:if test="${sessionScope.loginMember.memberRole eq 'ROLE_MEMBER'}">
	                <a href="${pageContext.request.contextPath}/journal/journalModify?journalNo=${journalDetail.journalNo}" class="btn btn-primary">수정</a>
	                <form action="${pageContext.request.contextPath}/journal/journalDelete" method="post" style="display: inline;">
	                    <input type="hidden" name="journalNo" value="${journalDetail.journalNo}" />
	                    <button type="submit" class="btn btn-danger" onclick="return confirm('정말 삭제하시겠습니까?');">삭제</button>
	                </form>
	            </c:if>
	        </div>
	    </div>
	</main>

	<!-- 푸터 연결 -->
	<%@ include file="../common/footer.jsp"%>

	<script>
		function goToList() {
			var urlParams = new URLSearchParams(window.location.search);
			var memberNo = urlParams.get('memberNo');
			var listUrl = "${pageContext.request.contextPath}/journal/journalList";

			if (memberNo) {
				listUrl += "?memberNo=" + memberNo;
			}

			window.location.href = listUrl;
		}
	</script>

</body>
</html>
