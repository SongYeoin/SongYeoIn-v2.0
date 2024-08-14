<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>송파여성인력센터 로그인</title>
</head>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<style>
body, h2, p, form {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100vh;
    background-color: #f0f0f0;
}

#login-wrap {
    width: 100%;
    display: flex;
    justify-content: center;
    align-items: center;
}

.login-wrapper {
    width: 400px;
    padding: 30px;
    background-color: #ffffff;
    border-radius: 10px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    text-align: left;
}

h2 {
    margin-bottom: 20px;
    font-size: 24px;
    color: #333;
     text-align: center;
}

form input[type="text"], 
form input[type="password"] {
    width: calc(100% - 20px);
    padding: 10px;
    border: 1px solid #ddd;
    border-radius: 5px;
    font-size: 16px;
    color: #333;
}

form input[type="submit"] {
    width: 100%;
    padding: 10px;
    border: none;
    border-radius: 5px;
    background-color: #000000;
    color: #fff;
    cursor: pointer;
    transition: background-color 0.3s ease;
}

form input[type="submit"]:hover {
    background-color: #b3b3b3;
}

.error {
    color: red;
    font-size: 14px;
    height: 20px; 
    line-height: 20px; 
    display: block;
    margin :5px;
}

#join {
	text-align: right;
}

p a {
    /* text-decoration: none; */
    color: #000000;
}

</style>

<body>

	<div id="login-wrap">

		<div class="login-wrapper">
			<h2>Login</h2>
			<form action="${ pageContext.servletContext.contextPath }/member/login" method="post" id="login-form">
				<p>ID</p>
				<input type="text" name="memberId" id="memberId" placeholder="아이디를 입력하세요"><br>
				<span id="memberIdError" class="error"></span> 
				
				<p>Password</p>
				<input type="password" name="memberPwd" id="memberPwd" placeholder="비밀번호를 입력하세요"><br>
				<span id="memberPwdError" class="error"></span>
				
				<input type="submit" id="loginBtn" value="로그인"><br>
				<span id="loginError" class="error"></span>
			</form>
			<p id="join"> <a href="${ pageContext.servletContext.contextPath }/member/join">회원가입</a>
		</div>

	</div>

	<script>
		$(document).ready(function() {
			let result = '${result}';
			let enrollResult = '${enroll_result}';
            if (result === '0') {			// 미승인 회원이 로그인 시
                alert("승인이 완료되지 않았습니다.\n관리자에게 문의하세요.");
            } else if (result === '1') {	// 로그인 실패 시
                $('#loginError').text("아이디와 비밀번호를 확인하고 다시 시도해주세요.");
            }
			if(enrollResult === 'success') {
				alert("회원가입에 성공하였습니다.");
			}

			$('#login-form').submit(function(event) {

				$('#memberIdError').text("");
				$('#memberPwdError').text("");
                $('#loginError').text("");

				let valid = true;

				if ($('#memberId').val().trim() === "") {
					$('#memberIdError').text("아이디를 입력하세요.");
					valid = false;
				}

				if ($('#memberPwd').val().trim() === "") {
					$('#memberPwdError').text("비밀번호를 입력하세요.");
					valid = false;
				}

				if (!valid) {
					event.preventDefault();
				}
			});

		});
	</script>

</body>
</html>