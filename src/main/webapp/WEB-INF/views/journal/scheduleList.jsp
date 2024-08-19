<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>교육일정 목록</title>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
<link
	href='https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.css'
	rel='stylesheet' />
<script
	src='https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.js'></script>
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
	margin-left: 250px; /* 왼쪽 여백을 300px로 설정 (사이드바 공간 확보) */
	margin-top: 160px; /* 상단 여백을 110px로 설정 (헤더 공간 확보) */
	overflow-y: auto; /* 세로 스크롤을 가능하게 설정 */
	height: 100%; /* 높이를 100%로 설정하여 부모 요소의 높이를 차지하도록 설정 */
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

/* 검색 영역의 레이아웃과 스타일 설정 */
.search_area {
	display: flex; /* flexbox 레이아웃 사용 */
	flex-wrap: wrap; /* 자식 요소가 여러 줄로 배치될 수 있도록 설정 */
	align-items: center; /* 자식 요소들을 수직 가운데 정렬 */
}

/* 검색 영역의 레이블, 셀렉트 박스, 버튼에 마진을 설정 */
.search_area label, .search_area select, .search_area button {
	margin-left: 10px; /* 왼쪽 여백을 10px로 설정 */
}

/* 셀렉트 박스와 입력 필드의 스타일 설정 */
.search_area select, .search_area input {
	height: 30px; /* 높이를 30px로 설정 */
	padding: 5px; /* 패딩을 5px로 설정 */
	border: 1px solid #ddd; /* 테두리를 연한 회색으로 설정 */
	border-radius: 5px; /* 모서리를 둥글게 설정 */
}

/* 검색 버튼의 스타일 설정 */
.search_area button {
	height: 36px; /* 버튼의 높이를 36px로 설정 */
	background-color: #007bff; /* 배경색을 파란색으로 설정 */
	color: white; /* 텍스트 색상을 흰색으로 설정 */
	border: none; /* 테두리 없음 */
	border-radius: 4px; /* 모서리를 둥글게 설정 */
	cursor: pointer; /* 클릭 시 포인터 커서 표시 */
	padding: 0 20px; /* 좌우 패딩을 20px로 설정 */
}

/* 검색 버튼 호버 시 색상 변경 */
.search_area button:hover {
	background-color: #0056b3; /* 호버 시 배경색을 더 어두운 파란색으로 설정 */
}

/* 테이블을 감싸는 div의 마진 설정 */
.table_wrap {
	margin: 50px 50px 0 50px; /* 상단, 좌측, 우측, 하단 여백을 각각 50px로 설정 */
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

/* 테이블 헤더의 기본 커서 설정 */
table thead tr {
	cursor: default; /* 기본 커서 */
}

/* 테이블 본문의 행에 포인터 커서 설정 */
table tbody tr {
	cursor: pointer; /* 포인터 커서 */
}

/* 테이블의 기본 스타일 설정 */
table {
	width: 100%; /* 테이블의 너비를 100%로 설정 */
	border-collapse: collapse; /* 테두리가 겹치지 않도록 설정 */
	text-align: center; /* 가운데 정렬 */
}

/* 테이블 헤더의 배경색 설정 */
thead {
	background-color: #f5f5f5; /* 배경색을 연한 회색으로 설정 */
	text-align: center; /* 가운데 정렬 */
}

/* 테이블 셀의 패딩, 정렬, 경계 설정 */
th, td {
	padding: 10px; /* 패딩을 10px로 설정 */
	/* text-align: left; */ /* 텍스트를 왼쪽 정렬 */
	text-align: center; /* 가운데 정렬 */
	border: 1px solid #ddd; /* 경계를 연한 회색으로 설정 */
}

/* 상태에 따라 셀의 배경색을 다르게 설정 */
td.checkStatus {
	text-align: center; /* 텍스트를 가운데 정렬 */
}

td.checkStatus:before {
	content: "Status: "; /* 셀에 'Status: ' 텍스트 추가 */
}

td.checkStatus.Y {
	background-color: #d4edda; /* 상태가 'Y'일 때 배경색을 연한 녹색으로 설정 */
}

td.checkStatus.N {
	background-color: #f8d7da; /* 상태가 'N'일 때 배경색을 연한 빨간색으로 설정 */
}

.hidden {
	display: none;
}

/* 페이지 정보 영역의 스타일 설정 */
.pageInfo_wrap {
	text-align: center; /* 가운데 정렬 */
	margin: 20px; /* 여백을 20px로 설정 */
}

/* 페이지 정보 버튼의 기본 스타일 설정 */
.pageInfo_btn {
	display: inline-block; /* 인라인 블록으로 설정 */
	margin: 0 5px; /* 좌우 여백을 5px로 설정 */
}

/* 페이지 정보 버튼의 기본 스타일 설정 */
.pageInfo_btn a {
	display: block; /* 블록 요소로 설정 */
	padding: 10px 15px; /* 상하 패딩 10px, 좌우 패딩 15px으로 설정 */
	background-color: #f8f9fa; /* 배경색을 연한 회색으로 설정 */
	color: #007bff; /* 텍스트 색상을 파란색으로 설정 */
	text-decoration: none; /* 밑줄 제거 */
	border-radius: 5px; /* 모서리를 둥글게 설정 */
}

/* 페이지 정보 버튼 호버 시 스타일 설정 */
.pageInfo_btn a:hover {
	background-color: #e9ecef; /* 호버 시 배경색을 더 연한 회색으로 설정 */
}

/* 페이지 정보 버튼 활성 상태의 스타일 설정 */
.pageInfo_btn.active a {
	background-color: #007bff; /* 활성화된 버튼의 배경색을 파란색으로 설정 */
	color: white; /* 활성화된 버튼의 텍스트 색상을 흰색으로 설정 */
}

/* 페이지 정보 버튼 '다음'과 '이전' 버튼의 스타일 설정 */
.pageInfo_btn.previous a, .pageInfo_btn.next a {
	font-weight: bold; /* 텍스트 굵기를 bold로 설정 */
}

/* 페이지 정보 버튼 '다음'과 '이전' 버튼의 커서 스타일 설정 */
.pageInfo_btn.previous a:hover, .pageInfo_btn.next a:hover {
	background-color: #0056b3; /* 호버 시 배경색을 더 어두운 파란색으로 설정 */
	color: white; /* 호버 시 텍스트 색상을 흰색으로 설정 */
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
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css"
	rel="stylesheet"
	integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3"
	crossorigin="anonymous">
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

	<main>

		<!-- 제목과 클래스 선택 박스 -->
		<div class="title-container">
			<h1>교육 일정</h1>
			<div class="select-box">
				<select id="classSelect" name="classSelect"
					onchange="sendClassChange()">
					<c:forEach var="classItem" items="${classList}">
						<option value="${classItem.classNo}"
							<c:if test="${classItem.classNo == param.classNo}">selected</c:if>>${classItem.className}</option>
					</c:forEach>
				</select>
			</div>
		</div>

		<!-- 캘린더 출력 영역 -->
		<div id='calendar'></div>

		<!-- 메인 콘텐츠 -->
		<div class="container">
			<div class="header">
				<h2>교육일정 목록</h2>
				<div class="search_area">
					<form id="searchForm" method="get"
						action="${pageContext.request.contextPath}/journal/scheduleList">

						<select id="category" name="category">
							<option value="all"
								<c:if test="${param.category == 'all'}">selected</c:if>>전체</option>
							<option value="title"
								<c:if test="${param.category == 'title'}">selected</c:if>>단원명</option>
							<option value="instructor"
								<c:if test="${param.category == 'instructor'}">selected</c:if>>강사</option>
						</select> <input type="text" id="keyword" name="keyword"
							value="${param.keyword}" placeholder="검색"> <select
							id="year" name="year">
							<option value="" <c:if test="${empty param.year}">selected</c:if>>년도</option>
							<c:forEach var="i" begin="2020" end="2025">
								<option value="${i}"
									<c:if test="${param.year == i}">selected</c:if>>${i}</option>
							</c:forEach>
						</select> <select id="month" name="month">
							<option value=""
								<c:if test="${empty param.month}">selected</c:if>>월</option>
							<c:forEach var="i" begin="1" end="12">
								<option value="${i}"
									<c:if test="${param.month == i}">selected</c:if>>${i}</option>
							</c:forEach>
						</select>

						<button type="submit">조회</button>
					</form>
				</div>
				<c:if test="${sessionScope.loginMember.memberRole eq 'ROLE_ADMIN'}">
					<div class="icons">
						<a href="/journal/admin/scheduleCreate"><i
							class="fas fa-square-plus"></i></a>
					</div>
				</c:if>
			</div>

			<div class="table_wrap">

				<table>
					<thead>
						<tr>
							<th>회차</th>
							<th class="hidden scheduleNo">회차</th>
							<th class="date_width">일자</th>
							<th class="title_width">단원명</th>
							<th class="title_width">학습주제</th>
							<th class="instructor_width">강사</th>
						</tr>
					</thead>

					<tbody>
						<c:forEach items="${schedules}" var="schedule" varStatus="i">
							<tr data-schedule-no="${schedule.scheduleNo}">
								<td>${pageMaker.total - (pageMaker.cri.pageNum - 1) * pageMaker.cri.amount -  i.index}</td>
								<td class="hidden scheduleNo"><c:out
										value="${schedule.scheduleNo}" /></td>
								<td><c:out value="${schedule.scheduleDate}" /></td>
								<td><a
									href="${pageContext.request.contextPath}/journal/scheduleDetail?scheduleNo=${schedule.scheduleNo}">
										<c:out value="${schedule.scheduleTitle}" />
								</a></td>
								<td><a
									href="${pageContext.request.contextPath}/journal/scheduleDetail?scheduleNo=${schedule.scheduleNo}">
										<c:out value="${schedule.scheduleDescription}" />
								</a></td>
								<td><c:out value="${schedule.scheduleInstructor}" /></td>
							</tr>
						</c:forEach>
					</tbody>
				</table>

				<div class="pageInfo_wrap">
					<div class="pageInfo_area">
						<ul id="pageInfo" class="pageInfo">

							<!-- 이전페이지 버튼 -->
							<c:if test="${pageMaker.prev}">
								<li class="pageInfo_btn previous"><a
									href="${pageContext.request.contextPath}/journal/scheduleList?pageNum=${pageMaker.cri.pageNum - 1}&amount=${pageMaker.cri.amount}&keyword=${param.keyword}&category=${pageMaker.cri.category}&year=${param.year}&month=${param.month}">이전</a>
								</li>
							</c:if>

							<!-- 각 번호 페이지 버튼 -->
							<c:forEach var="num" begin="${pageMaker.pageStart}"
								end="${pageMaker.pageEnd}">
								<li
									class="pageInfo_btn ${pageMaker.cri.pageNum == num ? 'active' : ''}">
									<a
									href="${pageContext.request.contextPath}/journal/scheduleList?pageNum=${num}&amount=${pageMaker.cri.amount}&keyword=${param.keyword}&category=${pageMaker.cri.category}&year=${param.year}&month=${param.month}">${num}</a>
								</li>
							</c:forEach>

							<!-- 다음페이지 버튼 -->
							<c:if test="${pageMaker.next}">
								<li class="pageInfo_btn next"><a
									href="${pageContext.request.contextPath}/journal/scheduleList?pageNum=${pageMaker.pageEnd + 1}&amount=${pageMaker.cri.amount}&keyword=${param.keyword}&category=${pageMaker.cri.category}&year=${param.year}&month=${param.month}">다음</a>
								</li>
							</c:if>
						</ul>
					</div>
					<p class="totalCount">총 ${pageMaker.total}건</p>
				</div>
			</div>
		</div>
	</main>

	<!-- 푸터 연결 -->
	<%@ include file="../common/footer.jsp"%>

	<script
		src='https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.js'></script>
	<script src="https://code.jquery.com/jquery-latest.min.js"></script>
	<script>
    document.addEventListener('DOMContentLoaded', function() {
        // FullCalendar 초기화
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

    $(document).ready(function() {
        // 테이블 행 클릭 시 상세 페이지로 이동
        $('table tbody tr').click(function() {
            var scheduleNo = $(this).data('schedule-no');
            if (scheduleNo) {
                window.location.href = '${pageContext.request.contextPath}/journal/scheduleDetail?scheduleNo=' + scheduleNo;
            }
        });

        // 수강생 목록 로드 함수
        function loadMembers() {
            var classNo = $('#classSelect').val();
            var url = '${pageContext.request.contextPath}/journal/loadMembers?classNo=' + classNo;

            $.get(url, function(data) {
                var memberSelect = $('#memberName');
                memberSelect.empty();
                memberSelect.append('<option value="">전체</option>');

                $.each(data.memberList, function(index, member) {
                    memberSelect.append('<option value="' + member.memberId + '">' + member.memberName + '</option>');
                });
            });
        }

        // 함수 바깥으로 빼는 것을 잊지 마세요
        window.loadMembers = loadMembers;
    });
</script>

</body>
</html>