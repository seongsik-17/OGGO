<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>여행상품 상세</title>
<link rel="stylesheet" href="/css/style.css">
<style>
    body {
        font-family: sans-serif;
        line-height: 1.6;
        margin: 20px;
    }

    h1 {
        text-align: center;
        margin-bottom: 30px;
    }

    .product-detail {
        max-width: 600px;
        margin: 0 auto;
        padding: 20px;
        border: 1px solid #ccc;
    }

    .product-detail img {
        max-width: 100%;
        height: auto;
        display: block;
        margin-bottom: 15px;
    }

    .product-detail h3 {
        margin: 10px 0;
    }

    .product-detail p {
        margin: 6px 0;
    }
</style>
</head>
<body>
<jsp:include page="../fragment/header.jsp"/>
<h1>여행상품 상세</h1>
<div class="product-detail">
    <img src="${product.image_url}" alt="${product.title}">
    <h3>${product.title}</h3>
    <p><strong>설명:</strong> ${product.description}</p>
    <p><strong>지역:</strong> ${product.region}</p>
    <p><strong>가격:</strong> ${product.price}</p>
    <p><strong>출발일:</strong> ${product.start_date}</p>
    <p><strong>도착일:</strong> ${product.end_date}</p>
    <p><strong>총 좌석:</strong> ${product.total_seats}</p>
    <p><strong>최소 인원:</strong> ${product.min_seats}</p>
    <p><strong>잔여수량:</strong> ${product.left_seats}</p>
    <p><strong>등록일:</strong> ${product.created_at}</p>
    <p><strong>조회수:</strong> ${product.views}</p>
    <p><strong>태그:</strong> ${product.tag}</p>
    <p><strong>상태:</strong> ${product.status}</p>
    <a href="/reservation/reservateForm?product_id=${product.product_id}" id="reserveBtn">예약하기</a>
    <!-- <a href="/product/addWishList">찜하기</a> -->
    <div id="wish">찜하기</div>



<script>

	const wish = document.getElementById('wish');
	wish.addEventListener('click',function(){
		
        location.href='/user/addWishList/${product.product_id}';
		//location.href='/user/addWishList/prod001';
    });
</script>
    
</div>
<jsp:include page="../fragment/footer.jsp"/>
<script>
    const productStatus = "${product.status}";
    const reserveBtn = document.getElementById('reserveBtn');

    reserveBtn.addEventListener('click', function(e) {
        if (productStatus === "DISABLED") {
            e.preventDefault();
            alert("예약이 마감되었습니다.");
        }
    });
</script>

</body>
</html>
