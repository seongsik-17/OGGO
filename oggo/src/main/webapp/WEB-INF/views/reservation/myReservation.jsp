<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="/css/style.css">
</head>
<body>
<jsp:include page="../fragment/header.jsp"/>
<h1>내 예약내역</h1>
<table>
<thead>
<tr>
    <th>예약번호</th><th>상품ID</th><th>일자</th><th>인원수</th><th>총 가격</th><th>상태</th>
</tr>
</thead>
<tbody>
<c:forEach var="reservation" items="${list}">
<tr>
    <td>${reservation.reservation_id}</td>
    <td>${reservation.product_id}</td>
    <td>${reservation.reservation_date}</td>
    <td>${reservation.num_people}</td>
    <td>${reservation.total_price}</td>
    <td>${reservation.status}</td>
</tr>
</c:forEach>
</tbody>
</table>
<jsp:include page="../fragment/footer.jsp"/>
</body>
</html>