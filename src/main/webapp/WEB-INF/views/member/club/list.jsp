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
	font-family: Arial, sans-serif;
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
    align-items: center; /* 수직 가운데 정렬 */
}

.title-container h1{
	margin-right: 20px; /* 텍스트와 선택 박스 사이의 간격 */
	font-weight: bold;
}

.container {
	margin: 20px auto;
	/* padding: 20px; */
	background-color: #f9fafc;
	box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
	/* width: 1320px; */
	max-width: 1320px;
	/* height: 710px; */
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
	/* padding: 20px; */
	
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

table thead tr {
    cursor: default; /* 기본 커서 */
}

table tbody tr {
    cursor: pointer;  /* 포인터 커서 */
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
	text-align: center !important;
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

.bi-paperclip{
	cursor: pointer;
	/* font-size: 20px; */
}

/* 중복된 아이콘을 숨깁니다 */
.bi-paperclip.duplicate {
    display: none; /* 중복된 아이콘 숨기기 */
} 

</style>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">

<script>
 function sendClassChange() {
    var classNo = $('#classSelect').val();
    if (!classNo) {
        console.error("classNo 값이 누락되었습니다.");
        return; // classNo가 없으면 요청을 중단합니다.
    }
    
    console.log("비동기 요청 시작 classNo: " + classNo);

    $.ajax({
        url: '/member/club/list/getByClass', // AJAX 요청 URL
        type: 'GET',
        dataType: 'json', // 데이터 타입을 JSON으로 설정
        data: { classNo: classNo },
        success: function(response) {
        	console.log('서버 응답:', response); // 응답 데이터 로그
        	
        	var tableBody = $('#tableContainer table tbody');
            tableBody.empty(); // 기존 데이터 제거
            
                // 배열일 때 테이블의 tbody 부분을 업데이트
                response.forEach(function(item) {
                    var studyDate = new Date(item.studyDate);
                    var regDate = new Date(item.regDate);

                    var formattedStudyDate = formatDate(studyDate);
                    var formattedRegDate = formatDate(regDate);
                    
                    if(item.checkCmt == null){
                    	item.checkCmt = "";
                    }

                    var row = '<tr onclick="location.href=\'/member/club/get?clubNo=' + item.clubNo + '\'">' +
                                '<td>' + item.clubNo + '</td>' +
                                '<td>' + item.enroll.member.memberName + '</td>' +
                                '<td>' + (item.checkStatus === 'W' ? '대기' : item.checkStatus === 'Y' ? '승인' : '미승인') + '</td>' +
                                '<td>' + item.checkCmt + '</td>' +
                                '<td>' + formattedStudyDate + '</td>' +
                                '<td>' + formattedRegDate + '</td>' +
                                '<td>' + (item.fileName ? '<a href="/member/club/downloadFile?fileName=' + item.fileName + '" download="' + item.fileName + '" title="' + item.fileName + '" class="file-download"><i class="bi bi-paperclip"></i></a>' : '') + '</td>' +
                              '</tr>';
                    tableBody.append(row);   
                });
            
             // 첨부파일 다운로드 링크에 대한 클릭 이벤트 핸들러 추가
                $('.file-download').on('click', function(event) {
                    event.stopPropagation(); // 클릭 이벤트가 상위 요소로 전파되는 것을 막음
                });
            
        },
        error: function() {
        	
            alert('데이터를 가져오는 데 실패했습니다.');
        }
    });

    function formatDate(date) {
        var year = date.getFullYear();
        var month = ('0' + (date.getMonth() + 1)).slice(-2); // 월을 2자리로 포맷
        var day = ('0' + date.getDate()).slice(-2); // 일을 2자리로 포맷
        return year + '/' + month + '/' + day;
    }
}
</script>

</head>
<body>

	<!-- 메뉴바 연결 -->
	<%@ include file="../../common/header.jsp"%>

	<!-- 사이드바 연결 -->
	<%@ include file="../aside.jsp"%>
	<%-- selectedClassNo --%>
	<main>
	<div class="title-container">
		<h1>동아리</h1>
		<div class="select-box">
			<select id="classSelect" name="classSelect" onchange="sendClassChange()">
			    <c:forEach var="classItem" items="${classList}">
			        <option value="${classItem.classNo}" <c:if test="${classItem.classNo == param.classNo || (classItem.classNo == classList[0].classNo && param.classNo == null)}">selected</c:if>>${classItem.className}</option>
			    </c:forEach>
			</select>
		</div>
</div>
		<%-- <div class="title-container">
            <h1>동아리</h1>
            <div class="select-box">
                <select id="classSelect" name="classSelect" onchange="sendClassChange()">
                    <c:forEach var="classItem" items="${classList}">
                        <option value="${classItem.classNo}" 
                            <c:if test="${classItem.classNo == selectedClassNo}">selected</c:if>>
                            ${classItem.className}
                        </option>
                    </c:forEach>
                </select>
            </div>
        </div> --%>

		<!-- Main content -->
		<div class="container">
			<div class="header">
				<h2>강의실 신청 목록</h2>
				<div class="search_area">
					<form id="searchForm" method="get" action="/member/club/list">
						<%-- <input type="text" placeholder="Search..." id="search">

						<label for="status">상태:</label>
						<select id="status" name="status">
							<option value="">전체</option>
							<option value="Y" ${param.status == 'Y' ? 'selected' : ''}>승인</option>
							<option value="N" ${param.status == 'N' ? 'selected' : ''}>미승인</option>
						</select>--%>
                        
                        
                        <select name="type">
                        	<option value="W" <c:out value="${pageMaker.cri.type eq 'W'? 'selected':''}"/>>작성자</option>
                        	<option value="J" <c:out value="${pageMaker.cri.type eq 'J'? 'selected':''}"/>>참여</option>
                        	<option value="C" <c:out value="${pageMaker.cri.type eq 'C'? 'selected':''}"/>>승인상태</option>
                        </select>
                        <input type="text" name="keyword" value="${pageMaker.cri.keyword }">
						<button>조회</button>
					</form>
				</div>
				<div class="icons">
					<a href="/member/club/enroll"><i class="fas fa-square-plus"></i></a>
<%-- 					<a href="/member/club/enroll?classNo=${param.classNo}"><i class="fas fa-square-plus"></i></a> --%>
				</div>
			</div>

			<div id="tableContainer" class="table_wrap">
				
			<table>
					<thead>
						<tr>
							<th class="clubNo_width">번호</th>
							<th class="writer_width">작성자</th>
							<th class="checkStatus_width">승인상태</th>
							<th class="checkCmt_width">승인메시지</th>
							<th class="studyDate_width">활동일</th>
							<th class="regDate_width">작성일</th>
							<th class="file_width">첨부</th>
						</tr>
					</thead>
					<tbody>
                <!-- 데이터는 AJAX 호출 후 여기에 삽입됩니다 -->
                <%-- <c:forEach items="${list}" var="item">
                            <tr onclick="location.href='/member/club/get?clubNo=${item.clubNo}'">
                                <td><c:out value="${item.clubNo}"/></td>
                                <td><c:out value="${list.enroll.member.memberName}"/></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${item.clubCheckStatus == 'W'}">대기</c:when>
                                        <c:when test="${item.clubCheckStatus == 'Y'}">승인</c:when>
                                        <c:when test="${item.clubCheckStatus == 'N'}">미승인</c:when>
                                        <c:otherwise>알 수 없음</c:otherwise>
                                    </c:choose>
                                </td>
                                <td><c:out value="${item.clubCheckCmt}"/></td>
                                <td><fmt:formatDate pattern="yyyy/MM/dd" value="${item.clubStudyDate}"/></td>
                                <td><fmt:formatDate pattern="yyyy/MM/dd" value="${item.clubRegDate}"/></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${item.fileName != null}">
                                            <a href="/member/club/downloadFile?fileName=${item.fileName}" download="${item.fileName}" title="${item.fileName}" onclick="event.stopPropagation();">
                                                <i class="bi bi-paperclip"></i>
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <c:out value=""/>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach> --%>
                
                
                
            		</tbody>
			
			</table>
			<div class="pageInfo_wrap">
				<div class="pageInfo_area">
					<ul id="pageInfo" class="pageInfo">
					
					<!-- 이전페이지 버튼 -->
					<c:if test="${pageMaker.prev }">
						<li class="pageInfo_btn previous"><a href="${pageMaker.pageStart-1 }">Previous</a></li>
					</c:if>
					
					<!-- 각 번호 페이지 버튼 -->
					<c:forEach var="num" begin="${pageMaker.pageStart }" end="${pageMaker.pageEnd }">
						<li class="pageInfo_btn ${pageMaker.cri.pageNum == num? "active":"" }"><a href="${num }">${num }</a></li>
					</c:forEach>
					
					<!-- 다음페이지 버튼 -->
					<c:if test="${pageMaker.next }">
						<li class="pageInfo_btn next"><a href="${pageMaker.pageEnd+1 }">Next</a></li>
					</c:if>
					
					</ul>
				</div>
			</div>
			<%-- <div class="pageInfo_wrap">
                    <div class="pageInfo_area">
                        <ul id="pageInfo" class="pageInfo">
                            <!-- 이전페이지 버튼 -->
                            <c:if test="${pageMaker.prev}">
                                <li class="pageInfo_btn previous">
                                    <a href="?pageNum=${pageMaker.pageStart-1}&amp;classNo=${selectedClassNo}">Previous</a>
                                </li>
                            </c:if>
                            <!-- 각 번호 페이지 버튼 -->
                            <c:forEach var="num" begin="${pageMaker.pageStart}" end="${pageMaker.pageEnd}">
                                <li class="pageInfo_btn ${pageMaker.cri.pageNum == num ? 'active' : ''}">
                                    <a href="?pageNum=${num}&amp;classNo=${selectedClassNo}">${num}</a>
                                </li>
                            </c:forEach>
                            <!-- 다음페이지 버튼 -->
                            <c:if test="${pageMaker.next}">
                                <li class="pageInfo_btn next">
                                    <a href="?pageNum=${pageMaker.pageEnd+1}&amp;classNo=${selectedClassNo}">Next</a>
                                </li>
                            </c:if>
                        </ul>
                    </div>
                </div> --%>
			

			<form id="moveForm" method="get">
				<input type="hidden" name="pageNum" value="${pageMaker.cri.pageNum }">
				<input type="hidden" name="amount" value="${pageMaker.cri.amount }">
				<input type="hidden" name="keyword" value="${pageMaker.cri.keyword }">
				<input type="hidden" name="type" value="${pageMaker.cri.type }">
			</form>



			<%-- <div class="table_wrap">
			
				<table>
					<thead>
						<tr>
							<th class="clubNo_width">번호</th>
							<th class="writer_width">작성자</th>
							<th class="checkStatus_width">승인상태</th>
							<th class="checkCmt_width">승인메시지</th>
							<th class="studyDate_width">활동일</th>
							<th class="regDate_width">작성일</th>
							<th class="file_width">첨부</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach items="${list }" var="list">
							<tr onclick="location.href='/member/club/get?clubNo=${list.clubNo}'">
								<td><c:out value="${list.clubNo }" /></td>
								<td><c:out value="${list.enroll.member.memberName }" /></td>
								<td>
									<c:choose>
										<c:when test="${list.checkStatus == 'W'}">대기</c:when>
										<c:when test="${list.checkStatus == 'Y'}">승인</c:when>
										<c:when test="${list.checkStatus == 'N'}">미승인</c:when>
										<c:otherwise>알 수 없음</c:otherwise>
									</c:choose>
								</td>
								<td><c:out value="${list.checkCmt }" /></td>
								<td><fmt:formatDate pattern="yyyy/MM/dd" value="${list.studyDate }" /></td>
								<td><fmt:formatDate pattern="yyyy/MM/dd" value="${list.regDate }" /></td>
								<td>
									<c:choose>
										<c:when test="${list.fileName != null }">
										<a href="/member/club/downloadFile?fileName=${list.fileName}" download="${list.fileName}" title="${list.fileName}" onclick="event.stopPropagation();">
											<i class="bi bi-paperclip"></i>
                            			</a>
										</c:when>
										<c:otherwise>
											<c:out value="" />
										</c:otherwise>
									</c:choose>
								</td>
								
							</tr>
						</c:forEach>
						</tbody>
				</table>
			
				
			</div> --%>
			</div>
		</div>
	</main>



	
	<!-- 푸터 연결 -->
	<%@ include file="../../common/footer.jsp"%>


	<script>
	$(document).ready(function(){
		//결과 메시지 처리
		let result = '<c:out value="${result}"/>';
		checkAlert(result);
		function checkAlert(result){
			
			if(result === ''){
				return;
			}
			if(result === "enroll success"){
				alert("등록이 완료되었습니다");
			}
			if(result === "modify success"){
				alert("수정이 완료되었습니다");
			}
			if(result === "delete success"){
				alert("삭제가 완료되었습니다");
			}
		}
	
		// 페이지 로드 시, 선택된 classNo에 따라 데이터를 불러오기
        sendClassChange();
		
     	// 반 선택 시 동작
        $('#classSelect').change(sendClassChange);
        
	}); 
       
	
	
	
		//페이지 정보 변경 처리
		$(".pageInfo a").on("click", function(e) {
			e.preventDefault();
			moveForm.find("input[name='pageNum']").val($(this).attr("href"));
			moveForm.attr("action", "/member/club/list");
			moveForm.submit();
		});

		//검색처리
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
	
		
		/* function sendClassChange() {
            let classNo = $("#classSelect").val();
            let pageNum = '<c:out value="${pageMaker.cri.pageNum}"/>';
            location.href = "/member/club/list?classNo=" + classNo + "&pageNum=" + pageNum;
        } */
        
	</script>

</body>
</html>