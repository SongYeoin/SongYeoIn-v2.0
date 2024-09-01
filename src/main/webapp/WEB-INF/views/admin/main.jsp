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
	margin-left: 300px;
	padding-top: 120px;
	overflow-y: auto;
	height: 100%;
}

</style>
</head>
<body>

	<!-- 메뉴바 연결 -->
	<%@ include file="../common/header.jsp"%>

	<!-- 사이드바 연결 -->	
	<%@ include file="aside.jsp"%>

   <main>
        <!-- Main content -->
        <div>
        	글자라도 써봅니다
        </div>
        
        <!-- 버튼 추가 -->
        <div style="margin-top: 20px;">
            <button id="attendanceButton" onclick="sendAttendanceRequest()">자동 결석 처리</button>
        </div>
    </main>

	<!-- 푸터 연결 -->
	<%@ include file="../common/footer.jsp"%>

<script>
function sendAttendanceRequest() {
    $.ajax({
        url: '<c:url value="/admin/class/attendance/absent" />', // 서버 요청 URL
        type: 'POST',
        success: function(response) {
            alert("자동 결석 처리가 완료되었습니다!");
        },
        error: function(xhr, status, error) {
            alert("오류가 발생했습니다. 다시 시도해주세요.");
        }
    });
}
</script>

</body>
</html>