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
<h1>Q&A 게시판</h1>

<!-- 검색창 + 자동완성 리스트를 묶는 래퍼 -->
<div class="search-wrapper">
  <form action="/qna/list" method="get" class="box_search">
    <input type="text" id="input_keyword" name="keyword" class="input_keyword" placeholder="검색하세요." maxlength="30">
    <span id="reset" style="cursor: pointer;">✖</span>
    <input type="submit" value="검색">
  </form>

  <!-- 자동완성 리스트 -->
  <ul id="autocomplete-list" class="autocomplete-list">
  </ul>
  <div class="hihi"></div>
</div>


<!-- 글쓰기 버튼 -->
<div class="write-container">
   <a href="/qna/write"><button class="write-btn">글쓰기</button></a>
</div>

<!-- Q&A 목록 -->
<table>
  <thead>
    <tr>
      <th>번호</th>
      <th>제목</th>
      <th>작성자</th>
      <th>작성일</th>
      <th>조회수</th>
      <th>답변 여부</th>
    </tr>
  </thead>
  <tbody>
    <c:forEach var="qna" items="${qnaList}">
      <tr>
        <td>${qna.qna_id}</td>
        <td><a href="/qna/detail/${qna.qna_id}">${qna.title}</a></td>
        <td>${qna.user_id}</td>
        <td>${qna.created_at}</td>
        <td>${qna.views}</td>
        <td>
          <c:choose>
            <c:when test="${qna.is_answered eq 'T'}">O</c:when>
            <c:otherwise>X</c:otherwise>
          </c:choose>
        </td>
      </tr>
    </c:forEach>
  </tbody>
</table>

   
   <script>
   const searchInput = document.getElementById('input_keyword');
   const autoList = document.getElementById('autocomplete-list');
   
   
   // 입력 시 자동완성과 추천어 처리
   searchInput.addEventListener('input', function () {
      const keyword = this.value.trim();

      // 자동완성 요청
      fetch(`/qna/autocomplete?keyword=` + encodeURIComponent(keyword))
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

   document.addEventListener('click', (e) => {
	   if (!e.target.closest('.search-wrapper')) {
	     autoList.style.display = 'none';
	   }
	 });

	 document.getElementById("reset").addEventListener("click", function () {
	   searchInput.value = "";
	   autoList.style.display = "none";
	 });

   
   </script>
   
   <jsp:include page="../fragment/footer.jsp"/>
</body>
</html>
