<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>교육일지 등록</title>

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

/* 헤더 스타일 */
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

/* 메인 콘텐츠 영역 */
main {
    flex: 1;
    margin-left: 250px;
    padding: 20px;
}

/* 폼 박스 스타일 */
.box {
    background-color: #fff;
    border-radius: 8px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    padding: 20px;
    max-width: 800px;
    margin: 0 auto; /* 페이지 중앙 정렬 */
}

h1 {
    margin-bottom: 20px;
    color: #333;
    font-size: 24px;
    border-bottom: 2px solid #007bff;
    padding-bottom: 10px;
}

.form_section {
    background-color: #fff;
    border-radius: 8px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    padding: 20px;
    margin-bottom: 20px;
}

.form_section_title {
    margin-bottom: 10px;
}

.form_section_content {
    margin-bottom: 10px;
}

.form_section label {
    font-weight: bold;
}

input[type="text"], input[type="date"], input[type="file"] {
    width: 100%;
    padding: 8px;
    border: 1px solid #ddd;
    border-radius: 4px;
    font-size: 16px;
}

input[type="text"]:focus, input[type="date"]:focus, input[type="file"]:focus {
    border-color: #007bff;
    outline: none;
}

/* 버튼 영역 스타일 */
.btn_section {
    text-align: right;
}

.btn {
    background-color: #007bff;
    color: #fff;
    border: none;
    padding: 10px 15px;
    border-radius: 5px;
    cursor: pointer;
    margin-left: 10px;
    font-size: 16px;
}

.btn:hover {
    background-color: #0056b3;
}

/* 경고 메시지 스타일 */
span {
    display: block;
    color: red;
    font-size: 14px;
}

/* 푸터 스타일 */
footer {
    background-color: #007bff;
    color: #fff;
    text-align: center;
    padding: 15px 0;
    position: relative;
    bottom: 0;
    width: 100%;
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
        <h1>교육일지 등록</h1>
        <form action="/journal/journalEnroll.do" method="post" id="enrollForm" enctype="multipart/form-data">
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
