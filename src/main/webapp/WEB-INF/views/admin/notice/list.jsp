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

/* noticeList-wrapper 스타일 */
.noticeList-wrapper {
	width: 85%;
    background-color: #fff;
    padding: 20px;
    margin: 20px auto;
}

/* 공지사항 제목 스타일 */
.noticeList-wrapper h2 {
    font-size: 24px;
    color: #333;
    margin-bottom: 20px;
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

/* 테이블 행에 마우스를 올렸을 때 배경색 변경 */
table tr:hover {
    background-color: #f9f9f9;
    cursor: pointer;
}

/* 테이블 번호 열 스타일 */
table td:first-child {
    font-weight: bold;
}

.search_wrap {
	margin-top: 20px;
	text-align: center; 
}

.search_input input[type=text], .search_input button {
	margin: 0 5px;
	padding: 5px 10px;
	border: 1px solid #ccc;
	border-radius: 4px;
	font-size: 14px;
}

.search_input button {
	background-color: #007bff;
	color: #fff;
	border: none;
	cursor: pointer;
}

.search_input button:hover {
	background-color: #0056b3;
}

.pageMaker_wrap{
	text-align: center;
    margin-top: 30px;
    margin-bottom: 40px;
}
.pageMaker_wrap a{
	color : black;
}
.pageMaker{
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
.active{							/* 현재 페이지 버튼 */
	border : 2px solid black;
	font-weight:400;
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
            <div class="noticeList-wrapper">
				<h2 align="center">공지사항</h2>
				<table>
					<tr >
						<th>번호</th>
						<th width=70%>제목</th>
						<th>조회수</th>
						<th>등록일</th>
					</tr>
					<!-- 전체공지 -->
					<c:forEach items="${ noticeList }" var="notice">
					<tr onclick="window.location.href='${pageContext.servletContext.contextPath}/admin/class/notice/detail?noticeNo=${notice.noticeNo}'">
						<td>전체</td>
						<td>${ notice.noticeTitle }</td>
						<td>${ notice.noticeCount }</td>
						<td>${ notice.noticeRegDate }</td>
					</tr>
					</c:forEach>
					
					<!-- 반별 공지 -->
					<c:forEach items="${ noticeClassList }" var="notice">
					<tr onclick="window.location.href='${pageContext.servletContext.contextPath}/admin/class/notice/detail?noticeNo=${notice.noticeNo}'">
						<td>${ notice.noticeNo }</td>
						<td>${ notice.noticeTitle }</td>
						<td>${ notice.noticeCount }</td>
						<td>${ notice.noticeRegDate }</td>
					</tr>
					</c:forEach>
				</table>
				
				<!-- 검색 영역 -->
				<div class="search_wrap">
					<form id="searchForm" action="/admin/class/notice/list" method="get">
						<div class="search_input">
							<input type="text" name="keyword"
								value='<c:out value="${pageMaker.cri.keyword}"></c:out>'>
							<input type="hidden" name="pageNum"
								value='<c:out value="${pageMaker.cri.pageNum }"></c:out>'>
							<input type="hidden" name="amount"
								value='${pageMaker.cri.amount}'>
							<button class='btn search_btn'>검 색</button>
						</div>
					</form>
				</div>

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
				<form id="moveForm" action="/admin/class/notice/list" method="get">
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
	let moveForm = $('#moveForm');
	//페이지 이동 버튼
	$(".pageMaker_btn a").on("click", function(e){
	    e.preventDefault();
	    let pageNum = $(this).attr("href");
	    moveForm.find("input[name='pageNum']").val(pageNum);
	    moveForm.submit();
	});

	</script>

</body>
</html>
