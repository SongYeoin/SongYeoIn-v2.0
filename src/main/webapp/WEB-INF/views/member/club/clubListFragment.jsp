<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<table>
    <thead>
        <tr>
            <th class="clubNo_width">번호</th>
            <th class="writer_width">작성자</th>
            <th class="checkStatus_width">승인현황</th>
            <th class="checkCmt_width">승인메시지</th>
            <th class="studyDate_width">활동일</th>
            <th class="regDate_width">작성일</th>
            <th class="file_width">첨부</th>
        </tr>
    </thead>
    <tbody>
        <c:forEach items="${list}" var="list">
            <tr onclick="location.href='/member/club/get?clubNo=${list.clubNo}'">
                <td><c:out value="${list.clubNo }" /></td>
                <td><c:out value="${list.enroll.member.memberName }" /></td>
                <td>
                    <c:choose>
                        <c:when test="${list.checkStatus == 'W'}">대기</c:when>
                        <c:when test="${list.checkStatus == 'Y'}">완료</c:when>
                        <c:when test="${list.checkStatus == 'N'}">불가</c:when>
                        <c:otherwise>알 수 없음</c:otherwise>
                    </c:choose>
                </td>
                <td><c:out value="${list.checkCmt }" /></td>
                <td><fmt:formatDate pattern="yyyy/MM/dd" value="${list.studyDate }" /></td>
                <td><fmt:formatDate pattern="yyyy/MM/dd" value="${list.regDate }" /></td>
                <td>
                    <c:choose>
                        <c:when test="${list.fileName != null }">
                            <a href="/member/club/downloadFile?fileName=${list.fileName}" download="${list.fileName}" title="${list.fileName}" onclick="event.stopPropagation();">
                                <i class="bi bi-paperclip"></i>
                            </a>
                        </c:when>
                        <c:otherwise>
                            <c:out value="" />
                        </c:otherwise>
                    </c:choose>
                </td>
            </tr>
        </c:forEach>
    </tbody>
</table>
