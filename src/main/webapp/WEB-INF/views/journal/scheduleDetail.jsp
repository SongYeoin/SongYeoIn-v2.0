<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>View Schedule</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href='https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css' rel='stylesheet' />
    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            padding-top: 70px; /* 고정된 헤더를 위한 여백 */
            padding-left: 250px; /* 고정된 사이드바를 위한 여백 */
            padding-right: 20px; /* 오른쪽 여백 */
        }

        header {
            background-color: black;
            color: white;
            padding: 20px;
            position: fixed;
            top: 0;
            left: 0;
            width: calc(100% - 250px); /* 사이드바를 제외한 전체 너비 */
            z-index: 1000;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .sidebar {
            width: 250px;
            background-color: #F2F2F2;
            color: #333333;
            height: calc(100vh - 70px); /* 헤더를 제외한 전체 높이 */
            position: fixed;
            top: 70px; /* 헤더 아래 위치 */
            left: 0;
            overflow-y: auto;
            border-right: 1px solid #ddd;
            padding-top: 20px;
        }

        footer {
            background-color: #BBB2FF;
            color: white;
            padding: 20px;
            text-align: center;
            position: fixed;
            bottom: 0;
            left: 250px; /* 사이드바와 맞추어 위치 */
            width: calc(100% - 250px); /* 사이드바를 제외한 전체 너비 */
            z-index: 1000;
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

    <!-- 헤더 영역 -->
    <header>
        <%@ include file="../common/header.jsp"%>
    </header>

    <!-- 사이드바 영역 -->
    <div class="sidebar">
        <%@ include file="../member/aside.jsp"%>
    </div>

    <!-- 메인 콘텐츠 영역 -->
    <div class="main-content">
        <div class="container">
            <h1>${scheduleDetail.scheduleTitle}</h1>
            <!-- 일정 상세 정보 -->
            <p>Date: ${scheduleDetail.scheduleDate}</p> <!-- 일정 날짜 -->
            <p>Description: ${scheduleDetail.scheduleDescription}</p> <!-- 일정 설명 -->
            <p>Instructor: ${scheduleDetail.scheduleInstructor}</p> <!-- 강사 이름 -->
            
            <!-- 버튼 컨테이너 (정렬을 위해) -->
            <div class="btn-container">
            
            
				<c:if test="${sessionScope.loginMember.memberRole eq 'ROLE_ADMIN' and sessionScope.loginMember.memberNo eq journal.memberNo}">
                    <button id="updateBtn">수정</button>
                    <button id="deleteBtn" onclick="deleteNotice(${notice.noticeNo})">삭제</button>
                </c:if>
                    
                <!-- 관리자 역할일 때만 수정 및 삭제 버튼 표시 -->
                <c:if test="${sessionScope.memberRole == 'role_admin'}">
                    <!-- 일정 수정 버튼 -->
                    <a href="${pageContext.request.contextPath}/journal/scheduleUpdate?scheduleNo=${scheduleDetail.scheduleNo}" class="btn btn-primary">Edit</a>
                    
                    <!-- 일정 삭제 버튼 -->
                    <form action="${pageContext.request.contextPath}/journal/scheduleDelete" method="post" style="display: inline;">
                        <input type="hidden" name="scheduleNo" value="${scheduleDetail.scheduleNo}" />
                        <button type="submit" onclick="return confirm('Are you sure you want to delete this schedule?');">Delete</button>
                    </form>
                </c:if>
                
                <!-- 목록으로 돌아가기 버튼 -->
                <a href="${pageContext.request.contextPath}/journal/scheduleList" class="btn btn-link">Back to List</a>
            </div>
        </div>
    </div>

    <!-- 푸터 영역 -->
    <footer>
        <%@ include file="../common/footer.jsp"%>
    </footer>

</body>
</html>
