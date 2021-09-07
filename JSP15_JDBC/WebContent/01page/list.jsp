<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>   <%-- JDBC 관련 클래스 import --%>
<%@ page import = "java.time.*" %>
<%@ page import = "java.time.format.*" %>
<%
	int curPage = 1;  // 현재 페이지 (디폴트는 1 page)
	
	// 현재 몇 페이지 인지 parameter 받아온다.
	String pageParam = request.getParameter("page");
	if(pageParam != null && !pageParam.trim().equals("")){
		try{
			curPage = Integer.parseInt(pageParam);
		} catch(NumberFormatException e){
			//
		}
	} // end if
%>
<%!
	// JDBC 관련 기본 객체 변수들 선언
	Connection conn = null;
	Statement stmt = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;    // SELECT 결과,  executeQuery()
	int cnt = 0;            // DML 결과,   executeUpdate()
	
	// Connection 에 필요한 값 세팅
	// ORACLE 버젼
	final String DRIVER = "oracle.jdbc.driver.OracleDriver"; // JDBC 드라이버 클래스
	final String URL = "jdbc:oracle:thin:@localhost:1521:XE"; // DB 접속 URL
	final String USERID = "scott26";   // DB 접속 계정 정보
	final String USERPW = "tiger26";
%>
<%!
	// 쿼리문 준비
	/*
	final String SQL_WRITE_SELECT = 
		"SELECT wr_uid \"uid\", wr_subject subject, wr_content content, " +
		"wr_name name, wr_viewcnt viewcnt, wr_regdate regdate " + 
		"FROM test_write ORDER BY wr_uid DESC";
	*/
	
	// 페이징
	// 쿼리 : 글 목록 전체 개수 가져오기
	final String SQL_WRITE_COUNT_ALL = "SELECT COUNT(*) FROM test_write";
	
	// 쿼리 : 페이지 분량만큼 SELECT
	final String SQL_WRITE_SELECT_FROM_ROW = "SELECT * FROM " 
			+ "(SELECT ROWNUM AS RNUM, T.* FROM (" 
			+ 		"SELECT wr_uid \"uid\", wr_subject subject, wr_content content, " 
			+		"wr_name name, wr_viewcnt viewcnt, wr_regdate regdate " 
			+		"FROM test_write ORDER BY wr_uid DESC"
			+ ") T) " 
			+ "WHERE RNUM >= ? AND RNUM < ?";

	//cnt // 글 목록 전체의 개수 
	// 페이징 관련 세팅값들
	int writePages = 10;  // 한 [페이징] 에 몇개의 '페이지'를 표현할 것인가
	int pageRows = 8;  // 한 '페이지' 에 몇개의 글을 리스트 할 것인가?
	int totalPage = 0;  // 총 몇 '페이지' 분량인가?
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

<!-- 페이징 -->
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" type="text/css" href="CSS/common.css"/>
<script src="https://kit.fontawesome.com/bb29575d31.js"></script>

</head>
<body>
<%
	try{
		Class.forName(DRIVER);
		out.println("드라이버 로딩 성공<br>");  // 테스트 출력
		conn = DriverManager.getConnection(URL, USERID, USERPW);
		out.println("conn 성공<br>");  // 테스트 출력
		
		// 트랜잭션 수행
		pstmt = conn.prepareStatement(SQL_WRITE_COUNT_ALL);
		rs = pstmt.executeQuery();
		
		if(rs.next()) cnt = rs.getInt(1);  // 글 전체 개수
		
		rs.close();
		pstmt.close();
		
		// 총 몇 페이지 분량인가?
		totalPage = (int)Math.ceil(cnt / (double)pageRows);
		
		// 몇번째 row 부터?
		int fromRow = (curPage - 1) * pageRows + 1; 
		
		pstmt = conn.prepareStatement(SQL_WRITE_SELECT_FROM_ROW);
		pstmt.setInt(1, fromRow);  // 몇번째 row부터
		pstmt.setInt(2, fromRow + pageRows);  // 몇번째 row 전까지?
				
		rs = pstmt.executeQuery();
		out.println("쿼리성공<br>");
%>
		<hr>
		<h2>리스트 <%= curPage %>페이지</h2> <!-- 현재 페이지 표시 -->
		<h4>총 <%= cnt %>개</h4> <!-- 전체 글 개수 -->
		<table>
			<tr>
				<th>row</th>  <!-- rownum -->
				<th>UID</th>
				<th>제목</th>
				<th>작성자</th>
				<th>조회수</th>
				<th>등록일</th>
			</tr>
<%
	while(rs.next()){
		int rnum = rs.getInt("rnum"); // rownum
		int uid = rs.getInt("uid");  // 컬럼명
		String subject = rs.getString("subject");
		String name = rs.getString("name");
		int viewcnt = rs.getInt("viewcnt");
		String regdate = "";
		Timestamp timestamp = rs.getTimestamp("regdate");
		if(timestamp != null)
			regdate = timestamp.toLocalDateTime()
			.format(DateTimeFormatter.ofPattern("yyyy-MM-dd hh:mm:ss"));
		
		
		out.println("<tr>");
		out.println("<td>" + rnum + "</td>");
		out.println("<td>" + uid + "</td>");
		out.println("<td><a href='view.jsp?uid=" + uid + "&page=" + curPage + "'>" + subject + "</a></td>");
		out.println("<td>" + name + "</td>");
		out.println("<td>" + viewcnt + "</td>");
		out.println("<td>" + regdate + "</td>");
		out.println("</tr>");
	} // end while
%>		
		</table>
		<br>
		<button onclick="location.href='write.jsp'">신규등록</button>
<%	
	} catch(Exception e){
		e.printStackTrace();
		// ※ 예외처리를 하든지, 예외 페이지를 설정해주어야 한다.
	} finally {
		// DB 리소스 해제
		try{			
			if(rs != null) rs.close();
			if(stmt != null) stmt.close();
			if(pstmt != null) pstmt.close();
			if(conn != null) conn.close();
		} catch(Exception e){
			e.printStackTrace();
		}		
	} //  end try
%>

<%-- [페이징] --%>
<jsp:include page="pagination.jsp">
	<jsp:param value="<%= writePages %>" name="writePages"/>
	<jsp:param value="<%= totalPage %>" name="totalPage"/>
	<jsp:param value="<%= curPage %>" name="curPage"/>
</jsp:include>

</body>
</html>



















































