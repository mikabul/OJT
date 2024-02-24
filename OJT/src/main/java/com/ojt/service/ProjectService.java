package com.ojt.service;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ojt.bean.CustomerBean;
import com.ojt.bean.ProjectBean;
import com.ojt.dao.ProjectDao;

@Service
public class ProjectService {
	
	@Autowired
	private ProjectDao projectDao;

	public ArrayList<ProjectBean> getProjectInfoList(String prj_nm, String cust_nm, String prj_dt_type, String firstDate, String secondDate, int startIndex, int endIndex){
		prj_nm = "%" + prj_nm + "%";
		cust_nm = "%" + cust_nm + "%";
		return projectDao.getProjectInfoList(prj_nm, cust_nm, prj_dt_type, firstDate, secondDate, startIndex, endIndex);
	}
	
	public ArrayList<String> getProjectSKList(int prj_seq){
		return projectDao.getProjectSKList(prj_seq);
	}
	
	public ArrayList<CustomerBean> getCustomerList(String cust_nm){
		return projectDao.getCustomerList(cust_nm);
	}
	
	public int getMaxSearchCount(String prj_nm, String cust_nm, String prj_dt_type, String firstDate, String secondDate) {
		
		prj_nm = "%" + prj_nm + "%";
		cust_nm = "%" + cust_nm + "%";
		
		return projectDao.getMaxSearchCount(prj_nm, cust_nm, prj_dt_type, firstDate, secondDate);
	}
}
