package com.ojt.bean;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ProjectMemberBean {
	
	private int mem_seq; 		// 사원 번호
	private String mem_nm; 		// 사원 이름
	private String st_dt; 		// 투입일
	private String ed_dt; 		// 철수일
	private String ro_cd; 		// 역할 코드
	
	private String dept; 		// 부서
	private String position; 	// 직급
	private String role;		// 역할
	
}
