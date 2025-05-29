<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>여행 상품 목록</title>
<link rel="stylesheet" href="/css/style.css">
<style>

</style>
</head>
<body>
<jsp:include page="../fragment/header.jsp"/>

<br>
<div class="section-title">이번주 인기 예약 BEST 4</div><br>

	<!-- 검색창 -->
<form action="/product/productlist" method="get" class="box_search">
    <div class="search-wrapper2">
        <input type="text" id="input_keyword" name="keyword"
            class="input_keyword" placeholder="#해시태그 검색을 이용해보세요." maxlength="30">
        <span id="reset" style="cursor: pointer;">✖</span>
        <input type="submit" value="검색">

        <!-- 자동완성 리스트 -->
        <ul id="autocomplete-list"></ul>

        <!-- 추천어 드롭다운 -->
        <div class="search-suggestions">
            <div class="search-box">
                <div class="popular-keywords">
                    <strong>인기 조회 여행지 TOP 5</strong>
                    <ul>
                        <c:forEach var="region" items="${list3}">
                            <li><a href="#">${region}</a></li>
                        </c:forEach>
                    </ul>
                </div>
                <div class="popular-tags">
                    <strong>인기 조회 태그 TOP 5</strong>
                    <ul>
                        <c:forEach var="tag_keyword" items="${list4}">
                            <li><a href="#">#${tag_keyword}</a></li>
                        </c:forEach>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</form>




	<div class="product-list">
		<c:forEach var="product" items="${list2}">
			<div class="product">
				<a href="/product/productDetail?product_id=${product.product_id}"><img src="${product.image_url}" alt="${product.title}"></a>
<!--				<h3>
					${product.title}
				</h3>
				<p>${product.description}</p>
				<p>지역 : ${product.region}</p>
				<p>가격 : 
					<fmt:formatNumber value="${product.price}" type="number" groupingUsed="true"/>원
				</p>
				<p>시작일 : ${product.start_date}</p>
				<p>종료일 : ${product.end_date}</p>
				<p>가능 인원 : ${product.total_seats}</p>
				<p>최소 인원 : ${product.min_seats}</p>
				<p>잔여수량 : ${product.left_seats}</p>
				<p>등록일 : ${product.created_at}</p>
				<p>조회수 : ${product.views}</p>
				<p>태그 : ${product.tag}</p>
				<p>상태 : ${product.status}</p>
				<form action="/product/delete" method="post"
					style="display: inline;">
					<input type="hidden" name="product_id"
						value="${product.product_id}">
 -->               <c:if test="${userSession.loginUser.role == 'admin'}">
                    <input type="submit" value="삭제">
                </c:if>
				</form>
			</div>
		</c:forEach>
	</div>
<c:if test="${userSession.loginUser.role == 'admin'}">
                    <h1><a href="/product/writeProductForm">상품 작성하기</a></h1>
                </c:if>
<hr>
<div class="section-title">국가별 보기</div>
	<!-- 여행 상품 목록 -->
	
	<div style="text-align: center; margin-bottom: 20px;">
    <button class="region-btn" data-region="">전체</button>
    <button class="region-btn" data-region="남극">남극</button>
    <button class="region-btn" data-region="북극">북극</button>
    <button class="region-btn" data-region="산티아고">산티아고</button>
    <button class="region-btn" data-region="몽골">몽골</button>
</div>
	
	
	
	<div id="productList" class="product-list">
		<c:forEach var="product" items="${list}">
			<div class="product">
				<a href="/product/productDetail?product_id=${product.product_id}"><img src="${product.image_url}" alt="${product.title}"></a>
<!--				<h3>
					${product.title}
				</h3>
				<p>${product.description}</p>
				<p>지역 : ${product.region}</p>
				<p>가격 : 
					<fmt:formatNumber value="${product.price}" type="number" groupingUsed="true"/>원
				</p>
				<p>시작일 : ${product.start_date}</p>
				<p>종료일 : ${product.end_date}</p>
				<p>가능 인원 : ${product.total_seats}</p>
				<p>최소 인원 : ${product.min_seats}</p>
				<p>잔여수량 : ${product.left_seats}</p>
				<p>등록일 : ${product.created_at}</p>
				<p>조회수 : ${product.views}</p>
				<p>태그 : ${product.tag}</p>
				<p>상태 : ${product.status}</p>
				<form action="/product/delete" method="post"
					style="display: inline;">
					<input type="hidden" name="product_id"
						value="${product.product_id}">
-->                <c:if test="${userSession.loginUser.role == 'admin'}">
                    <input type="submit" value="삭제">
                </c:if>
				</form>
			</div>
		</c:forEach>
	</div>
	<jsp:include page="../fragment/footer.jsp"/>

	<!-- JS -->
	
	<script>
document.querySelectorAll(".region-btn").forEach(button => {
    button.addEventListener("click", function () {
        const region = this.dataset.region;
        console.log("선택한 지역:", region);
        fetch(`/product/region?region=`+encodeURIComponent(region))
            .then(res => res.json())
            .then(data => {
                const listContainer = document.getElementById("productList");
                listContainer.innerHTML = ""; // 기존 내용 비우기

                data.forEach(product => {
                    const div = document.createElement("div");
                    div.className = "product";
                    div.innerHTML = `
                    	<a href="/product/productDetail?product_id=\${product.product_id}"><img src="\${product.image_url}" alt="\${product.title}"></a>
                    	<!--                        <h3>\${product.title}</h3>
                                                <p>\${product.description}</p>
                        <p>지역 : \${product.region}</p>
                        <p>가격 : \${product.price}</p>
                        <p>시작일 : \${product.start_date}</p>
                        <p>종료일 : \${product.end_date}</p>
                        <p>최대 인원 : \${product.total_seats}</p>
                        <p>최소 인원 : \${product.min_seats}</p>
                        <p>잔여수량 : \${product.left_seats}</p>
                        <p>등록일 : \${product.created_at}</p>
                        <p>조회수 : \${product.views}</p>
                        <p>태그 : \${product.tag}</p>
                        <p>상태 : \${product.status}</p>
                        <form action="/product/delete" method="post" style="display:inline;">
                            <input type="hidden" name="product_id" value="\${product.product_id}">
                            -->                            <c:if test="${userSession.loginUser.role == 'admin'}">
                            <input type="submit" value="삭제">
                        </c:if>
                        </form>
                    `;
                    listContainer.appendChild(div);
                });
            });
    });
});


const searchInput = document.getElementById('input_keyword');
const suggestionBox = document.querySelector('.search-suggestions');
const autoList = document.getElementById('autocomplete-list');

//예약이 완료되면 메시지 띄우기
<c:if test="${not empty message}">
alert("${message}");
</c:if>


// 입력 시 자동완성과 추천어 처리
searchInput.addEventListener('input', function () {
	const keyword = this.value.trim();

	// 1자 이상 입력하면 추천어 숨기기
	if (keyword.length > 0) {
		suggestionBox.style.display = "none";
	} else {
		suggestionBox.style.display = "block";
		autoList.style.display = "none";
		return;
	}

	// 자동완성 요청
	fetch(`/product/autocomplete?keyword=` + encodeURIComponent(keyword))
		.then(res => res.json())
		.then(data => {
			autoList.innerHTML = "";
			if (data.length === 0) {
				autoList.style.display = "none";
				return;
			}
			data.forEach(item => {
				const li = document.createElement('li');
				li.textContent = item;
				li.addEventListener('click', () => {
					searchInput.value = item;
					autoList.style.display = "none";
				});
				autoList.appendChild(li);
			});
			autoList.style.display = "block";
		});
});

// input 클릭했을 때만 추천어 보이게
searchInput.addEventListener('focus', () => {
	if (searchInput.value.trim() === "") {
		suggestionBox.style.display = 'block';
	}
});

// 외부 클릭 시 닫기
document.addEventListener('click', (e) => {
	if (!e.target.closest('.box_search') && !e.target.closest('.search-suggestions')) {
		suggestionBox.style.display = 'none';
		autoList.style.display = 'none';
	}
});

// 입력 초기화
document.getElementById("reset").addEventListener("click", function () {
	searchInput.value = "";
	autoList.style.display = "none";
	suggestionBox.style.display = "block";
});

// 추천어 클릭 시 input 채우기
document.querySelectorAll(".search-suggestions a").forEach(a => {
	a.addEventListener("click", function (e) {
		e.preventDefault();
		searchInput.value = this.textContent;
		suggestionBox.style.display = 'none';
	});
});
</script>

</body>
</html>
