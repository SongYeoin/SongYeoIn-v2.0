<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
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
	margin-top: 160px;
	overflow-y: auto;
	height: 100%;
}

/*
.title-container{
	display: flex;
    align-items: center; 
}

.title-container h1{
	margin-right: 20px; 
	font-weight: bold;
}
*/

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

.header input {
    padding: 10px;
    width: 200px;
    border: 1px solid #ddd;
    border-radius: 5px;
}

.header .icons {
    display: flex;
}

.header .icons i {
    cursor: pointer;
    margin-left: 10px; 
}

.table_wrap {
    margin-left: 12px;
    margin-right: 12px;
}

table {
    width: 100%;
    border-collapse: collapse;
    margin-bottom: 20px;
}

thead {
    background-color: #f5f5f5;
}

th, td {
    padding: 10px;
    text-align: left;
    border: 1px solid #ddd;
}

table tbody tr {
    cursor: pointer;  
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

.active { 
    border: 2px solid black;
    font-weight: 400;
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
        <div class="title-container">
            <!-- <h1>익명게시판</h1> -->
        </div>
        <!-- Main content -->
        <div class="container">
            <div class="header">
                <h2>익명게시판</h2>
                <div class="search_area">
					<form id="searchForm" action="${ pageContext.servletContext.contextPath }/admin/board/list" method="get">
                  		<div class="search_input">
                     		<input type="text" name="keyword" value='<c:out value="${pageMaker.cri.keyword}"></c:out>'>
                     		<input type="hidden" name="pageNum" value='<c:out value="${pageMaker.cri.pageNum }"></c:out>'>
                     		<input type="hidden" name="amount" value='${pageMaker.cri.amount}'>
                     		<input type="hidden" name="classNo" value='<c:out value="${param.classNo}"></c:out>'>
                     		<button class='btn search_btn'><i class="bi bi-search"></i></button>
                  		</div>
               		</form>
				</div>
            </div>

            <div class="table_wrap">
                <table>
                    <thead>
                        <tr>
                            <th>번호</th>
                            <th width="60%">제목</th>
                            <th>글쓴이</th>
                            <th>조회수</th>
                            <th>등록일</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${boardList}" var="board">
                            <tr onclick="window.location.href='${pageContext.servletContext.contextPath}/admin/board/detail?boardNo=${board.boardNo}'">
                                <td>${board.boardNo}</td>
                                <td>${board.boardTitle}</td>
                                <td>${board.member.memberNickname}</td>
                                <td>${board.boardCount}</td>
                                <td>${board.boardRegDate}</td>
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
                            <li class="pageMaker_btn next"><a href="${pageMaker.pageEnd + 1}">다음</a></li>
                        </c:if>

                    </ul>
                </div>
                <form id="moveForm" action="/admin/board/list" method="get">
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
    if (message) {
        alert(message);
    }

    // 검색 버튼 클릭 시 페이지 번호를 1로 설정하고 폼 제출
    $('#searchForm').on('submit', function() {
        let form = $(this);
        form.find("input[name='pageNum']").val('1');
        return true;  
    });

    // 페이지 이동 버튼
    $(".pageMaker_btn a").on("click", function(e) {
        e.preventDefault();
        let pageNum = $(this).attr("href");

        // 현재 URL에서 모든 쿼리 파라미터를 유지하면서 pageNum만 변경
        let url = new URL(window.location.href);
        url.searchParams.set('pageNum', pageNum);

        let keyword = $('input[name="keyword"]').val();

        if (keyword) {
            url.searchParams.set('keyword', keyword);
        } else {
            url.searchParams.delete('keyword');
        }

        window.location.href = url.toString();
    });
    </script>

</body>
</html>