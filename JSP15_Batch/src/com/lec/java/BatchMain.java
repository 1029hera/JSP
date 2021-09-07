package com.lec.java;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

public class BatchMain {

	// JDBC 관련 기본 객체 변수들 선언
	Connection conn = null;
	Statement stmt = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;   // executeQuery(), SELECT 결과 
	int cnt = 0;           // executeUpdate(), DML 결과
	
	final String DRIVER = "oracle.jdbc.driver.OracleDriver";	  // JDBC 드라이버 클래스
	final String URL = "jdbc:oracle:thin:@localhost:1521:XE";   // DB 접속 URL
	final String USERID = "scott26";   // DB 접속 계정 정보
	final String USERPW = "tiger26";

	
	final String SQL_WRITE_INSERT = "INSERT INTO test_write\r\n"
			+ "	(wr_uid, wr_subject, wr_content, wr_name)\r\n"
			+ "	VALUES(test_write_seq.nextval, ?, ?, ?)";
	
	
	public static void main(String[] args) {
		new BatchMain().runBatch();
	}

	private void runBatch() {
		// dummy data 10개 작성
		
		try{
			Class.forName(DRIVER);
			System.out.println("드라이버 로딩 성공" + "<br>");   // 테스트 출력
			conn = DriverManager.getConnection(URL, USERID, USERPW);
			System.out.println("conn 성공" + "<br>");       // 테스트 출력
			
			pstmt = conn.prepareStatement(SQL_WRITE_INSERT);
			int num = 10;
			for(int i = 0; i < num; i++) {
				pstmt.setString(1, String.format("subj%04d", i));
				pstmt.setString(2, String.format("content%04d", i));
				pstmt.setString(3, String.format("name%04d", i));
				cnt += pstmt.executeUpdate();
			}
			System.out.println(cnt + "개 의 데이터가 INSERT 되었습니다");
			
		} catch(Exception e){
			e.printStackTrace();
			//※ 예외처리를 하든지, 예외 페이지를 설정해주어야 한다.
		} finally {
			// DB 리소스 해제
			try{
				if(rs != null) rs.close();
				if(stmt != null) stmt.close();
				if(pstmt != null) pstmt.close();
				if(conn != null) conn.close();
			}catch(Exception e){
				e.printStackTrace();
			}
		} // end try



		
	}

}
