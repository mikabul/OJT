package com.ojt.dao;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.ojt.bean.CustomerBean;
import com.ojt.bean.ProjectBean;
import com.ojt.mapper.ProjectMapper;

@Repository
public class ProjectDao {

	@Autowired
	private ProjectMapper projectMapper;
	
	public ArrayList<ProjectBean> getProjectInfoList(String prj_nm, String cust_nm, String prj_dt_type, String firstDate, String secondDate, int startIndex, int endIndex){
		return projectMapper.getProjectInfoList(prj_nm, cust_nm, prj_dt_type, firstDate, secondDate, startIndex, endIndex);
	}
	
	public ArrayList<String> getProjectSKList(int prj_seq){
		return projectMapper.getProjectSKList(prj_seq);
	}
	
	public ArrayList<CustomerBean> getCustomerList(String cust_nm){
		return projectMapper.getCustomerList(cust_nm);
	}
	
	public int getMaxSearchCount(String prj_nm, String cust_nm, String prj_dt_type, String firstDate, String secondDate) {
		return projectMapper.getMaxSearchCount(prj_nm, cust_nm, prj_dt_type, firstDate, secondDate);
	}
}
