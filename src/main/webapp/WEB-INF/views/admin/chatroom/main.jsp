<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>채팅방</title>

<style>
body{
width: 100vw;  
height: 100vh; 
}

* {
    box-sizing: border-box;
}

html, body {
    overflow-x: hidden;
    overflow-y: auto; /* 수직 스크롤 보이기 */
}
.content{
	padding:80px 0 0;
}


.grid-rows{
	display:grid;
	grid-template-columns: 1.3fr 3fr;
	gap: 10px; /* 열 사이의 간격 */
}


.scrollable-div{
	 width: 380px; /* 너비 설정 */
     height: 650px; /* 높이 설정 */
     border: 1px solid #ccc; /* 테두리 설정 */
     overflow: auto; /* 스크롤을 자동으로 추가 */
}

a.custom{
	 text-decoration: none !important;
}

/* styles.css */

/* 모달 창을 숨깁니다. */
.modal {
    display: none; /* 숨김 */
    position: fixed; /* 고정 위치 */
    z-index: 1; /* 위쪽에 표시 */
    left: 0;
    top: 0;
    width: 50%; /* 전체 너비 */
    height: 50%; /* 전체 높이 */
    overflow: auto; /* 스크롤 가능 */
    background-color: rgb(0,0,0); /* 배경 색 */
    background-color: rgba(0,0,0,0.4); /* 반투명 배경 색 */
}

/* 모달 내용 스타일 */
.modal-content {
    background-color: #fefefe;
    margin: 15% auto; /* 가운데 정렬 */
    padding: 20px;
    border: 1px solid #888;
    width: 80%; /* 너비 설정 */
}

/* 닫기 버튼 스타일 */
.close {
    color: #aaa;
    float: right;
    font-size: 15px;
    font-weight: bold;
}

.close:hover,
.close:focus {
    color: black;
    text-decoration: none;
    cursor: pointer;
}


</style>

<!-- Font Awesome -->
<link
  href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"
  rel="stylesheet"
/>
<!-- Google Fonts -->
<link
  href="https://fonts.googleapis.com/css?family=Roboto:300,400,500,700&display=swap"
  rel="stylesheet"
/>
<!-- MDB -->
<link
  href="https://cdnjs.cloudflare.com/ajax/libs/mdb-ui-kit/7.3.2/mdb.min.css"
  rel="stylesheet"
/>
	<!-- MDB -->
</head>
<body>
	<!-- 메뉴바 연결 -->
	<%@ include file="../../common/header.jsp"%>
	<section class="content">
		<div class="w-100 h-100 p-3 py-4">

			<div class="grid-rows">
				<div class="d-flex align-items-start">
				<div class="w-100 h-100  p-3 border --bs-light-border-subtle rounded-3">
				
					<select class="form-select" aria-label="Default select example">
					  <option selected>Open this select menu</option>
					  <option value="1">One</option>
					  <option value="2">Two</option>
					  <option value="3">Three</option>
					</select>
					
					<form class="d-flex align-items-center" role="search">
				        <input class="form-control" type="search" placeholder="학생 이름을 검색해주세요." aria-label="Search">
				        <button class="my-3  ms-2 btn btn-outline-dark text-nowrap" type="submit">검색</button>
				     </form>
					
					<button id="openModalBtn">채팅방 생성</button>
					 <!--모달구조  -->
					 <div id="myModal" class="modal">
					 	<div class="modal-content">
					 		<span class="close">닫기</span>
					 		<h5>수강생을 선택해주세요</h5>
							 <form action="${pageContext.servletContext.contextPath}/admin/chatroom/createroom" method="post" id="createRoomForm">
							    <table border="1">
							        <!-- 테이블 헤더 -->
							        <tr>
							            <th>수강생명</th>
							            <th>수강과목명</th>
							            <th>선택</th> <!-- 라디오 버튼을 위한 열 -->
							        </tr>
							
							        <!-- 이전에 출력된 memberNo 값을 저장할 변수 -->
							        <c:set var="previousMemberNo" value=""/>
							
							        <!-- 리스트 항목을 반복해서 출력 -->
							        <c:forEach items="${classList}" var="enroll">
							            <tr>
							                <!-- 수강생명 출력 -->
							                <td>
							                    <c:out value="${enroll.member.memberName}"/>
							                </td>
							                <!-- 수강과목명 출력 -->
							                <td>
							                    <c:out value="${enroll.syclass.className}"/>
							                </td>
							                <!-- 라디오 버튼 -->
							                <td>
							                    <c:choose>
							                        <c:when test="${previousMemberNo != enroll.member.memberNo}">
							                            <input type="radio" name="memberNo" value="${enroll.member.memberNo}"/>
							                            <c:set var="previousMemberNo" value="${enroll.member.memberNo}"/>
							                        </c:when>
							                        <c:otherwise>
							                        </c:otherwise>
							                    </c:choose>
							                </td>
							            </tr>
							        </c:forEach>
							    </table>
							
							    <!-- 제출 버튼 -->
							    <input type="submit" value="생성하기">
							</form>
					 	</div>
					 </div>
					
					
					<div class="card">
						<div class="card-body w-auto scrollable-div">

							<ul class="list-unstyled mb-0">
								<c:forEach items="${roomList}"  var="room">
								<li class="p-2 border-bottom bg-body-tertiary"><a href="#!"
									class="custom d-flex justify-content-between">
										<div class="d-flex flex-row">
											<img
												src="https://mdbcdn.b-cdn.net/img/Photos/Avatars/avatar-8.webp"
												alt="avatar"
												class="rounded-circle d-flex align-self-center me-3 shadow-1-strong"
												width="60">
											<div class="pt-1">
												<p class="fw-bold mb-0"><c:out value="${room.member.memberName}"/></p>
												<p class="d-inline-block text-truncate small text-muted" style="max-width: 150px;">Hello, Are you there?????????????</p>
											</div>
										</div>
										<div class="pt-1">
											<p class="small text-muted mb-1">Just now</p>
											<span class="badge bg-danger float-end">1</span>
										</div>
								</a></li>
							</c:forEach>
							</ul>

						</div>
					</div>

				</div>
				</div>

				<div class="d-flex align-items-start ">
				<div class="w-100 h-100 col-md-6 col-lg-7 col-xl-8 p-3 border --bs-light-border-subtle rounded-3">

					<ul class="list-unstyled">
						<li class="d-flex justify-content-between mb-6"><img
							src="https://mdbcdn.b-cdn.net/img/Photos/Avatars/avatar-6.webp"
							alt="avatar"
							class="rounded-circle d-flex align-self-start me-3 shadow-1-strong"
							width="60">
							<div class="card">
								<div class="card-header d-flex justify-content-between p-3">
									<p class="fw-bold mb-0">Brad Pitt</p>
									<p class="text-muted small mb-0">
										<i class="far fa-clock"></i> 12 mins ago
									</p>
								</div>
								<div class="card-body">
									<p class="mb-0">Lorem ipsum dolor sit amet, consectetur
										adipiscing elit, sed do eiusmod tempor incididunt ut labore et
										dolore magna aliqua.</p>
								</div>
							</div></li>
						<li class="d-flex justify-content-between mb-6">
							<div class="card w-100">
								<div class="card-header d-flex justify-content-between p-3">
									<p class="fw-bold mb-0">Lara Croft</p>
									<p class="text-muted small mb-0">
										<i class="far fa-clock"></i> 13 mins ago
									</p>
								</div>
								<div class="card-body">
									<p class="mb-0">Sed ut perspiciatis unde omnis iste natus
										error sit voluptatem accusantium doloremque laudantium.</p>
								</div>
							</div> <img
							src="https://mdbcdn.b-cdn.net/img/Photos/Avatars/avatar-5.webp"
							alt="avatar"
							class="rounded-circle d-flex align-self-start ms-3 shadow-1-strong"
							width="60">
						</li>
						<li class="d-flex justify-content-between mb-6"><img
							src="https://mdbcdn.b-cdn.net/img/Photos/Avatars/avatar-6.webp"
							alt="avatar"
							class="rounded-circle d-flex align-self-start me-3 shadow-1-strong"
							width="60">
							<div class="card">
								<div class="card-header d-flex justify-content-between p-3">
									<p class="fw-bold mb-0">Brad Pitt</p>
									<p class="text-muted small mb-0">
										<i class="far fa-clock"></i> 10 mins ago
									</p>
								</div>
								<div class="card-body">
									<p class="mb-0">Lorem ipsum dolor sit amet, consectetur
										adipiscing elit, sed do eiusmod tempor incididunt ut labore et
										dolore magna aliqua.</p>
								</div>
							</div></li>
						<li class="bg-white mb-3">
							<div data-mdb-input-init class="form-outline">
								<textarea class="form-control bg-body-tertiary mb-4"
									id="textAreaExample2" rows="4"></textarea>
								<label class="form-label" for="textAreaExample2">메시지</label>
							</div>
						</li>
						<button type="button" data-mdb-button-init data-mdb-ripple-init
							class="btn btn-info btn-rounded float-end">보내기</button>
					</ul>

				</div>
				</div>
			</div>

		</div>
	</section>
	<!-- 푸터 연결 -->
	<%@ include file="../../common/footer.jsp"%>
	
	
<script
  type="text/javascript"
  src="https://cdnjs.cloudflare.com/ajax/libs/mdb-ui-kit/7.3.2/mdb.umd.min.js"
></script>	
<script>
//script.js

//모달과 버튼을 변수에 저장합니다.
var modal = document.getElementById("myModal");
var btn = document.getElementById("openModalBtn");
var span = document.getElementsByClassName("close")[0];

//버튼을 클릭하면 모달을 열어줍니다.
btn.onclick = function() {
modal.style.display = "block";
}

//<span> (닫기 버튼)을 클릭하면 모달을 닫아줍니다.
span.onclick = function() {
modal.style.display = "none";
}

//모달 밖을 클릭하면 모달을 닫아줍니다.
window.onclick = function(event) {
if (event.target == modal) {
   modal.style.display = "none";
}
}


</script>

</body>
</html>