<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>송파여성인력개발센터</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<style>
/* CSS Reset */
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

html, body {
    height: 1080px;
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
    height: 100%;
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

.main-content {
    padding: 20px;
}

.board-wrapper {
    width: 70%;
    background-color: #fff;
    padding: 20px;
    margin: 20px auto;
}

.board-wrapper h2 {
    margin-bottom: 20px;
    text-align: center;
    font-size: 1.75rem;
}

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

table th {
    background-color: #f4f4f4;
    color: #333;
    font-weight: bold;
}

table td {
    vertical-align: top;
}

.info-row {
    display: flex;
    align-items: center;
}

.info-row div {
    margin-right: 20px;
}

.table-content {
    min-height: 200px; 
    overflow-y: auto; 
    align-items: center; 
}

input[type="text"], textarea, input[type="file"] {
    width: 100%;
    padding: 8px;
    border: 1px solid #ced4da;
    border-radius: 4px;
    font-size: 14px;
}

textarea {
    resize: vertical;
}

button {
    border: none;
    border-radius: 4px;
    color: white;
    padding: 10px 20px;
    font-size: 16px;
    cursor: pointer;
    background-color: #007bff;
    transition: background-color 0.3s ease;
}

button:hover {
    background-color: #0056b3;
}

.button-container {
    display: flex;
    justify-content: center;
    margin-top: 20px;
    gap: 20px;
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
</head>
<body>

    <!-- 메뉴바 연결 -->
    <%@ include file="../../common/header.jsp"%>

    <!-- 사이드바 연결 -->    
    <%@ include file="../aside.jsp"%>

    <main>
        <!-- Main content -->
        <div class="board-wrapper">
            <h2></h2>
            <table>
                <thead>
                	<tr>
                        <th>작성자</th>
                        <td>${board.member.memberNickname}</td>
                        <th>등록일</th>
                        <td>${board.boardRegDate}</td>
                        <th>조회수</th>
                        <td>${board.boardCount}</td>
                    </tr>
                    <tr>
                    	<th>제목</th>
                        <td colspan="5">${board.boardTitle}</td>
                    </tr>
                    
                    <tr>
                        <th>내용</th>
                        <td colspan="5">
                        	<div class="table-content">
					            ${board.boardContent}
					        </div>
						</td>
                    </tr>
                    
                </thead>
            </table>
            
            

            <div class="button-container">
                <button type="button" id="listBtn">목록</button>
                <button id="deleteBtn" onclick="deleteboard(${board.boardNo})">삭제</button>
            </div>
            
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
        window.location.href = '${pageContext.servletContext.contextPath}/admin/board/list';
    });
    
    function deleteboard(boardNo) {
        if (confirm("정말로 삭제하시겠습니까?")) {
            $.ajax({
                url: "/admin/board/delete",
                type: "POST",
                data: { boardNo: boardNo },
                success: function(response) {
                    if (response === 'success') {
                        alert("삭제되었습니다.");
                        window.location.href = "/admin/board/list"; 
                    } else {
                        alert("삭제에 실패했습니다.");
                    }
                },
                error: function() {
                    alert("서버 오류가 발생했습니다.");
                }
            });
        }
    }

    </script>

</body>
</html>