<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>GoodMorning</title>
</head>
<body>
	<h2>좋은 아침</h2>

	<ol>
	<%
		for(int i = 0; i < 10; i++) {
			out.println("<li>" + i + "번째</li>");	
		}
	%>
	</ol>


</body>
</html>