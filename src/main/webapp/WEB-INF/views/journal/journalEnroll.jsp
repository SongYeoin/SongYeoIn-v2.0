<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>교육일지 작성</title>

<!-- jQuery 라이브러리 -->
<script src="https://code.jquery.com/jquery-3.4.1.js"
    integrity="sha256-WpOohJOqMqqyKL9FccASB9O0KwACQJpFTUBLTYOVvVU="
    crossorigin="anonymous"></script>

<style>
/* CSS Reset - 모든 요소의 기본 여백과 패딩을 제거하고 박스 사이징을 border-box로 설정 */
* {
	margin: 0;
	padding: 0;
	box-sizing: border-box;
}

/* html과 body 요소의 높이를 1080px로 설정 */
html, body {
	height: 1080px;
}

/* body에 폰트 패밀리를 설정하고 flexbox로 레이아웃을 설정 */
body {
	font-family: Arial, sans-serif;
	display: flex;
	flex-direction: column;
}

/* main 요소는 좌측에 사이드바를 두고 상단에는 헤더를 두며 세로 스크롤이 가능하게 설정 */
main {
	flex: 1;
	margin-left: 300px;
	margin-top: 110px;
	overflow-y: auto;
	height: 100%;
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

<!-- 사이드바 연결 -->
<%@ include file="../member/aside.jsp"%>

<main>
    <div class="form-container">
        <h1 class="form-title">교육일지 작성</h1>
        <form action="/journal/journalEnroll" method="post" id="enrollForm" enctype="multipart/form-data">
            <div class="form-group">
                <label for="journalTitle">교육일지 제목</label>
                <input id="journalTitle" name="journalTitle" type="text" />
                <span class="warn-message" id="warn_journalTitle">교육일지 제목을 입력 해주세요.</span>
            </div>
            <div class="form-group">
                <label for="writeDate">교육일지 작성일자</label>
                <input type="date" id="writeDate" name="journalWriteDate" />
                <span class="warn-message" id="warn_date">날짜를 선택해주세요.</span>
            </div>
            <div class="form-group">
                <label for="file">첨부파일</label>
                <input name="file" type="file" id="file" required />
                <span class="warn-message" id="warn_file">교육일지 파일을 첨부해주세요.</span>
            </div>
            <div class="button-group">
                <button type="button" id="cancelBtn" class="btn btn-secondary">취 소</button>
                <button type="button" id="enrollBtn" class="btn btn-primary">등 록</button>
            </div>
        </form>
    </div>
</main>

<script>
    // 서버에서 설정한 `selectedClassNo` 값을 JavaScript 변수로 설정합니다.
    var selectedClassNo = '${selectedClassNo}';

    // 등록 버튼 클릭 시 처리
    $("#enrollBtn").click(function() {
        let titleCheck = false; // 일지 제목
        let writeDateCheck = false; // 일지 작성일자
        let fileCheck = false; // 일지 첨부파일

        let journalTitle = $('input[name=journalTitle]').val(); // 일지 제목
        let writeDate = $('input[name=journalWriteDate]').val(); // 일지 작성일자
        let file = $('input[name=file]')[0].files; // 일지 첨부파일

        let wJournalTitle = $('#warn_journalTitle');
        let wWriteDate = $('#warn_date');
        let wFile = $('#warn_file');

        // 일지 제목 공란 체크
        if (journalTitle === '') {
            wJournalTitle.css('display', 'block');
            titleCheck = false;
        } else {
            wJournalTitle.css('display', 'none');
            titleCheck = true;
        }

        // 일지 작성일자 공란 체크
        if (writeDate === '') {
            wWriteDate.css('display', 'block');
            writeDateCheck = false;
        } else {
            wWriteDate.css('display', 'none');
            writeDateCheck = true;
        }

        // 첨부파일 공란 체크
        if (file.length === 0) {
            wFile.css('display', 'block');
            fileCheck = false;
        } else {
            wFile.css('display', 'none');
            fileCheck = true;
        }

        // 최종 검사 및 폼 제출
        if (titleCheck && writeDateCheck && fileCheck) {
            // `classNo` 값을 폼에 설정
            $('<input>').attr({
                type: 'hidden',
                name: 'classNo',
                value: selectedClassNo
            }).appendTo('#enrollForm');

            $("#enrollForm").submit(); // 폼 제출
        }
    });

    // 취소 버튼 클릭 시 처리
    $("#cancelBtn").click(function() {
        location.href = "/journal/journalList";
    });
</script>


<!-- 푸터 연결 -->
<%@ include file="../common/footer.jsp"%>

</body>
</html>
