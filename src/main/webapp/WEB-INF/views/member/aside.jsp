<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
<style>
body {
    margin: 0;
    font-family: Arial, sans-serif;
}

.sidebar {
    padding-top: 40px;
    width: 250px;
    background-color: #F2F2F2;
    color: #333333;
    height: 100vh;
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
    font-size: 14px;
    color: #333; /* 기본 글자 색상 설정 */
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
    background-color: #ECECEC;
}

.arrow {
    margin-left: auto;
}

/* 링크 기본 스타일 제거 */
a {
    text-decoration: none; /* 링크 밑줄 제거 */
    color: #333; /* 기본 링크 색상 설정 (부모 요소의 색상과 동일) */
}

/* 링크 상태별 색상 설정 */
a:link {
    color: #333; /* 기본 링크 색상 */
}

a:visited {
    color: #333; /* 방문한 링크 색상 */
}


</style>
</head>
<body>
    <div class="sidebar">
        <div class="menu-item">
            <div class="menu-title">
                <div>
                    <a><i class="fas fa-user"></i>출석</a>
                </div>
                <i class="fas fa-chevron-down arrow"></i>
            </div>
            <div class="submenu">
                <div class="submenu-item"><a><i class="fas fa-users"></i>출석하기</a></div>
                <div class="submenu-item"><a><i class="fas fa-user-tie"></i>출석조회</a></div>
            </div>
        </div>
        <div class="menu-item">
            <div class="menu-title">
                <div>
                    <a><i class="fas fa-chalkboard-teacher"></i>교육일지</a>
                </div>
                <i class="fas fa-chevron-down arrow"></i>
            </div>
            <div class="submenu">
                <div class="submenu-item"><a href="../journal/journalEnroll"><i class="fas fa-users"></i>교육 일지 작성하기</a></div>
                <div class="submenu-item"><a href="../journal/journalList"><i class="fas fa-user-tie"></i>교육 일지 조회하기</a></div>
                <div class="submenu-item"><a href="../journal/scheduleList"><i class="fas fa-user-tie"></i>교육 일정</a></div>
            </div>
        </div>
        <div class="menu-item">
            <div class="menu-title">
                <a><i class="fas fa-heart"></i>동아리</a>
            </div>
        </div>
        <div class="menu-item">
            <div class="menu-title">
                <a><i class="fas fa-home"></i>익명게시판</a> 
            </div>
        </div>
        <div class="menu-item">
            <div class="menu-title">
                <a><i class="fas fa-cog"></i>공지사항</a>
            </div>
        </div>
    </div>

    <script>
        document.querySelectorAll('.menu-title').forEach(item => {
            item.addEventListener('click', event => {
                const menuItem = item.parentElement;
                
                document.querySelectorAll('.menu-item').forEach(i => {
                    if (i !== menuItem) {
                        i.classList.remove('active');
                    }
                }); 
                
                menuItem.classList.toggle('active');
            });
        });
    </script>

</body>
</html>
