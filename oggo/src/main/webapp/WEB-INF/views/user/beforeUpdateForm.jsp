<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>OGGO-사용자확인</title>
<link rel="stylesheet" href="/css/style.css">
</head>
<body>
<jsp:include page="../fragment/header.jsp"/>
	
	<main>
	    <h1>사용자 확인</h1>
	    <hr>
	    <form name="frm" action="/user/beforeUpdate" method="POST" onsubmit="return login()">
	        <span>PW:</span> <input type="password" name="password"><br>
	        <p>${msg}</p>
	        <input type="submit" value="확인">
	    </form>
	    <hr>
	</main>
	
	
    <script>
        function login(){
            const form = document.forms['frm'];
            const pw = document.querySelector('input[name=pw]').value;
            if(pw.trim()===''){
                alert('정보를 입력해주세요');
                return false;
            }
            return true;
        }
    </script>



<jsp:include page="../fragment/footer.jsp"/>
</body>
</html>