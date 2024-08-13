<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Journal Main - Calendar View</title>
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
            left: 250px; /* 사이드바 너비만큼 왼쪽으로 이동 */
            width: calc(100% - 250px); /* 사이드바 너비만큼을 제외한 나머지 부분을 차지 */
            z-index: 1000;
        }

        .sidebar {
            width: 250px; /* 사이드바의 너비 */
            background-color: #F2F2F2;
            color: #333333;
            height: 100vh; /* 전체 높이 */
            position: fixed;
            top: 0;
            left: 0;
            overflow-y: auto;
            border-right: 1px solid #ddd;
            padding-top: 70px; /* 헤더 높이만큼 패딩 추가 */
        }

        .main-content {
            margin-left: 250px; /* 사이드바 너비만큼 왼쪽 마진 추가 */
            padding: 20px;
            padding-top: 80px; /* 헤더 높이만큼 패딩 추가 */
            position: relative;
        }

        #calendar {
            max-width: 100%;
            margin: 0 auto;
            height: 80vh;
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
