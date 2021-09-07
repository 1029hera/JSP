<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	Cookie cookie = new Cookie("userid", "");
	cookie.setMaxAge(0);  // 쿠키삭제!
	response.addCookie(cookie); 
%>
<script>
alert("로그아웃 되었습니다");
location.href = "login.jsp";
</script>