<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<header>
    <div class="logo">
        <a href="/">OGGO</a>
    </div>
    <div class="auth-links">
        <c:choose>
            <c:when test="${userSession.loginUser != null}">
                <span>${userSession.loginUser.user_id}님</span>
                <a href="/user/logout">로그아웃</a>
                <a href="/user/myPage">MyPage</a>
                <c:if test="${userSession.loginUser.role == 'admin'}">
                    <a href="/management">관리자페이지</a>
                </c:if>
            </c:when>
            <c:otherwise>
                <a href="/user/login">로그인</a>
                <a href="/user/registForm">회원가입</a>
            </c:otherwise>
        </c:choose>
    </div>
</header>



<nav>
  <ul>
    <li><a href="/product/productlist">여행</a></li>
    <li><a href="/team/list">동행</a></li>
    <li><a href="/reviews/list">후기</a></li>
    <li><a href="/qna/list">Q&A</a></li>
    <li><a href="/qna/faqList">FAQ</a></li>
  </ul>
</nav>
