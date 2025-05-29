<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>예약 작성</title>
<link rel="stylesheet" href="/css/style.css">
<script>
    const productPrice = Number('${product.price}');

    function updateTotal() {
        const numPeople = document.getElementById("num_people").value;
        const total = productPrice * parseInt(numPeople);
        document.getElementById("total_price").value = total;
    }
</script>

</head>
<body>
<jsp:include page="../fragment/header.jsp"/>
    <h1>상품 예약</h1>
    <hr>

    <form action="/reservation/reservate" method="post">
        <label>아이디</label>
        <input type="text" name="user_id" value="${userSession.loginUser.user_id}" readonly><br>

        <label>상품번호</label>
        <input type="text" name="product_id" value="${product.product_id}" readonly><br>

        <label>인원</label>
        <select name="num_people" id="num_people" onchange="updateTotal()">
            <c:forEach var="i" begin="1" end="${product.left_seats }">
                <option value="${i}">${i}명</option>
            </c:forEach>
        </select><br>

        <label>총 금액</label>
        <input type="text" name="total_price" id="total_price" readonly><br>
        
        <label>상태</label>
        <input type="text" name="status" value="${product.status}" readonly><br>

        <input type="submit" value="예약">
    </form>
    <jsp:include page="../fragment/footer.jsp"/>

    <script>
        updateTotal(); // 페이지 로드시 기본값 계산
    </script>
</body>
</html>
