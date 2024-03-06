package com.ojt.bean;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class MemberBean {

	private int mem_seq;
	private String mem_nm;
	private String mem_rnn;
	private String mem_tel;
	private String mem_phone;
	private String mem_email;
	private String dp_cd;
	private String ra_cd;
	private String mem_addr;
	private String mem_id;
	private String mem_pw;
	private String mem_pw2;
	private String mem_pic;
	private String st_cd;
	private String mem_hire_date;
	private String mem_resignation_date;
	
	private boolean loginState;
	
}
