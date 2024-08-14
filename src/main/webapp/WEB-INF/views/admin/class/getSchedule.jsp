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
}

.box {
    height: 100%;
}

.content {
    padding: 20px;
}

table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 20px;
}

table, th, td {
    border: 1px solid #ddd;
}

th, td {
    padding: 10px;
    text-align: left;
}

th {
    background-color: #f4f4f4;
}
</style>
</head>
<body>

    <!-- 메뉴바 연결 -->
    <%@ include file="../../common/header.jsp"%>

    <!-- 사이드바 연결 -->    
    <%@ include file="aside.jsp"%>

    <main>
        <!-- Main content -->
        <div class="content">
            <h2>등록된 시간표 조회</h2>
            <table>
                <thead>
                    <tr>
                        <th>요일</th>
                        <th>교시</th>
                        <th>시작 시간</th>
                        <th>종료 시간</th>
                    </tr>
                </thead>
                <tbody>
                    <c:set var="lastDayOfWeek" value="" />
                    <c:forEach var="period" items="${schedule.periods}">
                        <tr>
                            <c:choose>
                                <c:when test="${period.dayOfWeek != lastDayOfWeek}">
                                    <td>${period.dayOfWeek}</td>
                                    <c:set var="lastDayOfWeek" value="${period.dayOfWeek}" />
                                </c:when>
                                <c:otherwise>
                                    <td></td>
                                </c:otherwise>
                            </c:choose>
                            <td>${period.periodName}</td>
                            <td>${period.startTime}</td>
                            <td>${period.endTime}</td>
                        </tr>                             
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </main>

    <!-- 푸터 연결 -->
    <%@ include file="../../common/footer.jsp"%>

</body>
</html>
