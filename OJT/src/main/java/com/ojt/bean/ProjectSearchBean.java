package com.ojt.bean;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ProjectSearchBean {

	private String prj_nm;				// 프로젝트 명
	private int cust_seq;				// 고객사 번호
	private String dateType;			// 시작일(종료일)
	private String firstDate;			// 첫번째 날짜
	private String secondDate;			// 두번째 날짜
	private int[] ps_cd;				// 프로젝트 상태
	
}