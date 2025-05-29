<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="/css/style.css">
</head>
<body>
<jsp:include page="../fragment/header.jsp"/>

<h1>후기리스트</h1>
<table border="1">
	<thead>
		<tr>
			<th>No</th><th>제목</th><th>여행명</th><th>작성자</th><th>공개</th>
		</tr>
	</thead>
	<tbody>
		<c:forEach var="l" items="${list }" varStatus="status">
		<tr>
			<td>${status.count }</td>
			<c:choose>
			    <c:when test="${l.is_public == 'F'}">
			    	<td>${l.title}</td>
			    </c:when>
			    <c:otherwise>
					<td><a href="/reviews/detail/${l.review_id}">${l.title }</a></td>
			    </c:otherwise>
			</c:choose>
			
			<td>${l.travel_title }</td>
			<td>${l.user_id }</td>
			<td>${l.is_public }</td>
		</tr>
		</c:forEach>
	</tbody>
</table>

<jsp:include page="../fragment/footer.jsp"/>
</body>
</html>