package com.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.command.write.AjaxListCommand;
import com.command.write.Command;
import com.command.write.ListCommand;

@WebServlet("*.ajax")
public class AjaxController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public AjaxController() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		ajaxAction(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		ajaxAction(request, response);
	}
	

	protected void ajaxAction(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("ajaxAction()");
		request.setCharacterEncoding("UTF-8");
		
		Command command = null;   // 어떠한 로직을 수행할지
		
		// URL로부터 URI, ContextPath, Command 분리
		String uri = request.getRequestURI();
		String conPath = request.getContextPath();
		String com = uri.substring(conPath.length());
		
		switch(com) {
		case "/list.ajax":
			// 글 목록 데이터 읽기
			new ListCommand().execute(request, response);
			// 읽어온 데이터를 다음 커맨드에 넘겨줌
			new AjaxListCommand().execute(request, response);
			break;
		}
		
		// 트랜잭션 처리하고 html 이 아닌 데이터로 response 하니까
		// 굳이 forwarding 필요 없슴.
	
	}
}














