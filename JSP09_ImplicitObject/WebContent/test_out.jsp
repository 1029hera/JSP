<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>out</title>
</head>
<body>
<%--
<ul>
<%
	int i = 10;
	while(true){
		i--;
		out.println("<li>5 / " + i + " = " + 5 / i + "</li>");
%>
		-----<br>	
<%
		if(i <= 1) break;
	} // end while
%>
</ul>
 --%>
 
<%!  // <- 선언부 태그 : 변수, 메소드 정의
	int i = 100;
	String str = "test";

	public int hap(int a, int b){
		return a + b;
	}
%> 

<%  // 스크립트릿
	out.println("i = " + i + "<br>");
	out.println("str = " + str + "<br>");
	out.println("hap = " + hap(2, 10));
%>
<hr>
i = <%= i %><br>
str = <%= str %><br>
hap = <%= hap(10, 2) %><br>
 
 
</body>
</html>





















