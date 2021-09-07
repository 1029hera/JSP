<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>   <%-- JDBC 관련 클래스 import --%>
<%@ page import = "java.time.*" %>
<%@ page import = "java.time.format.*" %>
<%--
	Update 의 경우가 의외로 처리 할 것들이 많다.
	
	일단, 기존의 데이터를 불러 들어 와야 한다. SELECT
	그리고, 편집가능한 영역과 그렇지 않은 영역을 분리해서 사용자에게 form 을 제공해야 한다.
	표시내용은 view.jsp 에서 비슷하게 시작가능
	
	나중에 updateOk.jsp 로 넘겨서 실제 UPDATE 쿼리를 실행하기 위해선 uid 값도 넘어가야 한다.
	그래서 넘겨 받은 uid 값을 hidden 으로 담아 두었다가 넘겨준다.
	
 --%>



<% // parameter 받아오기
	int uid = Integer.parseInt(request.getParameter("uid"));
	// ※ 이단계에서 parameter 검증 필요
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
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>수정 <%= subject %></title>
</head>
<script>
function chkSubmit(){
	frm = document.forms['frm'];
	
	var subject = frm['subject'].value.trim();

	if(subject == ""){
		alert("제목은 반드시 작성해야 합니다");
        frm["subject"].focus();
        return false;
	}
	return true;
}
</script>
<body>
<h2>수정</h2>
<form name="frm" action="updateOk.jsp" method="post" onsubmit="return chkSubmit()">
<input type="hidden" name="uid" value="<%= uid%>"/>
작성자: <%= name %><br>  <%-- 작성자 이름은 변경불가 --%>
제목:
<input type="text" name="subject" value="<%= subject%>"/><br>
내용:<br>
<textarea name="content"><%= content %></textarea>
<br><br>
<input type="submit" value="수정">
</form>
<button onclick="history.back()">이전으로</button>
<button onclick="location.href='list.jsp'">목록보기</button>

</body>
</html>













