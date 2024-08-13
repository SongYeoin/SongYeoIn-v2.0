<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>교육 일정</title>
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
            left: 250px;
            width: calc(100% - 250px);
            z-index: 1000;
        }

        .sidebar {
            width: 250px;
            background-color: #F2F2F2;
            color: #333333;
            height: calc(100vh - 70px);
            position: fixed;
            top: 70px;
            left: 0;
            overflow-y: auto;
            border-right: 1px solid #ddd;
            padding-top: 20px;
            padding-left: 10px;
            z-index: 500;
        }

        .main-content {
            margin-left: 250px;
            padding: 20px;
            padding-top: 80px;
            position: relative;
            z-index: 1;
        }

        #calendar {
            max-width: 100%;
            margin: 0 auto;
            height: 80vh; /* Adjust height to ensure all dates are visible */
            background-color: #ffffff;
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

        .search_area select,
        .search_area button {
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
        
        /* Custom FullCalendar Styles */
        .fc {
            font-family: Arial, sans-serif;
        }

        .fc-daygrid-day-number {
            color: #333;
        }

        .fc-daygrid-day-top {
            background-color: #f4f4f4;
            border-bottom: 1px solid #ddd;
        }

        .fc-daygrid-day {
            border: 1px solid #ddd;
            background-color: #fff;
        }

        .fc-daygrid-day.fc-day-today {
            background-color: #e9ecef;
        }

        .fc-daygrid-day.fc-day-past {
            background-color: #f0f0f0;
        }

        .fc-daygrid-day.fc-day-future {
            background-color: #ffffff;
        }

        .fc-button {
            background-color: #007bff;
            color: #fff;
        }

        .fc-button:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <header>
        <%@ include file="../common/header.jsp"%>
    </header>

    <div class="sidebar">
        <%@ include file="../member/aside.jsp"%>
    </div>
    
    <div class="main-content">
        <h1>교육 일정</h1>
        <div id='calendar'></div>
        
        <div class="search_area">
            <form id="searchForm" method="get" action="${pageContext.request.contextPath}/journal/scheduleList">
                <label for="category">카테고리 선택:</label>
                <select id="category" name="category">
                    <option value="all" <c:if test="${param.category == 'all'}">selected</c:if>>전체</option>
                    <option value="title" <c:if test="${param.category == 'title'}">selected</c:if>>제목</option>
                    <option value="instructor" <c:if test="${param.category == 'instructor'}">selected</c:if>>강사</option>
                </select>
                
                <label for="keyword">검색어:</label>
                <input type="text" id="keyword" name="keyword" value="${param.keyword}" placeholder="검색어 입력">
                
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
        
        <a href="${pageContext.request.contextPath}/journal/admin/scheduleCreate">새 교육일정 등록</a>
        
        <table class="schedule-table">
            <thead>
                <tr>
                    <th>글번호</th>
                    <th>일정 날짜</th>
                    <th>제목</th>
                    <th>강사</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="schedule" items="${schedules}">
                    <tr>
                        <td>
                            <c:out value="${schedule.scheduleNo}" />
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
                            <c:out value="${schedule.scheduleInstructor}" />
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
        
        <div class="pageInfo_wrap">
            <div class="pageInfo_area">
                <ul id="pageInfo" class="pageInfo">
                    <c:if test="${pageMaker.prev}">
                        <li class="pageInfo_btn previous">
                            <a href="${pageContext.request.contextPath}/journal/scheduleList?pageNum=${pageMaker.cri.pageNum - 1}&amount=${pageMaker.cri.amount}&keyword=${param.keyword}&category=${param.category}&year=${param.year}&month=${param.month}">Previous</a>
                        </li>
                    </c:if>

                    <c:forEach var="num" begin="${pageMaker.pageStart}" end="${pageMaker.pageEnd}">
                        <li class="pageInfo_btn ${pageMaker.cri.pageNum == num ? 'active' : ''}">
                            <a href="${pageContext.request.contextPath}/journal/scheduleList?pageNum=${num}&amount=${pageMaker.cri.amount}&keyword=${param.keyword}&category=${param.category}&year=${param.year}&month=${param.month}">${num}</a>
                        </li>
                    </c:forEach>

                    <c:if test="${pageMaker.next}">
                        <li class="pageInfo_btn next">
                            <a href="${pageContext.request.contextPath}/journal/scheduleList?pageNum=${pageMaker.pageEnd + 1}&amount=${pageMaker.cri.amount}&keyword=${param.keyword}&category=${param.category}&year=${param.year}&month=${param.month}">Next</a>
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
