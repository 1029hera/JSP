<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<%--
	<%
		// 자바 주석
		int sum = 0;
		for(int cnt = 1; cnt <= 100; cnt++) sum += cnt;
	%>
	<!-- html  주석 -->
	
	1부터 100까지의 합은 : <%= sum %>
 	--%>
 	
 	<h3>오늘의 식단</h3>
 	- 비빔밥<br>
 	- 김치찌개<br>
 	- 칼국수<br>
 	<%@ include file = "test.jsp" %>
 	<hr>
 	
 	<%
 		System.out.println("뭐야뭐야?");
 		out.println("요건되나?");
 	%>
 	
</body>
</html>



