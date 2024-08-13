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

.notice-details {
    border-bottom: 1px solid #ddd;
    padding-bottom: 20px;
    margin-bottom: 20px;
}

.notice-details h2 {
    color: #333;
    font-size: 1.5em;
}

.notice-details .date {
    color: #888;
    font-size: 0.9em;
}

.notice-details .content {
    margin-top: 10px;
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
        <div class="content">
        	<div class="notice-wrapper">
                <h2>${notice.noticeTitle}</h2>
                <p><i class="bi bi-calendar"></i> ${notice.noticeRegDate}</p>
                <p><i class="bi bi-eye"></i> ${notice.noticeCount}</p>
                <p>${notice.member.memberName}</p>
                <p>${notice.noticeContent}</p>
                
                <c:if test="${not empty fileList}">
                   <p>첨부파일</p>
                   <c:forEach var="file" items="${fileList}">
                   	<a href="${pageContext.servletContext.contextPath}/admin/class/notice/download?fileNo=${file.fileNo}" download="${file.fileOriginalName}">
                   		${file.fileOriginalName}
                   	</a>
                   	<br>
                   </c:forEach>
                </c:if>
                
                <div class="button-container">
                    <button type="button" id="listBtn" class="listBtn">목록</button>
                    <c:if test="${ sessionScope.loginMember.memberRole eq 'ROLE_ADMIN' and sessionScope.loginMember.memberNo eq notice.member.memberNo }">
					<button id="updateBtn">수정</button>
					<button id="deleteBtn" onclick="deleteNotice(${notice.noticeNo})">삭제</button>
					</c:if>
                </div>
            </div>
            
        </div>
    </main>

    <!-- 푸터 연결 -->
    <%@ include file="../../common/footer.jsp"%>
    
    <script>
    $("#listBtn").click(function() {
        window.location.href = '${pageContext.servletContext.contextPath}/admin/class/notice/list';
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
