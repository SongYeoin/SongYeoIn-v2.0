<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Update Schedule</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css">
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
        }

        .container {
            margin-left: 270px; /* Sidebar width + padding */
            padding-top: 80px; /* Space for header */
            padding-bottom: 60px; /* Space for footer */
        }

        .form-container {
            max-width: 600px;
            margin: 0 auto;
            padding: 20px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }

        .form-container h1 {
            margin-bottom: 20px;
            font-size: 24px;
            color: #333;
        }

        .form-group {
            margin-bottom: 15px;
        }

        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: #333;
        }

        .form-group input {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }

        .form-group input[type="submit"] {
            background-color: #007bff;
            color: #fff;
            border: none;
            cursor: pointer;
            font-size: 16px;
        }

        .form-group input[type="submit"]:hover {
            background-color: #0056b3;
        }

        .form-container a {
            display: inline-block;
            margin-top: 10px;
            color: #007bff;
            text-decoration: none;
        }

        .form-container a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

    <!-- header 영역 -->
    <%@ include file="../common/header.jsp"%>

    <!-- 사이드바 연결 -->
    <%@ include file="../member/aside.jsp"%>

    <div class="container">
        <div class="form-container">
            <h1>Update Schedule</h1>
            <!-- 일정 업데이트 폼 -->
            <form action="${pageContext.request.contextPath}/journal/scheduleUpdate" method="post">
                <input type="hidden" name="scheduleNo" value="${schedule.scheduleNo}" />
                <div class="form-group">
                    <label for="scheduleTitle">Title:</label>
                    <input type="text" name="scheduleTitle" id="scheduleTitle" value="${schedule.scheduleTitle}" required />
                </div>
                <div class="form-group">
                    <label for="scheduleDate">Date:</label>
                    <input type="date" name="scheduleDate" id="scheduleDate" value="${schedule.scheduleDate}" required />
                </div>
                <div class="form-group">
                    <label for="scheduleDescription">Description:</label>
                    <input type="text" name="scheduleDescription" id="scheduleDescription" value="${schedule.scheduleDescription}" />
                </div>
                <div class="form-group">
                    <label for="scheduleInstructor">Instructor:</label>
                    <input type="text" name="scheduleInstructor" id="scheduleInstructor" value="${schedule.scheduleInstructor}" />
                </div>
                <div class="form-group">
                    <input type="submit" value="Update Schedule" />
                </div>
                <a href="${pageContext.request.contextPath}/journal/scheduleList">Back to List</a>
            </form>
        </div>
    </div>

    <!-- 푸터 연결 -->
    <%@ include file="../common/footer.jsp"%>

</body>
</html>
