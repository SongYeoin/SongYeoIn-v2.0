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

.date-container {
    text-align: center;
    margin-bottom: 20px;
}

.date-container h2 {
    font-size: 1.8em; 
    font-weight: bold;
    color: #333;
    margin-bottom: 5px; 
}

.date-container h3 {
    font-size: 1.2em; 
    color: #666;
}

/* Layout with flexbox */
.content-container {
    display: flex;
    gap: 100px; 
}

/* Left side (Card container) */
.card-container {
    flex: 2; 
    display: flex;
    flex-direction: column;
    align-items: left;
    gap: 20px;
}

.card {
    display: flex !important;
    background-color: #fff !important;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    border-radius: 10px !important;
    padding: 5px 20px;
    width: 100%;
    text-align: left;
    flex-direction: row !important;
    justify-content: space-between !important;
    align-items: center !important;
}

.card h3 {
    margin-bottom: 10px;
    font-size: 1.5em;
    color: #555;
}

.card p {
    font-size: 1em;
    color: #777;
}

/* Attendance button styling */
.attendance-btn {
    background-color: #28a745;
    color: white;
    border: none;
    padding: 10px 20px;
    border-radius: 5px;
    cursor: pointer;
    font-size: 1em;
    text-align: right;
}

.attendance-btn:hover {
    background-color: #218838;
}

/* Right side (Additional info) */
.info-container {
    flex: 1; 
    background-color: #fff;
    border-radius: 10px;
    padding: 15px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    text-align: left;
}

.info-container h2 {
    font-size: 1.4em;
    margin-bottom: 10px;
    font-weight: bold;
}

.info-container p {
    font-size: 1em;
    color: #555;
    margin-bottom: 20px;
}

.info-container .today-btn, .info-container .attendance-btn {
    display: block;
    margin: 10px 0; 
    padding: 5px 10px;
    background-color: #000;
    color: white;
    border-radius: 5px;
    font-size: 0.9em;
    width: fit-content;
    border: none; 
    cursor: pointer; 
    text-decoration: none;
}

.button-group {
    display: flex;
    justify-content: center;
    gap: 5px; 
}

.info-container .today-btn, .info-container .attendance-btn[disabled] {
    border-radius: 15px; 
    padding: 3px 10px; 
    cursor: default;
    background-color: #000;
    color: white;
    text-decoration: none;
}

.info-container .today-btn:hover, .info-container .attendance-btn:hover {
    background-color: #333;
}

.info-container .progress-bar {
    width: 100%;
    background-color: #e0e0e0;
    border-radius: 5px;
    overflow: hidden;
    margin-bottom: 10px;
}

.info-container .progress {
    width: 37.5%; /* Example percentage */
    height: 10px;
    background-color: #28a745;
}

.info-container .percentage {
    font-size: 0.9em;
    color: #555;
}

.attendance-btn[disabled] {
    background-color: #ddd; /* 비활성화 색상 */
    color: #aaa; /* 텍스트 색상 */
    cursor: not-allowed;
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
            <h1>출석 체크</h1>
            <div class="select-box">
                <select id="classSelect" name="classSelect" onchange="sendClassChange()">
				    <c:forEach var="classItem" items="${classList}">
				        <option value="${classItem.classNo}" <c:if test="${classItem.classNo == param.classNo}">selected</c:if>>${classItem.className}</option>
				    </c:forEach>
				</select>
            </div>
        </div>

        <!-- Date -->
        <div class="date-container">
            <h2><fmt:formatDate value="${now}" pattern="yyyy년 MM월 dd일" /></h2>
            <h3><fmt:formatDate value="${now}" pattern="EEEE" /></h3>
        </div>

        <!-- Main content area -->
        <div class="content-container">
            <!-- Left side -->
            <div class="card-container">
                <c:choose>
                    <c:when test="${result == 'null'}">
                        <p>등록된 시간표가 없습니다.</p>
                    </c:when>
                    <c:when test="${result == 'error'}">
                        <p>시간표 조회 중 오류가 발생했습니다. 다시 시도해 주세요.</p>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="period" items="${schedule.periods}">
						    <div class="card">
						        <div>
						            <h3>${period.periodName}</h3>
						            <p>${period.startTime} - ${period.endTime}</p>
						        </div>
						        <div>
						            <c:choose>
						                <c:when test="${periodAttendanceStatus[period.periodNo] != '미출석'}">
		                                            <!-- 출석 상태를 업데이트된 상태로 표시 -->
		                                            <button class="attendance-btn" disabled>${periodAttendanceStatus[period.periodNo]}</button>
		                                        </c:when>
		                                        <c:when test="${attendanceStatus[period.periodNo]}">
		                                            <form action="/member/attendance/enroll" method="post" onsubmit="return setDayOfWeek(this);">
		                                            	<input type="hidden" name="classNo" value="${param.classNo}">
		                                                <input type="hidden" name="periodNo" value="${period.periodNo}">
		                                                <input type="hidden" name="dayOfWeek" value="">
		                                                <button type="submit" class="attendance-btn">출석하기</button>
		                                            </form>
						                </c:when>

						            </c:choose>
						        </div>
						    </div>
						</c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Right side (Additional info) -->
            <div class="info-container">
                <h2>나의 훈련 과정</h2>
                <p id="selectedClassName">
				    <c:forEach var="classItem" items="${classList}">
				        <c:if test="${classItem.classNo == param.classNo}">
				            ${classItem.className}
				        </c:if>
				    </c:forEach>
				</p>
                <a href="#" class="today-btn" disabled>today</a>
                <p><fmt:formatDate value="${now}" pattern="yyyy년 MM월 dd일 EEEE" /></p>
                <a href="#" class="attendance-btn" disabled>오늘의 출석</a>
                <p>3교시 / 총 8교시</p>
                <div class="progress-bar">
                    <div class="progress"></div>
                </div>
                <p class="percentage">총 37.5%</p>
                <div class="button-group">
                    <a href="전체출석조회.html" class="attendance-btn">전체 출석 조회</a>
                    <a href="일지제출하기.html" class="attendance-btn">일지 제출하기</a>
                </div>
            </div>
        </div>
    </main>

    <!-- 푸터 연결 -->
    <%@ include file="../../common/footer.jsp"%>
    
<script>

//요일 정보를 얻어내는 함수
function getDayOfWeek() {
    var days = ['일', '월', '화', '수', '목', '금', '토'];
    var now = new Date();
    return days[now.getDay()];
}

// 페이지 초기 세팅 설정
window.onload = function() {
    var selectBox = document.getElementById("classSelect");
    var selectedClassNo = selectBox.options[selectBox.selectedIndex].value;

    if (!window.location.search.includes("classNo")) {
        var dayOfWeek = getDayOfWeek();
        var today = new Date();
        var formattedDate = today.getFullYear() + '-' + ('0' + (today.getMonth() + 1)).slice(-2) + '-' + ('0' + today.getDate()).slice(-2);
        window.location.href = "/member/attendance/enroll?classNo=" + selectedClassNo + "&dayOfWeek=" + dayOfWeek + "&attendanceDate=" + formattedDate;
    }
    
 	// resultMessage가 있으면 alert로 표시
    <c:if test="${not empty resultMessage}">
        alert("${resultMessage}");
    </c:if>
};

// 다른 반 셀렉 시 리다이렉트
function sendClassChange() {
    var selectBox = document.getElementById("classSelect");
    var selectedClassNo = selectBox.options[selectBox.selectedIndex].value;
    var dayOfWeek = getDayOfWeek();
    var today = new Date();
    var formattedDate = today.getFullYear() + '-' + ('0' + (today.getMonth() + 1)).slice(-2) + '-' + ('0' + today.getDate()).slice(-2);

    window.location.href = "/member/attendance/enroll?classNo=" + selectedClassNo + "&dayOfWeek=" + dayOfWeek + "&attendanceDate=" + formattedDate;
}

//폼 제출 시 dayOfWeek 설정
function setDayOfWeek(form) {
    var dayOfWeek = getDayOfWeek();
    var dayOfWeekField = form.elements['dayOfWeek']; // dayOfWeek 필드를 찾음
  
    if (dayOfWeekField) {
        dayOfWeekField.value = dayOfWeek; // dayOfWeek 필드에 값을 설정
        
     	// 오늘 날짜를 yyyy-MM-dd 형식으로 추가
        var today = new Date();
        var formattedDate = today.getFullYear() + '-' + ('0' + (today.getMonth() + 1)).slice(-2) + '-' + ('0' + today.getDate()).slice(-2);

        var attendanceDateField = document.createElement("input");
        attendanceDateField.setAttribute("type", "hidden");
        attendanceDateField.setAttribute("name", "attendanceDate");
        attendanceDateField.setAttribute("value", formattedDate);
        form.appendChild(attendanceDateField);
        
        return true; // 폼을 정상적으로 제출하도록 true 반환
        
    } else {
        console.error("dayOfWeek 필드를 찾을 수 없습니다.");
        return false; // 필드를 찾지 못했을 경우 폼 제출 중단
    }
}

   
</script>

</body>
</html>
