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
<h1>자주 묻는 질문 (FAQ)</h1>
<table>
	<tr>
		<th>번호</th><th>제목</th><th>작성자</th><th>조회수</th>
	</tr>
	<c:forEach var="qna" items="${faqList}">
	<tr>
		<td>${qna.qna_id}</td>
		<td><a href="/qna/detail/${qna.qna_id}">${qna.title}</a></td>
		<td>${qna.user_id}</td>
		<td>${qna.views}</td>
	</tr>
	</c:forEach>
</table>
<jsp:include page="../fragment/footer.jsp"/>
</body>
</html>