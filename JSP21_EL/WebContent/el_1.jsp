<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>EL</title>
</head>
<body>
	<h3>Expression Language</h3>
	${10 }<br>
	${99.99 }<br>
	${"ABC" }<br>
	${true }<br>
	<hr>
	<h3>EL의 연산자</h3>
	${1 + 2 }<br>
	${1 - 2 }<br>
	${1 * 2 }<br>
	${1 / 2 }<br> <%-- EL은 자바 아니다. --%>
	${1 > 2 }<br>
	${1 < 2 }<br>
	${ (1 > 2) ? 1 : 2 } <br>
	${ (1 > 2) || (1 < 2) } <br>
	
	<hr>
	<%
		int num = 10;
	%>
	num : ${num }<br> <%-- EL은 Java변수 그대로는 표현 안됨 --%>
	num : <%= num %><br>


<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>
</body>
</html>


