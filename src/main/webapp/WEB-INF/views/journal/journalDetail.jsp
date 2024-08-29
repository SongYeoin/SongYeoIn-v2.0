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

.box {
	background-color: #fff;
	border-radius: 8px;
	box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
	padding: 20px;
	max-width: 800px;
	margin: 0 auto; /* 페이지 중앙 정렬 */
}

h1 {
	margin-bottom: 20px;
	color: #333;
	font-size: 24px;
	border-bottom: 2px solid #007bff;
	padding-bottom: 10px;
}

.journal_detail {
	background-color: #fafafa;
	border-radius: 8px;
	padding: 20px;
	box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.journal_detail p {
	margin-bottom: 15px;
	font-size: 16px;
	color: #333;
}

.journal_detail strong {
	color: #007bff;
}

.journal_detail .attachment {
	margin-top: 10px;
}

.journal_detail .attachment a {
	color: #007bff;
	text-decoration: none;
}

.journal_detail .attachment a:hover {
	text-decoration: underline;
}

footer {
	background-color: #007bff;
	color: #fff;
	text-align: center;
	padding: 15px 0;
	position: relative;
	bottom: 0;
	width: 100%;
}

.buttons {
	margin-top: 20px;
	text-align: right;
}

.buttons a, .buttons button {
	background-color: #007bff;
	color: #fff;
	border: none;
	padding: 10px 15px;
	border-radius: 5px;
	text-decoration: none;
	cursor: pointer;
	margin-left: 10px;
}

.buttons a:hover, .buttons button:hover {
	background-color: #0056b3;
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
		<div class="box">
			<h1>교육일지 상세보기</h1>
			<div class="journal_detail">
				<p>
					<strong>수강생:</strong>
				</p>
				<p>
					<strong>제목:</strong>
					<c:out value="${journalDetail.journalTitle}" />
				</p>
				<p>
					<strong>작성일자:</strong>
					<fmt:formatDate pattern="yyyy/MM/dd"
						value="${journalDetail.journalWriteDate}" />
				</p>
				<c:if test="${not empty journalDetail.fileName}">
					<p class="attachment">
						<strong>첨부파일:</strong> <a
							href="${pageContext.request.contextPath}/journal/downloadFile?fileName=${journalDetail.fileName}"
							download> <c:out value="${journalDetail.fileName}" />
						</a>
					</p>
				</c:if>
			</div>
			<div class="buttons">
				<a href="${pageContext.request.contextPath}/journal/journalList">목록</a>
				<a
					href="${pageContext.request.contextPath}/journal/journalModify?journalNo=${journalDetail.journalNo}">수정</a>
				<form
					action="${pageContext.request.contextPath}/journal/journalDelete"
					method="post" style="display: inline;">
					<input type="hidden" name="journalNo"
						value="${journalDetail.journalNo}" />
					<button type="submit" onclick="return confirm('정말 삭제하시겠습니까?');">삭제</button>
				</form>
			</div>
		</div>
	</main>

	<!-- 푸터 연결 -->
	<%@ include file="../common/footer.jsp"%>

</body>
</html>
