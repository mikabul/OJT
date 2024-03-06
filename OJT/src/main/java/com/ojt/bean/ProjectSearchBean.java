package com.ojt.bean;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ProjectSearchBean {

	private String prj_nm;
	private int cust_seq;
	private String dateType;
	private String firstDate;
	private String secondDate;
	private int[] ps_cd;
	
}
