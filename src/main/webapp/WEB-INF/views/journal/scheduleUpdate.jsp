<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Update Schedule</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css">
    <style>
        /* 기본 스타일 및 CSS Reset */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        html, body {
            height: 100%;
            font-family: Arial, sans-serif;
        }

        body {
            display: flex;
            flex-direction: column;
            background-color: #f4f4f4; /* 배경색 설정 */
            padding-top: 60px; /* 헤더 높이만큼 상단 여백 추가 */
        }

        header {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            background-color: #fff;
            border-bottom: 1px solid #ddd;
            padding: 10px 20px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            z-index: 1000; /* 헤더가 콘텐츠 위에 보이도록 설정 */
        }

        main {
            flex: 1;
            margin-left: 250px;
            padding: 20px;
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

        /* 경고 메시지 스타일 */
        .warning {
            color: red;
            font-size: 0.875em;
            display: none; /* 기본적으로 숨김 */
        }
    </style>
</head>
<body>

    <!-- header 영역 -->
    <%@ include file="../common/header.jsp"%>

    <!-- 사이드바 연결 -->
    <%@ include file="../admin/aside.jsp"%>

    <main>
        <div class="container">
            <div class="form-container">
                <h1>교육 일정 수정하기</h1>
                <!-- 일정 업데이트 폼 -->
                <form id="scheduleForm" action="${pageContext.request.contextPath}/journal/scheduleUpdate" method="post">
                    <input type="hidden" name="scheduleNo" value="${schedule.scheduleNo}" />
                    
                    <div class="form-group">
                        <label for="scheduleTitle">단원명:</label>
                        <input type="text" name="scheduleTitle" id="scheduleTitle" value="${schedule.scheduleTitle}" required />
                        <span id="warn_scheduleTitle" class="warning">단원명을 입력해주세요.</span>
                    </div>

                    <div class="form-group">
                        <label for="scheduleDate">일자:</label>
                        <input type="date" name="scheduleDate" id="scheduleDate" value="${schedule.scheduleDate}" required />
                        <span id="warn_scheduleDate" class="warning">일자를 입력해주세요.</span>
                    </div>

                    <div class="form-group">
                        <label for="scheduleDescription">학습주제:</label>
                        <input type="text" name="scheduleDescription" id="scheduleDescription" value="${schedule.scheduleDescription}" />
                    </div>

                    <div class="form-group">
                        <label for="scheduleInstructor">강사:</label>
                        <input type="text" name="scheduleInstructor" id="scheduleInstructor" value="${schedule.scheduleInstructor}" />
                    </div>

                    <div class="form-group">
                        <input type="submit" value="교육 일정 수정하기" />
                    </div>

                    <a href="${pageContext.request.contextPath}/journal/scheduleList">목록</a>
                </form>
            </div>
        </div>

        <!-- 푸터 연결 -->
        <%@ include file="../common/footer.jsp"%>
    </main>

    <script>
        document.getElementById('scheduleForm').addEventListener('submit', function(event) {
            let valid = true;

            // 단원명 검사
            let scheduleTitle = document.getElementById('scheduleTitle').value;
            let titleWarning = document.getElementById('warn_scheduleTitle');
            if (scheduleTitle.trim() === '') {
                titleWarning.style.display = 'block';
                valid = false;
            } else {
                titleWarning.style.display = 'none';
            }

            // 일자 검사
            let scheduleDate = document.getElementById('scheduleDate').value;
            let dateWarning = document.getElementById('warn_scheduleDate');
            if (scheduleDate.trim() === '') {
                dateWarning.style.display = 'block';
                valid = false;
            } else {
                dateWarning.style.display = 'none';
            }

            if (!valid) {
                event.preventDefault(); // 폼 제출 방지
            }
        });
    </script>

</body>
</html>
