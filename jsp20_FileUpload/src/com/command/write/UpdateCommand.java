package com.command.write;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.List;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.lec.beans.FileDAO;
import com.lec.beans.WriteDAO;
import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;
import com.oreilly.servlet.multipart.FileRenamePolicy;

public class UpdateCommand implements Command {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) {
		int cnt = 0;
		WriteDAO dao = new WriteDAO();
		FileDAO fileDao = new FileDAO();  // 첨부파일
		
		// 1. 새로 업로드할 파일(들), MultipartRequest
		ServletContext context = request.getServletContext();
		// 서블릿 상의 upload 폴더 경로를 알아온다
		String saveDirectory = context.getRealPath("upload");
		System.out.println("업로드 경로: " + saveDirectory);
		
		int maxPostSize = 5 * 1024 * 1024;  // POST 받기, 최대 5M byte :1Kbyte = 1024 byte, 1Mbyte = 1024 Kbyte
		String encoding = "utf-8";  // response 인코딩
		FileRenamePolicy policy = new DefaultFileRenamePolicy(); //업로딩 파일 이름 중복에 대한 정책
		MultipartRequest multi = null; // com.oreilly.servlet.MultipartRequest 임포트

		// MultipartRequest 생성 단계에서 이미 파일은 저장됨.
		try {
			multi = new MultipartRequest(
					request,                 // JSP 내부객체 request
					saveDirectory,
					maxPostSize,
					encoding,
					policy
					);
		} catch (IOException e1) {
			e1.printStackTrace();
		}
		
		// 2. 새로 업로드된 파일의 '원본이름(들)' 과 '저장된 이름(들)' 받아오기
		List<String> originalFileNames = new ArrayList<String>();
		List<String> fileSystemNames = new ArrayList<String>();
		
		Enumeration names = multi.getFileNames();   // type="file" 요소 name들 추출		
		while(names.hasMoreElements()){		
			String name = (String)names.nextElement();  
			String originalFileName = multi.getOriginalFileName(name);
			String fileSystemName = multi.getFilesystemName(name);
			System.out.println("첨부파일: " + originalFileName + "->" + fileSystemName);
			
			if(originalFileName != null && fileSystemName != null) {
				originalFileNames.add(originalFileName);
				fileSystemNames.add(fileSystemName);
			}
		} // end while
		
		// 3. 삭제될 기존의 첨부파일(들) -> DB에서 삭제, 물리적 파일도 삭제
		String [] delFiles = multi.getParameterValues("delfile");
		if(delFiles != null && delFiles.length > 0) {  // 삭제할 파일(들) 이 있었다면
			// String [] -> int [] 변환
			int [] delFileUids = new int[delFiles.length];
			for(int i = 0; i < delFiles.length; i++) {
				delFileUids[i] = Integer.parseInt(delFiles[i]);
			}
			
			try {
				fileDao.deleteByUid(delFileUids, request);  // 물리적파일 삭제 + DB테이블 삭제
			} catch(SQLException e) {
				e.printStackTrace();
			}			
		} // end if
		
		
		
		// 4. 입력한 값을 받아오기 -> 글수정
		int uid = Integer.parseInt(multi.getParameter("uid"));
		String subject = multi.getParameter("subject");
		String content = multi.getParameter("content");
		
		// 유효성 체크  null 이거나, 빈문자열이면 이전화면으로 돌아가기
		if(subject != null && subject.trim().length() > 0){			
			try {			
				cnt = dao.update(uid, subject, content);
			} catch (SQLException e) {
				e.printStackTrace();
			}
		} // end if
		
		// 5. 추가된 첨부파일(들) --> DB에 저장
		fileDao = new FileDAO();
		try {
			fileDao.insert(uid, originalFileNames, fileSystemNames);
		} catch(SQLException e) {
			e.printStackTrace();
		}
		
		// 6. 결과
		request.setAttribute("uid", uid);  // multipart 로 받은것을, updateOk.jsp 로 넘겨야 한다
  		request.setAttribute("result", cnt);
	} // end execute()
} // end Command








