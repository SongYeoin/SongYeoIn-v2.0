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
<script src="https://kit.fontawesome.com/a076d05399.js"></script>

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
}

/* main {
    flex: 1;
    margin-left: 250px;
    padding-top: 90px;
    overflow-y: auto;
    top: 120px;
    left: 250px;
} */

main {
    flex: 1;
    margin-left: 300px;
    margin-top: 160px;
    overflow-y: auto;
    height: 100%;
}

/* .box {
    height: 100%;
} */

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

/* main {
    flex: 1;
    margin-left: 250px;
    padding: 20px;
    padding-top: 90px;
    overflow-y: auto;
} */

.container {
    margin: 20px auto;
    /* padding: 20px; */
    background-color: #f9fafc;
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    max-width: 1200px;
    border-radius: 10px;
    padding-bottom: 20px;
    
    padding-left: 0 !important;
    padding-right: 0 !important;
   
}

.header {
    display: flex;
    flex-wrap: wrap;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;
    padding-bottom: 10px;
    border-bottom: 1px solid #ddd;
    background-color: #e2eff9;
    /* padding: 20px; */
    
    padding-top: 40px;
    padding-right: 32px;
    padding-left: 32px;
    padding-bottom: 20px;
    border-radius: 10px 10px 0 0;
}

.header h1 {
    margin: 0;
    flex-grow: 1;
}

.header input {
    padding: 10px;
    width: 200px;
    border: 1px solid #ddd;
    border-radius: 5px;
}

.header .icons {
    display: flex;
}

.header .icons i {
    cursor: pointer;
    margin-left: 10px; /* 아이콘 사이에 간격을 줍니다 */
}

.div-table{
	margin-left: 12px;
    margin-right: 12px;
}

table {
    width: 100%;
    border-collapse: collapse;
}

thead {
    background-color: #f5f5f5;
}

th, td {
    padding: 10px;
    text-align: left;
    border: 1px solid #ddd;
}

.status-active {
    color: green;
    font-weight: bold;
}

.status-inactive {
    color: red;
    font-weight: bold;
}

.footer {
    display: flex;
    justify-content: space-between;
    margin-left: 12px;
    margin-right: 12px;
    margin-top: 20px;
}

/* 드롭다운 메뉴 스타일 */
.dropdown {
    position: relative;
    display: inline-block;
}

.dropdown-content {
    display: none;
    position: absolute;
    background-color: #f9f9f9;
    min-width: 100px;
    box-shadow: 0px 8px 16px 0px rgba(0, 0, 0, 0.2);
    z-index: 1;
}

.dropdown-content a {
    color: black;
    padding: 10px 12px;
    text-decoration: none;
    display: block;
}

.dropdown-content a:hover {
    background-color: #f1f1f1;
}

.dropbtn {
    background-color: transparent;
    border: none;
    font-size: 16px;
    cursor: pointer;
    padding: 0;
}

</style>
</head>
<body>

    <!-- 메뉴바 연결 -->
    <%@ include file="../../common/header.jsp"%>

    <!-- 사이드바 연결 -->
    <%@ include file="../../admin/aside.jsp"%>

    <!-- 메인 영역 -->
    <main>
        <div class="container">
            <div class="header">
                <h1>Class</h1>
                <input type="text" placeholder="Search..." id="search">
                <div class="icons">
                    <a href="/admin/class/enroll"><i class="fas fa-square-plus"></i></a>
                    <i class="fas fa-filter"></i>
                </div>
            </div>
            <div class="div-table">
            <table>
                <thead>
                    <tr>
                        <th><input type="checkbox"></th>
                        <th>클래스명</th>
                        <th>담당자</th>
                        <th>개강일</th>
                        <th>종강일</th>
                        <th>종강여부</th>
                        <th>...</th>
                    </tr>
                </thead>
                <tbody id="class-table-body">
                    <c:forEach var="classItem" items="${classList}">
                    	<c:if test="${classItem.isDeleted == 'N'}">
                        <tr>
                            <td><input type="checkbox"></td>
                            <td>
							    <a href="<c:url value='/admin/class/main'>
							                <c:param name='classNo' value='${classItem.classNo}'/>
							            </c:url>">
							        <c:out value="${classItem.className}"/>
							    </a>
							</td>
                            <td><c:out value="${classItem.managerName}"/></td>
                            <td><fmt:formatDate value="${classItem.startDate}" pattern="yyyy-MM-dd"/></td>
                            <td><fmt:formatDate value="${classItem.endDate}" pattern="yyyy-MM-dd"/></td>
                            <td class="${classItem.classStatus == 'Y' ? 'status-active' : 'status-inactive'}">
                                <c:out value="${classItem.classStatus == 'Y' ? '진행중' : '종강'}"/>
                            </td>
                            <td>
                                <div class="dropdown">
                                    <button class="dropbtn" onclick="toggleDropdown(event)">...</button>
                                    <div class="dropdown-content">
                                        <a href="/admin/class/update?classNo=${classItem.classNo}">수정하기</a>
                                        <a href="#" onclick="submitDeleteForm(${classItem.classNo})">삭제하기</a>

                                    </div>
                                </div>
                            </td>
                        </tr>
                        </c:if>
                    </c:forEach>
                </tbody>
            </table>
            </div>
            <div class="footer">
                <span>Item per pages: 10</span>
                <span>1-10 of 30</span>
            </div>
        </div>
    </main>

    <!-- 푸터 연결 -->
    <%@ include file="../../common/footer.jsp"%>

<script>
let currentDropdown = null;

function toggleDropdown(event) {
    event.stopPropagation();
    const dropdown = event.currentTarget.nextElementSibling;
    if (currentDropdown && currentDropdown !== dropdown) {
        currentDropdown.style.display = 'none';
    }
    dropdown.style.display = dropdown.style.display === 'block' ? 'none' : 'block';
    currentDropdown = dropdown.style.display === 'block' ? dropdown : null;
}

window.onclick = function(event) {
    if (currentDropdown && !event.target.matches('.dropbtn')) {
        currentDropdown.style.display = 'none';
        currentDropdown = null;
    }
}

// 삭제 post 요청 비동기 처리 
function submitDeleteForm(classNo) {
    if (confirm("정말로 삭제하시겠습니까?")) { // 삭제 확인
        // AJAX 요청 생성
        var xhr = new XMLHttpRequest();
        xhr.open("POST", "/admin/class/delete", true);
        xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

        // 서버로부터 응답이 왔을 때의 처리
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200) {
                    if (xhr.responseText === "success") {
                        alert("정상적으로 삭제되었습니다.");
                        window.location.href = "/admin/class/getClassList"; // 원하는 페이지로 리다이렉트
                    } else {
                        alert("삭제에 실패했습니다. 다시 시도해 주세요.");
                    }
                } else {
                    alert("서버와의 통신에 실패했습니다.");
                }
            }
        };

        // 폼 데이터 전송
        xhr.send("classNo=" + classNo);
    }
}
</script>

</body>
</html>
