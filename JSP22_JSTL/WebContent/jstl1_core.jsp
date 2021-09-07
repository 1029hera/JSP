<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>    
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>JSTL Core</title>
</head>
<body>

<h2>set, remove, out</h2>
이름: <c:out value='jang'/><br>
<c:set var="name" value="홍길동"/> 
이름: <c:out value='${name }'/><br> <%-- JSTL 의 변수는 -> EL에서 사용 가능 --%> 
${name }<br>

<c:remove var="name"/>
이름: <c:out value='${name }'/><br>

<hr>
<%
	int age = 10;
%>
나이: ${age }<br>   <%-- Java 변수 EL 에서 출력 불가 였다  Java → EL (X) --%>
<c:set var="age" value="<%= 10 %>"/>
나이: ${age }<br>   <%-- 이렇게는 가능 Java → JSTL → EL (O) --%>

<hr>
<h2>catch</h2>
<c:catch var="error">
<!-- 이 안에서 예외 발생하면 예외 객체를 error 변수에 담는다-->
	<%= 2 / 0 %>
</c:catch>
<c:out value='${error }'/>
</body>
</html>





















