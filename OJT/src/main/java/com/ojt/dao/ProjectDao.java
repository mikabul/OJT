package com.ojt.dao;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.ojt.bean.CustomerBean;
import com.ojt.bean.ProjectBean;
import com.ojt.bean.ProjectMemberBean;
import com.ojt.mapper.ProjectMapper;

@Repository
public class ProjectDao {

	@Autowired
	private ProjectMapper projectMapper;
	
	public ArrayList<ProjectBean> getProjectInfoList(String prj_nm, String optionalQuery, int startIndex, int endIndex){
		return projectMapper.getProjectInfoList(prj_nm, optionalQuery, startIndex, endIndex);
	}
	
	public ArrayList<String> getProjectSKList(int prj_seq){
		return projectMapper.getProjectSKList(prj_seq);
	}
	
	public ArrayList<CustomerBean> getCustomerList(String cust_nm){
		return projectMapper.getCustomerList(cust_nm);
	}
	
	public int getMaxSearchCount(String prj_nm, String optionalQuery) {
		return projectMapper.getMaxSearchCount(prj_nm, optionalQuery);
	}
	
	public ArrayList<ProjectMemberBean> getProjectMember(int prj_seq, String searchWord, String prj_role, String firstDate, String secondDate, String dateType, int index, int endIndex){
		return projectMapper.getProjectMember(prj_seq, searchWord, prj_role, firstDate, secondDate, dateType, index, endIndex);
	}
	
	public ArrayList<String> getProjectMemberSKList(int mem_seq){
		return projectMapper.getProjectMemberSKList(mem_seq);
	}
	
	public int getProjectMemberMaxCount(int prj_seq, String searchWord, String prj_role, String firstDate, String secondDate, String dateType){
		return projectMapper.getProjectMemberMaxCount(prj_seq, searchWord, prj_role, firstDate, secondDate, dateType);
	}
}
