<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>송파여성인력개발센터</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
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
            
            <!-- 좋아요 기능 -->    
            <div class="button-container">
                <button id="heartBtn" data-boardNo="${board.boardNo}">
                	<i id="heartIcon" class="bi ${heartCount > 0 ? 'bi-heart-fill' : 'bi-heart' }"></i>
                </button>
                <span id="boardHeartCount">${ board.boardHeartCount }</span> 
            </div>

            <!-- 댓글 추가 폼 -->
            <form action="${pageContext.request.contextPath}/member/board/comment/add" method="post">
                <input type="hidden" name="boardNo" value="${board.boardNo}" />
                <textarea name="commentContent" rows="4" placeholder="댓글을 입력하세요"></textarea>
                <button type="submit">등록</button>
            </form>

            <!-- 댓글 리스트 -->
            <c:forEach var="comment" items="${commentList}">
                <div id="comment-${comment.commentNo}" class="comment">
                    <p><strong>${comment.member.memberNickname}</strong> ${comment.commentRegDate}</p>
                    
                    <c:if test="${sessionScope.loginMember.memberNo eq comment.commentMemberNo}">
                        <!-- 댓글 수정 폼 -->
			            <form id="edit-form-${comment.commentNo}" class="edit-form" style="display:none;" action="${pageContext.request.contextPath}/member/board/comment/modify" method="post">
			                <input type="hidden" name="commentNo" value="${comment.commentNo}" />
			                <textarea name="commentContent" rows="4">${comment.commentContent}</textarea>
			                <button type="submit">수정</button>
			                <button type="button" onclick="cancelEdit(${comment.commentNo})">취소</button>
			            </form>
			
			            <!-- 댓글 수정 버튼 -->
			            <button id="updateCommentBtn-${comment.commentNo}" onclick="editComment(${comment.commentNo})">수정</button>
			            
			            <!-- 댓글 삭제 버튼 -->
			            <button id="deleteCommentBtn" onclick="deleteComment(${comment.commentNo})">삭제</button>
                    </c:if>
                    
                    <!-- 댓글 -->
                    <p id="comment-content-${ comment.commentNo }">${comment.commentContent}</p>
                </div>
            </c:forEach>

			<!-- 게시글 버튼 -->
            <div class="button-container">
                <button type="button" id="listBtn">목록</button>
                <c:if test="${sessionScope.loginMember.memberNo eq board.boardMemberNo }">
                    <button id="updateBtn">수정</button>
                    <button id="deleteBtn" onclick="deleteboard(${board.boardNo})">삭제</button>
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
        window.location.href = '${pageContext.servletContext.contextPath}/member/board/list';
    });
    
    $("#updateBtn").click(function() {
        var boardNo = ${board.boardNo}; 
        window.location.href = '${pageContext.servletContext.contextPath}/member/board/modify?boardNo=' + boardNo;
    });
    
    function deleteboard(boardNo) {
        if (confirm("정말로 삭제하시겠습니까?")) {
            $.ajax({
                url: "/member/board/delete",
                type: "POST",
                data: { boardNo: boardNo },
                success: function(response) {
                    if (response === 'success') {
                        alert("삭제되었습니다.");
                        window.location.href = "/member/board/list"; 
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
    
    function editComment(commentNo) {
        document.getElementById('comment-content-' + commentNo).style.display = 'none';
        document.getElementById('edit-form-' + commentNo).style.display = 'block';
    }

    function cancelEdit(commentNo) {
        document.getElementById('edit-form-' + commentNo).style.display = 'none';
        document.getElementById('comment-content-' + commentNo).style.display = 'block';
    }
    
    function deleteComment(commentNo) {
        if (confirm("정말로 이 댓글을 삭제하시겠습니까?")) {
            $.ajax({
                url: "${pageContext.request.contextPath}/member/board/comment/delete",
                type: "POST",
                data: { commentNo: commentNo },
                success: function(response) {
                    if (response === 'success') {
                        alert("댓글이 삭제되었습니다.");
                        $("#comment-" + commentNo).remove();
                    } else {
                        alert("댓글 삭제에 실패했습니다.");
                    }
                },
                error: function() {
                    alert("서버 오류가 발생했습니다.");
                }
            });
        }
    }
    
    $('#heartBtn').click(function() {
    	var button = $(this);
        var boardNo = button.data('boardno');
    	
        $.ajax({
            url: "${pageContext.request.contextPath}/member/board/heart", 
            type: "POST",
            data: { boardNo: boardNo },
            success: function(response) {
                var heartIcon = $('#heartIcon');
                var heartCount = $('#boardHeartCount');
                if (response === 'heartAdded') {
                    heartIcon.removeClass('bi-heart').addClass('bi-heart-fill');
                    heartCount.text(parseInt(heartCount.text()) + 1);
                } else if (response === 'heartRemoved') {
                    heartIcon.removeClass('bi-heart-fill').addClass('bi-heart');
                    heartCount.text(parseInt(heartCount.text()) - 1);
                } else {
                    alert('좋아요 처리에 실패했습니다.');
                }
            },
            error: function() {
                alert('네트워크 오류가 발생했습니다.');
            }
        });
    });
    </script>

</body>
</html>