<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>송파여성인력개발센터</title>
<script src="https://code.jquery.com/jquery-latest.min.js"></script>
<script src="https://kit.fontawesome.com/a076d05399.js"></script>
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
	display: flex;
	flex-direction: column;
}

main {
	flex: 1;
	margin-left: 300px;
	margin-top: 160px;
	overflow-y: auto;
	min-height: 100vh;
}

.bi-house-fill {
	cursor: pointer;
	font-size: 20px;
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
    margin-left: 10px;
}

.classroom-header .details {
    font-size: 12px;
    margin-left: 10px;
}

.content {
    margin: 20px auto;
    background-color: #f9fafc;
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    max-width: 1200px;
    border-radius: 10px;
    padding-bottom: 20px;
    padding-left: 0 !important;
    padding-right: 0 !important;
   
}

.content h2 {
    margin-bottom: 20px;
}

.header {
	display: flex;
	flex-wrap: wrap;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 20px;
	padding-bottom: 10px;
	border-bottom: 1px solid #ddd;
	background-color: #e2eff9;
	
	padding-top: 40px;
    padding-right: 32px;
    padding-left: 32px;
    padding-bottom: 20px;
    border-radius: 10px 10px 0 0;
}

.header h2 {
	margin: 0;
	flex-grow: 1;
}

.header .search_area {
	display: flex;
	align-items: center;
}

.header .search_area input[type="text"] {
	margin-left: 10px;
}

.header .icons {
    display: flex;
}

.header .icons i {
    cursor: pointer;
    margin-left: 10px; 
}

.table_wrap {
    margin: 50px 50px 0 50px;
    overflow-x: auto;
}

table {
    width: 100%;
    border-collapse: collapse;
    white-space: nowrap;
}

thead {
    background-color: #f5f5f5;
}

table thead tr {
    cursor: default; 
}

table tbody tr {
    cursor: pointer;  
}

table th, table td {
	padding: 10px;
	text-align: left;
}

.pageMaker_wrap {
	text-align: center; 
	margin: 20px; 
}

.pageMaker_btn {
	display: inline-block; 
	margin: 0 5px; 
}

.pageMaker_btn a {
	display: block; 
	padding: 10px 15px; 
	background-color: #f8f9fa; 
	color: #007bff; 
	text-decoration: none; 
	border-radius: 5px; 
	font-weight: bold; 
}

.pageMaker_btn a:hover {
	background-color: #e9ecef; 
}

.pageMaker_btn.active a {
	background-color: #007bff; 
	color: white; 
}

.pageMaker_btn.previous a:hover, 
.pageMaker_btn.next a:hover {
	background-color: #0056b3; 
	color: white; 
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
			<div class="header">
				<h2>공지사항</h2>
				<div class="search_area">
					<form id="searchForm" action="${ pageContext.servletContext.contextPath }/admin/class/notice/list" method="get">
                  		<div class="search_input">
                     		<input type="search" name="keyword" value='<c:out value="${pageMaker.cri.keyword}"></c:out>'>
                     		<input type="hidden" name="pageNum" value='<c:out value="${pageMaker.cri.pageNum }"></c:out>'>
                     		<input type="hidden" name="amount" value='${pageMaker.cri.amount}'>
                     		<button class='btn search_btn'><i class="bi bi-search"></i></button>
                  		</div>
               		</form>
				</div>
				<!-- 등록버튼 -->
				<div class="icons">
					<c:if test="${ sessionScope.loginMember.memberRole eq 'ROLE_ADMIN' }">
                    	<a href="${pageContext.servletContext.contextPath}/admin/class/notice/enroll"><i class="fas fa-square-plus"></i></a>
                    </c:if>
                </div>
			</div>

			<div id="tableContainer" class="table_wrap">
				
			<table>
				<thead>
					<tr>
						<th>번호</th>
						<th width=70%>제목</th>
						<th>조회수</th>
						<th>등록일</th>
					</tr>
				</thead>
				<tbody>
                	<c:forEach items="${ noticeList }" var="notice">
					<tr onclick="window.location.href='${pageContext.servletContext.contextPath}/admin/class/notice/detail?noticeNo=${notice.noticeNo}'">
						<td>${ notice.noticeClassNo == null ? '전체' : notice.noticeNo }</td>
						<td>
							<c:if test="${notice.hasFiles}"><i class="bi bi-paperclip"></i></c:if>
							${ notice.noticeTitle }
						</td>
						<td>${ notice.noticeCount }</td>
						<td>${ notice.noticeRegDate }</td>
					</tr>
					</c:forEach>
            	</tbody>
			</table>
			
			<!-- 페이지 이동 인터페이스 영역 -->
				<div class="pageMaker_wrap">
					<ul class="pageMaker">

						<!-- 이전 버튼 -->
						<c:if test="${pageMaker.prev}">
							<li class="pageMaker_btn prev"><a href="${pageMaker.pageStart - 1}">이전</a></li>
						</c:if>

						<!-- 페이지 번호 -->
						<c:forEach begin="${pageMaker.pageStart}" end="${pageMaker.pageEnd}" var="num">
							<li class="pageMaker_btn ${pageMaker.cri.pageNum == num ? "active" : ""}"><a href="${num}">${num}</a></li>
						</c:forEach>

						<!-- 다음 버튼 -->
						<c:if test="${pageMaker.next}">
							<li class="pageMaker_btn next"><a href="${pageMaker.pageEnd + 1 }">다음</a></li>
						</c:if>
					</ul>
				</div>
				<form id="moveForm" action="${ pageContext.servletContext.contextPath }/admin/class/notice/list" method="get">
					<input type="hidden" name="pageNum" value="${pageMaker.cri.pageNum}">
					<input type="hidden" name="amount" value="${pageMaker.cri.amount}">
					<input type="hidden" name="keyword" value="${pageMaker.cri.keyword}">
				</form>
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
	
	$('#searchForm').on('submit', function() {
        let form = $(this);
        form.find("input[name='pageNum']").val('1');
        return true;  
    });
	
	let moveForm = $('#moveForm');
	$(".pageMaker_btn a").on("click", function(e){
	    e.preventDefault();
	    let pageNum = $(this).attr("href");
	    moveForm.find("input[name='pageNum']").val(pageNum);
	    moveForm.submit();
	});
	
	function showNoticeDetail(event, noticeNo) {
		window.location.href = '${pageContext.servletContext.contextPath}/admin/class/notice/detail?noticeNo=' + noticeNo;
	}
	
	</script>

</body>
</html>
