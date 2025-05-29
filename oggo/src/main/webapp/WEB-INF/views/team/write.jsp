<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="/css/style.css">
<style>
h1 {
  text-align: center;
}

/* ========== 글쓰기 폼 영역 ========== */

form {
  max-width: 720px;
  margin: 40px auto;
  background: white;
  padding: 40px;
  border-radius: 16px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
  display: flex;
  flex-direction: column;
  gap: 20px;
}

form h2 {
  font-size: 22px;
  margin-top: 20px;
  color: var(--text-dark);
}

form input[type="text"],
form input[type="date"],
form input[type="number"],
form textarea,
form select {
  width: 100%;
  padding: 12px 16px;
  border: 1px solid var(--nav-border);
  border-radius: 8px;
  font-size: 15px;
  font-family: inherit;
  background: #fff;
  color: var(--text-dark);
  transition: var(--transition);
}

form input:focus,
form textarea:focus,
form select:focus {
  border-color: var(--nav-hover);
  outline: none;
  box-shadow: 0 0 0 3px rgba(255, 111, 97, 0.2);
}

form textarea {
  resize: vertical;
}

form button[type="submit"] {
  align-self: flex-end;
  background-color: var(--nav-hover);
  color: white;
  border: none;
  padding: 12px 24px;
  border-radius: 8px;
  font-size: 16px;
  font-weight: bold;
  cursor: pointer;
  transition: var(--transition);
}

form button[type="submit"]:hover {
  transform: scale(1.05);
  background-color: #e85a4f;
}

/* hr 꾸미기 */
form hr {
  border: none;
  border-top: 1px solid var(--nav-border);
  margin: 20px 0;
}

/* 제목 스타일 */
form > h1 {
  text-align: center;
  font-size: 28px;
  font-weight: 800;
  color: var(--text-dark);
  margin-bottom: 20px;
}

/* ========== 반응형 조정 ========== */
@media (max-width: 768px) {
  form {
    padding: 24px;
    margin: 20px 16px;
  }

  form button[type="submit"] {
    width: 100%;
  }

</style>
</head>
<body>
<jsp:include page="../fragment/header.jsp"/>
<h1>동행자 게시판 글쓰기</h1>
<form action="<c:choose>
                <c:when test='${team.post_id != null}'>
                    /team/update/${team.post_id}
                </c:when>
                <c:otherwise>
                    /team/write
                </c:otherwise>
             </c:choose>" method="post">
    제목<br>
    <input type="text" name="title" value="${team.title}"><br>
    
 	작성자 <input type="text" name="user_id" value="${ user_id}" readonly><br>
    내용<br>
	<textarea name="content" rows="5" cols="50" required>${team.content}</textarea>
    
    <hr>   
    
	<h2>여행 일정</h2>
	동행 시작일<br>
	<input type="date" id="start_date" name="start_date" required 
	       value="${team.start_date}"><br>
	
	동행 종료일<br>
	<input type="date" id="end_date" name="end_date" required 
	       value="${team.end_date}"><br>
	
	모집 인원 수<br>
	<input type="number" name="total_members" min="1" required 
	       value="${team.total_members}"><br>
	
	여행 상품:
	<select name="product_id" required>
	    <option value="">-- 선택하세요 --</option>
	    <c:forEach var="product" items="${productList}">
	        <c:set var="selected" value="${product.product_id == team.product_id ? 'selected' : ''}" />
	        <option value="${product.product_id}" ${selected}>
	            ${product.title}
	        </option>
	    </c:forEach>
	</select> <br>
    
    <button type="submit">등록</button>
</form>

<script>
  // 오늘 날짜 기준 (오늘부터 선택 가능)
  const today = new Date();
  today.setDate(today.getDate());

  // input 엘리먼트
  const startDateInput = document.getElementById('start_date');
  const endDateInput = document.getElementById('end_date');

  // 동행 시작일 최소값 설정(내일부터)
  startDateInput.min = today.toISOString().slice(0, 10);

  // 시작일이 변경될 때마다 종료일 최소값 갱신
  startDateInput.addEventListener('change', () => {
    const startDate = new Date(startDateInput.value);
    if (startDate.toString() === 'Invalid Date') {
      // 시작일이 유효하지 않으면 종료일 최소값 초기화
      endDateInput.min = '';
      return;
    }
    // 종료일은 시작일 이후여야 하니, 시작일 +1일로 설정
    startDate.setDate(startDate.getDate() + 1);
    endDateInput.min = startDate.toISOString().slice(0, 10);

    // 만약 종료일이 최소일 이전이면 종료일 초기화
    if (new Date(endDateInput.value) < new Date(endDateInput.min)) {
      endDateInput.value = '';
    }
  });

  // 페이지 로드 시 종료일 최소값 초기화(선택된 시작일이 있으면 반영)
  if (startDateInput.value) {
    startDateInput.dispatchEvent(new Event('change'));
  }
</script>
<jsp:include page="../fragment/footer.jsp"/>
</body>
</html>