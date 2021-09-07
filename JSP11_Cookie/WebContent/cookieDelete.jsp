<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String cookieName = "id";
	Cookie cookie = new Cookie(cookieName, "xxx");
	cookie.setMaxAge(0);  // expiry 를 0 으로 세팅
	response.addCookie(cookie);  // response 후 곧바로 삭제
%>
<script>
alert("<%= cookieName %> 쿠키 삭제");
location.href = "cookieList.jsp";
</script>


