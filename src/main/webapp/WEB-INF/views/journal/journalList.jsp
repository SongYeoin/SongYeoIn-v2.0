<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>교육일지 목록</title>
<script src="https://code.jquery.com/jquery-latest.min.js"></script>
<link rel='stylesheet' href='https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.css' />
<script src='https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.js'></script>
<style>
/* CSS Reset */
* {
	margin: 0;
	padding: 0;
	box-sizing: border-box;
}

html, body {
	height: 100%; /* 전체 높이 설정 */
	font-family: Arial, sans-serif;
}

body {
	display: flex;
	flex-direction: column;
	background-color: #f4f4f4; /* 전체 배경 색상 */
}

main {
	flex: 1;
	margin-left: 250px;
	padding-top: 90px;
	overflow-y: auto;
}

.box {
	background-color: #ffffff; /* 박스 배경 색상 */
	border-radius: 8px;
	box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
	padding: 20px;
	margin-bottom: 30px; /* 기존의 박스와 캘린더 사이에 여백 추가 */
}

h1 {
	margin-bottom: 20px;
	color: #333; /* 제목 색상 */
}

.search_area {
	display: flex;
	flex-wrap: wrap;
	gap: 10px; /* 요소 간 간격 */
	margin-bottom: 20px;
}

.search_area label {
	margin-right: 10px;
	font-weight: bold;
	color: #333; /* 라벨 색상 */
}

.search_area select, 
.search_area input, 
.search_area button {
	height: 30px;
}

.search_area select {
	padding: 0 10px;
}

.search_area input {
	width: 250px;
	padding: 0 10px;
}

.search_area button {
	background-color: #6c757d; /* 버튼 배경 색상 */
	color: #ffffff;
	border: none;
	border-radius: 4px;
	cursor: pointer;
}

.search_area button:hover {
	background-color: #5a6268; /* 버튼 호버 색상 */
}

.table_wrap {
	margin: 0 auto; /* 가운데 정렬 */
	padding: 0 20px; /* 좌우 여백 조정 */
}

table {
	border-collapse: collapse;
	width: 100%; /* 테이블 너비를 100%로 설정 */
	margin-top: 20px;
	text-align: center;
}

table th, table td {
	border: 2px solid #ccc; /* 테두리 색상 */
	padding: 10px; /* 셀 내 여백 */
}

table th {
	background-color: #6c757d; /* 헤더 배경 색상 */
	color: #ffffff; /* 헤더 텍스트 색상 */
	font-size: 16px;
}

table tbody tr:hover {
	background-color: #e9ecef; /* 마우스 오버 시 배경색 변경 */
}

.pageInfo_wrap {
	margin: 20px 0;
	text-align: center;
}

.pageInfo {
	list-style: none;
	padding: 0;
	display: inline-block;
}

.pageInfo li {
	display: inline;
	margin: 0 5px;
}

.pageInfo a {
	text-decoration: none;
	color: #6c757d; /* 페이지 링크 색상 */
	font-size: 16px;
	padding: 6px 12px;
	border-radius: 4px;
}

.pageInfo a:hover {
	background-color: #e9ecef; /* 페이지 링크 호버 색상 */
	color: #333; /* 페이지 링크 호버 텍스트 색상 */
}

.active a {
	background-color: #6c757d; /* 활성 페이지 색상 */
	color: #ffffff; /* 활성 페이지 텍스트 색상 */
}

/* Custom FullCalendar Styles */
#calendar {
    max-width: 80%; /* 캘린더의 최대 너비를 80%로 설정 */
    margin: 0 auto; /* 캘린더를 중앙에 배치 */
    height: auto; /* 자동 높이 설정으로 모든 날짜가 보이게 함 */
    min-height: 500px; /* 캘린더의 최소 높이 설정 */
    overflow: hidden; /* 스크롤 제거 */
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

	<!-- 메뉴바 연결 -->
	<%@ include file="../common/header.jsp"%>

	<!-- 사이드바 연결 -->
	<%@ include file="../member/aside.jsp"%>
	
	<main>
		<div class="box">
			<h1>교육일지 목록</h1>
			
			<!-- 캘린더 출력 영역 -->
			<div id='calendar'></div>
			
			<div class="search_area">
			    <form id="searchForm" method="get" action="${pageContext.request.contextPath}/journal/journalList">
			        
			        <label for="keyword">제목 검색:</label>
			        <input type="text" id="keyword" name="keyword" value="${param.keyword}" placeholder="제목으로 검색">
			        
			        <label for="year">년도:</label>
			        <select id="year" name="year">
					    <option value="" <c:if test="${empty param.year}">selected</c:if>>전체</option>
					    <c:forEach var="i" begin="2020" end="2025">
					        <option value="${i}" <c:if test="${param.year == i}">selected</c:if>>${i}</option>
					    </c:forEach>
					</select>
					
					<label for="month">월:</label>
					<select id="month" name="month">
					    <option value="" <c:if test="${empty param.month}">selected</c:if>>전체</option>
					    <c:forEach var="i" begin="1" end="12">
					        <option value="${i}" <c:if test="${param.month == i}">selected</c:if>>${i}</option>
					    </c:forEach>
					</select>

			        <button type="submit">검색</button>
			    </form>
			</div>
			
			<div class="table_wrap">
				<table>
				    <thead>
				        <tr>
				            <th class="bno_width">번호</th>
				            <th class="title_width">제목</th>
				            <th class="regdate_width">작성일자</th>
				        </tr>
				    </thead>
				    <tbody>
				    <c:forEach items="${journalList}" var="journal">
				        <tr>
				            <td><c:out value="${journal.journalNo}" /></td>
				            <td>
				                <a href="${pageContext.request.contextPath}/journal/journalDetail?journalNo=${journal.journalNo}">
				                    <c:out value="${journal.journalTitle}" />
				                </a>
				            </td>
				            <td><fmt:formatDate pattern="yyyy/MM/dd" value="${journal.journalWriteDate}" /></td>
				        </tr>
				    </c:forEach>
				    </tbody>
				</table>

				<div class="pageInfo_wrap">
					<div class="pageInfo_area">
						<ul id="pageInfo" class="pageInfo">
							
							<!-- 이전페이지 버튼 -->
							<c:if test="${pageMaker.prev}">
								<li class="pageInfo_btn previous">
									<a href="${pageContext.request.contextPath}/journal/journalList?pageNum=${pageMaker.cri.pageNum - 1}&amount=${pageMaker.cri.amount}&keyword=${param.keyword}&year=${param.year}&month=${param.month}">Previous</a>
								</li>
							</c:if>

							<!-- 각 번호 페이지 버튼 -->
							<c:forEach var="num" begin="${pageMaker.pageStart}" end="${pageMaker.pageEnd}">
								<li class="pageInfo_btn ${pageMaker.cri.pageNum == num ? 'active' : ''}">
									<a href="${pageContext.request.contextPath}/journal/journalList?pageNum=${num}&amount=${pageMaker.cri.amount}&keyword=${param.keyword}&year=${param.year}&month=${param.month}">${num}</a>
								</li>
							</c:forEach>

							<!-- 다음페이지 버튼 -->
							<c:if test="${pageMaker.next}">
								<li class="pageInfo_btn next">
									<a href="${pageContext.request.contextPath}/journal/journalList?pageNum=${pageMaker.pageEnd + 1}&amount=${pageMaker.cri.amount}&keyword=${param.keyword}&year=${param.year}&month=${param.month}">Next</a>
								</li>
							</c:if>

						</ul>
					</div>
				</div>
			</div>
		</div>
	</main>
	
	<!-- 푸터 연결 -->
	<%@ include file="../common/footer.jsp"%>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            var calendarEl = document.getElementById('calendar');

            var journalEvents = [
                <c:forEach items="${journalList}" var="journal" varStatus="status">
                    {
                        title: '${journal.journalTitle}',
                        start: '${journal.journalWriteDate}',
                        url: '${pageContext.request.contextPath}/journal/journalDetail?journalNo=${journal.journalNo}',
                        color: '#6c757d' // 교육일지 이벤트 색상
                    }<c:if test="${not empty journal}">,</c:if>
                </c:forEach>
            ];

            var scheduleEvents = [
                <c:forEach items="${schedules}" var="schedule" varStatus="status">
                    {
                        title: '${schedule.scheduleTitle}',
                        start: '${schedule.scheduleDate}',
                        url: '${pageContext.request.contextPath}/schedule/scheduleDetail?scheduleNo=${schedule.scheduleNo}',
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
        });
    </script>
</body>
</html>