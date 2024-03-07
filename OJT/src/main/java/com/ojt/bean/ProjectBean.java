package com.ojt.bean;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ProjectBean {

	private int prj_seq;
	private String prj_nm;
	private int cust_seq;
	private String prj_st_dt;
	private String prj_ed_dt;
	private String prj_dtl;
	private String ps_cd;
	
	private String cust_nm; //고객사 이름
	private String[] prj_sk_list; // 필요기술 리스트
	private String ps_nm; // 프로젝트 상태
	
}
