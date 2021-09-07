<%@ page language="java" 
	contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" 
    import="java.util.*, java.time.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>    
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>    

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>JSTL core</title>
<style>
table, th, td{
	border: 1px solid black;
	border-collapse: collapse;
}
</style>
</head>
<body>
<h2>if</h2>
	<!-- 스크립트릿만 사용 하는 경우 1 -->
	<%  
		if(1 + 2 == 3){
	%>
			1 + 2 = 3<br>
	<%
		}
	%>
	
	<!-- 스크립트릿만 사용 하는 경우2 -->
	<%  
		if(1 + 2 == 3){
			out.println("1 + 2 = 3<br>");	
		}
	%>
	
	<!-- JSTL 을 사용하는 경우 -->
	<c:if test="${1 + 2 == 3 }">
		1 + 2 = 3 : EL식 사용 가능 <br>
	</c:if>
	
	<c:if test="true"> <%-- 항상 참 --%> 
		true <br>	
	</c:if>
	
	<c:if test="<%= 1 + 2 == 3 %>">  <%-- 표현식 사용 --%>
		1 + 2 = 3 : JSP표현식 가능
	</c:if>
<hr>

<%-- JSTL 은 c:else 없다..
choose, when 을 조합해서 사용하면 된다. --%>

<h2>choose, when, otherwise</h2>
	<!-- 스크립트릿만 사용 하는 경우1 -->
	<%
		switch(10 % 2){
		case 0:
	%>
			"짝수입니다"<br>
	<%
			break;
		case 1:
	%>
			"홀수입니다"<br>
	<%
			break;
		default:
	%>
			"이도 저도 아닙니다"<br>
	<%
		} // end switch
	%>

	<!-- JSTL 을 사용하는 경우 -->
	<c:choose>
		<c:when test="${10 % 2 == 0 }">
			짝수입니다<br>
		</c:when>
		<c:when test="${10 % 2 == 1 }">
			홀수입니다<br>
		</c:when>
		<c:otherwise>
			이도 저도 아닙니다<br>
		</c:otherwise>
	</c:choose>
<hr>
<h2>forEach</h2>
	<!-- 스크립트릿만 사용 하는 경우1 -->
	<%
		for(int i = 0; i <= 30; i += 3 ){
	%>
			<span><%= i %> </span> 
	<%
		}
	%>
	<br>

	<!-- JSTL 을 사용 -->
	<c:forEach var="i" begin="0" end="30" step="3">
		<span>${i } </span>
	</c:forEach>
	<br>

	<!--  구구단 3단 
		3 * 1 = 3
		3 * 2 = 6
		..
		3 * 9 = 27
	 -->
	 <ul>
	<c:forEach var="i" begin="1" end="9">
		<li>4 * ${i} = ${4 * i }</li>
	</c:forEach>
	</ul>
	 
	 <br>
	 
	 <c:set var='intArray' value="<%= new int[]{1, 2, 3, 4, 5} %>"/>
	 
	 <c:forEach var="element" items="${intArray }">
	 	${element },
	 </c:forEach>
	 <br>
	 
	 <!-- intArray 배열인덱스 2 ~ 4 번째 값 출력 -->
	 <c:forEach var="element" items="${intArray }" begin="2" end="4">
	 	${element },
	 </c:forEach>
	 <br>
	 
	 <!-- varStatus 변수 -->
	 <c:forEach var="element" items="${intArray }" begin="2" end="4" varStatus="status">
	 	${status.count} : ${status.index } =  ${element }<br>
	 </c:forEach>
	 <br>
<%
	List<String> myList = new ArrayList<String>();
	myList.add("월");
	myList.add("화");
	myList.add("수");
%>
	<%-- 동시에 복수개의 객체를 순환하려면?? --%>
	
	<c:set var="arr1" value='<%= new String[]{"SUN", "MON", "TUE"}%>'/>
	<c:set var="arr2" value='<%= myList %>'/>
	
	<ul>
	<c:forEach var="element" items="${arr2 }" varStatus="status">
		<li>${element } - ${arr1[status.index] }</li>
	</c:forEach>
	</ul>

	<%-- functions 라이브러리 활용 --%>
	arr1 의 길이: ${fn:length(arr1) }<br>
	
	<ul>
	<c:forEach var="i" begin="0" end="${fn:length(arr1) - 1 }" varStatus="status">
		<li>${status.index } : ${arr1[status.index] } - ${arr2[status.index] }</li>	
	</c:forEach>
	</ul>
	<br>
	<%
		HashMap<String, Object> hMap = new HashMap<String, Object>();
		hMap.put("name", "홍길동");
		hMap.put("age", 33);
		hMap.put("today", LocalDateTime.now());
	%>
	<c:set var="map1" value="<%= hMap %>"/>
	
	<table>
		<tr><th>key</th><th>value</th></tr>
		<c:forEach var="item" items="${map1 }">
			<tr>
				<td>${item.key }</td>
				<td>${item.value }</td>
			</tr>
		</c:forEach>
	</table>
	
<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>
</body>
</html>

