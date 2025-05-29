<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>OGGO</title>
    <link rel="stylesheet" href="/css/style.css">
</head>
<body>

<!-- 공통 헤더 include -->
<jsp:include page="fragment/header.jsp" />

<!-- 이벤트 배너 이미지 추가 (링크 포함 가능) -->
<div class="event-banner" style="text-align: center; margin-top: 30px;">
    <a href="/reviews/list"><img src="/images/event.jpg" alt="이벤트 배너" style="width: 1000px; height: 500px; border-radius: 12px;"></a>
</div>

<!-- 인기 예약 BEST 4 -->
<div class="section-title">이번주 인기 예약 BEST 4</div>
<div class="product-list">
    <c:forEach var="product" items="${list2}">
        <div class="product">
            <a href="/product/productDetail?product_id=${product.product_id}"><img src="${product.image_url}" alt="${product.title}"></a>
 <!--              <h3>${product.title}</h3>
           <p>${product.description}</p>
            <p><strong>지역:</strong> ${product.region}</p>
            <p><strong>가격:</strong> <fmt:formatNumber value="${product.price}" type="number" groupingUsed="true"/>원</p>
            <p><strong>여행 기간:</strong> ${product.start_date} ~ ${product.end_date}</p>
            <p><strong>최대 인원:</strong> ${product.total_seats}명</p>
            <p><strong>잔여:</strong> ${product.left_seats}석</p>
            <p><strong>등록일:</strong> ${product.created_at}</p>
            <form action="/product/delete" method="post" onsubmit="return confirm('정말 삭제하시겠습니까?');">
                <input type="hidden" name="product_id" value="${product.product_id}">
-->
                <c:if test="${userSession.loginUser.role == 'admin'}">
                    <input type="submit" value="삭제">
                </c:if>
                
            </form>
        </div>
    </c:forEach>
</div>

<div id="more">
	<a href="/product/productlist"><button  class="write-btn">더보기 ⅴ</button></a>
</div>
<!-- 공통 푸터 include -->
<jsp:include page="fragment/footer.jsp" />

<script>
	
</script>

</body>
</html>
