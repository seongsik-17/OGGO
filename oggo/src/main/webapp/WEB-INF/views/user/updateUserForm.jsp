<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>OGGO-회원정보 수정</title>
    <link rel="stylesheet" href="/css/style.css">
</head>
<body>
<jsp:include page="../fragment/header.jsp"/>

<script>
	//페이지에 접속하면 id부분에 focus 두기
	window.onload = function () {
		document.forms["frm"].password.focus();
		
		// 오늘 이후 날짜 비활성화
		const today = new Date().toISOString().split("T")[0];
		document.forms["frm"].birth_date.setAttribute("max", today);
	}
</script>


    <h2>회원정보 수정</h2>
    
    <form action="/user/update" method="POST" name="frm" onsubmit="return validateForm()">
        ID: <input type="text" name="user_id" value="${user.user_id}" readonly><br>

		<!-- PW -->
		<span>PW변경:</span> <input type="password" name="password"><br>
		<span>PW확인:</span> <input type="password" name="password2" onblur="pwChk()"> <span id="pwResult"></span> <br>
		
        <label>이름: <input type="text" name="name" value="${user.name}"></label><br>
        <label>이메일: <input type="email" name="email" value="${user.email}"></label><br>
        <label>전화번호: <input type="text" name="phone" value="${user.phone}"></label><br>
        <label>주소: <input type="text" name="address" value="${user.address}"></label><br>
        <label>생년월일: <input type="date" name="birth_date" value="${user.birth_date}" required></label><br>

        <!-- 성별 -->
        <label>성별:</label>
		<label>
		  	<input type="radio" name="gender" value="M" required
		    <c:if test="${user.gender == 'M'}">checked</c:if>> 남자
		</label>
		<label>
		  	<input type="radio" name="gender" value="F"
		    <c:if test="${user.gender == 'F'}">checked</c:if>> 여자
		</label>
		<label>
		  	<input type="radio" name="gender" value="N"
		    <c:if test="${user.gender == 'N'}">checked</c:if>> 미공개
		</label>
		<br>


        <!-- MBTI -->
        <label>MBTI:</label><br>
        E/I:
        <label><input type="radio" name="mbti_ei" value="E" ${user.mbti.substring(0,1) == 'E' ? 'checked' : ''}> E</label>
        <label><input type="radio" name="mbti_ei" value="I" ${user.mbti.substring(0,1) == 'I' ? 'checked' : ''}> I</label><br>
        S/N:
        <label><input type="radio" name="mbti_sn" value="S" ${user.mbti.substring(1,2) == 'S' ? 'checked' : ''}> S</label>
        <label><input type="radio" name="mbti_sn" value="N" ${user.mbti.substring(1,2) == 'N' ? 'checked' : ''}> N</label><br>
        T/F:
        <label><input type="radio" name="mbti_tf" value="T" ${user.mbti.substring(2,3) == 'T' ? 'checked' : ''}> T</label>
        <label><input type="radio" name="mbti_tf" value="F" ${user.mbti.substring(2,3) == 'F' ? 'checked' : ''}> F</label><br>
        J/P:
        <label><input type="radio" name="mbti_jp" value="J" ${user.mbti.substring(3,4) == 'J' ? 'checked' : ''}> J</label>
        <label><input type="radio" name="mbti_jp" value="P" ${user.mbti.substring(3,4) == 'P' ? 'checked' : ''}> P</label><br>

        <!-- 성격 -->
        <label>성격:</label><br>
        <c:set var="personalitiesList" value="${['대담함','성실함','용감함','온화함','부끄럼쟁이','호기심','감수성','내성적','외향적','리더','팔로워']}" />
        <c:forEach var="p" items="${personalitiesList}">
            <label>
                <input type="checkbox" name="personalities" value="${p}"
                    <c:if test="${user.personalities != null && user.personalities.contains(p)}">checked</c:if>>
                ${p}
            </label>
        </c:forEach>
        <br>

        <!-- 음주량 -->
        <label>음주량:</label>
        <select name="drinking_level">
        	<option value="모름" ${user.drinking_level == '모름' ? 'selected' : ''}>모름</option>
        	<option value="비선호" ${user.drinking_level == '비선호' ? 'selected' : ''}>비선호</option>
        	<option value="못마심" ${user.drinking_level == '못마심' ? 'selected' : ''}>못마심</option>
            <option value="소주 3잔 미만" ${user.drinking_level == '소주 3잔 미만' ? 'selected' : ''}>소주 3잔 미만</option>
            <option value="소주 1병 이하" ${user.drinking_level == '소주 1병 이하' ? 'selected' : ''}>소주 1병 이하</option>
            <option value="소주 2병 이하" ${user.drinking_level == '소주 2병 이하' ? 'selected' : ''}>소주 2병 이하</option>
            <option value="소주 3병 이하" ${user.drinking_level == '소주 3병 이하' ? 'selected' : ''}>소주 3병 이하</option>
            <option value="소주 3병 이상" ${user.drinking_level == '소주 3병 이상' ? 'selected' : ''}>소주 3병 이상</option>
        </select><br><br>

        <button type="submit">수정하기</button>
    </form>
    
    ${msg }
	
	<form id="deleteForm" action="/user/delete" method="post">
	    <input type="hidden" name="user_id" value="${user.user_id}">
	    <button type="button" onclick="confirmDelete()">회원 탈퇴</button>
	</form>
	
<script>
	// 탈퇴하기
	function confirmDelete() {
	    if (confirm("정말로 회원 탈퇴하시겠습니까? 이 작업은 되돌릴 수 없습니다.")) {
	        document.getElementById("deleteForm").submit();
	    }
	}

	
	

	// 유효성검사
	const form = document.forms['frm'];
	
	// PW 확인
	function pwChk() {
	    const pwResult = document.getElementById('pwResult');
	    const $pw = document.querySelector('input[name=password]');
	    const $pw2 = document.querySelector('input[name=password2]');
	
	    // 영문, 숫자, 특수문자 포함 8자 이상 정규표현식
	    const pattern = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#$%^&*()_+\-=\[\]{};\\|,.<>\/?]).{8,}$/;
	
	    if (!pattern.test($pw.value)) {
	        alert("비밀번호는 영문, 숫자, 특수문자를 포함한 8자 이상이어야 합니다.");
	        pwResult.innerText = "";
	        setTimeout(() => {
	            form.pw.focus();
	        }, 0);
	        return;
	    }
	
	    // PW 일치여부
	    if ($pw.value !== $pw2.value) {
	        pwResult.innerText = "";
	        alert('비밀번호가 일치하지 않습니다.');
	        // 값 초기화 및 포커스 이동
	        $pw.value="";
	        $pw2.value="";
	        setTimeout(() => {
	            form.password.focus();
	        }, 0);
	    } else {
	        pwResult.innerText = "PW일치!";
	    }
	}
	
	// phone 숫자만 입력하면 자동으로 포맷 적용해주기
	function formatPhone(input) {
	    input.value = input.value.replace(/[^\d]/g, '') // 숫자만 남기기
	        .replace(/^(\d{3})(\d{4})(\d{4})$/, '$1-$2-$3'); // 포맷 적용
	}
	
	// 제출 전 최종 확인
	function validateForm() {
	    const email = form["email"].value;
	    const phone = form["phone"].value;
	    const emailRegex = /^[a-zA-Z0-9._%+-]+@\.$/;
	    const phoneRegex = /^\d{3}-\d{4}-\d{4}$/;
	
	    // 성격 체크박스 검사
	    const personalities = form.querySelectorAll("input[name='personalities']:checked");
	    if (personalities.length === 0) {
	        alert("성격은 하나 이상 선택해야 합니다.");
	        return false;
	    }
	
	    // 전화번호 형식 검사
	    if (!phoneRegex.test(phone)) {
	        alert("전화번호 형식이 올바르지 않습니다. 예: 010-1234-5678");
	        return false;
	    }
	
	    // 이름 한글/영문만
	    const name = form.name.value.trim();
	    const nameRegex = /^[가-힣a-zA-Z\s]+$/;
	    if (!nameRegex.test(name)) {
	        alert("이름은 한글과 영문만 입력 가능합니다.");
	        form.name.focus();
	        return false;
	    }

    	return true;
	}

</script>
    
<jsp:include page="../fragment/footer.jsp"/>
</body>
</html>
