package com.command.write;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.List;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.lec.beans.WriteDAO;
import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;
import com.oreilly.servlet.multipart.FileRenamePolicy;

public class WriteCommand implements Command {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) {
		int cnt = 0;
		WriteDAO dao = new WriteDAO();
		
		// 1.MultipartRequest 생성 -> 파일 업로드 됨.
		// 파일 저장할 폴더 경로 
		ServletContext context = request.getServletContext();
		String saveDirectory = context.getRealPath("upload");
		System.out.println("업로드 경로: " + saveDirectory);
		
		int maxPostSize = 5 * 1024 * 1024;  // POST 받기, 최대 5M byte
		String encoding = "utf-8";
		FileRenamePolicy policy = new DefaultFileRenamePolicy(); // 업로드 파일 이름 중복에 대한 rename 정책
		
		MultipartRequest multi = null;
		
		// MultipartRequest 생성 단계에서 이미 파일은 저장됨.
		try {
			multi = new MultipartRequest(
					request, 
					saveDirectory,
					maxPostSize,
					encoding,
					policy
					);
		} catch (IOException e1) {
			e1.printStackTrace();
		}
		
		// 2. 업로드된 파일의 '원본이름(들)' 과 '저장된 이름(들)'  받아오기
		Enumeration names = multi.getFileNames();  // type='file' 요소 name들 추출
		List<String> originalFileNames = new ArrayList<String>();
		List<String> fileSystemNames = new ArrayList<String>();
		
		
		while(names.hasMoreElements()) {
			String name = (String)names.nextElement();
			String originalFileName = multi.getOriginalFileName(name);
			String fileSystemName = multi.getFilesystemName(name);
			System.out.println("첨부파일: " + originalFileName + "->" + fileSystemName);
			
			if(originalFileName != null && fileSystemName != null) {
				originalFileNames.add(originalFileName);
				fileSystemNames.add(fileSystemName);
			}
		}
		
		// 3. 게시글 및 첨부파일 -> DB 에저장
		// 입력한값 받아오기  ★ MultipartRequest 객체에서 가져온다
		String name = multi.getParameter("name");
		String subject = multi.getParameter("subject");
		String content = multi.getParameter("content");
		
		try {
			cnt = dao.insert(subject, content, name, originalFileNames, fileSystemNames);
		} catch(SQLException e) {
			e.printStackTrace();
		}
		
		request.setAttribute("result", cnt);

	}

}







