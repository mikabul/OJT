package com.ojt.bean;

import java.util.ArrayList;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ProjectMemberBean {
	
	private int mem_seq;
	private String mem_nm;
	private String mem_hire_date;
	private String st_dt;
	private String ed_dt;
	private String prj_dept;
	private String prj_position;
	private String prj_role;
	private ArrayList<String> dtl_cd_nm;
	
}
