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

<!-- review/detail.jsp -->
<h1>후기 상세 보기</h1>

<table border="1">
    <tr>
        <th>제목</th>
        <td>${review.title}</td>
    </tr>
    <tr>
        <th>작성자</th>
        <td>${review.user_id}</td>
    </tr>
    <tr>
        <th>상품</th>
        <td>${review.product_id}</td>
    </tr>
    <tr>
        <th>점수</th>
        <td>${review.rating}</td>
    </tr>
    <tr>
        <th>내용</th>
        <td>${review.content}</td>
    </tr>
    <tr>
        <th>작성일</th>
        <td>${review.created_at}</td>
    </tr>
    <tr>
        <th>공개여부</th>
        <td>${review.is_public}</td>
    </tr>
</table>

<br/>

<!-- 수정, 삭제 버튼 / 본인만 -->

<c:if test="${review.user_id eq loginId}">
<div>
    <a href="/reviews/updateForm/${review.review_id}">수정</a>
    <form action="/reviews/delete/${review.review_id}" method="post">
        <button type="submit" onclick="return confirm('정말 삭제하시겠습니까?')">삭제</button>
    </form>
</div>
</c:if>

<jsp:include page="../fragment/footer.jsp"/>
</body>
</html>