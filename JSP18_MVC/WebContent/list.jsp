<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.lec.beans.*" %>    
<%@ page import="java.util.*" %>
<% // Controller 로부터 결과 데이터 받음
	List<WriteDTO> list = (List<WriteDTO>)request.getAttribute("list");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>목록</title>
<style>
table {width: 100%;}
table, th, td {
	border: 1px solid black;
	border-collapse: collapse;
}
</style>
</head>
<body>
	<hr>
	<h2>리스트</h2>
	<table>
		<tr>
			<th>UID</th>
			<th>제목</th>
			<th>작성자</th>
			<th>조회수</th>
			<th>등록일</th>
		</tr>
<%
	if(list != null){
		for(WriteDTO dto : list){
%>
		<tr>
			<td><%= dto.getUid() %></td>
			<td><a href="view.do?uid=<%=dto.getUid() %>"><%= dto.getSubject() %></a></td>
			<td><%= dto.getName() %></td>
			<td><%= dto.getViewCnt() %></td>
			<td><%= dto.getRegDateTime() %></td>
		</tr>
<%			
		} // end for
	} // end if
%>	
	</table>
	<br>
	<button onclick="location.href='write.do'">신규등록</button>
</body>
</html>




























