<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String sessionName = "id";
	String sessionValue = "" + Math.floor(Math.random() * 10);
	
	// 세션 생성
	session.setAttribute(sessionName, sessionValue);
%>
<script>
alert("<%= sessionName%> 세션 생성")
location.href = "sessionList.jsp";
</script>

