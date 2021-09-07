package com.lec.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Arrays;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/FormOk")
public class ServletForm extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public ServletForm() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		// POST방식 parameter 처리시, 가장먼저 꼭!!
		request.setCharacterEncoding("utf-8");
		
		String data1 = request.getParameter("data1");
		String data2 = request.getParameter("data2");
		
		String name = request.getParameter("name");
		//name.trim();
		String id = request.getParameter("id");
		String pw = request.getParameter("pw");
		
		String [] hobbys = request.getParameterValues("hobby");
		String gender = request.getParameter("gender");
		String local = request.getParameter("local");
		String memo = request.getParameter("memo");	
		
		
		response.setContentType("text/html; charset=utf-8");
		PrintWriter out = response.getWriter();
		
		out.println("hideen: " + data1 + ", " + data2 +"<br>");
		out.println("이름 : " + name + "<br>");
		out.println("아이디 :" + id + "<br>");
		out.println("비밀번호 :" + pw + "<br>");
		
		out.println("취미: " + Arrays.toString(hobbys) + "<br>");
		out.println("성별 :" + gender + "<br>");
		out.println("지역 :" + local + "<br>");
		out.println("메모 :" + memo + "<br>");
		out.close();
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}







