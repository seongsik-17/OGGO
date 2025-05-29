<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>OGGO-로그인</title>
<link rel="stylesheet" href="/css/style.css">
</head>
<body>
<jsp:include page="../fragment/header.jsp"/>

<main class="login-wrapper">
    <h1>로그인</h1>
    <form name="frm" action="login" method="POST" onsubmit="return login()">
        <input type="text" name="user_id" placeholder="아이디">
        <input type="password" name="password" placeholder="비밀번호">
        <p>${msg}</p>
        <input type="submit" value="로그인">
    </form>
</main>

	
	
    <script>
        function login(){
            const form = document.forms['frm'];
            const id = document.querySelector('input[name="user_id"]').value;
            const pw = document.querySelector('input[name="password"]').value;

            if(id.trim()===''|pw.trim()===''){
                alert('로그인 정보를 입력해주세요');
                return false;
            }
            return true;
        }
        
        <c:if test="${not empty message}">
        alert("${message}");
        </c:if>
    </script>

</body>
</html>