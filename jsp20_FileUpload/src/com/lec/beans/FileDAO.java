package com.lec.beans;

import java.io.File;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;

import common.D;

public class FileDAO {
	Connection conn;
	PreparedStatement pstmt;
	Statement stmt;
	ResultSet rs;
	
	// DAO 객체가 생성될때 Connection 도 생성된다
	public FileDAO(){
		try {
			Class.forName(D.DRIVER);
			conn = DriverManager.getConnection(D.URL, D.USERID, D.USERPW);
			System.out.println("FileDAO생성, 데이터베이스 연결!!");
		} catch (Exception e) {			
			e.printStackTrace();
		} // end try
	}// 생성자
	
	// DB 자원 반납 메소드, 만들어놓으면 편함..
	public void close() throws SQLException{
		if(rs != null) rs.close();
		if(pstmt != null) pstmt.close();
		if(stmt != null) stmt.close();
		if(conn != null) conn.close();
	} // end close();
	
	// 특정 글(wr_uid) 에 첨부파일(들) 추가. INSERT
	// 글 insert, update 시 발생
	public int insert(int wrUid,  // 첨부될 글
			List<String> originalFileNames, // 원본 파일명(들)
			List<String> fileSystemNames  // 저장된 파일명(들)
			) throws SQLException {
	 	int cnt = 0;
		
	 	try {
			pstmt = conn.prepareStatement(D.SQL_FILE_INSERT);
			for(int i = 0; i < originalFileNames.size(); i++) {
				pstmt.setString(1, originalFileNames.get(i));
				pstmt.setString(2, fileSystemNames.get(i));
				pstmt.setInt(3, wrUid);
				cnt += pstmt.executeUpdate();
			}
		} finally {
			close();
		}
	 	
		return cnt;
	} // end isnert()
	
	
	// 첨부파일 읽어 들이기
	//-------------------------------------------------
	// ResultSet --> List로 리턴 
	public List<FileDTO> buildList(ResultSet rs) throws SQLException{
		List<FileDTO> list = new ArrayList<>();
		
		while(rs.next()) {
			int uid = rs.getInt("uid");
			String source = rs.getString("source");
			String file = rs.getString("file");
			
			FileDTO dto = new FileDTO(uid, source, file);
			list.add(dto);
		}
		
		return list;
	} // end buildList()
	
	
	// 특정 글(wr_uid) 의 첨부파일(들) SELECT
	public List<FileDTO> selectFilesByWrUid(int wrUid) throws SQLException{
		List<FileDTO> list = null;
		
		try {
			pstmt = conn.prepareStatement(D.SQL_FILE_SELECT);
			pstmt.setInt(1, wrUid);
			rs = pstmt.executeQuery();
			
			list = buildList(rs);
		} finally {
			close();
		}		
		return list;
	} // end selectFilesByWrUid()
	
	// 특정 첨부파일 (bf_uid) 한개 SELECT
	public List<FileDTO> selectByUid(int uid) throws SQLException{
		
		List<FileDTO> list = null;
		try{
			// 트랜잭션 처리
			pstmt = conn.prepareStatement(D.SQL_FILE_SELECT_BY_UID);
			pstmt.setInt(1, uid);
			rs = pstmt.executeQuery();
			
			list = buildList(rs);
		}finally{
			close();
		} // end try	
		
		return list;
		
	} // end selectByUid()

	// List<FileDTO> 의 물리적인 파일(들) 삭제
	public void deleteFiles(List<FileDTO> list, HttpServletRequest request) {
		if(list == null || list.size() == 0 || request == null) return;
		
		// 물리적인 경로
		ServletContext context = request.getServletContext();
		String saveDirectory = context.getRealPath("upload");
		
		for(FileDTO dto : list) {
			// 삭제할 파일
			File f = new File(saveDirectory, dto.getFile());
			System.out.println("삭제시도---> " +  f.getAbsolutePath());
			
			if(f.exists()) {
				if(f.delete()) {
					System.out.println("삭제 성공");
				} else {
					System.out.println("삭제 실패");
				}
			} else {
				System.out.println("파일이 존재하지 않습니다.");
			}
			
		} // end for
	}
	
	// 특정 글(wr_uid) 의 첨부파일(들) 삭제
	// 1) 물리적인 파일(들) 삭제,  2) DB 삭제
	public int deleteByWrUid(int wrUid, HttpServletRequest request) throws SQLException{
		int cnt = 0;
		
		List<FileDTO> list = null;
		try {
			// 특정 글(wrUId) 의 첨부파일들 정보 가져오기 -> List<FileDTO>
			pstmt = conn.prepareStatement(D.SQL_FILE_SELECT);
			pstmt.setInt(1, wrUid);
			rs = pstmt.executeQuery();
			
			list = buildList(rs);
			
			// 물리적인 파일(들) 삭제
			deleteFiles(list,  request);
			
			// test_file 테이블 에서 삭제  
			// ※ test_file 에서 외래키 ON DELETE CASCADE 적용되어있으면 불필요)
			pstmt.close();
			rs.close();
			
			pstmt = conn.prepareStatement(D.SQL_FILE_DELETE_BY_WRUID);
			pstmt.setInt(1, wrUid);
			cnt = pstmt.executeUpdate();
			System.out.println("첨부파일 " + cnt + "개 삭제");
			
		} finally {
			close();
		}		
		
		return cnt;
	}
	
	
	// 복수개의 bf_uid 의 파일(들) 제거,
	// 글 '수정' 단계 에서 발생함. '글'이 삭제 되는 것은 아니라서, 파일만 개별적으로 삭제해야 함
	public int deleteByUid(int [] uids, HttpServletRequest request) throws SQLException{
		
		if(uids == null || uids.length == 0 || request == null) return 0;
		
		int cnt = 0;
		
		// bf_uid 가 101, 204, 319번 파일을 지우는 쿼리는?
		// DELETE FROM test_file WHERE bf_uid IN (101, 204, 319)
		// 읽어오는 쿼리
		// SELECT * FROM test_file WHERE bf_uid IN (101, 204, 319)
		
		try {
			// 삭제할 파일 정보들 읽어오기 -> List<FileDTO>
			StringBuffer sql = new StringBuffer("SELECT bf_uid \"uid\", bf_source \"source\", bf_file \"file\" FROM test_file WHERE bf_uid IN (");
			
			for(int uid : uids) {
				sql.append(uid + ",");
			}
			sql.deleteCharAt(sql.lastIndexOf(","));  // 맨 끝의 콤마 삭제
			sql.append(")");
			
			stmt = conn.createStatement();
			rs = stmt.executeQuery(sql.toString());
			
			List<FileDTO> list = buildList(rs);
			
			// 물리적인 파일(들) 삭제
			deleteFiles(list, request);
			
			// test_file 테이블 삭제, '글' 이 삭제되는 것이 아니라서, 파일DB를 개별적으로 삭제해야 함.
			sql = new StringBuffer("DELETE FROM test_file WHERE bf_uid IN(");
			for(int uid : uids) {
				sql.append(uid + ",");
			}
			sql.deleteCharAt(sql.lastIndexOf(","));
			sql.append(")");
			
			System.out.println("파일삭제: " + sql);
			
			cnt = stmt.executeUpdate(sql.toString());
			System.out.println(cnt + "개 삭제");
			
		} finally {
			close();
		}
		
		return cnt;
	}
	

} // end DAO

















