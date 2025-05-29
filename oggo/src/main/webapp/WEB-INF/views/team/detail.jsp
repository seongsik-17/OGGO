<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="/css/style.css">
</head>
<body>
<jsp:include page="../fragment/header.jsp"/>
<h1>동행자 구하기 상세보기</h1>

<div class="btn-group">
  <%-- 수정/삭제 버튼 작성자 본인일 때만 노출 --%>
  <c:if test="${team.user_id == sessionScope.user_id}">
    <a href="/team/write/${team.post_id}">
      <button type="button">수정</button>
    </a>
    <form action="/team/delete/${team.post_id}" method="POST">
    <button type="submit">삭제</button>
	</form>
  </c:if>
</div>

<p>상태: ${team.status}</p>
<p>작성일: ${team.created_at}</p>
<p>제목: ${team.title}</p>
<p>작성자: ${team.user_id}</p>
<p>내용: ${team.content}</p>
<p>일정: ${team.start_date} ~ ${team.end_date}</p>
<p>상품: ${team.product_title}</p>
<p>모집된 인원/모집인원 수: ${team.current_members} / ${team.total_members}</p>

  <!--참여 신청 버튼 작성자 본인일 때는 노출x -->
<c:if test="${team.user_id ne sessionScope.user_id}">
    <form method="post" action="/team/participate">
        <input type="hidden" name="post_id" value="${team.post_id}" />
        <button type="submit">참여 신청</button>
    </form>
</c:if>

<!-- 메시지 표시 -->
<c:if test="${not empty msg}">
  <p>${msg}</p>
</c:if>

<c:if test="${param.success eq 'participated'}">
  <p>참여가 완료되었습니다!</p>
</c:if>

<a href="/team/list">목록으로 가기</a>
<jsp:include page="../fragment/footer.jsp"/>
</body>
</html>