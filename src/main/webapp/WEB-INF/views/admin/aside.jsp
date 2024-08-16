<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
<style>
.sidebar {
	padding-top: 40px;
	width: 250px;
	background-color: #2c2c2c;
	color: white;
	height: 960px;
	position: fixed;
	top: 70px;
	overflow-y: auto;
	border-top: 1px solid black;
	border-bottom: 1px solid black;
}

.menu-item {
	padding: 13px 10px;
	cursor: pointer;
	display: flex;
	align-items: center;
	position: relative;
	flex-direction: column;
	font-size: 12px;
}

.menu-item:not(:first-child) {
	border-top: 1px solid black;
}

.menu-title {
	display: flex;
	justify-content: start;
	align-items: center;
	width: 100%;
	flex-direction: row;
}

.menu-item i {
	margin-right: 10px;
}

.submenu {
	display: none;
	padding-top: 10px;
	padding-left: 30px;
	width: 100%;
}

.submenu-item {
	padding: 10px 0;
	display: flex;
	align-items: center;
	width: 100%;
}

.submenu-item i {
	margin-right: 10px;
}

.menu-item.active .submenu {
	display: block;
}

.menu-item:hover, .submenu-item:hover {
	background-color: #333;
}

.arrow {
	margin-left: auto;
}

/* 링크의 기본 색상과 방문 후 색상 */
.menu-item a, .submenu-item a {
	color: white;
	text-decoration: none;
}

.menu-item a:visited, .submenu-item a:visited {
	color: white;
}

/* 현재 방문 중인 메뉴의 배경색 */
.menu-item.current {
	background-color: #444;
}
</style>
</head>
<body>

	<div class="sidebar">
        <div class="menu-item">
            <div class="menu-title">
                <div>
                    <a><i class="fas fa-user"></i>회원 관리</a>
                </div>
                <i class="fas fa-chevron-down arrow"></i>
            </div>
            <div class="submenu">
                <div class="submenu-item"><a href="${ pageContext.servletContext.contextPath }/admin/member/list"><i class="fas fa-users"></i>수강생 관리</a></div>
                <div class="submenu-item"><a><i class="fas fa-user-tie"></i>직원 관리</a></div>
            </div>
        </div>
        <div class="menu-item">
            <div class="menu-title">
                <a href="/admin/class/getClassList"><i class="fas fa-chalkboard-teacher"></i>반 관리</a>
            </div>
        </div>
        <div class="menu-item">
            <div class="menu-title">
                <a><i class="fas fa-heart"></i>마음의 소리</a>                
            </div>
        </div>
        <div class="menu-item">
            <div class="menu-title">
                <a><i class="fas fa-cog"></i>Settings</a>
            </div>
        </div>
        <div class="menu-item">
            <div class="menu-title">
                <div>
                    <a><i class="fas fa-chalkboard-teacher"></i>journal</a>
                </div>
                <i class="fas fa-chevron-down arrow"></i>
            </div>
            <div class="submenu">
                <div class="submenu-item"><a href="/journal/journalList"><i class="fas fa-book"></i>교육일지 조회</a></div>
                <div class="submenu-item"><a href="/journal/scheduleList"><i class="fas fa-calendar"></i>교육일정 관리</a></div>
            </div>
        </div>
    </div>
    
    <script>
        document.querySelectorAll('.menu-title').forEach(item => {
            item.addEventListener('click', event => {
                const menuItem = item.parentElement;
                menuItem.classList.toggle('active');
            });
        });
        
     	// 현재 URL과 일치하는 메뉴 항목에 'current' 클래스를 추가
        const currentPath = window.location.pathname;
        document.querySelectorAll('.menu-title a').forEach(link => {
            if (link.getAttribute('href') === currentPath) {
                link.closest('.menu-item').classList.add('current');
            }
        });
    </script>

</body>
</html>