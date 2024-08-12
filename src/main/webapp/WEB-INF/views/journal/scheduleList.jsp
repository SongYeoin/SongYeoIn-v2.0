<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Schedule List</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href='https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.css' rel='stylesheet' />
    <script src='https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.js'></script>
    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
        }

        header {
            background-color: #f8f9fa;
            padding: 10px;
            border-bottom: 1px solid #ddd;
            position: fixed;
            top: 0;
            left: 250px; /* Position to the right of the sidebar */
            width: calc(100% - 250px); /* Full width minus sidebar width */
            z-index: 1000; /* Ensure it stays above other elements */
        }

        .sidebar {
            width: 250px;
            background-color: #F2F2F2;
            color: #333333;
            height: calc(100vh - 70px); /* Full height minus header height */
            position: fixed;
            top: 70px; /* Below the header */
            left: 0;
            overflow-y: auto;
            border-right: 1px solid #ddd;
            padding-top: 20px;
            padding-left: 10px;
            z-index: 500; /* Ensure it is below the header but above content */
        }

        .main-content {
            margin-left: 250px; /* Leave space for the sidebar */
            padding: 20px;
            padding-top: 80px; /* Space for header */
            position: relative;
            z-index: 1; /* Ensure content is above sidebar */
        }

        /* footer {
            background-color: #f8f9fa;
            padding: 10px;
            border-top: 1px solid #ddd;
            position: fixed;
            bottom: 0;
            left: 250px; /* Position to the right of the sidebar */
            width: calc(100% - 250px); /* Full width minus sidebar width */
            z-index: 1000; /* Ensure it stays above other elements */
        } */

        #calendar {
            max-width: 100%; /* Ensure calendar does not overflow */
            margin: 0 auto; /* Center calendar */
            height: 60vh; /* Adjust height as needed */
        }

        .search_area {
            margin-bottom: 20px;
        }

        .search_area form {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
        }

        .search_area label {
            margin-right: 5px;
            display: flex;
            align-items: center;
        }

        .search_area input[type="text"],
        .search_area select {
            margin-right: 10px;
            padding: 5px;
            font-size: 14px;
        }

        .search_area button {
            padding: 5px 10px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
        }

        .search_area button:hover {
            background-color: #0056b3;
        }

        .schedule-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        .schedule-table th,
        .schedule-table td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
        }

        .schedule-table th {
            background-color: #f4f4f4;
        }

        .schedule-table tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        .schedule-table tr:hover {
            background-color: #f1f1f1;
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
			color: #007bff;
			font-size: 16px;
			padding: 6px 12px;
			border-radius: 4px;
		}
		
		.pageInfo a:hover {
			background-color: #007bff;
			color: #fff;
		}
		
		.active a {
			background-color: #007bff;
			color: #fff;
		}
        
    </style>
</head>
<body>
    <header>
        <%@ include file="../common/header.jsp"%>
    </header>

    <div class="sidebar">
        <!-- 사이드바 연결 -->
        <%@ include file="../member/aside.jsp"%>
    </div>
    
    <div class="main-content">
        <h1>Schedule List</h1>
        <!-- FullCalendar 출력 영역 -->
        <div id='calendar'></div>
        
        <div class="search_area">
            <form id="searchForm" method="get" action="${pageContext.request.contextPath}/journal/scheduleList">
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
        
        <!-- 새로운 일정 생성 페이지로 이동 -->
        <a href="${pageContext.request.contextPath}/journal/scheduleCreate">새 교육일정 등록</a>
        
        <!-- 일정 리스트 출력 -->
        <table class="schedule-table">
            <thead>
                <tr>
                    <th>글번호</th> <!-- 글번호 열 추가 -->
                    <th>일정 날짜</th>
                    <th>제목</th>
                    <th>강사</th> <!-- 강사 열 추가 -->
                </tr>
            </thead>
            <tbody>
                <c:forEach var="schedule" items="${schedules}">
                    <tr>
                        <td>
                            <c:out value="${schedule.scheduleNo}" /> <!-- 글번호 출력 -->
                        </td>
                        <td>
                            <c:out value="${schedule.scheduleDate}" />
                        </td>
                        <td>
                            <a href="${pageContext.request.contextPath}/journal/scheduleDetail?scheduleNo=${schedule.scheduleNo}">
                                <c:out value="${schedule.scheduleTitle}" />
                            </a>
                        </td>
                        <td>
                            <c:out value="${schedule.scheduleInstructor}" /> <!-- 강사 정보 출력 -->
                        </td>
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
									<a href="${pageContext.request.contextPath}/journal/scheduleList?pageNum=${pageMaker.cri.pageNum - 1}&amount=${pageMaker.cri.amount}&keyword=${param.keyword}&year=${param.year}&month=${param.month}">Previous</a>
								</li>
							</c:if>

							<!-- 각 번호 페이지 버튼 -->
							<c:forEach var="num" begin="${pageMaker.pageStart}" end="${pageMaker.pageEnd}">
								<li class="pageInfo_btn ${pageMaker.cri.pageNum == num ? 'active' : ''}">
									<a href="${pageContext.request.contextPath}/journal/scheduleList?pageNum=${num}&amount=${pageMaker.cri.amount}&keyword=${param.keyword}&year=${param.year}&month=${param.month}">${num}</a>
								</li>
							</c:forEach>

							<!-- 다음페이지 버튼 -->
							<c:if test="${pageMaker.next}">
								<li class="pageInfo_btn next">
									<a href="${pageContext.request.contextPath}/journal/scheduleList?pageNum=${pageMaker.pageEnd + 1}&amount=${pageMaker.cri.amount}&keyword=${param.keyword}&year=${param.year}&month=${param.month}">Next</a>
								</li>
							</c:if>

						</ul>
					</div>
				</div>
    </div>
    
    <footer>
        <%@ include file="../common/footer.jsp"%>
    </footer>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            var calendarEl = document.getElementById('calendar');
            var calendar = new FullCalendar.Calendar(calendarEl, {
                initialView: 'dayGridMonth',
                events: [
                    <c:forEach var="schedule" items="${schedules}">
                        {
                            title: '${schedule.scheduleTitle}',
                            start: '${schedule.scheduleDate}',
                            url: '${pageContext.request.contextPath}/journal/scheduleDetail?scheduleNo=${schedule.scheduleNo}'
                        }<c:if test="${not empty schedule}">
                            ,
                        </c:if>
                    </c:forEach>
                ],
                eventClick: function(info) {
                    // 클릭된 이벤트의 URL로 리디렉션
                    if (info.event.url) {
                        window.location.href = info.event.url;
                    }
                }
            });
            calendar.render();
        });
    </script>
</body>
</html>
