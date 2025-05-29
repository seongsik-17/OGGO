<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>OGGO-회원가입</title>
<link rel="stylesheet" href="/css/style.css">
</head>
<body>
<jsp:include page="../fragment/header.jsp"/>

<script>
	// 페이지에 접속하면 id부분에 focus 두기
	window.onload = function () {
		document.forms["frm"].user_id.focus();
		
		// 오늘 이후 날짜 비활성화
		const today = new Date().toISOString().split("T")[0];
		document.forms["frm"].birth_date.setAttribute("max", today);
		
		// 기본 MBTI 설정 (ESTJ)
		document.forms["frm"].mbti_ei.value = "E";
		document.forms["frm"].mbti_sn.value = "S";
		document.forms["frm"].mbti_tf.value = "T";
		document.forms["frm"].mbti_jp.value = "J";
	}
</script>



<main class="login-wrapper">
	<h1>회원가입</h1>
	<form action="regist" method="POST" name="frm" onsubmit="return validateForm()">
	
		<!-- ID -->
		<span>ID:</span> <input type="text" name="user_id" onblur="idInput()">&nbsp;
		<button onclick="chkId(event)">중복확인</button>&nbsp;
		<span id="idResult"></span><br>
		
		<!-- PW -->
		<span>PW:</span> <input type="password" name="password"><br>
		<span>PW확인:</span> <input type="password" name="password2" onblur="pwChk()"> <span id="pwResult"></span> <br>
		
		<!-- 이름 -->
		이름: <input type="text" name="name" required><br>
		
		<!-- 이메일 -->
		email: <input type="email" name="email" placeholder="id123@email.com" required><br>
		
		<!-- phone -->
		phone: <input type="text" name="phone" oninput="formatPhone(this)" placeholder="01012345678" required><br>
		
		<!-- 주소  -->
		주소: <input type="text" name="address" placeholder="부산시 해운대구"><br>
		
		<!-- 생년월일 -->
		생년월일: <input type="date" name="birth_date" required><br>

		<!-- 성별 -->
		성별:  
<label class="custom-radio">
  <input type="radio" name="gender" value="M" required>
  <span>남자</span>
  <span class="checkmark"></span>
</label>

<label class="custom-radio">
  <input type="radio" name="gender" value="F">
  <span>여자</span>
  <span class="checkmark"></span>
</label>

<label class="custom-radio">
  <input type="radio" name="gender" value="N">
  <span>미공개</span>
  <span class="checkmark"></span>
</label>

		<br>
<!-- MBTI -->
MBTI: 
<div>
  <div class="mbti-group" data-group="ei">
    <label class="custom-radio">
      <input type="radio" name="mbti_ei" value="E" required> E (외향)
      <span class="checkmark"></span>
    </label>
    <label class="custom-radio">
      <input type="radio" name="mbti_ei" value="I"> I (내향)
      <span class="checkmark"></span>
    </label>
  </div>

  <div class="mbti-group" data-group="sn">
    <label class="custom-radio">
      <input type="radio" name="mbti_sn" value="S" required> S (감각)
      <span class="checkmark"></span>
    </label>
    <label class="custom-radio">
      <input type="radio" name="mbti_sn" value="N"> N (직관)
      <span class="checkmark"></span>
    </label>
  </div>

  <div class="mbti-group" data-group="tf">
    <label class="custom-radio">
      <input type="radio" name="mbti_tf" value="T" required> T (사고)
      <span class="checkmark"></span>
    </label>
    <label class="custom-radio">
      <input type="radio" name="mbti_tf" value="F"> F (감정)
      <span class="checkmark"></span>
    </label>
  </div>

  <div class="mbti-group" data-group="jp">
    <label class="custom-radio">
      <input type="radio" name="mbti_jp" value="J" required> J (판단)
      <span class="checkmark"></span>
    </label>
    <label class="custom-radio">
      <input type="radio" name="mbti_jp" value="P"> P (인식)
      <span class="checkmark"></span>
    </label>
  </div>
</div>

<!-- 성격 -->
성격:
<div class="checkbox-group">
  <label class="custom-checkbox"><input type="checkbox" name="personalities" value="대담함"> 대담함<span class="checkmark"></span></label>
  <label class="custom-checkbox"><input type="checkbox" name="personalities" value="성실함"> 성실함<span class="checkmark"></span></label>
  <label class="custom-checkbox"><input type="checkbox" name="personalities" value="용감함"> 용감함<span class="checkmark"></span></label>
  <label class="custom-checkbox"><input type="checkbox" name="personalities" value="온화함"> 온화함<span class="checkmark"></span></label><br>

  <label class="custom-checkbox"><input type="checkbox" name="personalities" value="부끄럼쟁이"> 부끄럼쟁이<span class="checkmark"></span></label>
  <label class="custom-checkbox"><input type="checkbox" name="personalities" value="호기심"> 호기심<span class="checkmark"></span></label>
  <label class="custom-checkbox"><input type="checkbox" name="personalities" value="감수성"> 감수성<span class="checkmark"></span></label>
  <label class="custom-checkbox"><input type="checkbox" name="personalities" value="내성적"> 내성적<span class="checkmark"></span></label><br>

  <label class="custom-checkbox"><input type="checkbox" name="personalities" value="외향적"> 외향적<span class="checkmark"></span></label>
  <label class="custom-checkbox"><input type="checkbox" name="personalities" value="리더"> 리더<span class="checkmark"></span></label>
  <label class="custom-checkbox"><input type="checkbox" name="personalities" value="팔로워"> 팔로워<span class="checkmark"></span></label>
</div>

<!-- 주량 -->
<label>주량:</label><br>
<div class="radio-group">
  <label class="custom-radio">
    <input type="radio" name="drinking_level" value="모름" checked required>
    모름
    <span class="checkmark"></span>
  </label>
  <label class="custom-radio">
    <input type="radio" name="drinking_level" value="비선호">
    비선호
    <span class="checkmark"></span>
  </label>
  <label class="custom-radio">
    <input type="radio" name="drinking_level" value="못마심">
    못마심
    <span class="checkmark"></span>
  </label>
  <label class="custom-radio">
    <input type="radio" name="drinking_level" value="소주 3잔 미만">
    소주 3잔 미만
    <span class="checkmark"></span>
  </label>
  <label class="custom-radio">
    <input type="radio" name="drinking_level" value="소주 1병 이하">
    소주 1병 이하
    <span class="checkmark"></span>
  </label>
  <label class="custom-radio">
    <input type="radio" name="drinking_level" value="소주 2병 이하">
    소주 2병 이하
    <span class="checkmark"></span>
  </label>
  <label class="custom-radio">
    <input type="radio" name="drinking_level" value="소주 3병 이하">
    소주 3병 이하
    <span class="checkmark"></span>
  </label>
  <label class="custom-radio">
    <input type="radio" name="drinking_level" value="소주 3병 이상">
    소주 3병 이상
    <span class="checkmark"></span>
  </label>
</div>
	
		
		<input type="submit" value="가입">
	</form>
</main>

<script>
	const form = document.forms['frm'];

	// ID 중복확인(AJAX 활용)	
	const idResult = document.getElementById('idResult');
	
	function idInput() {
	    const idInput = document.forms["frm"].user_id;
	    const idResult = document.getElementById("idResult");

	    if (!idInput.value.trim()) {
	      idResult.textContent = "ID를 입력해주세요.";
	      idResult.style.color = "red";
	    } else {
	      idResult.textContent = "";
	    }
	  }
	
	function chkId(event){
		// form 제출 방지
		event.preventDefault();
		const id = form.user_id.value.trim();	
		// 유효성 검사(숫자로 시작하면 안됨)
		if(/^[0-9]/.test(id)){
            alert('숫자로 시작할 수 없습니다.');
            setTimeout(()=>{
				form.user_id.focus();
			},0)
            return false;
        }
		// 유효성 검사(4글자 이상이어야 함)
        if(id.length<4){
            alert('ID는 4글자 이상이어야 합니다.')
            setTimeout(()=>{
				form.id.focus();
			},0)
            return false;
        }
		
		const xhr = new XMLHttpRequest();
		xhr.onload = function(){
			idResult.innerHTML = xhr.responseText;
			idResult.style.color = "red";
		}
		xhr.open('POST','idChk');
		xhr.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
		xhr.send('user_id='+id);
	}
	
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
	            form.password.focus();
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
	    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
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
	
	    // 아이디 사용불가일 경우
	    if (idResult.innerText.trim() === '사용불가') {
	        alert('아이디를 다시 확인해주세요');
	        form.user_id.value = "";
	        idResult.innerText = "";
	        form.user_id.focus();  // 수정된 포커스
	        return false;
	    }
	    
	    if(form.user_id.value.trim()===''){
			alert('ID를 입력하세요.');
			setTimeout( ()=>{
				form.id.focus();
			}, 0)
			return false;
		}	

    	return true;
	}

	
	
	
</script>
<jsp:include page="../fragment/footer.jsp"/>
</body>
</html>
