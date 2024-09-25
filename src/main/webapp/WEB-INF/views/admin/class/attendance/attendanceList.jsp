<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
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
    height: 100%;
}

body {
    font-family: Arial, sans-serif;
    display: flex;
    flex-direction: column;
    min-height: 100vh;
}

main {
    flex: 1;
    margin-left: 250px;
    padding-top: 130px; /* 헤더 높이만큼 추가 */
    background-color: white;
    overflow-x: auto; /* 가로 스크롤을 가능하게 */
}

.box {
    height: 100%;
}

.content {
    padding: 20px;
    position: relative;
}

/* 반 별 홈 세미헤더 */
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
    margin-left: 10px;
}

.classroom-header .details {
    font-size: 12px;
    margin-left: 10px;
}

.bi-house-fill {
	cursor: pointer;
	font-size: 20px;
}

/* 테이블 스타일 */
table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 20px;
}

a {
    text-decoration: none !important; /* 링크의 밑줄 제거 */
    color: inherit !important; /* 부모 요소의 글자색 상속 */
}

table, th, td {
    border: 1px solid #ddd;
}

th, td {
    padding: 10px;
    text-align: center;
}

th {
    background-color: #f4f4f4;
    font-weight: bold;
    position: sticky; /* 헤더 고정 */
    top: 0;
    z-index: 2;
}

td {
    font-size: 1em;
    color: #333;
    white-space: nowrap; /* 줄바꿈 방지 */
}

td:first-child {
    position: sticky; /* 첫 번째 열 고정 */
    left: 0;
    background-color: white; /* 고정된 열의 배경색 */
    z-index: 1; /* 헤더보다 낮은 z-index */
}

/* 날짜 스타일 */
.date-text {
    font-size: 0.8em; /* 글씨 크기 줄이기 */
    font-weight: normal; /* 글씨체를 두껍지 않게 설정 */
    white-space: nowrap; /* 줄바꿈 방지 */
    overflow: hidden;
    text-overflow: ellipsis;
}

/* 푸터 스타일 */
footer {
    background-color: #f1f1f1;
    padding: 10px 20px;
    text-align: center;
    position: fixed; /* 스크롤에 영향을 받지 않도록 고정 */
    bottom: 0;
    width: 100%;
    z-index: 1000;
}

</style>
</head>
<body>

    <!-- 메뉴바 연결 -->
    <%@ include file="../../../common/header.jsp"%>

    <!-- 반별 홈 세미헤더 -->
    <div class="classroom-header">
        <i class="bi bi-house-fill" onclick="location.href='${pageContext.servletContext.contextPath}/admin/class/getClassList'"></i>
        <div class="title">${syclass.className}</div>
        <div class="details">담당자: ${syclass.managerName} | 강사명: ${syclass.teacherName}</div>
    </div>

    <!-- 사이드바 연결 -->    
    <%@ include file="../aside.jsp"%>

    <main>
        <!-- Main content -->
        <div class="content">
            <h2>출석 조회</h2>
            <table>
                <thead>
                    <tr>
                        <th> </th>
                        <c:forEach var="date" items="${attendanceDates}">
                            <th>
                                <span class="date-text">${date}</span> <!-- 날짜 스타일 적용 -->
                            </th>
                        </c:forEach>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="student" items="${studentList}" varStatus="status">
                        <tr>
                            <td style="white-space: nowrap;">
                            <a href="/admin/class/attendance/attendanceDetail?memberNo=${student.memberNo}">
						        ${student.memberName}
						    </a>
                            </td> <!-- 이름 줄바꿈 방지 및 열 고정 -->
                            <c:forEach var="date" items="${attendanceDates}">
                                <c:set var="key" value="${student.memberNo}-${date}"/>
                                <td>
                                    <c:choose>
                                        <c:when test="${attendanceMap[key] == '지각'}">△</c:when>
                                        <c:when test="${attendanceMap[key] == '출석'}">◯</c:when>
                                        <c:when test="${attendanceMap[key] == '결석'}">✕</c:when>
                                        <c:when test="${attendanceMap[key] == '조퇴'}">/</c:when>
                                        <c:otherwise>-</c:otherwise>
                                    </c:choose>
                                </td>
                            </c:forEach>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </main>

    <!-- 푸터 연결 -->
    <%@ include file="../../../common/footer.jsp"%>
 
<script>

</script>

</body>
</html>
