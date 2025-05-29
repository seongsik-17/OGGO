<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="/css/style.css">
</head>
<body>
<jsp:include page="../fragment/header.jsp"/>

<h1>동행 구하기 게시판</h1>
<!-- 글쓰기 버튼 -->
<div class="write-container">
  <a href="/team/write">
    <button class="write-btn">글쓰기</button>
  </a>
</div>
<!-- 게시판 목록 -->
<table border="1">
    <thead>
        <tr>
            <th>번호</th>
            <th>제목</th>
            <th>작성자</th>
            <th>일정</th>
            <th>모집 현황</th>
            <th>상태</th>
        </tr>
    </thead>
    <tbody>
    <c:forEach var="team" items="${teamList}">
        <tr>
            <td>${team.post_id}</td>
            <td><a href="/team/detail/${team.post_id}">${team.title}</a></td>
            <td>${team.user_id}</td>
            <td>${team.start_date} ~ ${team.end_date}</td>
            <td>${team.current_members} / ${team.total_members}</td>
            <td>${team.status}</td>
        </tr>
    </c:forEach>
    </tbody>
</table>
<jsp:include page="../fragment/footer.jsp"/>
</body>
</html>