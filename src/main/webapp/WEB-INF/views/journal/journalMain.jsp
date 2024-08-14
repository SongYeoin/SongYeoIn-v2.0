<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>교육일정 목록</title>
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

/* main 요소의 위치와 스크롤 설정 */
main {
	flex: 1; /* main 요소가 flexbox 컨테이너에서 가능한 모든 공간을 차지하도록 설정 */
	margin-left: 300px; /* 왼쪽 여백을 300px로 설정 (사이드바 공간 확보) */
	margin-top: 110px; /* 상단 여백을 110px로 설정 (헤더 공간 확보) */
	overflow-y: auto; /* 세로 스크롤을 가능하게 설정 */
	height: 100%; /* 높이를 100%로 설정하여 부모 요소의 높이를 차지하도록 설정 */
}

/* 제목과 선택 박스를 감싸는 컨테이너의 스타일 설정 */
.title-container {
	display: flex; /* flexbox 레이아웃 사용 */
	align-items: center; /* 자식 요소들을 수직 가운데 정렬 */
}

/* 제목과 선택 박스 사이의 간격을 설정 */
.title-container h1 {
	margin-right: 20px; /* 제목 오른쪽에 20px 간격 설정 */
	font-weight: bold; /* 제목을 굵은 글씨로 설정 */
}

/* 콘텐츠를 감싸는 컨테이너의 스타일 설정 */
.container {
	margin: 20px auto; /* 위아래 여백을 20px로 설정하고 좌우 중앙 정렬 */
	background-color: #f9fafc; /* 배경색을 연한 회색으로 설정 */
	box-shadow: 0 0 10px rgba(0, 0, 0, 0.1); /* 그림자를 설정하여 입체감을 줌 */
	max-width: 1200px; /* 최대 너비를 1200px로 설정 */
	border-radius: 10px; /* 모서리를 둥글게 설정 */
	padding-bottom: 20px; /* 하단 여백을 20px로 설정 */
	padding-left: 0 !important; /* 왼쪽 여백을 0으로 설정하고, 우선순위를 높임 */
	padding-right: 0 !important; /* 오른쪽 여백을 0으로 설정하고, 우선순위를 높임 */
}

/* 헤더의 스타일 설정 */
.header {
	display: flex; /* flexbox 레이아웃 사용 */
	flex-wrap: wrap; /* 자식 요소가 여러 줄로 배치될 수 있도록 설정 */
	justify-content: space-between; /* 자식 요소들 사이의 공간을 균등하게 배분 */
	align-items: center; /* 자식 요소들을 수직 가운데 정렬 */
	margin-bottom: 20px; /* 하단 여백을 20px로 설정 */
	padding-bottom: 10px; /* 하단 패딩을 10px로 설정 */
	border-bottom: 1px solid #ddd; /* 하단 경계를 연한 회색으로 설정 */
	background-color: #e2eff9; /* 배경색을 연한 파란색으로 설정 */
	padding-top: 40px; /* 상단 패딩을 40px로 설정 */
	padding-right: 32px; /* 오른쪽 패딩을 32px로 설정 */
	padding-left: 32px; /* 왼쪽 패딩을 32px로 설정 */
	padding-bottom: 20px; /* 하단 패딩을 20px로 설정 */
	border-radius: 10px 10px 0 0; /* 상단 모서리를 둥글게 설정 */
}

/* 헤더의 제목 스타일 설정 */
.header h2 {
	margin: 0; /* 제목의 여백을 0으로 설정 */
	flex-grow: 1; /* 제목이 가능한 모든 공간을 차지하도록 설정 */
}

/* 검색 영역의 입력 필드 스타일 설정 */
.header input {
	padding: 10px; /* 입력 필드의 패딩을 10px로 설정 */
	width: 200px; /* 입력 필드의 너비를 200px로 설정 */
	border: 1px solid #ddd; /* 테두리를 연한 회색으로 설정 */
	border-radius: 5px; /* 모서리를 둥글게 설정 */
}

/* 헤더의 아이콘 스타일 설정 */
.header .icons {
	display: flex; /* flexbox 레이아웃 사용 */
}

/* 아이콘 간의 간격 설정 및 포인터 커서 설정 */
.header .icons i {
	cursor: pointer; /* 아이콘 클릭 시 포인터 커서 표시 */
	margin-left: 10px; /* 아이콘 사이의 간격을 10px로 설정 */
}

/* 상단 버튼의 스타일 설정 */
.top_btn {
	font-size: 20px; /* 폰트 크기를 20px로 설정 */
	padding: 6px 12px; /* 상하 패딩 6px, 좌우 패딩 12px로 설정 */
	background-color: #28a745; /* 배경색을 녹색으로 설정 */
	color: white; /* 텍스트 색상을 흰색으로 설정 */
	border: none; /* 테두리 없음 */
	border-radius: 4px; /* 모서리를 둥글게 설정 */
	font-weight: 600; /* 텍스트 굵기를 600으로 설정 */
	cursor: pointer; /* 클릭 시 포인터 커서 표시 */
}

/* 상단 버튼 호버 시 색상 변경 */
.top_btn:hover {
	background-color: #218838; /* 호버 시 배경색을 더 어두운 녹색으로 설정 */
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

<!-- Bootstrap CSS를 불러오기 위한 링크 -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
</head>

<body>

	<!-- 메뉴바 연결 -->
	<%@ include file="../common/header.jsp"%>

	<!-- 사이드바 연결 -->
	<%@ include file="../member/aside.jsp"%>
	
	<main>

	<!-- 제목과 클래스 선택 박스 -->
		<div class="title-container">
		<h1>메인</h1>
			<div class="select-box">
				<select id="classSelect" name="classSelect" onchange="sendClassChange()">
					<c:forEach var="classItem" items="${classList}">
	                        <option value="${classItem.classNo}" <c:if test="${classItem.classNo == param.classNo}">selected</c:if>>${classItem.className}</option>
	                    </c:forEach>
				</select>
			</div>
		</div>
		
	<!-- 캘린더 출력 영역 -->
		<div id='calendar'></div>
		
	</main>
	
	<!-- 푸터 연결 -->
	<%@ include file="../common/footer.jsp"%>
	
	<script>
        document.addEventListener('DOMContentLoaded', function() {
            var calendarEl = document.getElementById('calendar');

            var journalEvents = [
                <c:forEach var="journal" items="${journalAllList}" varStatus="status">
                    {
                        title: "${journal.journalTitle}",
                        start: "${journal.journalWriteDate}",
                        url: "${pageContext.request.contextPath}/journal/journalDetail?journalNo=${journal.journalNo}",
                        color: '#6c757d' // 교육일지 이벤트 색상
                    }<c:if test="${not empty journal}">,</c:if>
                </c:forEach>
            ];
            
            console.log("--------->>> Events data: ", events);  // Debugging line to check events data


            var scheduleEvents = [
                <c:forEach var="schedule" items="${scheduleAllList}" varStatus="status">
                    {
                        title: "${schedule.scheduleTitle}",
                        start: "${schedule.scheduleDate}",
                        url: "${pageContext.request.contextPath}/schedule/scheduleDetail?scheduleNo=${schedule.scheduleNo}",
                        color: '#868e96' // 교육일정 이벤트 색상
                    }<c:if test="${not empty schedule}">,</c:if>
                </c:forEach>
            ];

            var calendar = new FullCalendar.Calendar(calendarEl, {
                initialView: 'dayGridMonth',
                headerToolbar: {
                    left: 'prev,next today',
                    center: 'title',
                    right: 'dayGridMonth,timeGridWeek,timeGridDay'
                },
                events: [...journalEvents, ...scheduleEvents],
                eventClick: function(info) {
                    window.location.href = info.event.url;
                }
            });

            calendar.render();
            
            console.log("--------->> Calendar events: ", calendar.getEvents());

        });
    </script>
</body>
</html>
