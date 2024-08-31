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
    display: flex;
    flex-direction: column;
}

main {
    flex: 1;
    margin-left: 250px;
    margin-top: 160px;
    overflow-y: auto;
    height: 100%;
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
    margin: 20px;
    gap: 20px;
}

.heart-container {
	color: red;
}

#heartIcon {
	font-size: 22px;
	cursor: pointer;
}

.comment-form-container, .reply-form {
    display: flex; 
    align-items: flex-start; 
    gap: 10px; 
    margin: 10px 0;
}

.comment-form-container form, .reply-form form {
    display: flex; 
    flex: 1; 
}

.comment-form-container textarea, .reply-form textarea {
    flex: 1; 
    margin-right: 10px; 
}

.comment-form-container button, .reply-form button {
    align-self: flex-start; 
}

.comment {
	padding: 10px;
	border-bottom: 1px solid #ddd;
}

.comment-button-container {
    display: flex;
    justify-content: flex-end;
    gap: 10px;
}

.comment-button-container button {
    border: 1px solid #007bff;
    border-radius: 4px;
    color: #007bff;
    background-color: transparent;
    padding: 5px 10px;
    font-size: 12px;
    cursor: pointer;
    transition: background-color 0.3s ease, color 0.3s ease;
}

.comment-button-container button:hover {
    background-color: #007bff;
    color: white;
}

.pageMaker_wrap {
    text-align: center;
    margin-top: 30px;
    margin-bottom: 40px;
}

.pageMaker_wrap a {
    color: black;
}

.pageMaker {
    list-style: none;
    display: inline-block;
}

.pageMaker_btn {
    float: left;
    width: 40px;
    height: 40px;
    line-height: 40px;
    margin-left: 20px;
}

.next, .prev {
    border: 1px solid #ccc;
    padding: 0 10px;
}

.next a, .prev a {
    color: #ccc;
}

.active { /* 현재 페이지 버튼 */
    border: 2px solid black;
    font-weight: 400;
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
            	<div class="heart-container">
	                <i id="heartIcon" class="bi ${heartCount > 0 ? 'bi-heart-fill' : 'bi-heart'}" data-board-no="${board.boardNo}"></i>
	                <span id="boardHeartCount">${board.boardHeartCount}</span> 
                </div>
            </div>
            

            <!-- 댓글 추가 폼 -->
            <div class="comment-form-container">
	            <form action="${pageContext.request.contextPath}/member/board/comment/add" method="post">
	                <input type="hidden" name="boardNo" value="${board.boardNo}" />
	                <textarea name="commentContent" rows="4" placeholder="댓글을 입력하세요"></textarea>
	                <button type="submit">등록</button>
	            </form>
            </div>
            
            
            <!-- 댓글 리스트 -->
            <c:forEach var="comment" items="${commentList}">
            	<c:choose>
            		<c:when test="${comment.commentStatus eq 'N'}">
	            		<div id="comment-${comment.commentNo}" class="comment" style="${comment.commentParentNo != null ? 'margin-left: 40px;' : ''}">
	                		<p>사용자에 의해 삭제된 댓글입니다.</p>
		            	</div>
	        		</c:when>
	        	
		        	<c:otherwise>
	                	<div id="comment-${comment.commentNo}" class="comment" style="${comment.commentParentNo != null ? 'margin-left: 40px;' : ''}">
	                		<c:if test="${comment.commentParentNo != null}">
	                			<i class="bi bi-arrow-return-right"></i>
	                		</c:if>
	                    	<p>
	                    		<strong>
								    <c:choose>
								        <c:when test="${board.boardMemberNo == comment.commentMemberNo}">
								            ${comment.member.memberNickname}
								            <span style="color: skyblue;">(작성자)</span>
								        </c:when>
								
								        <c:when test="${comment.member.memberRole == 'ROLE_ADMIN'}">
								            <span style="color: red;">관리자</span>
								        </c:when>
								
								        <c:otherwise>
								        	${comment.member.memberNickname}
								        </c:otherwise>
								    </c:choose>
								</strong>
	                    		${comment.commentRegDate}
	                    	</p>
	                    	<p id="comment-content-${comment.commentNo}">
	                    		<c:if test="${comment.commentParentNo != null}">
	                    			<strong style="color: blue;">@${comment.parentNickname} </strong>
	                    		</c:if>
								${comment.commentContent}
							</p>
	                    
	                    	<!-- 댓글 버튼 -->
				        	<div class="comment-button-container">
					        	<button id="replyBtn-${comment.commentNo}" class="replyBtn" onclick="showReplyForm(${comment.commentNo})">답글</button>
	                    		<c:if test="${sessionScope.loginMember.memberNo eq comment.commentMemberNo}">
				            		<button id="updateCommentBtn-${comment.commentNo}" onclick="editComment(${comment.commentNo})">수정</button>
				            		<button id="deleteCommentBtn-${comment.commentNo}" onclick="deleteComment(${comment.commentNo}, ${comment.commentBoardNo })">삭제</button>
	                    		</c:if>
				        	</div>
				        
				        	<!-- 댓글 수정 폼 -->
				        	<form id="edit-form-${comment.commentNo}" class="edit-form" style="display:none;">
					        	<input type="hidden" name="commentNo" value="${comment.commentNo}" />
			                    <textarea name="commentContent" rows="4">${comment.commentContent}</textarea>
			                    <div class="comment-button-container">
			                    	<button type="button" onclick="submitEdit(${comment.commentNo})">수정</button>
			                    	<button type="button" onclick="cancelEdit(${comment.commentNo})">취소</button>
			                    </div>
			                </form>
		                
					        <!-- 답글 작성 폼 -->
					        <div id="reply-form-${comment.commentNo}" class="reply-form" style="display:none;">
					            <form action="${pageContext.request.contextPath}/member/board/comment/add" method="post">
					                <input type="hidden" name="boardNo" value="${board.boardNo}" />
					                <input type="hidden" name="parentCommentNo" value="${comment.commentNo}" />
					                <textarea name="commentContent" rows="4" placeholder="답글을 입력하세요"></textarea>
					                <button type="submit">등록</button>
					            </form>
					        </div>
						</div>
					</c:otherwise>
    			</c:choose>
			</c:forEach>

			<!-- 페이지 이동 인터페이스 영역 -->
			<div class="pageMaker_wrap">
				<ul class="pageMaker">
					<!-- 이전 버튼 -->
					<c:if test="${pageMaker.prev}">
						<li class="pageMaker_btn prev"><a href="?boardNo=${board.boardNo}&pageNum=${pageMaker.pageStart - 1}">이전</a></li>
					</c:if>

					<!-- 페이지 번호 -->
					<c:forEach begin="${pageMaker.pageStart}" end="${pageMaker.pageEnd}" var="num">
						<li class="pageMaker_btn ${pageMaker.cri.pageNum == num ? "active" : ""}"><a href="?boardNo=${board.boardNo}&pageNum=${num}">${num}</a></li>
					</c:forEach>

					<!-- 다음 버튼 -->
					<c:if test="${pageMaker.next}">
						<li class="pageMaker_btn next"><a href="?boardNo=${board.boardNo}&pageNum=${pageMaker.pageEnd + 1}">다음</a></li>
					</c:if>
				</ul>
			</div>
			
			<form id="moveForm" action="${pageContext.servletContext.contextPath}/member/board/detail" method="get">
				<input type="hidden" name="boardNo" value="${board.boardNo}">
				<input type="hidden" name="pageNum" value="${pageMaker.cri.pageNum}">
				<input type="hidden" name="amount" value="${pageMaker.cri.amount}">
			</form>

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
    
  	//페이지 이동 버튼
    $(".pageMaker_btn a").on("click", function(e){
        e.preventDefault();
        let pageNum = $(this).attr("href").split("pageNum=")[1];
        $("#moveForm input[name='pageNum']").val(pageNum);
        $("#moveForm").submit();
    });
    
 	// 목록 버튼
    $("#listBtn").click(function() {
        window.location.href = '${pageContext.servletContext.contextPath}/member/board/list';
    });
 
    // 게시글 수정
    $("#updateBtn").click(function() {
        const boardNo = ${board.boardNo}; 
        window.location.href = '${pageContext.servletContext.contextPath}/member/board/modify?boardNo=' + boardNo;
    });
    
 	// 게시글 삭제
    function deleteboard(boardNo) {
        if (confirm("정말로 삭제하시겠습니까?")) {
            $.ajax({
                url: "${pageContext.request.contextPath}/member/board/delete",
                type: "POST",
                data: { boardNo: boardNo },
                success: function(response) {
                    if (response === 'success') {
                        alert("게시글이 삭제되었습니다.");
                        window.location.href = "${pageContext.request.contextPath}/member/board/list";
                    } else {
                        alert("게시글 삭제에 실패했습니다.");
                    }
                },
                error: function() {
                    alert("서버 오류가 발생했습니다.");
                }
            });
        }
    }
 	
 	// 게시글 좋아요
    $("#heartIcon").click(function() {
        const icon = $(this);
        const boardNo = icon.data('boardNo');
        
        $.ajax({
            url: "${pageContext.request.contextPath}/member/board/heart",
            type: "POST",
            data: { boardNo: boardNo },
            success: function(response) {
                const heartCount = $('#boardHeartCount');
                if (response === 'heartAdded') {
                	icon.removeClass('bi-heart').addClass('bi-heart-fill');
                    heartCount.text(parseInt(heartCount.text()) + 1);
                } else if (response === 'heartRemoved') {
                	icon.removeClass('bi-heart-fill').addClass('bi-heart');
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

 	// 답글 작성 폼 표시
    function showReplyForm(commentNo) {
        $('#reply-form-' + commentNo).toggle(); 
        
        if($('#reply-form-' + commentNo).is(':visible')) {
        	$('#updateCommentBtn-' + commentNo).hide();
            $('#deleteCommentBtn-' + commentNo).hide();
        } else {
        	$('#updateCommentBtn-' + commentNo).show();
            $('#deleteCommentBtn-' + commentNo).show();
        }
    }
    
 	// 댓글 추가
    $("#addCommentForm").submit(function(event) {
        event.preventDefault();
        const formData = $(this).serialize();
        $.ajax({
            url: "${pageContext.request.contextPath}/member/board/comment/add",
            type: "POST",
            data: formData,
            success: function(response) {
                if (response === 'success') {
                    location.reload(); 
                } else {
                    alert("댓글 추가에 실패했습니다.");
                }
            },
            error: function() {
                alert("서버 오류가 발생했습니다.");
            }
        });
    });
    
 	// 댓글 수정 버튼 클릭 시
    function editComment(commentNo) {
    	$('#replyBtn-' + commentNo).hide();
    	$('#updateCommentBtn-' + commentNo).hide();
        $('#deleteCommentBtn-' + commentNo).hide();
        $('#comment-content-' + commentNo).hide();
        $('#edit-form-' + commentNo).show();
    }

    // 댓글 수정 취소 버튼 클릭 시
    function cancelEdit(commentNo) {
    	$('#edit-form-' + commentNo).hide();
    	$('#replyBtn-' + commentNo).show();
        $('#comment-content-' + commentNo).show();
        $('#updateCommentBtn-' + commentNo).show();
        $('#deleteCommentBtn-' + commentNo).show();
    }

    // 댓글 수정
    function submitEdit(commentNo) {
    	let commentContent = $('#edit-form-' + commentNo + ' textarea').val();
        $.ajax({
            url: "${pageContext.request.contextPath}/member/board/comment/modify",
            type: "POST",
            data: {
                commentNo: commentNo,
                commentContent: commentContent
            },
            success: function(response) {
                if (response === 'success') {
                    $('#comment-content-' + commentNo).text(commentContent).show();
                    cancelEdit(commentNo);
                    alert("댓글이 수정되었습니다.");
                } else {
                    alert("댓글 수정에 실패했습니다.");
                }
            },
            error: function() {
                alert("서버 오류가 발생했습니다.");
            }
        });
    }

    // 댓글 삭제
    function deleteComment(commentNo, boardNo) {
        if (confirm("정말로 이 댓글을 삭제하시겠습니까?")) {
            $.ajax({
                url: "${pageContext.request.contextPath}/member/board/comment/delete",
                type: "POST",
                data: { commentNo: commentNo,
                		boardNo: boardNo
                	},
                success: function(response) {
                    if (response === 'success') {
                        alert("댓글이 삭제되었습니다.");
                        location.reload(); 
                        /* $('#comment-' + commentNo).remove(); */
                    } else if (response === 'deleted') {
                    	$('#comment-' + commentNo).html('<p>사용자에 의해 삭제된 댓글입니다.</p>');
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

    </script>

</body>
</html>