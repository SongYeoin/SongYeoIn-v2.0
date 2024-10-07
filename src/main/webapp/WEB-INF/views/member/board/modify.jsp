<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>송파여성인력센터</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<style>
/* CSS Reset */
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

html, body {
    height: auto;
}

body {
    font-family: Arial, sans-serif;
    display: flex;
    flex-direction: column;
    /* min-height: 100vh; */
}

main {
    flex: 1;
    margin-left: 250px;
    margin-top: 160px;
    overflow-y: auto;
    min-height: 100vh;
}

.content {
    padding: 20px;
    background-color: #fff;
}

.content h2 {
    margin-bottom: 20px;
}

.bi-house-fill {
	cursor: pointer;
	font-size: 20px;
}

.board-wrapper {
	width: 70%;
    background-color: #fff;
    padding: 20px;
    margin: 20px auto;
}

/* 공지사항 제목 스타일 */
.board-wrapper h2 {
    margin-bottom: 30px;
}

/* 테이블 스타일 */
table {
    width: 100%;
    border-collapse: collapse;
    margin-bottom: 20px;
}

table th, table td {
    padding: 10px;
    text-align: left;
    border-bottom: 1px solid #ddd;
    font-size: 14px;
}

/* 테이블 헤더 스타일 */
table th {
    background-color: #f4f4f4;
    color: #333;
    font-weight: bold;
}

/* 테이블 행 스타일 */
table tr {
    transition: background-color 0.3s ease;
}

button {
    border: none;
    border-radius: 4px;
    color: white;
    padding: 10px 20px;
    font-size: 16px;
    cursor: pointer;
    margin: 5px;
} 

button {
    background-color: #007bff; /* 버튼 배경색 */
    transition: background-color 0.3s ease;
}

button:hover {
    background-color: #0056b3; /* 버튼 호버시 배경색 */
}

.button-container {
    display: flex;
    justify-content: center;
    margin-top: 20px;
    gap: 20px;
}

.checkbox-container {
    margin-top: 20px;
}

.checkbox-container input {
    margin-right: 10px;
}

.file-list {
    margin-top: 10px;
    list-style: none;
    padding: 0;
}

.file-list li {
    margin-bottom: 10px;
}

.file-list a {
    text-decoration: none;
    color: #007bff;
}

.file-list a:hover {
    text-decoration: underline;
}

</style>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
</head>
<body>

    <!-- 메뉴바 연결 -->
    <%@ include file="../../common/header.jsp"%>

    <!-- 사이드바 연결 -->
    <%@ include file="../aside.jsp"%>

    <main>
        <!-- Main content -->
        <div class="board-wrapper">
            <h2 align="center"></h2>
            <form id="boardForm" action="${pageContext.servletContext.contextPath}/member/board/modify" method="post" enctype="multipart/form-data">
                <input type="hidden" name="boardNo" value="${board.boardNo}" />
                <table>
                    <tr>
                        <th>제목</th>
                        <td><input type="text" id="boardTitle" name="boardTitle" value="${board.boardTitle}" required/></td>
                    </tr>
                    <tr>
                        <th>작성자</th>
                        <td>${sessionScope.loginMember.memberNickname}</td>
                    </tr>
                    <tr>
                        <th>내용</th>
                        <td colspan="3"><textarea id="boardContent" name="boardContent" cols="50" rows="5" required>${board.boardContent}</textarea></td>
                    </tr>
                </table>
                <div class="button-container">
                    <button type="button" id="listBtn">목록</button>
                    <button type="submit">수정</button>
                </div>
            </form>
        </div>
    </main>

    <!-- 푸터 연결 -->
    <%@ include file="../../common/footer.jsp"%>

    <script>
    let message = '${message}';
	if(message) {
		alert(message);
	}
	
    $("#listBtn").click(function() {
        window.location.href = '${pageContext.servletContext.contextPath}/member/board/list';
    });
    </script>

</body>
</html>
