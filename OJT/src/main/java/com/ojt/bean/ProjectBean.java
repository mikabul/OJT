package com.ojt.bean;

import java.util.ArrayList;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ProjectBean {

	private int prj_seq;							// 프로젝트 번호
	private String prj_nm;							// 프로젝트 이름
	private int cust_seq;							// 고객사 번호
	private String prj_st_dt;						// 프로젝트 시작일
	private String prj_ed_dt;						// 프로젝트 종료일
	private String prj_dtl;							// 프로젝트 상세 정보
	private String ps_cd;							// 프로젝트 상태 코드
	private String maint_st_dt;						// 유지보수 시작일
	private String maint_ed_dt;						// 유지보수 종료일
	
	private String cust_nm; 						// 고객사 이름
	private String[] sk_cd_list;					// 필요기술 배열
	private ArrayList<CodeBean> prj_sk_list;		// 필요기술 리스트
	private String ps_nm; 							// 프로젝트 상태
	
	private ArrayList<ProjectMemberBean> pmList; 	// 프로젝트 멤버 리스트
	// pmList 유효성 검사결과를 받기위한 변수
	private String mem_seq_error;
	private String st_dt_error;
	private String ed_dt_error;
	private String ro_cd_error;
	
}
