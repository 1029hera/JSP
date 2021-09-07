<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.lec.beans.*, java.util.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>    

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>JSTL & Bean</title>
</head>
<body>
<%
	Person kim = new Person();
	kim.setName("제임스");
	kim.setAge(200);
%>
<c:set var="dto" value="<%= kim %>"/>

이름: ${dto.name }<br>  <%-- dto.getName() 값 --%>
나미: ${dto.age }<br>
dto: ${dto }<br>

<hr>
<%-- 빈(bean) 배열의 경우 --%>
<%
	Person p1 = new Person();
	p1.setName("고질라");
	p1.setAge(100);
	Person p2 = new Person();
	p2.setName("킹기도라");
	p2.setAge(200);
	Person p3 = new Person();
	p3.setName("모스라");
	p3.setAge(80);

	Person [] arr = {p1, p2, p3};
%>

<c:set var="dtoArr" value="<%= arr %>"/>
<c:forEach var="p" items="${dtoArr }">
	${p.name }<br>
	${p.age }<br>
	${p }<br>
</c:forEach>

<hr>
<%
	ArrayList<Person> list = new ArrayList<Person>();
	list.add(p1);
	list.add(p2);
	list.add(p3);
%>

<c:set var="dtoArr" value="<%= list %>"/>
<c:forEach var="p" items="${dtoArr }">
	${p.name }<br>
	${p.age }<br>
	${p }<br>
</c:forEach>

<hr>
${dtoArr[0].name }<br>
${dtoArr[1].name }<br>
${dtoArr[2].name }<br>
${dtoArr[3].name }<br> <%-- 인덱스 범위 벗어나도 Exception 없이 넘어감 --%>
<%--${dtoArr[2].address }<br> --%>

<hr>
<%-- 특정 id 의 bean 이 있는지 체크, empty --%>
<c:if test="${empty dto }">
	dto 는 없습니다<br>
</c:if>

<c:if test="${not empty dto }">
	dto 는 있습니다<br>
</c:if>

<c:if test="${empty aaa }">
	aaa 는 없습니다<br>
</c:if>

<c:if test="${dto == null }">
	dto 는 null<br>
</c:if>

<c:if test="${dto != null }">
	dto 는 null 이 아닙니다<br>
</c:if>

<hr>
<%-- null 값도 empty 로 처리함 --%>
<%
	Person park = null;
%>

<c:set var="v1" value="<%= park %>"/>  <%-- null값 --%>
park: ${v1 }<br>

<c:if test="${empty v1 }">  <%-- 존재해도 null 값은 empty 판정 --%>
	v1 은 empty 입니다<br>
</c:if>
<c:if test="${empty v2 }"> <%-- 존재안하면 empty --%>
	v2 은 empty 입니다<br>
</c:if>


<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>
</body>
</html>

