package com.command.write;

import java.sql.SQLException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.lec.beans.WriteDAO;
import com.lec.beans.WriteDTO;

public class ListCommand implements Command {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) {
		WriteDAO dao = new WriteDAO(); // DAO 객체 생성
		
		List<WriteDTO> list = null;
		
		try {
			// 트랜잭션 수행
			list = dao.select();
			
			// "list" 란 name으로 request 에 list 저장
			// 즉, request 에 담아서 컨트롤러에 전달되는 셈.
			request.setAttribute("list", list);
		} catch(SQLException e) {
			e.printStackTrace();
		}

		
	}

}







