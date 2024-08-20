<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>View Schedule</title>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
<link
	href='https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css'
	rel='stylesheet' />
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

.main-content {
	margin-left: 250px; /* 사이드바를 위한 여백 */
	margin-bottom: 50px; /* 푸터를 위한 여백 */
	padding: 20px;
}

.container {
	max-width: 800px;
	margin: 0 auto;
	background: #fff;
	padding: 20px;
	border-radius: 8px;
	box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
	margin-top: 20px; /* 헤더와의 간격 */
}

h1 {
	margin-bottom: 20px;
	font-size: 28px;
	font-weight: 600;
}

p {
	font-size: 16px;
	margin-bottom: 15px;
}

a {
	color: #007bff;
	text-decoration: none;
	font-size: 16px;
}

a:hover {
	text-decoration: underline;
}

button {
	padding: 10px 15px;
	border: none;
	border-radius: 4px;
	color: white;
	cursor: pointer;
	font-size: 16px;
	margin-right: 10px;
}

button[type="submit"] {
	background-color: #dc3545;
}

button[type="submit"]:hover {
	background-color: #c82333;
}

.btn-container {
	margin-top: 20px;
}

.btn-container a {
	margin-right: 10px;
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

	<!-- 메인 콘텐츠 영역 -->
	<main>
		<div class="main-content">
			<div class="container">
				<h1>단원명: ${scheduleDetail.scheduleTitle}</h1>
				<!-- 일정 상세 정보 -->
				<p>일자: ${scheduleDetail.scheduleDate}</p>
				<!-- 일정 날짜 -->
				<p>학습주제: ${scheduleDetail.scheduleDescription}</p>
				<!-- 일정 설명 -->
				<p>강사: ${scheduleDetail.scheduleInstructor}</p>
				<!-- 강사 이름 -->

				<!-- 버튼 컨테이너 (정렬을 위해) -->
				<div class="btn-container">

					<!-- 관리자 역할일 때만 수정 및 삭제 버튼 표시 -->
					<c:if test="${sessionScope.loginMember.memberRole eq 'ROLE_ADMIN'}">
						<!-- 일정 수정 버튼 -->
						<a
							href="${pageContext.request.contextPath}/journal/admin/scheduleUpdate?scheduleNo=${scheduleDetail.scheduleNo}"
							class="btn btn-primary">수정</a>

						<!-- 일정 삭제 버튼 -->
						<form
							action="${pageContext.request.contextPath}/journal/admin/scheduleDelete"
							method="post" style="display: inline;">
							<input type="hidden" name="scheduleNo"
								value="${scheduleDetail.scheduleNo}" />
							<button type="submit"
								onclick="return confirm('해당 교육일정을 삭제하시겠습니까?');">삭제</button>
						</form>
					</c:if>

					<!-- 목록으로 돌아가기 버튼 -->
					<a href="${pageContext.request.contextPath}/journal/scheduleList" class="btn btn-secondary">목록으로</a>

				</div>
			</div>
		</div>
	</main>

	<!-- 푸터 영역 -->
	<%@ include file="../common/footer.jsp"%>

</body>
</html>