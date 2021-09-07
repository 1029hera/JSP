<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="com.lec.beans.WriteDTO"%>    
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>EL request</title>
</head>
<body>
<%
	request.setAttribute("myage", 30);
	request.setAttribute("mydto", new WriteDTO(100, "제목", "내용", "작성자", 3, null));
%>

	${myage }<br>
	${mydto }<br>
	${mydto.uid }<br>
	<%= ((WriteDTO)request.getAttribute("mydto")).getUid() %><br>

</body>
</html>














