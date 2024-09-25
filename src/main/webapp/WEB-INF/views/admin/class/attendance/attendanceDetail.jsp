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

/* 수강생 정보 박스 스타일 */
.student-info-box {
    border: 1px solid #ddd;
    padding: 20px;
    margin-bottom: 20px;
    background-color: #f9f9f9;
    border-radius: 5px;
}

.student-info-content {
    display: flex; /* Flexbox로 왼쪽과 오른쪽 나누기 */
    justify-content: space-between; /* 양쪽으로 정렬 */
}

.student-info-left,
.student-info-right {
    width: 48%; /* 각 부분의 너비 설정 */
}

.student-info-title {
    font-size: 18px;
    font-weight: bold;
    margin-bottom: 10px;
}

.student-info-detail {
    margin-bottom: 8px;
    font-size: 14px;
}

/* 테이블 스타일 */
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
    text-align: center;
}

th {
    background-color: #f4f4f4;
    font-weight: bold;
}

td {
    font-size: 1em;
    color: #333;
    white-space: nowrap; /* 줄바꿈 방지 */
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
            
            <!-- 수강생 정보 박스 -->
            <div class="student-info-box">
                <div class="student-info-title">수강생 정보</div>
                <div class="student-info-content">
                    <!-- 왼쪽 정보 -->
                    <div class="student-info-left">
                        <div class="student-info-detail">이름: ${student.memberName}</div>
                        <div class="student-info-detail">생년월일: ${student.memberBirthday}</div>
                        <div class="student-info-detail">주소: ${student.memberStreetAddress} ${student.memberDetailAddress} (${student.memberAddress})</div>
                    </div>
                    
                    <!-- 오른쪽 정보 -->
                    <div class="student-info-right">
                        <div class="student-info-detail">전화번호: ${student.memberPhone}</div>
                        <div class="student-info-detail">이메일: ${student.memberEmail}</div>
                    </div>
                </div>
            </div>
            
            <!-- 출석 정보 테이블 -->
            <table>
                <thead>
                    <tr>
                        <th>날짜</th>
                        <th>교시</th>
                        <th>교시 별 출석</th>
                        <th>최종출석</th>
                        <th>비고</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="date" items="${attendanceDates}">
                        <c:set var="finalKey" value="${student.memberNo}-${date}" />
                        <c:set var="finalStatusDisplayed" value="false" />
                        <tr>
                            <td rowspan="${fn:length(periods) + 1}">${date}</td> <!-- 날짜 정보는 교시 수 + 1만큼 rowspan -->
                            <td colspan="4"></td> <!-- 첫 행은 비워둠 -->
                        </tr>
                        <c:forEach var="period" items="${periods}">
                            <tr>
                                <td>${period.periodName}</td> <!-- 교시 정보 -->

								<c:set var="dateStr" value="${date.toString()}" />
								
								<c:set var="key" value="${student.memberNo}-${dateStr}" />
								
								<td>
								<!-- 교시별 출석 상태를 추적하는 플래그 -->
    							<c:set var="foundAttendance" value="false" />
								    <c:forEach var="attendance" items="${studentAttendanceMap[key]}">
								        <c:if test="${attendance.periodNo == period.periodNo}">
								            <c:choose>
								                <c:when test="${attendance.attendanceStatus == '지각'}">△</c:when>
								                <c:when test="${attendance.attendanceStatus == '출석'}">◯</c:when>
								                <c:when test="${attendance.attendanceStatus == '결석'}">✕</c:when>
								                <c:when test="${attendance.attendanceStatus == '조퇴'}">/</c:when>
								                <c:otherwise>-</c:otherwise>
								            </c:choose>
								            <!-- 출석 상태가 발견된 경우 플래그를 true로 설정 -->
            									<c:set var="foundAttendance" value="true" />
								        </c:if>
								    </c:forEach>
								    <!-- attendance가 없을 경우 대체 표시를 출력 -->
								    <c:if test="${!foundAttendance}">
								        -
								    </c:if>
								</td>

                                <td>
                                    <c:if test="${!finalStatusDisplayed}">
                                        ${finalAttendanceMap[finalKey]}
                                        <c:set var="finalStatusDisplayed" value="true" />
                                    </c:if>
                                </td> <!-- 최종 출석은 날짜별로 한 번만 출력 -->
                                <td>
                                    <c:forEach var="attendance" items="${studentAttendanceMap[key]}">
                                        <c:if test="${attendance.periodNo == period.periodNo}">
                                            <c:out value="${attendance.memo}" />
                                        </c:if>
                                    </c:forEach>
                                </td> <!-- 비고 -->
                            </tr>
                        </c:forEach>
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
