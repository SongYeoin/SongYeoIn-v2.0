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
}

main {
    flex: 1;
    margin-left: 300px;
    margin-top: 110px;
    overflow-y: auto;
    padding: 20px;
    height: calc(100% - 130px); 
}

.title-container {
    display: flex;
    align-items: center;
    margin-bottom: 20px;
}

.title-container h1 {
    margin-right: 20px;
    font-weight: bold;
}

.select-box {
    position: relative;
    display: inline-block;
    width: 250px;
}

.select-box select {
    width: 100%;
    padding: 10px;
    font-size: 1em;
    border: 1px solid #ddd;
    border-radius: 5px;
    background: #f8f8f8;
}

/* Layout with flexbox */
.content-container {
    display: flex;
    gap: 100px; 
}

/* Table Styles */
table {
    width: 100%;
    border-collapse: collapse; /* 테이블 셀 간의 경계선 */
    table-layout: fixed; /* 고정된 테이블 레이아웃 */
}

th, td {
    border: 1px solid #ddd; /* 테두리 추가 */
    padding: 8px;
    text-align: center;
}

th {
    background-color: #f2f2f2;
    font-weight: bold;
}

td {
    font-size: 1em;
    color: #333;
}

/* 요일이 오른쪽으로 치우치지 않도록 조정 */
td:not(:first-child) {
    text-align: left;
    padding: 12px;
}

/* 첫 번째 열에 대한 조정 */
td:first-child {
    text-align: left;
    padding-left: 10px;
}

/* Responsive */
@media (max-width: 768px) {
    .title-container {
        flex-direction: column;
        align-items: flex-start;
    }
    
    .select-box {
        width: 100%;
    }
}

</style>
</head>
<body>

    <!-- 메뉴바 연결 -->
    <%@ include file="../../common/header.jsp"%>

    <!-- 사이드바 연결 -->
    <%@ include file="../aside.jsp"%>

    <c:set var="now" value="<%= new java.util.Date() %>" />

    <main>
    	<!-- Title and Select Box -->
        <div class="title-container">
            <h1>출석 조회</h1>
            <div class="select-box">
                <select id="classSelect" name="classSelect" onchange="sendClassChange()">
				    <c:forEach var="classItem" items="${classList}">
				        <option value="${classItem.classNo}" <c:if test="${classItem.classNo == param.classNo}">selected</c:if>>${classItem.className}</option>
				    </c:forEach>
				</select>
            </div>
        </div>

        <!-- Main content area -->
        <div class="content-container">
            	<!-- Attendance Table -->
            <table>
                <thead>
                    <tr>
                        <th>주차</th>
                        <c:forEach var="dayOfWeek" items="${dayOfWeekList}">
                            <th>${dayOfWeek}</th>
                        </c:forEach>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="week" begin="1" end="${weeksBetween}">
                        <tr>
                            <td>${week}주</td>
                            <c:forEach var="dayOfWeek" items="${dayOfWeekList}">
							    <c:set var="key" value="week-${week}-${dayOfWeek}"/>
							    <td>
							        <c:choose>
							            <c:when test="${finalAttendanceMap[key] == '지각'}">△</c:when>
							            <c:when test="${finalAttendanceMap[key] == '출석'}">◯</c:when>
							            <c:when test="${finalAttendanceMap[key] == '결석'}">✕</c:when>
							            <c:when test="${finalAttendanceMap[key] == '조퇴'}">/</c:when>
							            <c:otherwise>-</c:otherwise>
							        </c:choose>
							        <br/>
        								<span style="font-size: 0.8em; color: #666;">
					                    <a href="/member/attendance/attendanceDetail?classNo=${param.classNo}" style="text-decoration: none; color: inherit;">
									        <c:out value="${dateMap[key]}" />
									    </a>
					                </span>
							    </td>
							</c:forEach>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
             
        </div>
    </main>

    <!-- 푸터 연결 -->
    <%@ include file="../../common/footer.jsp"%>
    
<script>
//페이지 초기 세팅 설정
window.onload = function() {
    var selectBox = document.getElementById("classSelect");
    var selectedClassNo = selectBox.options[selectBox.selectedIndex].value;

    if (!window.location.search.includes("classNo")) {
        window.location.href = "/member/attendance/attendanceList?classNo=" + selectedClassNo;
    }
};

//반 변경 시 출석 조회
function sendClassChange() {
    var selectBox = document.getElementById("classSelect");
    var selectedClassNo = selectBox.options[selectBox.selectedIndex].value;
    window.location.href = "/member/attendance/attendanceList?classNo=" + selectedClassNo;
}
</script>

</body>
</html>
