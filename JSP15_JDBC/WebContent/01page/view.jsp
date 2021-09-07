<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>   <%-- JDBC 관련 클래스 import --%>
<%@ page import = "java.time.*" %>
<%@ page import = "java.time.format.*" %>
<% // parameter 받아오기
	int uid = Integer.parseInt(request.getParameter("uid"));
	// ※ 이단계에서 parameter 검증 필요
	
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
	final String SQL_WRITE_INC_VIEWCNT = 
		"UPDATE test_write SET wr_viewcnt = wr_viewcnt + 1 WHERE wr_uid = ?";
	final String SQL_WRITE_SELECT_BY_UID = 
			"SELECT wr_uid \"uid\", wr_subject subject, wr_content content, " +
			"wr_name name, wr_viewcnt viewcnt, wr_regdate regdate " + 
			"FROM test_write WHERE wr_uid = ?";
%>
<%
	String name = "";
	String subject = "";
	String content = "";
	String regdate = "";
	int viewcnt = 0;
%>
<%
	try{
		Class.forName(DRIVER);
		out.println("드라이버 로딩 성공<br>");  // 테스트 출력
		conn = DriverManager.getConnection(URL, USERID, USERPW);
		out.println("conn 성공<br>");  // 테스트 출력
		
		// 트랜잭션 수행
		// 여러 쿼리를 하나의 트랜잭션으로 처리 
		conn.setAutoCommit(false);  // 일단 auto-commit 을  끈다.
		
		pstmt = conn.prepareStatement(SQL_WRITE_INC_VIEWCNT);
		pstmt.setInt(1, uid);
		cnt = pstmt.executeUpdate();
		// ※cnt 결과값에 따른 처리 필요
		
		pstmt.close();
		
		pstmt = conn.prepareStatement(SQL_WRITE_SELECT_BY_UID);
		pstmt.setInt(1, uid);
		rs = pstmt.executeQuery();
		
		// 한개의 레코드만 select 된다.
		if(rs.next()){
			uid = rs.getInt("uid");  // 컬럼명
			subject = rs.getString("subject");
			content = rs.getString("content");
			if(content == null) content = "";  // null 인경우 처리
			name = rs.getString("name");
			viewcnt = rs.getInt("viewcnt");
			regdate = "";
			Timestamp timestamp = rs.getTimestamp("regdate");
			if(timestamp != null)
				regdate = timestamp.toLocalDateTime()
				.format(DateTimeFormatter.ofPattern("yyyy-MM-dd hh:mm:ss"));
		} else {
			// wr_uid 값의 글이 없는 것이다!
%>
			<script>
				alert("해당 정보가 삭제되거나 없습니다");
				history.back();
			</script>
<%		
			return; // ★더이상 JSP 프로세싱 하지 않고 종료★
		} // end if
		
		conn.commit();  // 트랜잭션이 성공적으로 끝나면 commit
		
	} catch(Exception e){
		e.printStackTrace();
		// ※ 예외처리를 하든지, 예외 페이지를 설정해주어야 한다.
		conn.rollback();   // 트랜잭션 중간에 실패하면 rollback 한다.
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
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>읽기 <%= subject %></title>
</head>
<script>
function chkDelete(uid){
	var r = confirm("삭제하시겠습니까?");
	if(r){
		location.href = "deleteOk.jsp?uid=" + uid;
	}
}
</script>
<body>
<h2>읽기 <%= subject %></h2>
<br>
UID : <%= uid %><br>
작성자 : <%= name %><br>
제목: <%= subject %><br>
등록일: <%= regdate %><br>
조회수: <%= viewcnt %><br>
내용: <br>
<hr>
<div>
<%= content %>
</div>
<hr>
<br>
<button onclick="location.href='update.jsp?uid=<%= uid%>'">수정하기</button>
<button onclick="location.href='list.jsp?page=<%= curPage%>'">목록보기</button>
<button onclick="chkDelete(<%= uid %>)">삭제하기</button>
<button onclick="location.href='write.jsp'">신규등록</button>
</body>
</html>
















