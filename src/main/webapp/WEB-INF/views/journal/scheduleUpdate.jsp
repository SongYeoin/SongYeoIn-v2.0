<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Update Schedule</title>
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css">
<style>
/* 기본 스타일 및 CSS Reset */
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
    /* min-height: 100vh; */
}

main {
    flex: 1;
    margin-left: 250px;
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

/* 추가 및 수정된 스타일 */
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
.form-group input[type="date"] {
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
    text-decoration: none;
    display: inline-block;
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

	<!-- header 영역 -->
	<%@ include file="../common/header.jsp"%>

	<div class="classroom-header">
		<i class="bi bi-house-fill"
			onclick="location.href='${pageContext.servletContext.contextPath}/admin/class/getClassList'"></i>
		<div class="title">${syclass.className}</div>
		<div class="details">담당자: ${syclass.managerName} | 강사명:
			${syclass.teacherName}</div>
	</div>

	<!-- 사이드바 연결 -->
	<%@ include file="../admin/class/aside.jsp"%>

	<main>
	    <div class="form-container">
	        <h1 class="form-title">교육 일정 수정하기</h1>
	        <form id="scheduleForm" action="${pageContext.request.contextPath}/journal/scheduleUpdate" method="post">
	            <input type="hidden" name="scheduleNo" value="${schedule.scheduleNo}" />
	            <input type="hidden" name="classNo" value="${schedule.classNo}" />
	            <div class="form-group">
	                <label>현재 선택된 반:</label>
	                <span>${syclass.className}</span>
	            </div>
	            <div class="form-group">
	                <label for="scheduleTitle">단원명</label>
	                <input type="text" id="scheduleTitle" name="scheduleTitle" value="${schedule.scheduleTitle}" required />
	                <span class="warn-message" id="warn_scheduleTitle">단원명을 입력해주세요.</span>
	            </div>
	            <div class="form-group">
	                <label for="scheduleDate">일자</label>
	                <input type="date" id="scheduleDate" name="scheduleDate" value="${schedule.scheduleDate}" required />
	                <span class="warn-message" id="warn_scheduleDate">일자를 입력해주세요.</span>
	            </div>
	            <div class="form-group">
	                <label for="scheduleDescription">학습주제</label>
	                <input type="text" id="scheduleDescription" name="scheduleDescription" value="${schedule.scheduleDescription}" />
	            </div>
	            <div class="form-group">
	                <label for="scheduleInstructor">강사</label>
	                <input type="text" id="scheduleInstructor" name="scheduleInstructor" value="${schedule.scheduleInstructor}" />
	            </div>
	            <div class="button-group">
	                <a href="${pageContext.request.contextPath}/journal/scheduleList" class="btn btn-secondary">취소</a>
	                <button type="submit" class="btn btn-primary">수정하기</button>
	            </div>
	        </form>
	    </div>
	</main>

	<script>
		document.getElementById('scheduleForm')
				.addEventListener(
						'submit',
						function(event) {
							let valid = true;

							// 단원명 검사
							let scheduleTitle = document
									.getElementById('scheduleTitle').value;
							let titleWarning = document
									.getElementById('warn_scheduleTitle');
							if (scheduleTitle.trim() === '') {
								titleWarning.style.display = 'block';
								valid = false;
							} else {
								titleWarning.style.display = 'none';
							}

							// 일자 검사
							let scheduleDate = document
									.getElementById('scheduleDate').value;
							let dateWarning = document
									.getElementById('warn_scheduleDate');
							if (scheduleDate.trim() === '') {
								dateWarning.style.display = 'block';
								valid = false;
							} else {
								dateWarning.style.display = 'none';
							}

							if (!valid) {
								event.preventDefault(); // 폼 제출 방지
							}
						});
	</script>
	<!-- 푸터 연결 -->
	<%@ include file="../common/footer.jsp"%>
</body>
</html>
