package com.controller;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.command.write.Command;
import com.command.write.DeleteCommand;
import com.command.write.DownLoadCommand;
import com.command.write.ListCommand;
import com.command.write.SelectCommand;
import com.command.write.UpdateCommand;
import com.command.write.ViewCommand;
import com.command.write.WriteCommand;

// CONTROLLER
@WebServlet("*.do")
public class DoController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public DoController() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		actionDo(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		actionDo(request, response);
	}
	
	private void actionDo(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
		System.out.println("actionDo() 호출");
		
		request.setCharacterEncoding("utf-8");  // 한글인코딩
		
		// URL 로부터 URI, ContextPath, Command 분리
		String uri = request.getRequestURI();   // -->        /JSP18_MVC/aaa.do
		String conPath = request.getContextPath();  // -->    /JSP18_MVC
		String com = uri.substring(conPath.length());  // -->           /aaa.do
		
		// 테스트 출력
		System.out.println("uri: " + uri);  
		System.out.println("conPath: " + conPath);  
		System.out.println("com: " + com);		
		
		
		
		// 컨트롤러는 커맨드에 따라, '비지니스로직'을 수행하고
		// 그 결과를 내보낼 view를 결정한다.
		
		Command command = null;  // 어떠한 로직을 수행할지 결정
		String viewPage = null;  // 어떠한 페이지(view) 에 보여줄지 결정
		
		switch(com) {
		case "/list.do":
			command = new ListCommand();
			command.execute(request, response);
			viewPage = "list.jsp";
			break;
		case "/write.do":
			viewPage = "write.jsp";
			break;
		case "/writeOk.do":
			command = new WriteCommand();
			command.execute(request, response);
			viewPage = "writeOk.jsp";
			break;
		case "/view.do":
			command = new ViewCommand();
			command.execute(request, response);
			viewPage = "view.jsp";
			break;
		case "/update.do":
			command = new SelectCommand();  // '수정' 이지만, 일단 읽어오는것부터 시작이다.
			command.execute(request, response);
			viewPage = "update.jsp";
			break;
		case "/updateOk.do":
			command = new UpdateCommand();
			command.execute(request, response);
			viewPage = "updateOk.jsp";
			break;  // 디버깅 훈련, 이 break를 없애고, 찾아보기
		case "/deleteOk.do":
			command = new DeleteCommand();
			command.execute(request, response);
			viewPage = "deleteOk.jsp";
			break;
			
		// ★ 파일 다운로드
		case "/download.do":
			command = new DownLoadCommand();
			command.execute(request, response);  
			// 굳이 view 필요하지 않다. 
			break;			
		} // end switch
		
		// 위에서 결정된 페이지 (viewPage) 로 forward 해줌
		if(viewPage != null) {
			RequestDispatcher dispather = request.getRequestDispatcher(viewPage);
			dispather.forward(request, response);
		}
		
	} // end actionDo()
	

}















