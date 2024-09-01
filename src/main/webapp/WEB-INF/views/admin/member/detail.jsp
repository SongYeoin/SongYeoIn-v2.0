<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>송파여성인력센터</title>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<style>

* {
	margin: 0;
	padding: 0;
	box-sizing: border-box;
}

html, body {
	height: 1080px;
}

body {
	display: flex;
	flex-direction: column;
	/* min-height: 100vh; */
}

main {
	flex: 1;
	margin-left: 250px;
	padding: 20px;
	padding-top: 90px;
	overflow-y: auto;
}

.box {
    padding: 20px;
    background-color: #ffffff;
    border-radius: 8px;
    /* box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1); */
    max-width: 800px;
    margin: 0 auto;
}

.memberDetail-wrapper {
    font-size: 16px;
    line-height: 1.6;
}

.memberDetail-wrapper p {
    margin-bottom: 10px;
}

table {
    width: 100%;
    border-collapse: collapse;
    margin-bottom: 20px;
}

table, table th, table td {
    border: 1px solid #ddd;
}

th, td {
    padding: 10px;
    text-align: left;
}

th {
    background-color: #f2f2f2;
    font-weight: bold;
}

select, button {
    font-size: 16px;
    padding: 10px;
    border-radius: 5px;
    border: 1px solid #ccc;
    margin-right: 10px;
}

button {
    background-color: #007bff;
    color: #ffffff;
    border: none;
    cursor: pointer;
    transition: background-color 0.3s ease;
}

button:hover {
    background-color: #0056b3;
}

button:disabled {
    background-color: #cccccc;
    cursor: not-allowed;
}

label {
    font-weight: bold;
    margin-right: 10px;
}

.center {
    text-align: center;
}

.deleteButton {
    color: #dc3545; 
    cursor: pointer;
    font-size: 20px; 
    transition: color 0.3s ease, transform 0.3s ease; 
}

.button-container {
    text-align: center;
    margin-top: 20px;
}

</style>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.1/font/bootstrap-icons.css">
</head>
<body>

    <!-- 메뉴바 연결 -->
    <%@ include file="../../common/header.jsp"%>

    <!-- 사이드바 연결 -->    
    <%@ include file="../aside.jsp"%>

   <main>
        <!-- Main content -->
        <div class="box">
            <div class="memberDetail-wrapper center">
                <table>
                    <tr>
                        <th>이름</th>
                        <td>${member.memberName}</td>
                    </tr>
                    <tr>
                        <th>생년월일</th>
                        <td>${member.memberBirthday}</td>
                    </tr>
                    <tr>
                        <th>성별</th>
                        <td>${member.memberGender == 'M' ? '남자' : '여자'}</td>
                    </tr>
                    <tr>
                        <th>전화번호</th>
                        <td>${member.memberPhone}</td>
                    </tr>
                    <tr>
                        <th>이메일</th>
                        <td>${member.memberEmail}</td>
                    </tr>
                    <tr>
                        <th>주소</th>
                        <td>(${member.memberAddress}) ${member.memberStreetAddress} ${member.memberDetailAddress}</td>
                    </tr>
                    <tr>
                        <th>수강 프로그램</th>
                        <td>
                            <c:forEach var="enroll" items="${enrollList}">
                                ${enroll.syclass.className} <i class="bi bi-dash-circle deleteButton" data-enrollno="${enroll.enrollNo}"></i><br>
                            </c:forEach>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" class="center">
                            <strong><label for="classNo">수강 신청: </label></strong>
                            <select id="classNo">
                                <option value="" disabled selected>선택하세요</option>
                                <c:forEach var="syclass" items="${classList}">
                                    <option value="${syclass.classNo}">${syclass.className}</option>
                                </c:forEach>
                            </select>
                            <button id="submitButton">등록</button>
                        </td>
                    </tr>
                </table>
                <div class="button-container">
                    <button id="cancelButton">목록</button>
                </div>
            </div>
        </div>
    </main>
    <!-- 푸터 연결 -->
    <%@ include file="../../common/footer.jsp"%>

<script>
$(document).ready(function() {
    $('#submitButton').on('click', function() {
        var memberNo = '${member.memberNo}'; 
        var classNo = $('#classNo').val();

        if (!classNo) {
            alert("프로그램을 선택해주세요.");
            return;
        }

        $.ajax({
            url: '${pageContext.servletContext.contextPath}/admin/member/enroll',
            type: 'POST',
            data: {
                memberNo: memberNo,
                classNo: classNo
            },
            success: function(response) {
                if (response === 'success') {
                    alert("수강신청이 완료되었습니다.");
                    location.reload();
                } else {
                    alert("수강신청에 실패하였습니다.");
                }
            },
            error: function(xhr, status, error) {
                alert("서버와의 통신에 문제가 발생했습니다.");
            }
        });
    });
    
    $('.deleteButton').on('click', function() {
    	if(confirm("삭제하시겠습니까?")) {
    		var enrollNo = $(this).data('enrollno');
    		
    		$.ajax({
                url: '${pageContext.servletContext.contextPath}/admin/member/enroll/delete',
                type: 'POST',
                data: {
                    enrollNo: enrollNo
                },
                success: function(response) {
                    if (response === 'success') {
                        alert("수강신청이 삭제되었습니다.");
                        location.reload();
                    } else {
                        alert("수강신청 삭제에 실패하였습니다.");
                    }
                },
                error: function(xhr, status, error) {
                    alert("서버와의 통신에 문제가 발생했습니다.");
                }
            });
    	}
    })
    
    $('#cancelButton').on('click', function() {
        window.location.href = '${pageContext.servletContext.contextPath}/admin/member/list';
    });
});
</script>
</body>
</html>