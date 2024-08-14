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


</style>
</head>
<body>

<!-- 메뉴바 연결 -->
<%@ include file="../common/header.jsp"%>

<!-- 사이드바 연결 -->
<%@ include file="../member/aside.jsp"%>

<main>
    <div class="box">
        <h1>교육일지 작성</h1>
        <form action="/journal/journalEnroll" method="post" id="enrollForm" enctype="multipart/form-data">
            <div class="form_section">
                <div class="form_section_title">
                    <label>교육일지 제목</label>
                </div>
                <div class="form_section_content">
                    <input name="journalTitle" type="text" />
                    <span id="warn_journalTitle" style="display:none;">교육일지 제목을 입력 해주세요.</span>
                </div>
            </div>
            <div class="form_section">
                <div class="form_section_title">
                    <label>교육일지 작성일자</label>
                </div>
                <div class="form_section_content">
                    <input type="date" id="writeDate" name="journalWriteDate" />
                    <span id="warn_date" style="display:none;">날짜를 선택해주세요.</span>
                </div>
            </div>
            <div class="form_section">
                <div class="form_section_title">
                    <label for="file">첨부파일</label>
                </div>
                <div class="form_section_content">
                    <input name="file" type="file" id="file" required />
                    <span id="warn_file" style="display:none;">교육일지 파일을 첨부해주세요.</span>
                </div>
            </div>
            <div class="btn_section">
                <button type="button" id="cancelBtn" class="btn">취 소</button>
                <button type="button" id="enrollBtn" class="btn">등 록</button>
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
            $("#enrollForm").submit();
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
