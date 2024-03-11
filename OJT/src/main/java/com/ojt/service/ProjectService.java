package com.ojt.service;

import java.util.ArrayList;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ojt.bean.CodeBean;
import com.ojt.bean.ProjectBean;
import com.ojt.bean.ProjectSearchBean;
import com.ojt.dao.ProjectDao;
import com.ojt.util.Pagination;

@Service
public class ProjectService {
	
	@Autowired
	private ProjectDao projectDao;
	
	@Autowired
	private Pagination pagination;
	
	// 프로젝트 검색
	public Map<String, Object> searchProjectList(ProjectSearchBean projectSearchBean, int page, int view){

		// projectSearchBean 데이터 꺼냄
		String prj_nm = "%" + projectSearchBean.getPrj_nm() + "%";
		int cust_seq = projectSearchBean.getCust_seq();
		String dateType = projectSearchBean.getDateType();
		String firstDate = projectSearchBean.getFirstDate();
		String secondDate = projectSearchBean.getSecondDate();
		int ps_cd[] = projectSearchBean.getPs_cd();
		
		// 페이징에 필요한 index 계산
		int index = (page * view) + 1;
		int endIndex = (index + view) - 1;
		
		// 필터링을 위한 퀴리 작성
		String optionalQuery = getOptionalQuery(cust_seq, dateType, firstDate, secondDate, ps_cd);
		
		// 프로젝트 검색 결과와 최대 검색 결과 개수
		ArrayList<ProjectBean> projectList = projectDao.searchProjectList(prj_nm, optionalQuery, index, endIndex);
		int maxCount = projectDao.searchProjectListMaxCount(prj_nm, optionalQuery);
		
		// 페이지 버튼과 최대 페이지를 받아옴
		Map<String, Object> map = pagination.getPageBtns(page, maxCount, view);
		
		// 프로젝트 검색 결과를 맵에 추가
		map.put("projectList", projectList);
		
		return map;
	}
	
	// 프로젝트 역할 리스트
	public ArrayList<CodeBean> getRole(){
		return projectDao.getRole();
	}
	
	// optionalQuery
	private String getOptionalQuery(int cust_seq, String dateType, String firstDate, String secondDate,
									int[] ps_cd) {
		
		String optionalQuery = "";
		
		if(cust_seq != 0) {
			optionalQuery += " and prj.cust_seq = " + cust_seq + " ";
		}
		
		if(firstDate != null && secondDate != null && // 두개 모두 null이 아니라면
			!firstDate.isEmpty()&& !secondDate.isEmpty()) { // 두개 모두 비어있지 않다면
			optionalQuery += " and to_date(prj." + dateType + ") between to_date('" + firstDate + "') and to_date('" + secondDate + "') ";
		} else if(firstDate != null && !firstDate.isEmpty()) { // 첫번째 날짜가 null이 아니고 비어있지 않다면
			optionalQuery += " and to_date(prj." + dateType + ") > to_date('" + firstDate + "') ";
		} else if(secondDate != null && !secondDate.isEmpty()) { // 두번째 날짜가 null이 아니고 비어있지 않다면
			optionalQuery += " and to_date(prj." + dateType + ") < to_date('" + secondDate + "') ";
		}
		
		if(ps_cd != null && ps_cd.length >= 1) {
			optionalQuery += " and (prj.ps_cd = " + ps_cd[0];
			
			for(int i = 1; i < ps_cd.length; i++) {
				optionalQuery += " or prj.ps_cd = " + ps_cd[i];
			}
			
			optionalQuery += ") ";
		}
		
		return optionalQuery;
	}

}
