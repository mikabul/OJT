package com.ojt.bean;

import java.util.ArrayList;

public class ProjectBean {

	private int prj_seq;
	private String prj_nm;
	private int cust_seq;
	private String prj_st_dt;
	private String prj_ed_dt;
	private String prj_dtl;
	private String ed_cd;
	
	private String cust_nm; //고객사 이름
	private ArrayList<String> prj_sk_list; // 필요기술 리스트
	private String dtl_cd_nm; // 프로젝트 상태
	
	public int getPrj_seq() {
		return prj_seq;
	}
	public void setPrj_seq(int prj_seq) {
		this.prj_seq = prj_seq;
	}
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
	public String getPrj_st_dt() {
		return prj_st_dt;
	}
	public void setPrj_st_dt(String prj_st_dt) {
		this.prj_st_dt = prj_st_dt;
	}
	public String getPrj_ed_dt() {
		return prj_ed_dt;
	}
	public void setPrj_ed_dt(String prj_ed_dt) {
		this.prj_ed_dt = prj_ed_dt;
	}
	public String getPrj_dtl() {
		return prj_dtl;
	}
	public void setPrj_dtl(String prj_dtl) {
		this.prj_dtl = prj_dtl;
	}
	public String getEd_cd() {
		return ed_cd;
	}
	public void setEd_cd(String ed_cd) {
		this.ed_cd = ed_cd;
	}
	public String getCust_nm() {
		return cust_nm;
	}
	public void setCust_nm(String cust_nm) {
		this.cust_nm = cust_nm;
	}
	public ArrayList<String> getPrj_sk_list() {
		return prj_sk_list;
	}
	public void setPrj_sk_list(ArrayList<String> prj_sk_list) {
		this.prj_sk_list = prj_sk_list;
	}
	public String getDtl_cd_nm() {
		return dtl_cd_nm;
	}
	public void setDtl_cd_nm(String dtl_cd_nm) {
		this.dtl_cd_nm = dtl_cd_nm;
	}
	
}
