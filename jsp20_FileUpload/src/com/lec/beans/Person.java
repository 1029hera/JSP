package com.lec.beans;

public class Person {
	// 필드 (멤버변수)
	private String name;
	private int age;
	private int id;
	private String gender;
	
	public Person() {
		System.out.println("Person() 생성");
	}
	
//	public Person(int n) {}
	
	// getter, setter
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public int getAge() {
		return age;
	}
	public void setAge(int age) {
		this.age = age;
	}
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getGender() {
		return gender;
	}
	public void setGender(String gender) {
		this.gender = gender;
	}
	
	
	
}
