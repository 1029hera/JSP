package com.command.write;

import java.sql.SQLException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.lec.beans.FileDAO;
import com.lec.beans.FileDTO;
import com.lec.beans.WriteDAO;
import com.lec.beans.WriteDTO;

public class SelectCommand implements Command {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) {
		WriteDAO dao = new WriteDAO();
		List<WriteDTO> list = null;
		int uid = Integer.parseInt(request.getParameter("uid"));  // 매개변수 검증 필요
		
		try {
			list = dao.selectByUid(uid);  // 읽기 only
			request.setAttribute("list", list);
		} catch (SQLException e) { // 만약 ConnectionPool 을 사용한다면 여기서 NamingException 도 catch 해야 한다  
			e.printStackTrace();
		}
		
		// 첨부파일 정보도 update 화면에 보여주어야 한다.
		FileDAO fileDao = new FileDAO();
		List<FileDTO> fileList = null;   // 첨부파일(들)
		
		// 첨부파일 읽어들이기
		try {
			fileList = fileDao.selectFilesByWrUid(uid);
			request.setAttribute("fileList", fileList);			
		} catch(SQLException e) {
			e.printStackTrace();
		}
		
		
	} //end execute()
} // end Command














