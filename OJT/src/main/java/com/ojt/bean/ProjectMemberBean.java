package com.ojt.bean;

import java.util.ArrayList;

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
	
	public int getMem_seq() {
		return mem_seq;
	}
	public void setMem_seq(int mem_seq) {
		this.mem_seq = mem_seq;
	}
	public String getMem_nm() {
		return mem_nm;
	}
	public void setMem_nm(String mem_nm) {
		this.mem_nm = mem_nm;
	}
	public String getMem_hire_date() {
		return mem_hire_date;
	}
	public void setMem_hire_date(String mem_hire_date) {
		this.mem_hire_date = mem_hire_date;
	}
	public String getSt_dt() {
		return st_dt;
	}
	public void setSt_dt(String st_dt) {
		this.st_dt = st_dt;
	}
	public String getEd_dt() {
		return ed_dt;
	}
	public void setEd_dt(String ed_dt) {
		this.ed_dt = ed_dt;
	}
	public String getPrj_dept() {
		return prj_dept;
	}
	public void setPrj_dept(String prj_dept) {
		this.prj_dept = prj_dept;
	}
	public String getPrj_position() {
		return prj_position;
	}
	public void setPrj_position(String prj_position) {
		this.prj_position = prj_position;
	}
	public String getPrj_role() {
		return prj_role;
	}
	public void setPrj_role(String prj_role) {
		this.prj_role = prj_role;
	}
	public ArrayList<String> getDtl_cd_nm() {
		return dtl_cd_nm;
	}
	public void setDtl_cd_nm(ArrayList<String> dtl_cd_nm) {
		this.dtl_cd_nm = dtl_cd_nm;
	}
	
}
