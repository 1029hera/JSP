package com.lec.beans;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.fasterxml.jackson.datatype.jsr310.deser.LocalDateTimeDeserializer;
import com.fasterxml.jackson.datatype.jsr310.ser.LocalDateTimeSerializer;

// DTO : Data Transfer Object
public class WriteDTO {
	private int uid; // wr_uid
	private String subject; // wr_subject
	private String content; // wr_content
	private String name; // wr_name
	
	@JsonProperty("viewcnt")  // Json Property 이름과 Java 필드 이름이 다른 경우
	private int viewCnt; // wr_viewcnt
	
	// java.time.*  객체 변환을 위한 annotation
	@JsonDeserialize(using = LocalDateTimeDeserializer.class)
    @JsonSerialize(using = LocalDateTimeSerializer.class)
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone="Asia/Seoul")
	@JsonProperty("regdate")
	private LocalDateTime regDate; // wr_regdate

	// 웹개발시...
	// 가능한, 다음 3가지는 이름을 일치시켜주는게 좋습니다.
	// 클래스 필드명 = DB 필드명 = form의 name명

	// 생성자
	public WriteDTO() {
		super();
//		System.out.println("WriteDTO() 객체 생성");
	}

	public WriteDTO(int uid, String subject, String content, String name, int viewCnt, LocalDateTime regDate) {
		super();
		this.uid = uid;
		this.subject = subject;
		this.content = content;
		this.name = name;
		this.viewCnt = viewCnt;
		this.regDate = regDate;
//		System.out.printf("WriteDTO(%d, %s, %s, %s, %d) 객체 생성\n", uid, subject, content, name, viewCnt);
	}

	public int getUid() {
//		System.out.println("getUid() 호출");
		return uid;
	}

	public void setUid(int uid) {
//		System.out.println("setUid(" + uid + ") 호출");
		this.uid = uid;
	}

	public String getSubject() {
//		System.out.println("getSubject() 호출");
		return subject;
	}

	public void setSubject(String subject) {
//		System.out.println("setSubject(" + subject + ") 호출");
		this.subject = subject;
	}

	public String getContent() {
//		System.out.println("getContent() 호출");
		return content;
	}

	public void setContent(String content) {
//		System.out.println("setContent(" + content + ") 호출");
		this.content = content;
	}

	public String getName() {
//		System.out.println("getName() 호출");
		return name;
	}

	public void setName(String name) {
//		System.out.println("setName(" + name + ") 호출");
		this.name = name;
	}

	public int getViewCnt() {
//		System.out.println("getViewCnt() 호출");
		return viewCnt;
	}

	public void setViewCnt(int viewCnt) {
//		System.out.println("setViewCnt(" + viewCnt + ") 호출");
		this.viewCnt = viewCnt;
	}

	public LocalDateTime getRegDate() {
//		System.out.println("getRegDate() 호출");
		return this.regDate;
	}

	public void setRegDate(LocalDateTime regDate) {
//		System.out.println("setRegDate(" + regDate + ") 호출");
		this.regDate = regDate;
	}

	
	//  regDate 를 String 으로 리턴하는 getter
	//@JsonProperty("regdate")   // 임의의 getter에 붙일수도 있다.
	@JsonIgnore
	public String getRegDateTime() {
		if(this.regDate == null) return "";
		return this.regDate.format(DateTimeFormatter.ofPattern("yyyy-MM-dd hh:mm:ss"));
	}
	
//	public int getAge() {
//		return 120;
//	}
	
	@Override
	public String toString() {
		return String.format("WriteDTO] %d : %s : %s : %s : %d : %s", 
				uid, subject, content, name, viewCnt, regDate);
	}
	
	
} // end DTO












