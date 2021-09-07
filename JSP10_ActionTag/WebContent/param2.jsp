<%@page import="java.net.URLEncoder"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>param2</title>
</head>
<body>
<!-- Action Tag -->
<p> 지금 현재 페이지는 param2 페이지 입니다...</p>
<%
	int num = 788;
	String id = "홍길동"; // 한글..
%>
<jsp:include page = "subParam.jsp">
	<jsp:param value="<%= URLEncoder.encode(id, "utf-8")%>" name="id"/>
	<jsp:param value="<%= num %>" name="pw"/>
</jsp:include>
<p> 위 라인의 내용은 subParam 페이지 의 내용입니다 </p>
</body>
</html>

</html>


