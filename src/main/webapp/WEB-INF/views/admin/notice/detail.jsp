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

.main-content {
    padding: 20px;
}

.notice-wrapper {
    width: 70%;
    background-color: #fff;
    padding: 20px;
    margin: 20px auto;
}

.notice-wrapper h2 {
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
            <h2>공지사항</h2>
            <table>
                <thead>
                	<tr>
                        <th>작성자</th>
                        <td>${notice.member.memberName}</td>
                        <th>등록일</th>
                        <td>${notice.noticeRegDate}</td>
                        <th>조회수</th>
                        <td>${notice.noticeCount}</td>
                    </tr>
                    <tr>
                    	<th>제목</th>
                        <td colspan="5">${notice.noticeTitle}</td>
                    </tr>
                    
                    <tr>
                        <th>내용</th>
                        <td colspan="5">
                        	<div class="table-content">
					            ${notice.noticeContent}
					        </div>
						</td>
                    </tr>
                    <c:if test="${not empty fileList}">
                        <tr>
                            <th>첨부파일</th>
                            <td colspan="3">
                                <ul class="file-list">
                                    <c:forEach var="file" items="${fileList}">
                                        <li>
                                            <a href="${pageContext.servletContext.contextPath}/admin/class/notice/download?fileNo=${file.fileNo}" download="${file.fileOriginalName}">
                                                ${file.fileOriginalName}
                                            </a>
                                        </li>
                                    </c:forEach>
                                </ul>
                            </td>
                        </tr>
                    </c:if>
                </thead>
            </table>

            <div class="button-container">
                <button type="button" id="listBtn">목록</button>
                <c:if test="${sessionScope.loginMember.memberRole eq 'ROLE_ADMIN' and sessionScope.loginMember.memberNo eq notice.member.memberNo }">
                    <button id="updateBtn">수정</button>
                    <button id="deleteBtn" onclick="deleteNotice(${notice.noticeNo})">삭제</button>
                </c:if>
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
        window.location.href = '${pageContext.servletContext.contextPath}/admin/class/notice/list';
    });
    
    $("#updateBtn").click(function() {
        var noticeNo = ${notice.noticeNo}; // Retrieve noticeNo from JSP variable
        window.location.href = '${pageContext.servletContext.contextPath}/admin/class/notice/modify?noticeNo=' + noticeNo;
    });
    
    function deleteNotice(noticeNo) {
        if (confirm("정말로 삭제하시겠습니까?")) {
            $.ajax({
                url: "/admin/class/notice/delete",
                type: "POST",
                data: { noticeNo: noticeNo },
                success: function(response) {
                    if (response === 'success') {
                        alert("공지사항이 삭제되었습니다.");
                        window.location.href = "/admin/class/notice/list"; 
                    } else {
                        alert("공지사항 삭제에 실패했습니다.");
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