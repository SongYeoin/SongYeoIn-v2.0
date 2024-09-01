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
    font-family: Arial, sans-serif;
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

.bi-house-fill {
	cursor: pointer;
	font-size: 20px;
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

.table_wrap{
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

/* 페이지 정보 영역의 스타일 설정 */
.pageInfo_area {
	text-align: center; /* 가운데 정렬 */
	margin-top: 20px; /* 여백을 20px로 설정 */
}

.pageInfo{
	margin: 0px;
}

/* 페이지 정보 버튼의 기본 스타일 설정 */
.pageInfo_btn {
	display: inline-block; /* 인라인 블록으로 설정 */
	margin: 0 5px; /* 좌우 여백을 5px로 설정 */
}

/* 페이지 정보 버튼의 기본 스타일 설정 */
.pageInfo_btn a {
	display: block; /* 블록 요소로 설정 */
	padding: 10px 15px; /* 상하 패딩 10px, 좌우 패딩 15px으로 설정 */
	text-decoration: none;  /* 밑줄 제거 */ 
	border-radius: 5px; /* 모서리를 둥글게 설정 */
	color: black !important;
}

/* 페이지 정보 버튼 호버 시 스타일 설정 */
.pageInfo_btn a:hover {
	background-color: #e9ecef; /* 호버 시 배경색을 더 진한 회색으로 설정 */
}

/* 페이지 정보 버튼 활성 상태의 스타일 설정 */
.pageInfo_btn.active a {
	background-color: #007bff !important; /* 활성화된 버튼의 배경색을 파란색으로 설정 */
	color: white !important; /* 활성화된 버튼의 텍스트 색상을 흰색으로 설정 */
}

/* 페이지 정보 버튼 '다음'과 '이전' 버튼의 스타일 설정 */
.pageInfo_btn.previous a, .pageInfo_btn.next a {
	font-weight: bold ; /* 텍스트 굵기를 bold로 설정 */
}

/* 페이지 정보 버튼 '다음'과 '이전' 버튼의 커서 스타일 설정 */
.pageInfo_btn.previous a:hover, .pageInfo_btn.next a:hover {
	background-color: #0056b3; /* 호버 시 배경색을 더 어두운 파란색으로 설정 */
	color: white !important; /* 호버 시 텍스트 색상을 흰색으로 설정 */
}

.totalCount {
	text-align: right;
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
    <%@ include file="../../../common/header.jsp"%>

	<div class="classroom-header">
			<i class="bi bi-house-fill" onclick="location.href='${pageContext.servletContext.contextPath}/admin/class/getClassList'"></i>
            <div class="title">${syclass.className}</div>
            <div class="details">담당자: ${syclass.managerName} | 강사명: ${syclass.teacherName}</div>
    </div>

    <!-- 사이드바 연결 -->    
    <%@ include file="../aside.jsp"%>

	<!-- Main content -->
	 <main>
		<div class="container">
			<div class="header">
				<h2>강의실 신청</h2>
				<div class="search_area">
					<form id="searchForm" method="get" action="/admin/class/club/list">
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
					<i class="fas fa-filter"></i>
				</div>
			</div>

			<div id="tableContainer" class="table_wrap">
			
				<table>
					<thead>
						<tr>
							<th><input type="checkbox"></th>
							<th class="clubNo_width">번호</th>
							<th class="writer_width">작성자</th>
							<th class="checkStatus_width">승인상태</th>
							<th class="checkCmt_width">승인메시지</th>
							<th class="studyDate_width">활동일</th>
							<th class="regDate_width">작성일</th>
							<th class="file_width">첨부</th>
							<th>...</th>
						</tr>
					</thead>
					<tbody>
				<!-- 데이터는 AJAX 호출 후 여기에 삽입됩니다 -->	
					</tbody>
				</table>

				<div class="pageInfo_area">
					<ul id="pageInfo" class="pageInfo">
				<!-- 데이터는 AJAX 호출 후 여기에 삽입됩니다 -->	
					</ul>
				</div>
				<div id="totalCount" class="totalCount">
				<!-- 데이터는 AJAX 호출 후 여기에 삽입됩니다 -->
				</div>	
			</div>
		</div>
	</main>


    <!-- 푸터 연결 -->
    <%@ include file="../../../common/footer.jsp"%>


	<script>
	$(document).ready(function(){
		let classNo = '<c:out value="${param.classNo}"/>';
		
		function sendClassChange() {
		    if (!classNo) {
		        console.error("classNo 값이 누락되었습니다.");
		        return;
		    }
		    
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
		        	 }else {
		                 updateTable(response.list, classNo);
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
		     
		        var row = '<tr onclick="location.href=\'/admin/class/club/get?clubNo=' + item.clubNo + '&rn=' + item.rn + '&classNo=' + classNo + '\'">' +
		        			'<td><input type="checkbox"></td>' +
		        			'<td>' + item.rn + '</td>' +
		                    '<td>' + item.enroll.member.memberName + '</td>' +
		                    '<td>' + (item.checkStatus === 'W' ? '대기' : item.checkStatus === 'Y' ? '승인' : '미승인') + '</td>' +
		                    '<td>' + (item.checkCmt || '') + '</td>' +
		                    '<td>' + formattedStudyDate + '</td>' +
		                    '<td>' + formattedRegDate + '</td>' +
		                    '<td>' + (item.fileName ? '<a href="/admin/class/club/downloadFile?fileName=' + item.fileName + '" download="' + item.fileName + '" title="' + item.fileName + '" class="file-download"><i class="bi bi-paperclip"></i></a>' : '') + '</td>' +
		                  	'<td><div class="dropdown"><button class="dropbtn" onclick="event.stopPropagation(); toggleDropdown(event);">...</button><div class="dropdown-content">' +
		                  			'<a href="/admin/class/club/modify?clubNo=' + item.clubNo + '&classNo=' + classNo + '&rn=' + item.rn + '">수정하기</a>' +
		                  			'<a href="#" onclick="submitDeleteForm(event, ' + item.clubNo + ', ' + classNo + ')">삭제하기</a></div></div></td>' +
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
		        pageUl.append('<li class="pageInfo_btn previous"><a href="' + (pageInfo.pageStart - 1) + '">◀</a></li>');
		    }
		    for (var num = pageInfo.pageStart; num <= pageInfo.pageEnd; num++) {
		        pageUl.append('<li class="pageInfo_btn ' + (pageInfo.cri.pageNum == num ? 'active' : '') + '"><a href="' + num + '">' + num + '</a></li>');
		    }
		    if (pageInfo.next) {
		        pageUl.append('<li class="pageInfo_btn next"><a href="' + (pageInfo.pageEnd + 1) + '">▶</a></li>');
		    }
		    
		    var totalUl = $('#totalCount');
		    totalUl.empty();
		    totalUl.append('<p>총 ' + pageInfo.total +'건</p>');
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
        
		sendClassChange();
		
		
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
	        
            loadPageData(classNo, 1, type, keyword); // 검색 후 첫 페이지 로드

        });
        
     	// 페이지 번호 클릭 시 데이터 로드
        $(document).on('click', '.pageInfo_btn a', function(e) {
            e.preventDefault();
            const pageNum = $(this).attr('href');
            const type = $(".search_area select[name='type']").val();
            const keyword = $(".search_area input[name='keyword']").val();
            loadPageData(classNo, pageNum, type, keyword);
        });
        
	}); 
        
	let currentDropdown = null;

	function toggleDropdown(event) {
	    event.stopPropagation();
	    const dropdown = event.currentTarget.nextElementSibling;
	    if (currentDropdown && currentDropdown !== dropdown) {
	        currentDropdown.style.display = 'none';
	    }
	    dropdown.style.display = dropdown.style.display === 'block' ? 'none' : 'block';
	    currentDropdown = dropdown.style.display === 'block' ? dropdown : null;
	}

	window.onclick = function(event) {
	    if (currentDropdown && !event.target.matches('.dropbtn')) {
	        currentDropdown.style.display = 'none';
	        currentDropdown = null;
	    }
	}
	
	// 삭제 post 요청 비동기 처리 
	function submitDeleteForm(event, clubNo, classNo) {
		event.stopPropagation(); // 클릭 이벤트의 전파를 막음
		
	    if (confirm("정말로 삭제하시겠습니까?")) { // 삭제 확인
	        // AJAX 요청 생성
	        var xhr = new XMLHttpRequest();
	        xhr.open("POST", "/admin/class/club/deleteadmin", true);
	        xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

	        // 서버로부터 응답이 왔을 때의 처리
	        xhr.onreadystatechange = function() {
	            if (xhr.readyState === XMLHttpRequest.DONE) {
	                if (xhr.status === 200) {
	                    if (xhr.responseText === "success") {
	                        alert("정상적으로 삭제되었습니다.");
	                        window.location.href = "/admin/class/club/list?classNo="+classNo; // 원하는 페이지로 리다이렉트
	                    } else {
	                        alert("삭제에 실패했습니다. 다시 시도해 주세요.");
	                    }
	                } else {
	                    alert("서버와의 통신에 실패했습니다.");
	                }
	            }
	        };

	        // 폼 데이터 전송
	        xhr.send("clubNo=" + clubNo + "&classNo=" + classNo);
	    }
	}
	
	</script>
</body>
</html>
