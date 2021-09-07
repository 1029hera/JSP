<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<jsp:useBean id="dao" class="com.lec.beans.WriteDAO"/> <%-- DAO bean 생성 --%>
<%
	request.setCharacterEncoding("utf-8");  // 한글 인코딩 받아올때 꼭!
%>
<jsp:useBean id="dto" class="com.lec.beans.WriteDTO"/>
<jsp:setProperty property="*" name="dto"/>

<% // dao 사용한 트랜잭션
	int cnt = dao.insert(dto);
%>

<% if(cnt == 0){ %>
	<script>
		alert("등록 실패!!!!!!");
		history.back();
	</script>
<% } else { %>
	<script>
		alert("등록 성공, 리스트 출력합니다");
		location.href = "list.jsp";
	</script>
<% } %>


























