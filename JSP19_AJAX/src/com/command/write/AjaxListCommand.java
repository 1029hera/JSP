package com.command.write;

import java.io.IOException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.dataformat.xml.XmlMapper;
import com.lec.beans.AjaxBoardListJSON;
import com.lec.beans.AjaxWriteListXML;
import com.lec.beans.WriteDTO;

public class AjaxListCommand implements Command {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) {
		// parameter
		String reqType = request.getParameter("reqType");
		if (reqType == null)
			reqType = "json"; // 없으면 json 으로 response (디폴트)

		// "xml" 혹은 "json" 으로 response
		switch (reqType) {
		case "xml":
			responseXML(request, response);
			break;
		case "json":
			responseJSON(request, response);
			break;
		default:
			responseJSON(request, response);
		} // end switch

	} // end execute()

	private void responseJSON(HttpServletRequest request, HttpServletResponse response) {
		System.out.println("JSON response");

		List<WriteDTO> dtoArr = (List<WriteDTO>) request.getAttribute("list");

		AjaxBoardListJSON list = new AjaxBoardListJSON(); // response 할 Java객체

		if (dtoArr == null) {
			list.setStatus("FAIL");
		} else {
			list.setStatus("OK");
			list.setCount(dtoArr.size());
			list.setList(dtoArr);
		}

		ObjectMapper mapper = new ObjectMapper(); // Java - Json 매핑할 Mapper 객체

		try {
			String jsonString = mapper.writeValueAsString(list);
			System.out.println(jsonString);

			response.setContentType("application/json; charset=utf-8"); // MIME설정
			response.getWriter().write(jsonString); // response 보내기
		} catch (JsonProcessingException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}

	}

	private void responseXML(HttpServletRequest request, HttpServletResponse response) {
		System.out.println("XML response");

		List<WriteDTO> dtoArr = (List<WriteDTO>) request.getAttribute("list");

		AjaxWriteListXML list = new AjaxWriteListXML(); // response 할 Java객체

		if (dtoArr == null) {
			list.setStatus("FAIL");
		} else {
			list.setStatus("OK");
			list.setCount(dtoArr.size());
			list.setList(dtoArr);
		}

		XmlMapper mapper = new XmlMapper(); // Java - XML 매핑할 Mapper 객체

		try {

			String xmlString = mapper.writeValueAsString(list);
			

			response.setContentType("application/xml; charset=utf-8"); // MIME설정
			response.getWriter().write(xmlString); // response 보내기
		} catch (JsonProcessingException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}

	}

} // end Command
