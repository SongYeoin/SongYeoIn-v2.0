<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>교육일지 수정</title>

<!-- jQuery 라이브러리 -->
<script src="https://code.jquery.com/jquery-3.4.1.js"
	integrity="sha256-WpOohJOqMqqyKL9FccASB9O0KwACQJpFTUBLTYOVvVU="
	crossorigin="anonymous"></script>

<style>
/* 기본 스타일 및 CSS Reset */
* {
	margin: 0;
	padding: 0;
	box-sizing: border-box;
}

html, body {
	height: 100%;
	font-family: Arial, sans-serif;
}

body {
	display: flex;
	flex-direction: column;
	background-color: #f4f4f4; /* 배경색 설정 */
	padding-top: 60px; /* 헤더 높이만큼 상단 여백 추가 */
}

header {
	position: fixed;
	top: 0;
	left: 0;
	width: 100%;
	background-color: #fff;
	border-bottom: 1px solid #ddd;
	padding: 10px 20px;
	box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
	z-index: 1000; /* 헤더가 콘텐츠 위에 보이도록 설정 */
}

main {
	flex: 1;
	margin-left: 250px;
	padding: 20px;
}


/* 기존 CSS는 그대로 유지하고 아래 스타일을 추가합니다 */

.form-container {
    max-width: 600px;
    margin: 2rem auto;
    padding: 2rem;
    background-color: #fff;
    border-radius: 8px;
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
}

.form-title {
    text-align: center;
    color: #333;
    margin-bottom: 2rem;
}

.form-group {
    margin-bottom: 1.5rem;
}

.form-group label {
    display: block;
    margin-bottom: 0.5rem;
    color: #555;
    font-weight: bold;
}

.form-group input[type="text"],
.form-group input[type="date"],
.form-group input[type="file"] {
    width: 100%;
    padding: 0.5rem;
    border: 1px solid #ddd;
    border-radius: 4px;
    font-size: 1rem;
}

.warn-message {
    display: none;
    color: #d9534f;
    font-size: 0.875rem;
    margin-top: 0.25rem;
}

.button-group {
    display: flex;
    justify-content: flex-end;
    gap: 1rem;
    margin-top: 2rem;
}

.btn {
    padding: 0.5rem 1rem;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    font-size: 1rem;
    transition: background-color 0.3s;
}

.btn-primary {
    background-color: #007bff;
    color: white;
}

.btn-primary:hover {
    background-color: #0056b3;
}

.btn-secondary {
    background-color: #6c757d;
    color: white;
}

.btn-secondary:hover {
    background-color: #545b62;
}
</style>
</head>
<body>

	<!-- 메뉴바 연결 -->
	<%@ include file="../common/header.jsp"%>

	<!-- 사용자 역할일 때 사이드바 -->
	<c:if test="${sessionScope.loginMember.memberRole eq 'ROLE_MEMBER'}">
		<%@ include file="../member/aside.jsp"%>
	</c:if>
	<!-- 관리자 역할일 때 사이드바 -->
	<c:if test="${sessionScope.loginMember.memberRole eq 'ROLE_ADMIN'}">
		<%@ include file="../admin/aside.jsp"%>
	</c:if>

	<main>
    <div class="form-container">
        <h1 class="form-title">교육일지 수정</h1>
	        <form action="${pageContext.request.contextPath}/journal/journalModify.do" method="post" id="modifyForm" enctype="multipart/form-data">
	            <input type="hidden" name="journalNo" value="${journal.journalNo}" />
            	<div class="form-group">
	                <label for="journalTitle">제목</label>
	                <input type="text" id="journalTitle" name="journalTitle" value="${journal.journalTitle}" required />
                <span class="warn-message" id="warn_journalTitle">교육일지 제목을 입력 해주세요.</span>
	            </div>
            	<div class="form-group">
	                <label for="journalWriteDate">작성일자</label>
	                <input type="date" id="journalWriteDate" name="journalWriteDate" value="${journal.journalWriteDate}" required />
                <span class="warn-message" id="warn_date">날짜를 선택해주세요.</span>
	            </div>
            	<div class="form-group">
	                <label for="file">첨부파일</label>
	                <input type="file" id="file" name="file" />
                <span class="warn-message" id="warn_file">교육일지 파일을 첨부해주세요.</span>
	            </div>
	            <div class="button-group">
	                <button type="button" id="cancelBtn" class="btn btn-secondary">취 소</button>
	                <button type="button" id="enrollBtn" class="btn btn-primary">확 인</button>
	            </div>
	        </form>
	    </div>
	</main>
	<script>
		/* 등록 버튼 */
		$("#enrollBtn").click(function() {
			/* 검사 통과 유무 변수 */
			let titleCheck = false; // 일지 제목
			let writeDateCheck = false; // 일지 작성일자
			let fileCheck = false; // 일지 첨부파일

			/* 입력값 변수 */
			let journalTitle = $('input[name=journalTitle]').val(); // 일지 제목
			let writeDate = $('input[name=journalWriteDate]').val(); // 일지 작성일자
			let file = $('input[name=file]')[0].files; // 일지 첨부파일

			/* 공란 경고 span 태그 */
			let wJournalTitle = $('#warn_journalTitle');
			let wWriteDate = $('#warn_date');
			let wFile = $('#warn_file');

			/* 일지 제목 공란 체크 */
			if (journalTitle === '') {
				wJournalTitle.css('display', 'block');
				titleCheck = false;
			} else {
				wJournalTitle.css('display', 'none');
				titleCheck = true;
			}

			/* 일지 작성일자 공란 체크 */
			if (writeDate === '') {
				wWriteDate.css('display', 'block');
				writeDateCheck = false;
			} else {
				wWriteDate.css('display', 'none');
				writeDateCheck = true;
			}

			/* 첨부파일 공란 체크 */
			if (file.length === 0) {
				wFile.css('display', 'block');
				fileCheck = false;
			} else {
				wFile.css('display', 'none');
				fileCheck = true;
			}

			/* 최종 검사 */
			if (titleCheck && writeDateCheck && fileCheck) {
				$("#modifyForm").submit();
			}
		});

		/* 취소 버튼 */
		$("#cancelBtn").click(function() {
			location.href = "/journal/journalList";
		});
	</script>
	<!-- 푸터 연결 -->
	<%@ include file="../common/footer.jsp"%>

</body>
</html>