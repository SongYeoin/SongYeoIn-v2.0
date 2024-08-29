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

/* 메인 박스 부분 CSS 수정 */
.container {
    background-color: #ffffff;
    border-radius: 8px;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    padding: 30px;
    max-width: 800px;
    margin: 0 auto;
}

h1 {
    margin-bottom: 25px;
    color: #333;
    font-size: 28px;
    border-bottom: 2px solid #3498db;
    padding-bottom: 10px;
}

.schedule-detail {
    background-color: #f9f9f9;
    border-radius: 6px;
    padding: 20px;
    margin-bottom: 25px;
}

.schedule-detail p {
    margin-bottom: 15px;
    font-size: 16px;
    color: #444;
    line-height: 1.6;
}

.schedule-detail strong {
    color: #2c3e50;
    font-weight: 600;
    margin-right: 10px;
}

.buttons {
    margin-top: 25px;
    text-align: right;
}

.buttons a, .buttons button {
    background-color: #3498db;
    color: #fff;
    border: none;
    padding: 10px 20px;
    border-radius: 5px;
    text-decoration: none;
    cursor: pointer;
    margin-left: 15px;
    font-size: 14px;
    transition: background-color 0.3s ease;
}

.buttons a:hover, .buttons button:hover {
    background-color: #2980b9;
}

.buttons button[type="submit"] {
    background-color: #e74c3c;
}

.buttons button[type="submit"]:hover {
    background-color: #c0392b;
}

.btn-secondary {
    background-color: #6c757d;
}

.btn-secondary:hover {
    background-color: #5a6268;
}

.btn-primary {
    background-color: #3498db;
}

.btn-primary:hover {
    background-color: #2980b9;
}

.btn-danger {
    background-color: #e74c3c;
}

.btn-danger:hover {
    background-color: #c0392b;
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
	    <div class="container">
	        <h1>교육일정 상세보기</h1>
	        <div class="schedule-detail">
	            <p><strong>단원명:</strong> <span><c:out value="${scheduleDetail.scheduleTitle}" /></span></p>
	            <p><strong>일자:</strong> <span><c:out value="${scheduleDetail.scheduleDate}" /></span></p>
	            <p><strong>학습주제:</strong> <span><c:out value="${scheduleDetail.scheduleDescription}" /></span></p>
	            <p><strong>강사:</strong> <span><c:out value="${scheduleDetail.scheduleInstructor}" /></span></p>
	        </div>
	        <div class="buttons">
	            <button class="btn btn-secondary" onclick="location.href='${pageContext.request.contextPath}/journal/scheduleList'">목록</button>
	            <c:if test="${sessionScope.loginMember.memberRole eq 'ROLE_ADMIN'}">
	                <a href="${pageContext.request.contextPath}/journal/admin/scheduleUpdate?scheduleNo=${scheduleDetail.scheduleNo}" class="btn btn-primary">수정</a>
	                <form action="${pageContext.request.contextPath}/journal/admin/scheduleDelete" method="post" style="display: inline;">
	                    <input type="hidden" name="scheduleNo" value="${scheduleDetail.scheduleNo}" />
	                    <button type="submit" class="btn btn-danger" onclick="return confirm('해당 교육일정을 삭제하시겠습니까?');">삭제</button>
	                </form>
	            </c:if>
	        </div>
	    </div>
	</main>

	<!-- 푸터 영역 -->
	<%@ include file="../common/footer.jsp"%>

</body>
</html>