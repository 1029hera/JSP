package com.lec.beans;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import common.D;

// DAO : Data Access Object
// DB에 접속하여 트랜잭션 수행
public class WriteDAO {
	
	Connection conn;
	PreparedStatement pstmt;
	Statement stmt;
	ResultSet rs;
	
	
	public WriteDAO() {
		 try {
			Class.forName(D.DRIVER);
			conn = DriverManager.getConnection(D.URL, D.USERID, D.USERPW);
			System.out.println("WriteDAO 생성, 데이터베이스 연결!");
		} catch (Exception e) {
			e.printStackTrace();
		}
	} // end 생성자


	// DB 자원 반납
	public void close() throws SQLException {
		if(rs != null) rs.close();
		if(pstmt != null) pstmt.close();
		if(stmt != null) stmt.close();
		if(conn != null) conn.close();		
	} // end close();
	
	// DB 트랜잭션 동작

	// 새글 작성 <-- 제목, 내용, 작성자  :  writeOk.jsp
	public int insert(String subject, String content, String name) throws SQLException {
		int cnt = 0;
		
		try {			
			pstmt = conn.prepareStatement(D.SQL_WRITE_INSERT);
			pstmt.setString(1, subject);
			pstmt.setString(2, content);
			pstmt.setString(3, name);
			cnt = pstmt.executeUpdate();
		} finally {
			close();
		} // end try		
		
		return cnt;
	} // end insert
	
	// 새글작성 <-- DTO
	public int insert(WriteDTO dto) throws SQLException{
		int cnt = 0;
		
		String subject = dto.getSubject();
		String content = dto.getContent();
		String name = dto.getName();
		cnt = this.insert(subject, content, name);
		
		return cnt;
	} // end insert(DTO)
	
	// 글 목록 읽기 : list.jsp
	// ResultSet --> List<> 로 리턴
	public List<WriteDTO> buildList(ResultSet rs) throws SQLException{
		List<WriteDTO> list = new ArrayList<WriteDTO>();
		
		while(rs.next()) {
			int uid = rs.getInt("uid");
			String subject = rs.getString("subject");
			String content = rs.getString("content");
			if(content == null) content = "";
			String name = rs.getString("name");
			int viewCnt = rs.getInt("viewcnt");
			
			LocalDateTime regDate = null;
			Timestamp timestamp = rs.getTimestamp("regdate");
			if(timestamp != null)
				regDate = timestamp.toLocalDateTime();
			
			WriteDTO dto = new WriteDTO(uid, subject, content, name, viewCnt, regDate);
			list.add(dto);
		} // end while
		
		return list;
	} // end buildList()
	
	// 전체 SELECT
	public List<WriteDTO> select() throws SQLException {
		List<WriteDTO> list = null;
		try {			
			pstmt = conn.prepareStatement(D.SQL_WRITE_SELECT);
			rs = pstmt.executeQuery();
			list = buildList(rs);
		} finally {
			close();
		} // end try		
		return list;
	} // end select()
	
		
	// 특정 uid 글 하나 SELECT : update.jsp
	public List<WriteDTO> selectByUid(int uid) throws SQLException{
		List<WriteDTO> list = null;
		try {
			pstmt = conn.prepareStatement(D.SQL_WRITE_SELECT_BY_UID);
			pstmt.setInt(1, uid);
			rs = pstmt.executeQuery();
			list = buildList(rs);
		} finally {
			close();
		} // end try		
		return list;
	} // end selectByUid()
	
	// 특정 uid 글 하나 SELECT + 조회수 증가 : view.jsp
	// viewcnt 로 +1 증가해야 하고, 글 하나 읽어와야 한다, 트랜잭션 처리
	// -> List<DTO> 로 리턴 
	public List<WriteDTO> readByUid(int uid) throws SQLException {
		int cnt = 0;
		List<WriteDTO> list = null;
		try {
			// 트랜잭션 처리
			conn.setAutoCommit(false);
			pstmt = conn.prepareStatement(D.SQL_WRITE_INC_VIEWCNT);
			pstmt.setInt(1, uid);
			cnt = pstmt.executeUpdate();
			
			pstmt.close();
			pstmt = conn.prepareStatement(D.SQL_WRITE_SELECT_BY_UID);
			pstmt.setInt(1, uid);
			rs = pstmt.executeQuery();
			
			list = buildList(rs);  // 글 하나 --> List<>
			
			conn.commit();
		} catch(SQLException e) {
			conn.rollback();  // 예외 발생하면 rollback 하고
			throw e;     // 다시 예외를 throw
		} finally {
			close();
		} // end try
		return list;		
	} // end readByUid()
	
	// 특정 uid 글 수정 (제목, 내용)
	public int update(int uid, String subject, String content) throws SQLException {
		int cnt = 0;
		
		try {
			pstmt = conn.prepareStatement(D.SQL_WRITE_UPDATE);
			pstmt.setString(1, subject);
			pstmt.setString(2, content);
			pstmt.setInt(3, uid);
			cnt = pstmt.executeUpdate();
		} finally {
			close();
		} // end try
		
		return cnt;
	} // end update();
	
	// 특정 uid 글 삭제하기
	public int deleteByUid(int uid) throws SQLException {
		int cnt = 0;
		try{
			pstmt=conn.prepareStatement(D.SQL_WRITE_DELETE_BY_UID);
			pstmt.setInt(1, uid);
			cnt = pstmt.executeUpdate();
		}finally{
			close();
		} // end try
		return cnt;
	} // end deleteByUid()
	
} // end DAO


















