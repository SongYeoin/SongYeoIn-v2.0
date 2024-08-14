<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>송파여성인력개발센터</title>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>

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
	/* min-height: 100vh; */
}

main {
	flex: 1;
	margin-left: 250px;
	padding-top: 90px;
	overflow-y: auto;
	top: 120px;
	left: 250px;
}

.box{
	height: 100%;

}

.form-container {
    padding: 20px;
    background-color: #f9f9f9;
    border: 1px solid #ddd;
    border-radius: 5px;
    width: 60%;
    margin: auto;
}

.form-container h2 {
    text-align: center;
    margin-bottom: 20px;
}

.form-group {
    margin-bottom: 15px;
}

.form-group label {
    display: block;
    margin-bottom: 5px;
    font-weight: bold;
}

.form-group input, .form-group textarea {
    width: 100%;
    padding: 8px;
    box-sizing: border-box;
    border: 1px solid #ccc;
    border-radius: 4px;
}

.form-group button {
    display: block;
    width: 100%;
    padding: 10px;
    background-color: #28a745;
    color: white;
    border: none;
    border-radius: 4px;
    font-size: 16px;
    cursor: pointer;
}

.form-group button:hover {
    background-color: #218838;
}                                  

.form-group button#cancelButton {
    background-color: #dc3545;
    color: white;
}

.form-group button#cancelButton:hover {
    background-color: #c82333;
}
</style>
</head>
<body>

	<!-- 메뉴바 연결 -->
	<%@ include file="../../common/header.jsp"%>

	<!-- 사이드바 연결 -->	
	<%@ include file="../../admin/aside.jsp"%>

   	<main>
        <!-- Main content -->
	    <div class="form-container">
	        <h2>반 등록</h2>
	        <form action="/admin/class/enroll" method="post" id="class-registration-form">
	            <div class="form-group">
	                <label for="className">반 이름:</label>
	                <input type="text" id="className" name="className" required>
	            </div>
	            <div class="form-group">
	                <label for="description">설명:</label>
	                <textarea id="description" name="description" required></textarea>
	            </div>
	            <div class="form-group">
	                <label for="managerName">관리자명:</label>
	                <input type="text" id="managerName" name="managerName" required>
	            </div>
	            <div class="form-group">
	                <label for="teacherName">강사명:</label>
	                <input type="text" id="teacherName" name="teacherName" required>
	            </div>
	            <div class="form-group">
	                <label for="classroomName">강의실:</label>
	                <input type="text" id="classroomName" name="classroomName" required>
	            </div>
	            <div class="form-group">
	                <label for="startDate">개강일:</label>
	                <input type="date" id="startDate" name="startDate" required>
	            </div>
	            <div class="form-group">
	                <label for="endDate">종강일:</label>
	                <input type="date" id="endDate" name="endDate" required>
	            </div>
	            <div class="form-group">
	                <button type="submit" id="enrollButton">등록</button>
	                <button type="button" id="cancelButton">취소</button>
	            </div>
	        </form>
	    </div>
    </main>

	<!-- 푸터 연결 -->
	<%@ include file="../../common/footer.jsp"%>
<script>

$(document).ready(function() {
	// 폼 제출 이벤트 처리
	$('#class-registration-form').on('submit', function(event) {
		
		// 기본 제출 동작 막기
		event.preventDefault();

		// 간단한 검증
		let valid = true;
		$('#class-registration-form input, #class-registration-form textarea').each(function() {
			if (!$(this).val()) {
				valid = false;
				alert('모든 필드를 채워주세요.');
				return false; // break
			}
		});

		if (valid) {
			this.submit(); // 폼 제출
		}
	});

	// 취소 버튼 클릭 시 어드민 메인화면으로 이동
	$('#cancelButton').on('click', function() {
		location.href = "/admin/class/getClassList";
	});
	
	// 서버에서 전달된 enroll_result 속성 확인
    var enrollResult = '${enroll_result}';
    
    if (enrollResult === 'success') {
    	if (confirm('반 등록이 성공적으로 완료되었습니다.')) {
            window.location.href = "/admin/class/getClassList#"; // 리다이렉트할 URL로 변경
        }
        
    } else if (enrollResult === 'fail') {
        alert('반 등록에 실패하였습니다. 다시 시도해 주세요.');
    }
});

</script>

</body>
</html>