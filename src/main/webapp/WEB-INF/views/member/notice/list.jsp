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
	height: 1080px;
}

body {
	display: flex;
	flex-direction: column;
}

main {
	flex: 1;
	margin-left: 300px;
	margin-top: 110px;
	overflow-y: auto;
	height: 100%;
}

.title-container{
	display: flex;
    align-items: center; 
}

.title-container h1{
	margin-right: 20px; 
	font-weight: bold;
}

.container {
	margin: 20px auto;
	/* padding: 20px; */
	background-color: #f9fafc;
	box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
	width: 1320px;
	height: 710px;
	border-radius: 10px;
	padding-bottom: 20px;
    
    padding-left: 0 !important;
    padding-right: 0 !important;
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

.container {
	margin: 20px auto;
	background-color: #f9fafc;
	box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
	width: 1320px;
	height: 710px;
	border-radius: 10px;
	padding-bottom: 20px;
    padding-left: 0 !important;
    padding-right: 0 !important;
}

.search_area {
	display: flex;
	flex-wrap: wrap;
	align-items: center;
}

.search_area label, .search_area select, .search_area button {
	margin-left: 10px;
}

.search_area select, .search_area input {
	height: 30px;
	padding: 5px;
	border: 1px solid #ddd;
	border-radius: 5px;
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

.select-box {
    position: relative;
    display: inline-block;
}

.select-box select {
    padding: 10px;
    font-size: 1em;
    border: 1px solid #ddd;
    border-radius: 5px;
    background: #f8f8f8;
    width: auto;
    min-width: 300px;
}

.header .search_area {
	display: flex;
	align-items: center;
}

.header .search_area input[type="text"] {
	margin-left: 10px;
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
	color: #007bff !important; 
	text-decoration: none; 
	border-radius: 5px; 
	font-weight: bold; 
}

.pageMaker_btn a:hover {
	background-color: #e9ecef; 
}

.pageMaker_btn.active a {
	background-color: #007bff; 
	color: white !important; 
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

	<!-- 사이드바 연결 -->
	<%@ include file="../aside.jsp"%>
	<%-- selectedClassNo --%>
	<main>
		<div class="title-container">
		<h1>공지사항</h1>
			<div class="select-box">
				<select id="classSelect" name="classSelect" onchange="sendClassChange(this.value)">
				    <c:forEach var="classItem" items="${classList}">
				        <option value="${classItem.classNo}" <c:if test="${classItem.classNo == param.classNo || (classItem.classNo == classList[0].classNo && param.classNo == null)}">selected</c:if>>${classItem.className}</option>
				    </c:forEach>
				</select>
			</div>
		</div>
		<!-- Main content -->
		<div class="container">
			<div class="header">
				<h2>공지사항</h2>
				<div class="search_area">
					<form id="searchForm" action="${ pageContext.servletContext.contextPath }/member/notice/list" method="get">
                  		<div class="search_input">
                     		<input type="search" name="keyword" value='<c:out value="${pageMaker.cri.keyword}"></c:out>'>
                     		<input type="hidden" name="pageNum" value='<c:out value="${pageMaker.cri.pageNum }"></c:out>'>
                     		<input type="hidden" name="amount" value='${pageMaker.cri.amount}'>
                     		<input type="hidden" name="classNo" value='<c:out value="${param.classNo}"></c:out>'>
                     		<button class='btn search_btn'><i class="bi bi-search"></i></button>
                  		</div>
               		</form>
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
                	<c:forEach items="${noticeList}" var="notice">
                		<tr onclick="window.location.href='${pageContext.servletContext.contextPath}/member/notice/detail?noticeNo=${notice.noticeNo}'">
                    		<td>${ notice.noticeClassNo == 0 ? '전체' : notice.noticeNo }</td>
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
				<form id="moveForm" action="${ pageContext.servletContext.contextPath }/member/notice/list" method="get">
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

    function sendClassChange(classNo) {
        let url = new URL(window.location.href);
        url.searchParams.set('classNo', classNo);
        url.searchParams.delete('pageNum');
        url.searchParams.delete('keyword');
        window.location.href = url.toString();
    }
    
    $(".pageMaker_btn a").on("click", function(e) {
        e.preventDefault();
        let pageNum = $(this).attr("href");
        
        // 현재 URL에서 모든 쿼리 파라미터를 유지하면서 pageNum만 변경
        let url = new URL(window.location.href);
        url.searchParams.set('pageNum', pageNum);
        
        let classNo = $('#classSelect').val();
        let keyword = $('input[name="keyword"]').val();
        
        if (classNo) {
            url.searchParams.set('classNo', classNo);
        } else {
            url.searchParams.delete('classNo');
        }
        
        if (keyword) {
            url.searchParams.set('keyword', keyword);
        } else {
            url.searchParams.delete('keyword');
        }
        
        window.location.href = url.toString();
    });
	
	function showNoticeDetail(event, noticeNo) {
		window.location.href = '${pageContext.servletContext.contextPath}/member/notice/detail?noticeNo=' + noticeNo;
	}
	
	</script>

</body>
</html>