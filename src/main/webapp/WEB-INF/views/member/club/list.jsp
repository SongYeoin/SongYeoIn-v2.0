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
	background-color: #f9fafc;
	box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
	max-width: 1320px;
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

/*  .pageInfo {
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
} */

.pageInfo_area {
    text-align: center; /* 중앙 정렬 */
    margin-top: 50px;
}

.pageInfo {
    list-style: none;
    display: inline-block; /* inline-block을 사용하여 중앙 정렬 */
    padding: 0;
    margin: 0;
}

.pageInfo li {
    display: inline; /* inline으로 설정하여 목록 항목을 나란히 배치 */
    font-size: 20px;
    margin: 0 9px;  /* 양쪽 여백을 조정 */
    padding: 7px;
    font-weight: 500;
}

a:link, a:visited, a:hover {
    color: black;
    text-decoration: none;
}

.pageInfo .active {
    background-color: #cdd5ec !important;
    font-weight: bold !important; /* 강조된 페이지의 텍스트를 굵게 표시 */
}

.pageInfo_btn.previous a, .pageInfo_btn.next a {
    font-weight: bold; /* 이전 및 다음 버튼 텍스트 굵게 표시 */
    color: black; /* 버튼 텍스트 색상 */
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
}

/* 중복된 아이콘을 숨깁니다 */
.bi-paperclip.duplicate {
    display: none; /* 중복된 아이콘 숨기기 */
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
		<h1>동아리</h1>
		<div class="select-box">
			<select id="classSelect" name="classSelect" onchange="sendClassChange()">
			    <c:forEach var="classItem" items="${classList}">
			        <option value="${classItem.classNo}" <c:if test="${classItem.classNo == param.classNo || (classItem.classNo == classList[0].classNo && param.classNo == null)}">selected</c:if>>${classItem.className}</option>
			    </c:forEach>
			</select>
		</div>
	</div>

		<!-- Main content -->
		<div class="container">
			<div class="header">
				<h2>강의실 신청</h2>
				<div class="search_area">
					<form id="searchForm" method="get" action="/member/club/list">
						<input type="hidden" name="pageNum" value="${pageMaker.cri.pageNum }">
						<input type="hidden" name="amount" value="${pageMaker.cri.amount }">
						<input type="hidden" name="classNo" value="${param.classNo}"> 
                        <select name="type">
                        	<option value="W" <c:out value="${pageMaker.cri.type eq 'W'? 'selected':''}"/>>작성자</option>
                        	<option value="J" <c:out value="${pageMaker.cri.type eq 'J'? 'selected':''}"/>>참여자</option>
                        	<option value="C" <c:out value="${pageMaker.cri.type eq 'C'? 'selected':''}"/>>승인상태</option>
                        </select>
                        <input type="text" name="keyword" value="${pageMaker.cri.keyword }">
						<button>조회</button>
					</form>
				</div>
				<div class="icons">
 					<a href="/member/club/enroll"><i class="fas fa-square-plus"></i></a> 
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
                	</tbody>
			</table>
			
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
		</div>
	</main>

	<!-- 푸터 연결 -->
	<%@ include file="../../common/footer.jsp"%>

	<script>
	$(document).ready(function(){
		let currentClassNo = '<c:out value="${param.classNo}"/>'; // 초기값 설정
		
		function sendClassChange() {
		    const classNo = $('#classSelect').val();
		    if (!classNo) {
		        console.error("classNo 값이 누락되었습니다.");
		        return;
		    }
		    currentClassNo = classNo; // 현재 classNo 업데이트
		    
		    const pageNum = 1; // 기본적으로 첫 페이지 로드
		    
		    const searchForm = $('#searchForm');

		    // 검색 조건 초기화
		    const type = searchForm.find("select[name='type']").val() || 'W'; // 기본값 설정
	        const keyword = searchForm.find("input[name='keyword']").val() || '';

	     	// 공백이 아닌 유효한 경우만 필터링 처리
	        if (type === 'C' && keyword.trim() && !['대기', '승인', '미승인'].includes(keyword.trim())) {
	            $('#tableContainer table tbody').html('<tr><td colspan="7">데이터가 없습니다.</td></tr>');
	            return;
	        }
	     
	        loadPageData(classNo, pageNum, type, keyword);
		}
    
		function loadPageData(classNo, pageNum, type, keyword) {
			 console.log('AJAX 요청 데이터:', { classNo, pageNum, type, keyword });
			 
		    $.ajax({
		        url: '/member/club/list/getByClass',
		        type: 'GET',
		        dataType: 'json',
		        data: { classNo: classNo, pageNum: pageNum, type: type, keyword: keyword },
		        success: function(response) {
		        	console.log('Response:', response); // 응답 데이터 확인
		        	 if (!response.list || response.list.length === 0) {
		        		if (keyword.trim()) { // 공백이 아닌 경우에만 "데이터가 없습니다." 표시
			         		$('#tableContainer table tbody').html('<tr><td colspan="7">데이터가 없습니다.</td></tr>');
			        	}
		             } else {
		                 updateTable(response.list, currentClassNo);
		             }
		             updatePagination(response.pageInfo);
		        },
		        error: function() {
		            alert('데이터를 가져오는 데 실패했습니다.');
		        }
		    });
		}

		function updateTable(data, classNo) {
			console.log('테이블 데이터:', data); // 데이터 확인
		    var tableBody = $('#tableContainer table tbody');
		    tableBody.empty();
		    if (!data || data.length === 0) {
		        tableBody.append('<tr><td colspan="7">데이터가 없습니다.</td></tr>');
		        return;
		    }
		    data.forEach(function(item) {
		        var studyDate = new Date(item.studyDate);
		        var regDate = new Date(item.regDate);
		        var formattedStudyDate = formatDate(studyDate);
		        var formattedRegDate = formatDate(regDate);
		     
		        var row = '<tr onclick="location.href=\'/member/club/get?clubNo=' + item.clubNo + '&rn=' + item.rn + '&classNo=' + classNo + '\'">' +
		                    '<td>' + item.rn + '</td>' +
		                    '<td>' + item.enroll.member.memberName + '</td>' +
		                    '<td>' + (item.checkStatus === 'W' ? '대기' : item.checkStatus === 'Y' ? '승인' : '미승인') + '</td>' +
		                    '<td>' + (item.checkCmt || '') + '</td>' +
		                    '<td>' + formattedStudyDate + '</td>' +
		                    '<td>' + formattedRegDate + '</td>' +
		                    '<td>' + (item.fileName ? '<a href="/member/club/downloadFile?fileName=' + item.fileName + '" download="' + item.fileName + '" title="' + item.fileName + '" class="file-download"><i class="bi bi-paperclip"></i></a>' : '') + '</td>' +
		                  '</tr>';
		        tableBody.append(row);   
		    });
		    
		  	//첨부파일 다운로드 링크에 대한 클릭 이벤트 핸들러 추가
		    $('.file-download').on('click', function(event) {
		        event.stopPropagation(); // 클릭 이벤트가 상위 요소로 전파되는 것을 막음
		    });
		}

		function updatePagination(pageInfo) {
		    var pageUl = $('#pageInfo');
		    pageUl.empty();
		    if (pageInfo.prev) {
		        pageUl.append('<li class="pageInfo_btn previous"><a href="' + (pageInfo.pageStart - 1) + '">Previous</a></li>');
		    }
		    for (var num = pageInfo.pageStart; num <= pageInfo.pageEnd; num++) {
		        pageUl.append('<li class="pageInfo_btn ' + (pageInfo.currentPage == num ? 'active' : '') + '"><a href="' + num + '">' + num + '</a></li>');
		    }
		    if (pageInfo.next) {
		        pageUl.append('<li class="pageInfo_btn next"><a href="' + (pageInfo.pageEnd + 1) + '">Next</a></li>');
		    }
		}

		function formatDate(date) {
		    var year = date.getFullYear();
		    var month = ('0' + (date.getMonth() + 1)).slice(-2);
		    var day = ('0' + date.getDate()).slice(-2);
		    return year + '/' + month + '/' + day;
		}
		
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
	 	const classNo = '<c:out value="${param.classNo}"/>';
        if (classNo) {
            $('#classSelect').val(classNo);
            sendClassChange();
        } else {
            sendClassChange();
        }
        
    
     	// 반 선택 시 동작
		$('#classSelect').change(function() {
		    sendClassChange();
		});
        
        $('.search_area button').on('click', function(e) {
            e.preventDefault();
            
            //검색조건확인
            let type = $(".search_area select[name='type']").val();
			let keyword = $(".search_area input[name='keyword']").val();
						
			if (!type) {
				alert("검색 종류를 선택하세요");
				return false;
			}
			
			// 공백이 아닌 유효한 경우만 필터링 처리
	        if (type === 'C' && keyword.trim() && !['대기', '승인', '미승인'].includes(keyword.trim())) {
	            $('#tableContainer table tbody').html('<tr><td colspan="7">데이터가 없습니다.</td></tr>');
	            return;
	        }
			
			// 폼 필드 업데이트
	        $('#searchForm').find("input[name='type']").val(type);
	        $('#searchForm').find("input[name='keyword']").val(keyword);
	        $('#searchForm').find("input[name='pageNum']").val(1);
	        
            const classNo = $('#classSelect').val();
            loadPageData(classNo, 1, type, keyword); // 검색 후 첫 페이지 로드

        });
        
     	// 페이지 번호 클릭 시 데이터 로드
        $(document).on('click', '.pageInfo_btn a', function(e) {
            e.preventDefault();
            const pageNum = $(this).attr('href');
            const classNo = $('#classSelect').val();
            const type = $(".search_area select[name='type']").val();
            const keyword = $(".search_area input[name='keyword']").val();
            loadPageData(classNo, pageNum, type, keyword);
        });
     	
     	// 등록 페이지로 이동
        $(document).on('click', '.icons a', function(e) {
            e.preventDefault();
            const url = $(this).attr('href') + '?classNo=' + currentClassNo;
            window.location.href = url;
        });
     	
	}); 
       
	</script>

</body>
</html>