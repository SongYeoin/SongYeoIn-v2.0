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
}

main {
	flex: 1;
	margin-left: 250px;
	padding-top: 90px;
	overflow-y: auto;
	top: 120px;
	left: 250px;
}

.box {
	height: 100%;
}

.container {
	margin: 20px auto;
	padding: 20px;
	background-color: #f9fafc;
	box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
	max-width: 1200px;
	border-radius: 10px;
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
	padding: 20px;
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
	margin-left: 10px; /* 아이콘 사이에 간격을 줍니다 */
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

.search_area button {
	height: 36px;
	background-color: #007bff;
	color: white;
	border: none;
	border-radius: 4px;
	cursor: pointer;
	padding: 0 20px;
}

.search_area button:hover {
	background-color: #0056b3;
}

.table_wrap {
	margin: 50px 50px 0 50px;
}

.top_btn {
	font-size: 20px;
	padding: 6px 12px;
	background-color: #28a745;
	color: white;
	border: none;
	border-radius: 4px;
	font-weight: 600;
	cursor: pointer;
}

.top_btn:hover {
	background-color: #218838;
}

table {
	width: 100%;
	border-collapse: collapse;
}

thead {
	background-color: #f5f5f5;
}

th, td {
	padding: 10px;
	text-align: left;
	border: 1px solid #ddd;
}

.status-active {
	color: green;
	font-weight: bold;
}

.status-inactive {
	color: red;
	font-weight: bold;
}

.footer {
	display: flex;
	justify-content: space-between;
	margin-top: 20px;
}

/* 드롭다운 메뉴 스타일 */
.dropdown {
	position: relative;
	display: inline-block;
}

.dropdown-content {
	display: none;
	position: absolute;
	background-color: #f9f9f9;
	min-width: 100px;
	box-shadow: 0px 8px 16px 0px rgba(0, 0, 0, 0.2);
	z-index: 1;
}

.dropdown-content a {
	color: black;
	padding: 10px 12px;
	text-decoration: none;
	display: block;
}

.dropdown-content a:hover {
	background-color: #f1f1f1;
}

.dropbtn {
	background-color: transparent;
	border: none;
	font-size: 16px;
	cursor: pointer;
	padding: 0;
}

.pageInfo {
	list-style: none;
	display: inline-block;
	margin: 50px 0 0 100px;
}

.pageInfo li {
	float: left;
	font-size: 20px;
	margin-left: 18px;
	padding: 7px;
	font-weight: 500;
}

a:link {
	color: black;
	text-decoration: none;
}

a:visited {
	color: black;
	text-decoration: none;
}

a:hover {
	color: black;
	text-decoration: none;
}

.active {
	background-color: #cdd5ec;
}

/* Adjusted select box style */
.select-box {
    position: relative;
    display: inline-block;
    width: 100%;
    max-width: 250px; /* Adjusted width for more text space */
}

.select-box select {
    width: 100%;
    padding: 10px; /* Adjusted padding */
    font-size: 1em; /* Adjusted font size */
    border: none;
    outline: none;
    appearance: none;
    background: #ddd;
}

.select-box::after {
    content: '▼';
    font-size: 1em; /* Adjusted arrow size */
    position: absolute;
    right: 10px; /* Adjusted position */
    top: 50%;
    transform: translateY(-50%);
    pointer-events: none;
}

.header .search_area {
	display: flex;
	align-items: center;
}

.header .search_area input[type="text"] {
	margin-left: 10px;
}

</style>
</head>
<body>

	<!-- 메뉴바 연결 -->
	<%@ include file="../common/header.jsp"%>

	<!-- 사이드바 연결 -->
	<%@ include file="../member/aside.jsp"%>

	<main>
		<div class="select-box">
			<select id="classSelect" name="classSelect">
				<option value="">JAVA&SPRING 백엔드 과정</option>
				<!-- Add other options here -->
			</select>
		</div>

		<!-- Main content -->
		<div class="container">
			<div class="header">
				<h2>동아리 신청 목록</h2>
				<div class="search_area">
					<form id="searchForm" method="get" action="/club/list">
						<input type="text" placeholder="Search..." id="search">
						<button type="submit">검색</button>
						<label for="classNo">반 선택:</label>
						<select id="classNo" name="classNo">
							<option value="">전체</option>
							<c:forEach items="${classes}" var="cls">
								<option value="${cls.classNo}" ${param.classNo == cls.classNo ? 'selected' : ''}>
									<c:out value="${cls.className}" />
								</option>
							</c:forEach>
						</select>

						<label for="status">상태:</label>
						<select id="status" name="status">
							<option value="">전체</option>
							<option value="Y" ${param.status == 'Y' ? 'selected' : ''}>Y</option>
							<option value="N" ${param.status == 'N' ? 'selected' : ''}>N</option>
						</select>

						<button type="submit">조회하기</button>
					</form>
				</div>
				<div class="icons">
					<a href="/club/enroll"><i class="fas fa-square-plus"></i></a>
				</div>
			</div>

			<div class="table_wrap">
				<table>
					<thead>
						<tr>
							<th class="bno_width">번호</th>
							<th class="writer_width">작성자</th>
							<th class="writer_width">승인현황</th>
							<th class="writer_width">승인메시지</th>
							<th class="regdate_width">활동일</th>
							<th class="regdate_width">작성일</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach items="${list }" var="list">
							<tr onclick="location.href='/club/get?clubNo=${list.clubNo}'">
								<td><c:out value="${list.clubNo }" /></td>
								<td><c:out value="${list.enroll.member.memberName }" /></td>
								<td>
									<c:choose>
										<c:when test="${list.checkStatus == 'W'}">승인대기</c:when>
										<c:when test="${list.checkStatus == 'Y'}">승인완료</c:when>
										<c:when test="${list.checkStatus == 'N'}">승인불가</c:when>
										<c:otherwise>알 수 없음</c:otherwise>
									</c:choose>
								</td>
								<td><c:out value="${list.checkCmt }" /></td>
								<td><fmt:formatDate pattern="yyyy/MM/dd" value="${list.studyDate }" /></td>
								<td><fmt:formatDate pattern="yyyy/MM/dd" value="${list.regDate }" /></td>
							</tr>
						</c:forEach>
						</tbody>
				</table>

				<div class="pageInfo_wrap">
					<div class="pageInfo_area">
						<ul id="pageInfo" class="pageInfo">
							<c:if test="${pageMaker.prev }">
								<li class="pageInfo_btn previous"><a href="${pageMaker.startPage-1 }">Previous</a></li>
							</c:if>
							<c:forEach var="num" begin="${pageMaker.startPage }" end="${pageMaker.endPage }">
								<li class="pageInfo_btn ${pageMaker.cri.pageNum == num? "active":"" }"><a href="${num }">${num }</a></li>
							</c:forEach>
							<c:if test="${pageMaker.next }">
								<li class="pageInfo_btn next"><a href="${pageMaker.endPage+1 }">Next</a></li>
							</c:if>
						</ul>
					</div>
					<form id="moveForm" method="get">
						<input type="hidden" name="pageNum" value="${pageMaker.cri.pageNum }"> 
						<input type="hidden" name="amount" value="${pageMaker.cri.amount }"> 
						<input type="hidden" name="keyword" value="${pageMaker.cri.keyword }">
						<input type="hidden" name="type" value="${pageMaker.cri.type }">
					</form>
				</div>
			</div>
		</div>
	</main>

	<!-- 푸터 연결 -->
	<%@ include file="../common/footer.jsp"%>

	<script>
		$(document).ready(function() {
			let result = '<c:out value="${result}"/>';
			checkAlert(result);
			function checkAlert(result) {
				if (result === '') {
					return;
				}
				if (result === "enroll success") {
					alert("등록이 완료되었습니다");
				}
				if (result === "modify success") {
					alert("수정이 완료되었습니다");
				}
				if (result === "delete success") {
					alert("삭제가 완료되었습니다");
				}
			}
		});

		let moveForm = $("#moveForm");

		$(".move").on("click", function(e) {
			e.preventDefault();
			moveForm.append("<input type='hidden' name='bno' value='"+ $(this).attr("href") + "'>");
			moveForm.attr("action", "/board/get");
			moveForm.submit();
		});

		$(".pageInfo a").on("click", function(e) {
			e.preventDefault();
			moveForm.find("input[name='pageNum']").val($(this).attr("href"));
			moveForm.attr("action", "/board/list");
			moveForm.submit();
		});

		$(".search_area button").on("click", function(e) {
			e.preventDefault();
			let type = $(".search_area select").val();
			let keyword = $(".search_area input[name='keyword']").val();
			if (!type) {
				alert("검색 종류를 선택하세요");
				return false;
			}
			if (!keyword) {
				alert("키워드를 입력하세요");
				return false;
			}
			moveForm.find("input[name='type']").val(type);
			moveForm.find("input[name='keyword']").val(keyword);
			moveForm.find("input[name='pageNum']").val(1);
			moveForm.submit();
		});
	</script>
</body>
</html>
