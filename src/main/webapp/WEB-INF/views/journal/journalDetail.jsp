<!-- 교육일지 상세보기 페이지 -->
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>교육일지 상세보기</title>
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

.journal_detail {
    background-color: #fafafa;
    border-radius: 8px;
    padding: 20px;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.journal_detail p {
    margin-bottom: 15px;
    font-size: 16px;
    color: #333;
}

.journal_detail strong {
    color: #007bff;
}

.journal_detail .attachment {
    margin-top: 10px;
}

.journal_detail .attachment a {
    color: #007bff;
    text-decoration: none;
}

.journal_detail .attachment a:hover {
    text-decoration: underline;
}

footer {
    background-color: #007bff;
    color: #fff;
    text-align: center;
    padding: 15px 0;
    position: relative;
    bottom: 0;
    width: 100%;
}

.buttons {
    margin-top: 20px;
    text-align: right;
}

.buttons a, .buttons button {
    background-color: #007bff;
    color: #fff;
    border: none;
    padding: 10px 15px;
    border-radius: 5px;
    text-decoration: none;
    cursor: pointer;
    margin-left: 10px;
}

.buttons a:hover, .buttons button:hover {
    background-color: #0056b3;
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
        <h1>교육일지 상세보기</h1>
        <div class="journal_detail">
            <p><strong>제목:</strong> <c:out value="${journalDetail.journalTitle}" /></p>
            <p><strong>작성일자:</strong> <fmt:formatDate pattern="yyyy/MM/dd" value="${journalDetail.journalWriteDate}" /></p>
            <c:if test="${not empty journalDetail.fileName}">
                <p class="attachment">
                    <strong>첨부파일:</strong> 
                    <a href="${pageContext.request.contextPath}/journal/downloadFile?fileName=${journalDetail.fileName}" download>
                        <c:out value="${journalDetail.fileName}" />
                    </a>
                </p>
            </c:if>
        </div>
        <div class="buttons">
            <a href="${pageContext.request.contextPath}/journal/journalList">목록</a>
            <a href="${pageContext.request.contextPath}/journal/journalModify?journalNo=${journalDetail.journalNo}">수정</a>
            <form action="${pageContext.request.contextPath}/journal/journalDelete" method="post" style="display:inline;">
                <input type="hidden" name="journalNo" value="${journalDetail.journalNo}" />
                <button type="submit" onclick="return confirm('정말 삭제하시겠습니까?');">삭제</button>
            </form>
        </div>
    </div>
</main>

<!-- 푸터 연결 -->
<%@ include file="../common/footer.jsp"%>

</body>
</html>
