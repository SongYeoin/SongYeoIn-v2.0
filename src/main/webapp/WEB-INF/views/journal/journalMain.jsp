<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Journal Main - Calendar View</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
<link href='https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.css' rel='stylesheet' />
<script src='https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.js'></script>
<script src="https://code.jquery.com/jquery-latest.min.js"></script>
<style>
/* 모든 요소에 기본 스타일을 초기화하고 박스 모델을 설정 */
* {
	margin: 0; /* 모든 요소의 외부 여백을 0으로 설정 */
	padding: 0; /* 모든 요소의 내부 여백을 0으로 설정 */
	box-sizing: border-box; /* 요소의 크기를 padding과 border를 포함하여 설정 */
}

/* html과 body 요소의 높이를 설정하여 페이지의 기본 높이를 1080px로 설정 */
html, body {
	height: 1080px; /* html과 body의 높이를 1080px로 설정 */
}

/* body의 기본 폰트와 레이아웃 설정 */
body {
	font-family: Arial, sans-serif;
	/* 기본 폰트를 Arial로 설정하고, 대체 폰트로 sans-serif 사용 */
	display: flex; /* flexbox 레이아웃 사용 */
	flex-direction: column; /* 자식 요소들을 수직으로 배치 */
}

/* Custom FullCalendar Styles */
#calendar {
	max-width: 80%; /* 캘린더의 최대 너비를 80%로 설정 */
	margin: 0 auto; /* 캘린더를 중앙에 배치 */
	height: auto; /* 자동 높이 설정으로 모든 날짜가 보이게 함 */
	min-height: 500px; /* 캘린더의 최소 높이 설정 */
	overflow: hidden; /* 스크롤 제거 */
	border-radius: 5px; /* 모서리를 둥글게 설정 */
}

/* Custom FullCalendar Styles */
.fc {
	font-family: Arial, sans-serif;
}

.fc-daygrid-day-number {
	color: #333; /* 날짜 숫자 색상 */
}

.fc-daygrid-day-top {
	background-color: #e0e0e0; /* 날짜 헤더 배경 색상 */
	border-bottom: 1px solid #ddd;
}

.fc-daygrid-day {
	border: 1px solid #ddd; /* 날짜 셀 테두리 색상 */
	background-color: #ffffff; /* 날짜 셀 배경 색상 */
	border-radius: 8px; /* 둥글게 처리 */
}

.fc-daygrid-day.fc-day-today {
	background-color: #f0f0f0; /* 오늘 날짜 배경 색상 */
}

.fc-daygrid-day.fc-day-past {
	background-color: #f5f5f5; /* 과거 날짜 배경 색상 */
}

.fc-daygrid-day.fc-day-future {
	background-color: #ffffff; /* 미래 날짜 배경 색상 */
}

.fc-button {
	background-color: #6c757d; /* 버튼 배경 색상 */
	color: #ffffff;
	border-radius: 4px;
}

.fc-button:hover {
	background-color: #5a6268; /* 버튼 호버 색상 */
}
</style>
</head>
<body>
	<%@ include file="../common/header.jsp"%>

	<%@ include file="../member/aside.jsp"%>

	<div class="main-content">
		<h1>교육 일정</h1>
	</div>
		<div id='calendar'></div>

	<%@ include file="../common/footer.jsp"%>

	<script>
    document.addEventListener('DOMContentLoaded', function() {
        var calendarEl = document.getElementById('calendar');
        var calendar = new FullCalendar.Calendar(calendarEl, {
            initialView: 'dayGridMonth',
            events: [
                <c:forEach var="schedule" items="${scheduleAllList}" varStatus="status">
                {
                    title: "${schedule.scheduleTitle}",
                    start: "${schedule.scheduleDate}",
                    url: "${pageContext.request.contextPath}/journal/scheduleDetail?scheduleNo=${schedule.scheduleNo}"
                }<c:if test="${!status.last}">,</c:if>
                </c:forEach>
            ],
            eventClick: function(info) {
                if (info.event.url) {
                    window.location.href = info.event.url;
                }
            }
        });
        calendar.render();
        
        console.log("Calendar events: ", calendar.getEvents());
    });
	</script>
</body>
</html>
