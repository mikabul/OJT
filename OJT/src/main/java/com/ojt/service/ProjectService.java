package com.ojt.service;

import java.util.ArrayList;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ojt.bean.CodeBean;
import com.ojt.bean.CustomerBean;
import com.ojt.bean.MemberBean;
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
	public Map<String, Object> searchProjectList(ProjectSearchBean projectSearchBean, int page){

		// projectSearchBean 데이터 꺼냄
		String name = "%" + projectSearchBean.getName() + "%";
		int customer = projectSearchBean.getCustomer();
		int dateType = projectSearchBean.getDateType();
		String firstDate = projectSearchBean.getFirstDate();
		String secondDate = projectSearchBean.getSecondDate();
		int state[] = projectSearchBean.getState();
		int view = projectSearchBean.getView();
		
		// 페이징에 필요한 index 계산
		int index = (page * view) + 1;
		int endIndex = (index + view) - 1;
		
		// 필터링을 위한 퀴리 작성
		String optionalQuery = getOptionalQuery(customer, dateType, firstDate, secondDate, state);
		
		// 프로젝트 검색 결과와 최대 검색 결과 개수
		ArrayList<ProjectBean> projectList = projectDao.searchProjectList(name, optionalQuery, index, endIndex);
		int maxCount = projectDao.searchProjectListMaxCount(name, optionalQuery);
		
		// 페이지 버튼과 최대 페이지를 받아옴
		Map<String, Object> map = pagination.getPageBtns(page, maxCount, view);
		
		// 프로젝트 검색 결과를 맵에 추가
		map.put("projectList", projectList);
		
		return map;
	}
	
	// 고객사 리스트 검색
	public ArrayList<CustomerBean> getCustomerList(String customer){
		customer = "%" + customer + "%";
		return projectDao.getCustomerList(customer);
	}
	
	// 프로젝트 역할 리스트
	public ArrayList<CodeBean> getRole(){
		return projectDao.getRole();
	}
	
	// 신규 프로젝트 인원 등록 조회
	public ArrayList<MemberBean> getNotAddProjectMember(String str, int[] mem_seqList){
		
		str = "%" + str + "%";
		String optinalQuery = getOptionalQuery(mem_seqList);
		
		return projectDao.getNotAddProjectMember(str, optinalQuery);
		
	}
	
	// optionalQuery(프로젝트 검색)
	private String getOptionalQuery(int cust_seq, int dateType, String firstDate, String secondDate,
									int[] state) {
		
		String optionalQuery = "";
		
		// 고객사 검색 쿼리
		if(cust_seq != 0) {
			optionalQuery += " and prj.cust_seq = " + cust_seq + " ";
		}
		
		// 기간 검색 쿼리
		String dateString;
		switch(dateType) {
		case(1):
			dateString = "prj_st_dt";
			break;
		case(2):
			dateString = "prj_ed_dt";
			break;
		default:
			dateString = "prj_st_dt";
		}
		
		if(firstDate != null && secondDate != null && // 두개 모두 null이 아니라면
			!firstDate.isEmpty()&& !secondDate.isEmpty()) { // 두개 모두 비어있지 않다면
			optionalQuery += " and to_date(prj." + dateString + ") between to_date('" + firstDate + "') and to_date('" + secondDate + "') ";
		} else if(firstDate != null && !firstDate.isEmpty()) { // 첫번째 날짜가 null이 아니고 비어있지 않다면
			optionalQuery += " and to_date(prj." + dateString + ") > to_date('" + firstDate + "') ";
		} else if(secondDate != null && !secondDate.isEmpty()) { // 두번째 날짜가 null이 아니고 비어있지 않다면
			optionalQuery += " and to_date(prj." + dateString + ") < to_date('" + secondDate + "') ";
		}
		
		// 프로젝트 상태 검색 쿼리
		if(state != null && state.length >= 1) {
			optionalQuery += " and (prj.ps_cd = " + state[0];
			
			for(int i = 1; i < state.length; i++) {
				optionalQuery += " or prj.ps_cd = " + state[i];
			}
			
			optionalQuery += ") ";
		}
		
		return optionalQuery;
	}
	
	// optionalQuery(신규 프로젝트 인원 검색)
	private String getOptionalQuery(int[] mem_seqList) {
		String optionalQuery = " ";
		
		if(mem_seqList != null && mem_seqList.length > 0) {
			optionalQuery += "and mem.mem_seq not in (" + mem_seqList[0];
			for(int i = 1; i < mem_seqList.length; i++) {
				optionalQuery += "," + mem_seqList[i];
			}
			optionalQuery += ") ";
		}
		return optionalQuery;
	}

}
