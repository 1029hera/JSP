package com.command.write;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.sql.SQLException;
import java.util.List;

import javax.servlet.ServletContext;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.lec.beans.FileDAO;
import com.lec.beans.FileDTO;

public class DownLoadCommand implements Command {

	//  파일다운로드
	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) {
		FileDAO fileDao = new FileDAO();
		List<FileDTO> fileList = null;
		
		int uid = Integer.parseInt(request.getParameter("uid"));  
		// ※ 매개변수 검증 필요
		
		FileInputStream in = null;
		ServletOutputStream sout = null;		
		
		try {
			fileList = fileDao.selectByUid(uid);
			String fileSystemName = fileList.get(0).getFile();
			String originalFileName = fileList.get(0).getSource();
			
			
			ServletContext context = request.getServletContext();
			String realPath = context.getRealPath("upload");
			String downloadFilePath = realPath + File.separator + fileSystemName;

			String fileType = request.getServletContext().getMimeType(downloadFilePath);
			if(fileType == null){
				fileType = "application/octet-stream";  // 일련의 8bit 스트림 형식
											// 유형이 알려지지 않은 파일에 대한 읽기 형식 지정
			}
			response.setContentType(fileType);
			String encFileName = URLEncoder.encode(originalFileName, "utf-8");
			// 원본파일 이름으로 다운로드 받을수 있도록 하기
			response.setHeader("Content-Disposition", "attachment; filename=" + encFileName);

			File srcFile = new File(downloadFilePath);
			in = new FileInputStream(srcFile);
			sout = response.getOutputStream();

			byte [] buff = new byte[(int)srcFile.length()]; // 파일크기만큼의 버퍼
			int numRead = 0;
			int totalRead = 0;
			
			while((numRead = in.read(buff, 0, buff.length)) != -1){  // 파일에서 읽기
				totalRead += numRead;
				sout.write(buff, 0, numRead);  // 전송
			}
			
		} catch (SQLException e) {
			e.printStackTrace();
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			try {
				if(sout != null) {
					sout.flush();					
					sout.close();
				}
				if(in != null) in.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		
		
	}

}












