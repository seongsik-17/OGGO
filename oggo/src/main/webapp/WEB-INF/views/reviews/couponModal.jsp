<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>쿠폰 발급 완료</title>
<style>
.modal {
  position: fixed;
  top: 30%;
  left: 50%;
  transform: translate(-50%, -30%);
  background: white;
  border: 2px solid #ccc;
  padding: 20px;
  z-index: 1000;
  text-align: center;
  border-radius: 10px;
}
.overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0,0,0,0.6);
  z-index: 999;
}
button {
  margin-top: 15px;
  padding: 10px 20px;
}
</style>
</head>
<body>

<div class="overlay"></div>
<div class="modal">
  <h2>🎉 리뷰 감사합니다!</h2>
  <p>할인 쿠폰 코드가 발급되었습니다:)</p>
  <h3 style="color:blue;">${couponCode}</h3>
  <p>※ 재발급이나 마이페이지에서 확인할 수 없으니 반드시 저장하세요.</p>
  <form action="/user/myPage">
    <button type="submit">마이페이지로 이동</button>
  </form>
</div>

</body>
</html>