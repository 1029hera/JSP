package com.lec.beans;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.dataformat.xml.annotation.JacksonXmlElementWrapper;
import com.fasterxml.jackson.dataformat.xml.annotation.JacksonXmlProperty;
import com.fasterxml.jackson.dataformat.xml.annotation.JacksonXmlRootElement;

@JacksonXmlRootElement(localName = "WriteList")  // <WriteList> ~ </WriteList>  (없으면 class 이름의 태그 만들어짐)
public class AjaxWriteListXML {
	
	@JacksonXmlProperty  // <count> ~ </count>
	int count;    // 
	
	@JacksonXmlProperty  // <status> ~ </status> (없으면 getter 이름으로 동작)
	String status;
	
	@JsonIgnore  // 제외할 데이터
	String memo;
	
	@JacksonXmlElementWrapper(useWrapping = false)
	@JacksonXmlProperty(localName = "Data")
	List<WriteDTO> list;	
	
	public List<WriteDTO> getList() {
		return list;
	}

	public void setList(List<WriteDTO> list) {
		this.list = list;
	}

	public int getCount() {
		return count;
	}

	public String getMemo() {
		return memo;
	}

	public void setMemo(String memo) {
		this.memo = memo;
	}

	public void setCount(int count) {
		this.count = count;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}


}
