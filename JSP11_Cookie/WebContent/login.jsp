<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>login 페이지</title>
</head>
<body>
	
	<%!
		int i = 0;
	%>	
	<%
		Cookie [] cookies = request.getCookies();
		String cookieName = "userid"; // 로그인 성공하면 발급되는 쿠키 이름
	
		if(cookies != null){
			for(i = 0; i < cookies.length; i++){
				if(cookieName.equals(cookies[i].getName())){
					break;  // 쿠키 발견하면 종료
				}
			}
		}		
	%>


	<%if(cookies == null || i == cookies.length){ %>
		<h2>로그인 상태가 아닙니다</h2>
		<form action="loginOk.jsp">
			id: <input type="text" name="userid"><br>
			pw:	<input type="password" name="pw"><br>
			<input type="submit" value="로그인"><br>
		</form>
	<%} else { %>
		<h2>로그인 상태입니다</h2>
		<form action="logout.jsp">
			<input type="submit" value="로그아웃"><br>
		</form>
	<% } %>

</body>
</html>















