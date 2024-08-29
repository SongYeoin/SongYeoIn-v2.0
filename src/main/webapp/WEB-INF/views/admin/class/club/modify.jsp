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

.input_wrap {
	padding: 5px 20px;
}

label {
	display: block;
	margin: 10px 0;
	font-size: 20px;
}

input {
	padding: 5px;
	font-size: 17px;
}

.large-input{
	width: 500px;
}

textarea {
	width: 800px;
	height: 95px;
	font-size: 15px;
	padding: 10px;
}

.btn {
	display: inline-block;
	font-size: 22px;
	padding: 6px 12px;
	background-color: #fff;
	border: 1px solid #ddd;
	font-weight: 600;
	width: 140px;
	height: 41px;
	line-height: 39px;
	text-align: center;
	margin-left: 30px;
	cursor: pointer;
}

.btn_wrap {
	padding-left: 80px;
	margin-top: 50px;
}

.bi-house-fill {
	cursor: pointer;
	font-size: 20px;
}

</style>
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

	<main>
		<!-- Main content -->
		<div>
			<h1>수정 페이지</h1>
			<form id="modifyForm" action="/admin/class/club/modify" method="post" enctype="multipart/form-data">
			<input type="hidden" name="classNo" value='<c:out value="${param.classNo }"/>'>
			<input type="hidden" id="checkStatusHidden" name="checkStatus" value="N">
			
			<div class="input_wrap">
				<label>번호</label> <input name="clubNo" readonly="readonly"
					value='<c:out value="${pageInfo.clubNo }"/>'>
			</div>
			<div class="input_wrap">
				<label>작성자</label> <input name="memberName" readonly="readonly"
					value='<c:out value="${pageInfo.enroll.member.memberName }"/>'>
			</div>
			<div class="input_wrap">
				<label>참여자</label> <input name="join" class="large-input" id="joinInput" readonly="readonly"
					value='<c:out value="${pageInfo.join}"/>'>
			</div>
			<div class="input_wrap">
				<label>내용</label>
				<textarea rows="3" name="content" readonly="readonly"><c:out
						value="${pageInfo.content}" /></textarea>
			</div>
		<!-- 	<div class="input_wrap">
				<label>승인상태</label>
				<input type="checkbox" id="approveCheckbox" name="approve" value="Y">
			    <label for="approveCheckbox">승인</label>
			    <input type="checkbox" id="denyCheckbox" name="deny" value="N">
			    <label for="denyCheckbox">미승인</label>
			</div> -->
			
			
			
			    <div class="input_wrap">
        <label>승인상태</label>
        <input type="checkbox" id="approveCheckbox" name="approve" value="Y" <c:if test="${pageInfo.checkStatus == 'Y'}">checked</c:if>>
        <label for="approveCheckbox">승인</label>
        <input type="checkbox" id="denyCheckbox" name="deny" value="N" <c:if test="${pageInfo.checkStatus == 'N'}">checked</c:if>>
        <label for="denyCheckbox">미승인</label>
    </div>
    
 
			
			  <div class="input_wrap">
        <label>승인메시지</label>
        <input name="checkCmt" id="checkCmt" value='<c:out value="${pageInfo.checkCmt }"/>'>
    </div>
			
			
			
			<div class="input_wrap">
				<label>활동일</label> <input type="date" name="studyDate" id="studyDateInput" readonly="readonly"
					value='<fmt:formatDate pattern="yyyy-MM-dd" value="${pageInfo.studyDate }"/>'>
			</div>
			<div class="input_wrap">
				<label>작성일</label> <input name="regDate" readonly="readonly"
					value='<fmt:formatDate pattern="yyyy-MM-dd" value="${pageInfo.regDate }"/>'>
			</div>
		
			<div class="input_wrap">
				<label>첨부파일</label>
				<%-- <input name="file" readonly="readonly" value="${pageInfo.fileName == null ? '첨부파일 없음' : '<c:out value="${pageInfo.fileName }"/>'}"> --%>
				<c:choose>
				<c:when test="${pageInfo.fileName != null && !pageInfo.fileName.isEmpty() }">
				<input name="file" readonly="readonly" class="large-input" value='<c:out value="${pageInfo.fileName }"/>'>
				</c:when>
				<c:otherwise>
				<input name="file" readonly="readonly" value="첨부파일 없음">
				</c:otherwise>
			</c:choose>
			</div>
			</form>
	
			<div class="btn_wrap">
				<a class="btn" id="modify_btn">수정</a>
				<a class="btn" id="list_btn">취소</a>
			</div>
			<form id="infoForm" action="/admin/class/club/modify" method="get">
				<input type="hidden" id="clubNo" name="clubNo" value='<c:out value="${pageInfo.clubNo }"/>'>
				<input type="hidden" id="classNo" name="classNo" value='<c:out value="${param.classNo }"/>'>
				<input type="hidden" name="keyword" value="${cri.keyword}">
				<input type="hidden" name="type" value="${cri.type}">
			</form>


		</div>

	</main>

	<!-- 푸터 연결 -->
	<%@ include file="../../../common/footer.jsp"%>


	<script>
	$(document).ready(function() {
		let form = $("#infoForm"); //리스트, 조회
		let mForm = $("#modifyForm"); //수정

		$("#list_btn").on("click", function(e) {
			e.preventDefault();
			form.find("#clubNo").remove();
			form.attr("action", "/admin/class/club/list");
			form.submit();
		});

		$("#modify_btn").on("click", function(e) {
			e.preventDefault();
			
			if (validateForm()) {
				// 체크박스 상태를 숨겨진 필드에 반영
	            let checkStatusHidden = $("#checkStatusHidden");
	            if ($("#approveCheckbox").is(":checked")) {
	                checkStatusHidden.val("Y"); // 승인 상태에서 'Y'로 설정
	            } else if ($("#denyCheckbox").is(":checked")) {
	                checkStatusHidden.val("N"); // 미승인 상태에서 'N'으로 설정
	            } else {
	                checkStatusHidden.val("N"); // 기본값 설정 (미승인)
	            }
		        mForm.submit(); // 검증 통과 시 폼 제출
		    }
		});
		
		function validateForm() {
		     
			// 승인 상태를 확인합니다.
		    let approveChecked = $("#approveCheckbox").is(":checked");
		    let denyChecked = $("#denyCheckbox").is(":checked");

		    // 승인 메시지를 확인합니다.
		    let checkCmt = $("#checkCmt").val().trim();
		    
		 	// 승인 상태 체크박스와 승인 메시지 검증
		    if (!approveChecked && !denyChecked) {
		        alert('승인 상태를 선택해 주세요.');
		        return false; // 폼 제출을 막습니다.
		    }

		    if (checkCmt === '') {
		        alert('승인 메시지를 입력해 주세요.');
		        return false; // 폼 제출을 막습니다.
		    }
		    
		    return true; // 폼 제출을 허용합니다.
		}
	});
	
	// 승인 체크박스와 미승인 체크박스의 상호작용 관리
    $("#approveCheckbox").on("change", function() {
        if ($(this).is(":checked")) {
            $("#denyCheckbox").prop("checked", false);
        }
    });

    $("#denyCheckbox").on("change", function() {
        if ($(this).is(":checked")) {
            $("#approveCheckbox").prop("checked", false);
        }
    });
    
	/* document.addEventListener('DOMContentLoaded', function() {
        var checkStatus = '${pageInfo.checkStatus}';
        if (checkStatus === 'Y') {
            document.getElementById('approveCheckbox').checked = true;
            document.getElementById('denyCheckbox').checked = false;
        } else if (checkStatus === 'N') {
            document.getElementById('approveCheckbox').checked = false;
            document.getElementById('denyCheckbox').checked = true;
        } else {
            document.getElementById('approveCheckbox').checked = false;
            document.getElementById('denyCheckbox').checked = false;
        }
    }); */
		
	</script>

</body>
</html>