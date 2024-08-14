<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Footer</title>
<%-- <link rel="stylesheet"
	href="${pageContext.servletContext.contextPath}/resources/css/common.css"> --%>

<style>
footer {
	background-color: #BBB2FF;
	color: white;
	padding: 20px;
	text-align: center;
	display: flex;
	justify-content: center;
	align-items: center;
	flex-wrap: wrap;
	font-size: 12px;
	position: relative;
	bottom: 0;
	width: 100%;
	left: 0;
	z-index: 1000; /* 다른 요소들 위에 위치하도록 함 */
}

.footer-container {
	display: flex;
	justify-content: space-around;
	align-items: center;
	width: 100%;
	max-width: 1200px;
}

.footer-section {
	margin: 0 10px;
	text-align: center;
}

.footer-section p {
	margin: 5px 0;
}

.footer-section a {
	color: white;
	text-decoration: none;
}

.footer-section a:hover {
	text-decoration: underline;
}

.footer-section.logo {
	font-size: 14px;
	margin-right: 20px;
}
</style>

</head>
<body>
	
	<footer>
        <div class="footer-container">
            <div class="footer-section logo">
                <span class="highlight">S</span>ongpa <span class="highlight">W</span>oman
            </div>
            <div class="footer-section">
                <p>Songpa Women | 송파여성인력개발<br>
                Business License : 215-82-12405<br>
                개인정보관리책임자 : 류근수</p>
            </div>
            <div class="footer-section">
                <p>Tel : 010-4920-0177<br>
                Contact : wmfrjqsp@gmail.com<br>
                Address : Seoul, Republic of Korea</p>
            </div>
            <div class="footer-section">
                <p><a href="#">이용약관</a> | <a href="#">개인정보처리방침</a></p>
            </div>
        </div>
    </footer>
    
</body>
</html>