package com.ojt.service;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ojt.bean.CustomerBean;
import com.ojt.bean.ProjectBean;
import com.ojt.bean.ProjectMemberBean;
import com.ojt.dao.ProjectDao;

@Service
public class ProjectService {
	
	@Autowired
	private ProjectDao projectDao;

	// 프로젝트 검색
	public ArrayList<ProjectBean> getProjectInfoList(String prj_nm, int cust_seq, String prj_dt_type, String firstDate, String secondDate, int startIndex, int endIndex){
		// 검색을 위한 전처리
		prj_nm = "%" + prj_nm + "%";
		
		String optionalQuery = getOptionalQuery(cust_seq, prj_dt_type, firstDate, secondDate);
		
		System.out.println("optionalQuery: " + optionalQuery);
		
		ArrayList<ProjectBean> projectList = projectDao.getProjectInfoList(prj_nm, optionalQuery, startIndex, endIndex);
		
		// 가져온 프로젝트리스트의 각 번호를 이용하여 필요기술 목록 가져오기
		if(projectList != null) {
			for (int i = 0; i < projectList.size(); i++) {
				int prj_seq = projectList.get(i).getPrj_seq();
				projectList.get(i).setPrj_sk_list(projectDao.getProjectSKList(prj_seq));
			}
		}
		
		return projectList;
	}
	// 프로젝트 필요 기술 리스트
	public ArrayList<String> getProjectSKList(int prj_seq){
		return projectDao.getProjectSKList(prj_seq);
	}
	// 고객사 리스트
	public ArrayList<CustomerBean> getCustomerList(String cust_nm){
		return projectDao.getCustomerList(cust_nm);
	}
	// 검색결과 최대 갯수
	public int getMaxSearchCount(String prj_nm, int cust_seq, String prj_dt_type, String firstDate, String secondDate) {
		
		prj_nm = "%" + prj_nm + "%";
		
		String optionalQuery = getOptionalQuery(cust_seq, prj_dt_type, firstDate, secondDate);
		
		return projectDao.getMaxSearchCount(prj_nm, optionalQuery);
		
	}
	
	public ArrayList<ProjectMemberBean> getProjectMember(int prj_seq, String searchWord, String prj_role, String firstDate, String secondDate, String dateType, int index, int endIndex){
		searchWord = "%" + searchWord + "%";
		prj_role = "%" + prj_role + "%";
		
		ArrayList<ProjectMemberBean> projectMemberList = projectDao.getProjectMember(prj_seq, searchWord, prj_role, firstDate, secondDate, dateType, index, endIndex);
		for(ProjectMemberBean member : projectMemberList) {
			ArrayList<String> skList = projectDao.getProjectMemberSKList(member.getMem_seq());
			member.setDtl_cd_nm(skList);
		}
		
		return projectMemberList;
	}
	
	public int getProjectMemberMaxCount(int prj_seq, String searchWord, String prj_role, String firstDate, String secondDate, String dateType) {
		searchWord = "%" + searchWord + "%";
		prj_role = "%" + prj_role + "%";
		
		return projectDao.getProjectMemberMaxCount(prj_seq, searchWord, prj_role, firstDate, secondDate, dateType);
	}
	
	// ========== 옵션 쿼리 ============
	private String getOptionalQuery(int cust_seq, String dateType, String firstDate, String secondDate) {
		
		String optionalQuery = "";
		
		if(cust_seq != 0) {
			optionalQuery += " and cust.cust_seq=" + cust_seq + " ";
		}
		
		if(!dateType.isEmpty() && (!firstDate.isEmpty() || !secondDate.isEmpty())) {

			if(dateType.equals("prj_st_dt")) {
				optionalQuery += " and prj.prj_st_dt ";
			} else if (dateType.equals("prj_ed_dt")) {
				optionalQuery += " and prj.prj_ed_dt ";
			}
			
			if(!firstDate.isEmpty() && !secondDate.isEmpty()) {
				
				optionalQuery += " between " + firstDate + " and " + secondDate + " ";
				
			} else if(!firstDate.isEmpty()) {
				optionalQuery += " > " + firstDate + " ";
			} else if(!secondDate.isEmpty()) {
				optionalQuery += " < " + secondDate + " ";
			}
		}
		
		return optionalQuery;
	}
}
