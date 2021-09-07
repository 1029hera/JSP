<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%-- cos 라이브러리 --%>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.FileRenamePolicy"%>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>

<%-- parameter 값들,  file name 값들 추출 --%>
<%@ page import="java.util.Enumeration" %>   

<%--File 객체 추출 --%>
<%@ page import="java.io.File" %>

<%-- 이미지 파일 다루기 --%>
<%@ page import="java.awt.image.BufferedImage" %>
<%@ page import="javax.imageio.ImageIO" %>    
    
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>파일업로드 결과</title>
</head>
<body>
<form action="FileCheck.jsp" method="post" name="fileCheck">
<%
	// MultipartRequest 객체 생성 준비
	
	// 파일 저장 경로
	String saveDirectory = "";
	//saveDirectory = "C:\\tomcat\\upload";
	ServletContext context = this.getServletContext();
	// 서블릿 상의 upload 폴더 경로를 알아온다.
	saveDirectory = context.getRealPath("upload");
	
	System.out.println("업로드 경로: " + saveDirectory);

	int maxPostSize = 5 * 1024 * 1024;  // POST 받기, 최대 5M byte
	String encoding = "utf-8";
	FileRenamePolicy policy = new DefaultFileRenamePolicy(); // 업로드 파일 이름 중복에 대한 rename 정책
	
	MultipartRequest multi = null;
	
	// MultipartRequest 생성 단계에서 이미 파일은 저장됨.
	multi = new MultipartRequest(
			request, 
			saveDirectory,
			maxPostSize,
			encoding,
			policy
			);
	
	// multi part requst 에선 아래와 같이 parameter 가져올수 없다.
	//out.println(request.getParameter("name"));\
	
	Enumeration names = null;
	
	// 1. Parameter 추출
	out.println("name : " + multi.getParameter("name") + "<br>");
	out.println("title : " + multi.getParameter("title") + "<br>");
	out.println("<hr>");
	
	// 2. File 들 추출
	names = multi.getFileNames();  // type="file" 요소의 name 들 추출
	while(names.hasMoreElements()){
		
		String name = (String)names.nextElement();
		out.println("input name: " + name + "<br>");
		
		// 위 name 을 가지고 원래 파일(업로드 한 파일) 정보를 가져온다.
		String originalFileName = multi.getOriginalFileName(name);
		out.println("원본파일 이름: " + originalFileName + "<br>");
		out.println("<input type='hidden' value='" + originalFileName + "' name='originalFileName'/>");
		
		// 시스템에 업로딩 된 파일 정보를 가져온다.
		String fileSystemName = multi.getFilesystemName(name);
		out.println("파일시스템 이름: " + fileSystemName + "<br>");
		out.println("<input type='hidden' value='" + fileSystemName + "' name='fileSystemName'/>");
		
		// 업로딩된 파일의 타입 : MIME 타입
		String fileType = multi.getContentType(name);
		out.println("파일타입: " + fileType + "<br>");
		
		// 저장된 파일을 File 객체로 가져오기
		File file = multi.getFile(name);
		if(file != null){
			long fileSize = file.length();
			out.println("파일크기: " + fileSize + " bytes<br>");
			
			// 이미지 파일 다루기
			BufferedImage bi = ImageIO.read(file);
			if(bi != null){
				int width = bi.getWidth();
				int height = bi.getHeight();
				out.println("이미지 파일 WxH: " + width + " x " + height + "<br>");
			} else {
				out.println("이미지 파일이 아닙니다<br>");
			}
		}
		
		out.println("<hr>");
	} // end while
%>
<input type="submit" value="업로드 파일 확인"/><br>
</form>
</body>
</html>


















