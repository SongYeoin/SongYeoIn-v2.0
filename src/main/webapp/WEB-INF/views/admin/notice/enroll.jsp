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

.notice-wrapper {
	width: 70%;
    background-color: #fff;
    padding: 20px;
    margin: 20px auto;
}

.notice-wrapper h2 {
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

table th {
    background-color: #f4f4f4;
    color: #333;
    font-weight: bold;
}

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
    gap:20px;
}



</style>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
</head>
<body>

    <!-- 메뉴바 연결 -->
    <%@ include file="../../common/header.jsp"%>

	<div class="classroom-header">
			<i class="bi bi-house-fill" onclick="location.href='${pageContext.servletContext.contextPath}/admin/class/getClassList'"></i>
            <div class="title">${syclass.className}</div>
            <div class="details">담당자: ${syclass.managerName} | 강사명: ${syclass.teacherName}</div>
    </div>

        
    <!-- 사이드바 연결 -->    
    <%@ include file="../class/aside.jsp"%>

    <main>
        <!-- Main content -->
            <div class="notice-wrapper">
				<form id="noticeForm" action="${pageContext.servletContext.contextPath}/admin/class/notice/enroll" method="post" enctype="multipart/form-data">
					<table>
						<tr>
							<th>제목</th>
							<td><input type="text" id="noticeTitle" name="noticeTitle" required/></td>
						</tr>
						<tr>
							<th>작성자</th>
							<td>${sessionScope.loginMember.memberName}</td>
						</tr>
						<tr>
							<th>내용</th>
							<td colspan="3"><textarea id="noticeContent" name="noticeContent" cols="50" rows="5" required></textarea></td>
						</tr>
						<tr>
							<th>첨부파일</th>
							<td colspan="3"><input type="file" id="files" name="files" multiple></td>
						</tr>
						<tr>
							<th>옵션</th>
							<td>
								<input type="checkbox" id="allNotice" name="allNotice" value="true"/>
  								<label for="allNotice">전체 공지</label>
  							</td>
						</tr>
					</table>
					<div class="button-container">
						<button type="button" id="listBtn">목록</button>
						<button type="submit">등록</button>
					</div>
				</form>
				
			</div>
    </main>

    <!-- 푸터 연결 -->
    <%@ include file="../../common/footer.jsp"%>
    
    <script>
    $("#listBtn").click(function() {
        window.location.href = '${pageContext.servletContext.contextPath}/admin/class/notice/list';
    });

	</script>

</body>
</html>
