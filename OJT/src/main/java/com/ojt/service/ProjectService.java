package com.ojt.service;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Service;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.DefaultTransactionDefinition;

import com.ojt.bean.CodeBean;
import com.ojt.bean.CustomerBean;
import com.ojt.bean.MemberBean;
import com.ojt.bean.ProjectBean;
import com.ojt.bean.ProjectMemberBean;
import com.ojt.bean.ProjectSearchBean;
import com.ojt.dao.ProjectDao;
import com.ojt.dao.ProjectMemberDao;
import com.ojt.util.Pagination;

@Service
public class ProjectService {
	
	@Autowired
	private ProjectDao projectDao;
	
	@Autowired
	private ProjectMemberDao projectMemberDao;
	
	@Autowired
	private Pagination pagination;
	
	@Autowired
	private DataSourceTransactionManager transactionManager;
	
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
		
		// 프로젝트 상태 리스트
		ArrayList<CodeBean> psList = projectDao.getPsList();
		
		// 페이지 버튼과 최대 페이지를 받아옴
		Map<String, Object> map = pagination.getPageBtns(page, maxCount, view);
		
		// 프로젝트 검색 결과를 맵에 추가
		map.put("projectList", projectList);
		map.put("psList", psList);
		
		return map;
	}
	
	// 고객사 리스트 검색
	public ArrayList<CustomerBean> getCustomerList(String customer){
		customer = "%" + customer + "%";
		return projectDao.getCustomerList(customer);
	}
	
	// 프로젝트 번호, 시작일, 종료일, 유지보수 종료일이 모두 일치하는지
	public int matchProjectInfo(ProjectBean projectBean) {
		return projectDao.matchProjectInfo(projectBean);
	}
	
	// 프로젝트 역할 리스트
	public ArrayList<CodeBean> getRole(){
		return projectDao.getRole();
	}
	
	// 프로젝트 역할 코드 배열
	public ArrayList<String> getRoleCodeList() {
		return projectDao.getRoleCodeList();
	}
	
	// 프로젝트 등록
	public Boolean insertProject(ProjectBean addProjectBean) {
		
		DefaultTransactionDefinition def = new DefaultTransactionDefinition();
		TransactionStatus status = transactionManager.getTransaction(def);
		
		/*
		 * prj_st_dt와 prj_ed_dt는 not null 이므로 LocalDate로 바로 변환하지만
		 * maint_st_dt와 maint_ed_dt는 null 일수 있으므로 if문을 통해 검사후 변환
		 */
		LocalDate now = LocalDate.now();
		LocalDate projectStartDate = LocalDate.parse(addProjectBean.getProjectStartDate());
		LocalDate projectEndDate = LocalDate.parse(addProjectBean.getProjectEndDate());
		String maintStartDate = addProjectBean.getMaintStartDate();
		String maintEndDate = addProjectBean.getMaintEndDate();
		
		/*	
		 * ps_cd => 상태 코드
		 * 1: 진행 예정
		 * 2: 진행 중
		 * 3: 유지보수
		 * 4: 종료
		 * 5: 중단
		 */
		if(projectStartDate.isAfter(now)) { // 현재 날짜가 프로젝트 시작일 보다 이전일 경우
			addProjectBean.setProjectStateCode("1");
		}
		// 혼재 날짜가 프로젝트 시작일, 종료일 사이에 위치하거나 시작일 또는 종료일과 같을 경우
		else if ((projectStartDate.isBefore(now) && projectEndDate.isAfter(now)) || now.equals(projectStartDate)  || now.equals(projectEndDate) ){
			addProjectBean.setProjectStateCode("2");
		}
		// 유지보수 시작일과 종료일 모두 비어있지 않을 경우
		else if(maintStartDate != null && !maintStartDate.isEmpty() && maintEndDate != null && !maintEndDate.isEmpty()) {
			LocalDate localMaintStartDate = LocalDate.parse(maintStartDate);
			LocalDate localMaintEndDate = LocalDate.parse(maintEndDate);
			
			// 현재 날짜가 유지보수 시작일과 종료일 사이에 위치하거나 종료일과 같을 경우
			if((localMaintStartDate.isBefore(now) && localMaintEndDate.isAfter(now)) || maintEndDate.equals(now)) {
				addProjectBean.setProjectStateCode("3");
			} else {
				addProjectBean.setProjectStateCode("4");
			}
			
		}
		// 유지보수 시작일이 비어있지 않을 경우
		else if(maintStartDate != null && !maintStartDate.isEmpty()){
			// 종료일이 없으므로 유지보수 기간인 것으로 판단(ex 2023-01-01 ~ )
			addProjectBean.setProjectStateCode("3");
		}
		else {
			addProjectBean.setProjectStateCode("4");
		}
		
		try {
			// 프로젝트 등록
			projectDao.insertProject(addProjectBean);
			int projectNumber = projectDao.getProjectNumber();
			
			// 프로젝트 멤버 등록
			if(addProjectBean.getPmList() != null) {
				for(ProjectMemberBean member : addProjectBean.getPmList()) {
					member.setProjectNumber(projectNumber);
					projectMemberDao.insertProjectMember(member);
				}
			}
			
			// 프로젝트 필요기술 등록
			if(addProjectBean.getSkillCodeList() != null) {
				for(String skillCode : addProjectBean.getSkillCodeList()) {
					projectDao.insertProjectSK(projectNumber, skillCode);
				}
			}
			transactionManager.commit(status);
			return true;
		} catch (Exception e) {
			e.printStackTrace();
			transactionManager.rollback(status);
			return false;
		}
		
	}
	
	// 프로젝트 번호
	public int getProjectNumber() {
		return projectDao.getProjectNumber();
	}
	
	// 프로젝트 정보
	public ProjectBean getProjectInfo(int projectNumber) {
		ProjectBean projectBean = projectDao.getProjectInfo(projectNumber);
		ArrayList<ProjectMemberBean> pmList = projectMemberDao.getProjectMemberList(projectNumber);
		ArrayList<CodeBean> projectSkillList = projectDao.getProjectSKList(projectNumber);
		
		if(pmList != null) {
			projectBean.setPmList(pmList);
		}
		if(projectSkillList != null) {
			projectBean.setProjectSkillList(projectSkillList);
		}
		
		return projectBean;
		
	}
	
	// 프로젝트 상태 리스트
	public ArrayList<CodeBean> getPsList(){
		return projectDao.getPsList();
	}
	
	// 프로젝트 삭제(여러개)
	public Boolean deleteProjects(Integer[] projectNumbers) {
		DefaultTransactionDefinition def = new DefaultTransactionDefinition();
		TransactionStatus status = transactionManager.getTransaction(def);
		try {
			for(Integer projectNumber : projectNumbers) {
				if(projectNumber != null) {
					projectDao.deleteProject(projectNumber);
				}
			}
			transactionManager.commit(status);
			return true;
		} catch (Exception e) {
			transactionManager.rollback(status);
			return false;
		}
	}
	
	// 프로젝트 상태 업데이트
	public Boolean updateProjectState(int[] projectNumbers, String[] projectState) {
		
		DefaultTransactionDefinition def = new DefaultTransactionDefinition();
		TransactionStatus status = transactionManager.getTransaction(def);
		Boolean result = true;
		try {
			ProjectBean testProjectBean;
			ArrayList<String> testPsList = projectDao.getStringListProjectState();
			ProjectBean updateProjectBean;
			for(int i = 0; i < projectNumbers.length; i++) {
				testProjectBean = projectDao.getProjectInfo(projectNumbers[i]);
				
				// 업데이트 전 확인 없다면 result = false를 저장하고 반복문 중단
				if(testProjectBean == null && !testPsList.contains(projectState[i])) {
					result = false;
					break;
				}
				
				updateProjectBean = new ProjectBean();
				updateProjectBean.setProjectNumber(projectNumbers[i]);
				updateProjectBean.setProjectStateCode(projectState[i]);
				
				projectDao.updateProjectState(updateProjectBean);
			}
			
			
			if(result) {
				transactionManager.commit(status);
				return true;
			} else {
				transactionManager.rollback(status);
				return false;
			}
		} catch (Exception e) {
			e.printStackTrace();
			transactionManager.rollback(status);
			return false;
		}
	}
	
	// 전체 기술 리스트
	public ArrayList<CodeBean> getSKList(){
		return projectDao.getSKList();
	}
	
	// optionalQuery(프로젝트 검색)
	private String getOptionalQuery(int customerNumber, int dateType, String firstDate, String secondDate,
									int[] state) {
		
		String optionalQuery = "";
		
		// 고객사 검색 쿼리
		if(customerNumber != 0) {
			optionalQuery += " and prj.cust_seq = " + customerNumber + " ";
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
	
	//================ 밸리데이션 =================
	// 해당 고객사가 존재하는지
	public Boolean hasCustomer(int customerNumber) {
		
		Integer tempCustomerNumber = projectDao.hasCustomer(customerNumber);
		
		if(tempCustomerNumber != null) { // 고객사가 존재한다면 false반환
			return false;
		} else {
			return true;
		}
	}
	
	// 기술이 모두 존재하는지
	public Boolean hasSkill(String[] skillCodeList, int skLength) {
		
		String query = skillCodeList[0];
		
		for(int i = 1; i < skillCodeList.length; i++) {
			query += "," + skillCodeList[i];
		}
		
		Integer countSkill = projectDao.hasSkill(query);
		if(countSkill == skLength) { //두개의 값이 같다면 false 반환
			return false;
		} else {
			return true;
		}
	}

}
