<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>송파여성인력개발센터</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>

<style>
/* CSS Reset */
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

html, body {
    height: 100%;
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
    padding: 20px;
    height: calc(100% - 130px); /* Adjusted height to account for margins */
}

.title-container {
    display: flex;
    align-items: center;
    margin-bottom: 20px;
}

.title-container h1 {
    margin-right: 20px;
    font-weight: bold;
}

.select-box {
    position: relative;
    display: inline-block;
    width: 250px;
}

.select-box select {
    width: 100%;
    padding: 10px;
    font-size: 1em;
    border: 1px solid #ddd;
    border-radius: 5px;
    background: #f8f8f8;
}

.date-container {
    text-align: center;
    margin-bottom: 20px;
}

.date-container h2 {
    font-size: 1.8em; /* Reduced font size */
    font-weight: bold;
    color: #333;
    margin-bottom: 5px; /* Add spacing between date and day */
}

.date-container h3 {
    font-size: 1.2em; /* Font size for the day */
    color: #666;
}

/* Layout with flexbox */
.content-container {
    display: flex;
    gap: 100px; 
}

/* Left side (Card container) */
.card-container {
    flex: 2; /* Occupy more space for cards */
    display: flex;
    flex-direction: column;
    align-items: left;
    gap: 20px;
}

.card {
    display: flex !important;
    background-color: #fff !important;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    border-radius: 10px !important;
    padding: 5px 20px;
    width: 100%;
    text-align: left;
    flex-direction: row !important;
    justify-content: space-between !important;
    align-items: center !important;
}

.card h3 {
    margin-bottom: 10px;
    font-size: 1.5em;
    color: #555;
}

.card p {
    font-size: 1em;
    color: #777;
}

/* Attendance button styling */
.attendance-btn {
    background-color: #28a745;
    color: white;
    border: none;
    padding: 10px 20px;
    border-radius: 5px;
    cursor: pointer;
    font-size: 1em;
    text-align: right;
}

.attendance-btn:hover {
    background-color: #218838;
}

/* Right side (Additional info) */
.info-container {
    flex: 1; 
    background-color: #fff;
    border-radius: 10px;
    padding: 15px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    text-align: left;
}

.info-container h2 {
    font-size: 1.4em;
    margin-bottom: 10px;
    font-weight: bold;
}

.info-container p {
    font-size: 1em;
    color: #555;
    margin-bottom: 20px;
}

.info-container .today-btn, .info-container .attendance-btn {
    display: block;
    margin: 10px 0; /* Remove 'auto' to left align */
    padding: 5px 10px;
    background-color: #000;
    color: white;
    border-radius: 5px;
    font-size: 0.9em;
    width: fit-content;
    border: none; /* Remove border */
    cursor: pointer; /* Add pointer cursor */
    text-decoration: none;
}

.button-group {
    display: flex;
    justify-content: center;
    gap: 5px; 
}

.info-container .today-btn, .info-container .attendance-btn[disabled] {
    border-radius: 15px; 
    padding: 3px 10px; 
    cursor: default;
    background-color: #000;
    color: white;
    text-decoration: none;
}

.info-container .today-btn:hover, .info-container .attendance-btn:hover {
    background-color: #333;
}

.info-container .progress-bar {
    width: 100%;
    background-color: #e0e0e0;
    border-radius: 5px;
    overflow: hidden;
    margin-bottom: 10px;
}

.info-container .progress {
    width: 37.5%; /* Example percentage */
    height: 10px;
    background-color: #28a745;
}

.info-container .percentage {
    font-size: 0.9em;
    color: #555;
}
</style>
</head>
<body>

    <!-- 메뉴바 연결 -->
    <%@ include file="../../common/header.jsp"%>

    <!-- 사이드바 연결 -->
    <%@ include file="../aside.jsp"%>

    <c:set var="now" value="<%= new java.util.Date() %>" />

    <main>
        <!-- Title and Select Box -->
        <div class="title-container">
            <h1>출석 체크</h1>
            <div class="select-box">
                <select id="classSelect" name="classSelect">
                    <option value="">JAVA&SPRING 백엔드 과정</option>
                    <!-- Add other options here -->
                </select>
            </div>
        </div>

        <!-- Date Display -->
        <div class="date-container">
            <h2><fmt:formatDate value="${now}" pattern="yyyy년 MM월 dd일" /></h2>
            <h3><fmt:formatDate value="${now}" pattern="EEEE" /></h3>
        </div>

        <!-- Main content area -->
        <div class="content-container">
            <!-- Left side (Card container) -->
            <div class="card-container">
                <div class="card">
                    <div>
                        <h3>1교시</h3>
                        <p>09:00 - 10:00</p>
                    </div>
                    <div><button class="attendance-btn">출석하기</button></div>
                </div>
                <!-- Add more card elements as needed -->
            </div>

            <!-- Right side (Additional info) -->
            <div class="info-container">
                <h2>나의 훈련 과정</h2>
                <p>JAVA&SPRING 백엔드 과정</p>
                <a href="#" class="today-btn" disabled>today</a>
                <p>2024년 7월 29일 월요일</p>
                <a href="#" class="attendance-btn" disabled>오늘의 출석</a>
                <p>3교시 / 총 8교시</p>
                <div class="progress-bar">
                    <div class="progress"></div>
                </div>
                <p class="percentage">총 37.5%</p>
                <div class="button-group">
                    <a href="전체출석조회.html" class="attendance-btn">전체 출석 조회</a>
                    <a href="일지제출하기.html" class="attendance-btn">일지 제출하기</a>
                </div>
            </div>
        </div>
    </main>

    <!-- 푸터 연결 -->
    <%@ include file="../../common/footer.jsp"%>

</body>
</html>
