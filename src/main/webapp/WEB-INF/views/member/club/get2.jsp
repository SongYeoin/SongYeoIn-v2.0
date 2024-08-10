<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>송파여성인력개발센터</title>
<script src="https://code.jquery.com/jquery-latest.min.js"></script>
<style>
<stype type="text/css">
.input_wrap{
padding: 5px 20px;
}

label{
display: block;
margin: 10px 0;
font-size: 20px;
}

input{
padding: 5px;
font-size: 17px;
}

textarea{
width: 800px;
height: 200px;
font-size: 15px;
padding: 10px;
}

.btn{
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

.btn_wrap{
padding-left: 80px;
margin-top: 50px;
}

</style>
	
</head>
<body>
<h1>조회 페이지</h1>
<div class="input_wrap">
<label>번호</label>
<input name="clubNo" readonly="readonly" value='<c:out value="${pageInfo.clubNo }"/>'>
</div>
<div class="input_wrap">
<label>작성자</label>
<input name="memberName" readonly="readonly" value='<c:out value="${pageInfo.enroll.member.memberName }"/>'>
</div>
<div class="input_wrap">
<label>참여</label>
<input name="join" readonly="readonly" value='<c:out value="${pageInfo.join }"/>'>
</div>
<div class="input_wrap">
<label>내용</label>
<textarea rows="3" name="content" readonly="readonly"><c:out value="${pageInfo.content }"/></textarea>
</div>
<label>승인현황</label>
<input name="checkStatus" readonly="readonly" value='<c:out value="${pageInfo.checkStatus }"/>'>
</div>
<label>승인메시지</label>
<input name="checkCmt" readonly="readonly" value='<c:out value="${pageInfo.checkCmt }"/>'>
</div>
<div class="input_wrap">
<label>활동일</label>
<input name="studyDate" readonly="readonly" value='<fmt:formatDate pattern="yyyy/MM/dd" value="${pageInfo.studyDate }"/>'>
</div>
<div class="input_wrap">
<label>작성일</label>
<input name="regDate" readonly="readonly" value='<fmt:formatDate pattern="yyyy/MM/dd" value="${pageInfo.regDate }"/>'>
</div>
<div class="btn_wrap">
<a class="btn" id="list_btn">목록 페이지</a>
<a class="btn" id="modify_btn">수정 하기</a>
</div>
<form id="infoForm" action="/club/modify" method="get">
<input type="hidden" id="clubNo" name="clubNo" value='<c:out value="${pageInfo.clubNo }"/>'>
<input type="hidden" name="keyword" value="${cri.keyword}">
<input type="hidden" name="type" value="${cri.type}">
</form>

<script>
	let form = $("#infoForm");
	
	$("#list_btn").on("click", function(e){
		form.find("#clubNo").remove();
		form.attr("action", "/club/list");
		form.submit();
	});
	
	$("#modify_btn").on("click", function(e){
		form.attr("action", "/club/modify");
		form.submit();
	});
</script>

	
</body>
</html>