<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="/css/style.css">
</head>
<body>
<jsp:include page="../fragment/header.jsp"/>
<h3>${qna.title}</h3>
<p>${qna.content}</p>
<p>조회수: ${qna.views}</p>
<p>작성자: ${qna.user_id}</p>
<p>작성일: ${qna.created_at}</p>

<form action="/qna/delete/${qna.qna_id}" method="POST">
    <button type="submit">삭제하기</button>
    
    <!-- 관리자 답변-->
</form>
<jsp:include page="../fragment/footer.jsp"/>
</body>
</html>