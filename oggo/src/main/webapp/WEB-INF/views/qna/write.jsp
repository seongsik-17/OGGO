<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
<form action="/qna/write" method="post">
 작성자 아이디 <input type="text" name="user_id" value="${ user_id}"  readonly/><br>
 제목 <input type="text" name="title" required /><br>
 내용 <textarea name="content" placeholder="내용을 입력하세요.." required></textarea><br>
  <button type="submit">등록</button>
</form>
<jsp:include page="../fragment/footer.jsp"/>
</body>
</html>