package com.ojt.bean;

public class ProjectSearchBean {

	private String prj_nm;
	private int cust_seq;
	private String dateType;
	private String firstDate;
	private String secondDate;
	private int[] st_cd;
	
	public String getPrj_nm() {
		return prj_nm;
	}
	public void setPrj_nm(String prj_nm) {
		this.prj_nm = prj_nm;
	}
	public int getCust_seq() {
		return cust_seq;
	}
	public void setCust_seq(int cust_seq) {
		this.cust_seq = cust_seq;
	}
	public String getDateType() {
		return dateType;
	}
	public void setDateType(String dateType) {
		this.dateType = dateType;
	}
	public String getFirstDate() {
		return firstDate;
	}
	public void setFirstDate(String firstDate) {
		this.firstDate = firstDate;
	}
	public String getSecondDate() {
		return secondDate;
	}
	public void setSecondDate(String secondDate) {
		this.secondDate = secondDate;
	}
	public int[] getSt_cd() {
		return st_cd;
	}
	public void setSt_cd(int[] st_cd) {
		this.st_cd = st_cd;
	}
	
}
