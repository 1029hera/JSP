<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String cookieName = "id";
	String cookieValue = "" + Math.floor(Math.random() * 10);
	Cookie cookie = new Cookie(cookieName, cookieValue); // 이름-값 으로 쿠키 생성
	cookie.setMaxAge(2 * 30);  // 쿠키파기(expiry) 설정. (생성시점으로부터 60초 후);
	response.addCookie(cookie);  // response 에 쿠키 정보 추가
%>
<script>
alert("<%= cookieName %> : <%= cookieValue %> 쿠키생성");
location.href = "cookieList.jsp";
</script>