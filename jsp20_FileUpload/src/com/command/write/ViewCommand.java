package com.command.write;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.lec.beans.FileDAO;
import com.lec.beans.FileDTO;
import com.lec.beans.WriteDAO;
import com.lec.beans.WriteDTO;

public class ViewCommand implements Command {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) {
		WriteDAO dao = new WriteDAO();
		List<WriteDTO> list = null;
		int uid = Integer.parseInt(request.getParameter("uid"));  // 매개변수 검증 필요
		
		try {
			list = dao.readByUid(uid);  // 읽기 + 조회수 증가
			request.setAttribute("list", list);
		} catch (SQLException e) { // 만약 ConnectionPool 을 사용한다면 여기서 NamingException 도 catch 해야 한다  
			e.printStackTrace();
		}
		
		// 첨부파일용 DAO 추가
		FileDAO fileDao = new FileDAO();
		List<FileDTO> fileList = null;
		
		// 첨부파일 읽어들이기
		try {
			if(list != null && list.size() == 1) {  // 글 1개에 대한 첨부파일
				fileList = fileDao.selectFilesByWrUid(uid); // 첨부파일 읽어오기
				
				// 이미지파일 여부 세팅
				String realPath =
						request.getServletContext().getRealPath("upload");
				
				for(FileDTO fileDto : fileList) {
					String filePath = realPath + File.separator + fileDto.getFile();
					BufferedImage imgData = ImageIO.read(new File(filePath));
					if(imgData != null) {
						fileDto.setImage(true); 
					}
				}
				
				request.setAttribute("fileList", fileList);  // VIEW 에서 보여줄 첨부파일 정보
				
			}
		} catch(SQLException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}	
		
		
		
		
		
		
		
		
	} //end execute()
} // end Command







