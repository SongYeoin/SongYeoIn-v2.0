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
<style>

* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

html, body {
    height: 100%;
}

body {
    font-family: Arial, sans-serif;
    display: flex;
    flex-direction: column;
    min-height: 100vh;
}

main {
    flex: 1;
    margin-left: 250px;
    padding-top: 130px; /* 헤더 높이만큼 추가 */
    background-color: white;
}

.box {
    height: 100%;
}

.content {
    padding: 20px;
    position: relative;
}

table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 20px;
    margin-left: 5px;
    border: 1px solid #ddd; /* 테두리 추가 */
}

th, td, tr {
    padding: 10px 0px 10px 0px;
    text-align: center;
    border-left: 1px solid #ddd; /* 왼쪽 테두리 추가 */
    border-right: 1px solid #ddd; /* 오른쪽 테두리 추가 */
}

th {
    background-color: #f4f4f4;
    border-bottom: 1px solid #ddd; /* 아래쪽 테두리 추가 */
}

td {
    border-bottom: 1px solid #ddd; /* 아래쪽 테두리 추가 */
}

/* 반 별 홈 세미헤더 */
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
    margin-left: 10px;
}

.classroom-header .details {
    font-size: 12px;
    margin-left: 10px;
}

.bi-house-fill {
	cursor: pointer;
	font-size: 20px;
}

/* 시간표 추가하기 버튼 스타일 */
.add-schedule-btn {
    position: absolute;
    right: 20px;
    top: 20px;
    padding: 5px 10px;
    background-color: RoyalBlue; 
    color: white;
    border: none;
    border-radius: 4px;
    font-size: 14px;
    cursor: pointer;
    text-align: center;
    transition: background-color 0.3s, box-shadow 0.3s; /* 부드러운 전환 효과 */
}

.add-schedule-btn:hover {
    background-color: CornflowerBlue; /* 약간 어두운 회색으로 호버 효과 */
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1); /* 호버 시 살짝 부각되도록 그림자 효과 */
}

/* 수정 버튼 스타일 */
.edit-schedule-btn {
    margin-left: 10px;
    padding: 5px 10px;
    background-color: lightsteelblue; 
    color: white;
    border: none;
    border-radius: 4px;
    font-size: 12px;
    cursor: pointer;
    transition: background-color 0.3s, box-shadow 0.3s; /* 부드러운 전환 효과 */
}

.edit-schedule-btn:hover {
    background-color: SteelBlue; /* 약간 어두운 회색으로 호버 효과 */
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1); /* 호버 시 살짝 부각되도록 그림자 효과 */
}

/* 저장 버튼 스타일 */
.save-schedule-btn {
    margin-left: 10px;
    padding: 5px 10px;
    background-color: #28a745;
    color: white;
    border: none;
    border-radius: 4px;
    font-size: 12px;
    cursor: pointer;
}

.save-schedule-btn:hover {
    background-color: #218838;
}

/* 취소 버튼 스타일 */
.cancel-edit-btn {
    margin-left: 10px;
    padding: 5px 10px;
    background-color: #dc3545;
    color: white;
    border: none;
    border-radius: 4px;
    font-size: 12px;
    cursor: pointer;
}

.cancel-edit-btn:hover {
    background-color: #c82333;
}

/* 구분선 스타일 */
.separator {
    border: none;
    border-top: 2px solid #ccc;
    margin: 0; /* 기본 여백 제거 */
    width: 100%; /* 테두리까지 확장 */
}
</style>
</head>
<body>

    <!-- 메뉴바 연결 -->
    <%@ include file="../../common/header.jsp"%>

    <!-- 반별 홈 세미헤더 -->
    <div class="classroom-header">
        <i class="bi bi-house-fill" onclick="location.href='${pageContext.servletContext.contextPath}/admin/class/getClassList'"></i>
        <div class="title">${syclass.className}</div>
        <div class="details">담당자: ${syclass.managerName} | 강사명: ${syclass.teacherName}</div>
    </div>

    <!-- 사이드바 연결 -->    
    <%@ include file="aside.jsp"%>

    <main>
        <!-- Main content -->
        <div class="content">
            <button class="add-schedule-btn" onclick="location.href='${pageContext.servletContext.contextPath}/admin/class/enrollSchedule'">시간표 추가하기</button>
            <h2>시간표 조회</h2>
            <c:choose>
                <c:when test="${result == 'null'}">
                    <p>등록된 시간표가 없습니다.</p>
                </c:when>
                <c:when test="${result == 'error'}">
                    <script>
                        alert("시간표 조회 중 오류 발생");
                    </script>
                </c:when>
                <c:otherwise>
                    <table>
                        <thead>
                            <tr>
                                <th>요일</th>
                                <th>교시</th>
                                <th>시작 시간</th>
                                <th>종료 시간</th>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:set var="lastDayOfWeek" value="" />
                            <c:forEach var="period" items="${schedule.periods}" varStatus="status">
                            	<!-- 요일이 바뀔 때마다 구분선 추가 -->
                                <c:if test="${period.dayOfWeek != lastDayOfWeek && status.index != 0}">
                                    <tr>
                                        <td colspan="5">
                                            <hr class="separator" />
                                        </td>
                                    </tr>
                                </c:if>
                                <tr>
                                    <c:choose>
                                        <c:when test="${period.dayOfWeek != lastDayOfWeek}">
                                            <td>${period.dayOfWeek}</td>
                                            <td>${period.periodName}</td>
                                            <td>
                                                <span class="startTime">${period.startTime}</span>
                                                <input type="time" class="edit-input" value="${period.startTime}" style="display:none;">
                                            </td>
                                            <td>
                                                <span class="endTime">${period.endTime}</span>
                                                <input type="time" class="edit-input" value="${period.endTime}" style="display:none;">
                                            </td>
                                            <td rowspan="${schedule.periods.stream().filter(p -> p.dayOfWeek.equals(period.dayOfWeek)).count()}">
                                                <button class="edit-schedule-btn" onclick="editSchedule(this)">수정하기</button>
                                                <button class="save-schedule-btn" style="display:none;" onclick="saveSchedule(this, '${period.dayOfWeek}')">저장</button>
                                                <button class="cancel-edit-btn" style="display:none;" onclick="cancelEdit(this)">취소</button>
                                            </td>
                                            <!-- Hidden inputs for periodNo and scheduleNo -->
								            <input type="hidden" class="periodNo" value="${period.periodNo}" />
								            <input type="hidden" class="scheduleNo" value="${period.scheduleNo}" />
                                            <c:set var="lastDayOfWeek" value="${period.dayOfWeek}" />
                                        </c:when>
                                        <c:otherwise>
                                            <td></td>
                                            <td>${period.periodName}</td>
                                            <td>
                                                <span class="startTime">${period.startTime}</span>
                                                <input type="time" class="edit-input" value="${period.startTime}" style="display:none;">
                                            </td>
                                            <td>
                                                <span class="endTime">${period.endTime}</span>
                                                <input type="time" class="edit-input" value="${period.endTime}" style="display:none;">
                                            </td>
                                            <td></td>
                                            <!-- Hidden inputs for periodNo and scheduleNo -->
								            <input type="hidden" class="periodNo" value="${period.periodNo}" />
								            <input type="hidden" class="scheduleNo" value="${period.scheduleNo}" />
                                        </c:otherwise>
                                    </c:choose>
                                </tr>                             
                            </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>
        </div>
    </main>

    <!-- 푸터 연결 -->
    <%@ include file="../../common/footer.jsp"%>
    
    <c:if test="${not empty message}">
        <script>
            alert('${message}');
        </script>
    </c:if>
    
<script>
//수정 버튼 클릭 시 입력 칸 활성화
function editSchedule(button) {
    var row = button.closest('tr');
    var dayOfWeek = row.querySelector('td').textContent.trim() || getPreviousDayOfWeek(row);
    var allRows = document.querySelectorAll('tbody tr');

    allRows.forEach(function(r) {
        var firstTd = r.querySelector('td');
        var currentDayOfWeek = (firstTd && firstTd.textContent.trim()) || getPreviousDayOfWeek(r); // firstTd가 null이 아닌지 확인
        if (currentDayOfWeek === dayOfWeek) {
            r.querySelectorAll('.edit-input').forEach(function(input) {
                input.style.display = 'inline-block';
                input.disabled = false; // 수정 가능하도록 비활성화 해제
            });
            r.querySelectorAll('span').forEach(function(span) {
                span.style.display = 'none';
            });

            // 버튼 상태 변경
            var editBtn = r.querySelector('.edit-schedule-btn');
            if (editBtn) editBtn.style.display = 'none'; // 수정 버튼 숨기기
            var saveBtn = r.querySelector('.save-schedule-btn');
            if (saveBtn) saveBtn.style.display = 'inline-block'; // 저장 버튼 보이기
            var cancelBtn = r.querySelector('.cancel-edit-btn');
            if (cancelBtn) cancelBtn.style.display = 'inline-block'; // 취소 버튼 보이기
        }
    });
}

// 저장 시
function saveSchedule(button, dayOfWeek) {
    var allRows = document.querySelectorAll('tbody tr');
    var schedule = {
        scheduleNo: document.querySelector('.scheduleNo').value,  // scheduleNo를 저장할 변수
        periods: []
    };
    
    allRows.forEach(function(r) {
        var firstTd = r.querySelector('td');
        var currentDayOfWeek = firstTd ? (firstTd.textContent.trim() || getPreviousDayOfWeek(r)) : getPreviousDayOfWeek(r);
        if (currentDayOfWeek === dayOfWeek) {
            var startTimeInput = r.querySelector('input[type="time"]');
            var endTimeInput = r.querySelectorAll('input[type="time"]')[1];

            if (startTimeInput && endTimeInput) {
                var periodName = r.querySelector('.periodName') ? r.querySelector('.periodName').textContent : '';
                var startTime = startTimeInput.value;
                var endTime = endTimeInput.value;
                
             	// periodNo 가져오기
                var periodNo = r.querySelector('.periodNo').value;

                var period = {
                    periodNo: periodNo,  
                    dayOfWeek: currentDayOfWeek,
                    periodName: periodName,
                    startTime: startTime,
                    endTime: endTime
                };
                schedule.periods.push(period);
                
                // scheduleNo 설정
                if (!schedule.scheduleNo) {
                    schedule.scheduleNo = period.scheduleNo;
                }
            }
        }
    });

    // 서버로 schedule 객체 전송 (예: AJAX 요청)
    $.ajax({
        type: 'POST',
        url: '/admin/class/updateSchedule',  // 실제 서버 URL로 교체
        contentType: 'application/json',
        data: JSON.stringify(schedule),
        success: function(response, status, xhr) {
        		if (xhr.status === 200) {  // 성공 상태 코드
                alert('시간표가 성공적으로 저장되었습니다.');
                window.location.href = '/admin/class/getSchedule';
            } else {
                alert('알 수 없는 응답을 받았습니다.');
            }
        },
        error: function(xhr, status, error) {
        		if (xhr.status === 500) {  // 서버 오류 상태 코드
                alert('시간표 저장 중 오류가 발생했습니다.');
            } else {
                alert('알 수 없는 오류가 발생했습니다.');
            }
        }
    });

    // 저장 후 수정 모드 종료
    cancelEdit(button);
}

// 취소 버튼 클릭 시 수정 모드 종료
function cancelEdit(button) {
    var row = button.closest('tr');
    var dayOfWeek = row.querySelector('td').textContent.trim() || getPreviousDayOfWeek(row);
    var allRows = document.querySelectorAll('tbody tr');

    allRows.forEach(function(r) {
        var firstTd = r.querySelector('td');
        var currentDayOfWeek = (firstTd && firstTd.textContent.trim()) || getPreviousDayOfWeek(r); // firstTd가 null이 아닌지 확인
        if (currentDayOfWeek === dayOfWeek) {
            r.querySelectorAll('.edit-input').forEach(function(input) {
                input.style.display = 'none';
                input.disabled = true; // 수정 불가능하도록 비활성화 설정
            });
            r.querySelectorAll('span').forEach(function(span) {
                span.style.display = 'inline-block';
            });

            // 버튼 상태 복원
            var editBtn = r.querySelector('.edit-schedule-btn');
            if (editBtn) editBtn.style.display = 'inline-block';
            var saveBtn = r.querySelector('.save-schedule-btn');
            if (saveBtn) saveBtn.style.display = 'none';
            var cancelBtn = r.querySelector('.cancel-edit-btn');
            if (cancelBtn) cancelBtn.style.display = 'none';
        }
    });
}

//이전 행의 요일 정보를 가져오는 함수
function getPreviousDayOfWeek(row) {
    var previousRow = row.previousElementSibling;
    while (previousRow) {
        var dayOfWeekCell = previousRow.querySelector('td');
        if (dayOfWeekCell && dayOfWeekCell.textContent.trim()) {
            return dayOfWeekCell.textContent.trim();
        }
        previousRow = previousRow.previousElementSibling;
    }
    return '';
}


</script>

</body>
</html>
