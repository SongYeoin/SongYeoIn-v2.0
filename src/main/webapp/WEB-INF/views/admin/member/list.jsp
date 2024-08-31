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
}

/* 메인 영역 스타일 */
main {
    flex: 1;
    margin-left: 300px; 
    margin-top: 160px; 
    overflow-y: auto;
    height: 100%;
}

.container {
	margin: 20px auto;
	background-color: #f9fafc;
	box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
	width: 1320px;
	height: 710px;
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
	padding-top: 40px;
    padding-right: 32px;
    padding-left: 32px;
    padding-bottom: 20px;
    border-radius: 10px 10px 0 0;
}

.header h2 {
	margin: 0;
	flex-grow: 1;
}

.header input {
    padding: 10px;
    width: 200px;
    border: 1px solid #ddd;
    border-radius: 5px;
}

.table-wrap{
	margin-left: 12px;
    margin-right: 12px;
    overflow-x: auto;
}

table {
    width: 100%;
    border-collapse: collapse;
    margin-bottom: 20px;
    white-space: nowrap;
}

table th {
    background-color: #f5f5f5;
}

table th, table td {
    padding: 10px;
    text-align: left;
	border: 1px solid #ddd;
}

tr {
    transition: background-color 0.3s;
}

tr:hover {
	cursor: pointer;
    background-color: #e0e0e0; 
}

.approval-status {
    cursor: pointer;
    pointer-events: auto;
}

.approval-status:hover {
    background-color: #c5c5c5;
}

.pageMaker_wrap {
	text-align: center; 
	margin: 20px; 
}

.pageMaker_btn {
	display: inline-block; 
	margin: 0 5px; 
}

.pageMaker_btn a {
	display: block; 
	padding: 10px 15px; 
	background-color: #f8f9fa; 
	color: #007bff; 
	text-decoration: none; 
	border-radius: 5px; 
	font-weight: bold; 
}

.pageMaker_btn a:hover {
	background-color: #e9ecef; 
}

.pageMaker_btn.active a {
	background-color: #007bff; 
	color: white; 
}

.pageMaker_btn.previous a:hover, 
.pageMaker_btn.next a:hover {
	background-color: #0056b3; 
	color: white; 
}

</style>
</head>
<body>
   
   <!-- 메뉴바 연결 -->
   <%@ include file="../../common/header.jsp"%>

   <!-- 사이드바 연결 -->   
   <%@ include file="../aside.jsp"%>

   <main>
        <!-- Main content -->
        <div class="container">
         <div class="header">
            <h2>Member</h2>
            <!-- 검색 영역 -->
            <div class="search_wrap">
               <form id="searchForm" action="${ pageContext.servletContext.contextPath }/admin/member/list" method="get">
                  <div class="search_input">
                     <input type="search" name="keyword" value='<c:out value="${pageMaker.cri.keyword}"></c:out>'>
                     <input type="hidden" name="pageNum" value='<c:out value="${pageMaker.cri.pageNum }"></c:out>'>
                     <input type="hidden" name="amount" value='${pageMaker.cri.amount}'>
                     <button class='btn search_btn'><i class="bi bi-search"></i></button>
                  </div>
               </form>
            </div>
         </div>

         <div class="table-wrap">
            <table>
            	<thead>
	               <tr>
	                  <th>번호</th>
	                  <th>이름</th>
	                  <th>전화번호</th>
	                  <th>가입일</th>
	                  <th width=15%>승인</th>
	               </tr>
               	</thead>
               	<tbody>
	               	<c:forEach items="${ memberList }" var="member">
	                  <tr onclick="showMemberDetail(event, ${member.memberNo})">
	                     <td>${ member.memberNo }</td>
	                     <td>${ member.memberName }</td>
	                     <td>${ member.memberPhone }</td>
	                     <td>${ member.memberEnrollDate }</td>
	                     <td class="approval-status" onclick="changeApprovalStatus(${member.memberNo}, event);">
	                        <c:choose>
	                           <c:when test="${member.memberCheckStatus == 'W'}">대기</c:when>
	                           <c:when test="${member.memberCheckStatus == 'Y'}">승인</c:when>
	                           <c:when test="${member.memberCheckStatus == 'N'}">미승인</c:when>
	                        </c:choose>
	                     </td>
	                  </tr>
	               </c:forEach>
               </tbody>
            </table>
            
            <!-- 페이지 이동 인터페이스 영역 -->
            <div class="pageMaker_wrap">
               <ul class="pageMaker">

                  <!-- 이전 버튼 -->
                  <c:if test="${pageMaker.prev}">
                     <li class="pageMaker_btn prev"><a href="${pageMaker.pageStart - 1}">이전</a></li>
                  </c:if>

                  <!-- 페이지 번호 -->
                  <c:forEach begin="${pageMaker.pageStart}" end="${pageMaker.pageEnd}" var="num">
                     <li class="pageMaker_btn ${pageMaker.cri.pageNum == num ? "active" : ""}"><a href="${num}">${num}</a></li>
                  </c:forEach>

                  <!-- 다음 버튼 -->
                  <c:if test="${pageMaker.next}">
                     <li class="pageMaker_btn next"><a href="${pageMaker.pageEnd + 1 }">다음</a></li>
                  </c:if>
               </ul>
            </div>
            <form id="moveForm" action="${ pageContext.servletContext.contextPath }/admin/member/list" method="get">
               <input type="hidden" name="pageNum" value="${pageMaker.cri.pageNum}">
               <input type="hidden" name="amount" value="${pageMaker.cri.amount}">
               <input type="hidden" name="keyword" value="${pageMaker.cri.keyword}">
            </form>
         </div>
		</div>
   </main>

   <!-- 푸터 연결 -->
   <%@ include file="../../common/footer.jsp"%>

</body>

<script>
let moveForm = $('#moveForm');

//검색 버튼 클릭 시 페이지 번호를 1로 설정하고 폼 제출
$('#searchForm').on('submit', function() {
    let form = $(this);
    form.find("input[name='pageNum']").val('1');
    return true;  // 폼 제출
});

//페이지 이동 버튼
$(".pageMaker_btn a").on("click", function(e){
    e.preventDefault();
    let pageNum = $(this).attr("href");
    moveForm.find("input[name='pageNum']").val(pageNum);
    moveForm.submit();
});

function changeApprovalStatus(memberNo, event) {
   event.stopPropagation();
   
   if (window.confirm("승인 하시겠습니까?")) {
       $.ajax({
               url: "${ pageContext.servletContext.contextPath }/admin/status-y",
               type: "post",
               data: {memberNo: memberNo},
               success: function(data) {
                   if (data.trim() === 'success') {
                       alert("승인되었습니다.");
                       location.reload();
                   } else {
                       alert("승인 처리를 실패했습니다.");
                   }
               },
               error: function(error) {
                   alert("승인 처리 중 오류가 발생하였습니다.");
               }
           });
     } else {
        $.ajax({
               url: "${ pageContext.servletContext.contextPath }/admin/status-n",
               type: "post",
               data: {memberNo: memberNo},
               success: function(data) {
                   if (data.trim() === 'success') {
                       alert("미승인되었습니다.");
                       location.reload();
                   } else {
                       alert("미승인 처리를 실패했습니다.");
                   }
               },
               error: function(error) {
                   alert("미승인 처리 중 오류가 발생하였습니다.");
               }
           });
       
     }
}

function showMemberDetail(event, memberNo) {
   if (!$(event.target).hasClass('approval-status')) {
    window.location.href = '${pageContext.servletContext.contextPath}/admin/member/detail?memberNo=' + memberNo;
    }
}

</script>
</html>