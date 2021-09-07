<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.Enumeration" %>    
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%
	String sessionName, sessionValue;
	Enumeration enumeration = session.getAttributeNames();

	int i = 0;
	while(enumeration.hasMoreElements()){
		sessionName = enumeration.nextElement().toString();
		sessionValue = session.getAttribute(sessionName).toString();
		out.println((i + 1) + "] " + sessionName + " : " + sessionValue +"<br>");
		i++;
	}
	if(i == 0){
		out.println("세션이 없습니다<br>");
	}
%>
<hr>
<form action="sessionCreate.jsp" method="GET">
	<input type="submit" value="세션생성">
</form>
<br>
<form action="sessionDelete.jsp" method="GET">
	<input type="submit" value="세션삭제">
</form>
<hr>
<%
	String sessionId = session.getId();
	int sessionInterval = session.getMaxInactiveInterval();
	
	out.println("세션 ID: " + sessionId + "<br>");
	out.println("세션 유효시간: " +  sessionInterval + "<br>");
%>


</body>
</html>















