<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>교육일지 수정</title>
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

        .box {
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            padding: 20px;
            max-width: 800px;
            margin: 0 auto; /* 페이지 중앙 정렬 */
        }

        h1 {
            margin-bottom: 20px;
            color: #333;
            font-size: 24px;
            border-bottom: 2px solid #007bff;
            padding-bottom: 10px;
        }

        form {
            display: flex;
            flex-direction: column;
        }

        form div {
            margin-bottom: 15px;
        }

        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: #333;
        }

        input[type="text"], input[type="date"] {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }

        input[type="file"] {
            border: none;
        }

        button {
            background-color: #007bff;
            color: #fff;
            border: none;
            padding: 10px 15px;
            border-radius: 5px;
            cursor: pointer;
            margin-right: 10px;
        }

        button:hover {
            background-color: #0056b3;
        }

        a.button {
            background-color: #6c757d;
            color: #fff;
            padding: 10px 15px;
            text-decoration: none;
            border-radius: 5px;
        }

        a.button:hover {
            background-color: #5a6268;
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
        <h1>교육일지 수정</h1>

        <form action="${pageContext.request.contextPath}/journal/journalModify.do" method="post" enctype="multipart/form-data">
            <input type="hidden" name="journalNo" value="${journal.journalNo}" />

            <div>
                <label for="journalTitle">제목:</label>
                <input type="text" id="journalTitle" name="journalTitle" value="${journal.journalTitle}" required />
            </div>

            <div>
                <label for="journalWriteDate">작성일자:</label>
                <input type="date" id="journalWriteDate" name="journalWriteDate" value="${journal.journalWriteDate}" required />
            </div>

            <div>
                <label for="file">첨부파일:</label>
                <input type="file" id="file" name="file" />
            </div>

            <div>
                <button type="submit">확인</button>
                <a href="${pageContext.request.contextPath}/journal/journalList" class="button">취소</a>
            </div>
        </form>
    </div>
</main>

<!-- 푸터 연결 -->
<%@ include file="../common/footer.jsp"%>

</body>
</html>
