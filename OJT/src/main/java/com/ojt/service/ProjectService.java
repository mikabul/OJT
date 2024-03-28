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
	
	// 프로젝트 역할 리스트
	public ArrayList<CodeBean> getRole(){
		return projectDao.getRole();
	}
	
	// 신규 프로젝트 인원 등록 조회
	public ArrayList<MemberBean> getNotAddProjectMember(String str, int[] mem_seqList){
		
		str = "%" + str + "%";
		String optionalQuery = getOptionalQuery(mem_seqList);
		
		return projectMemberDao.getNotAddProjectMember(str, optionalQuery);
		
	}
	
	// 프로젝트 등록
	public Boolean insertProject(ProjectBean addProjectBean) {
		
		addProjectBean.setPs_cd("1");
		
		DefaultTransactionDefinition def = new DefaultTransactionDefinition();
		TransactionStatus status = transactionManager.getTransaction(def);
		
		/*
		 * prj_st_dt와 prj_ed_dt는 not null 이므로 LocalDate로 바로 변환하지만
		 * maint_st_dt와 maint_ed_dt는 null 일수 있으므로 if문을 통해 검사후 변환
		 */
		LocalDate now = LocalDate.now();
		LocalDate projectStartDate = LocalDate.parse(addProjectBean.getPrj_st_dt());
		LocalDate projectEndDate = LocalDate.parse(addProjectBean.getPrj_ed_dt());
		String maint_st_dt = addProjectBean.getMaint_st_dt();
		String maint_ed_dt = addProjectBean.getMaint_ed_dt();
		
		/*	
		 * ps_cd => 상태 코드
		 * 1: 진행 예정
		 * 2: 진행 중
		 * 3: 유지보수
		 * 4: 종료
		 * 5: 중단
		 */
		if(projectStartDate.isAfter(now)) { // 현재 날짜가 프로젝트 시작일 보다 이전일 경우
			addProjectBean.setPs_cd("1");
		}
		// 혼재 날짜가 프로젝트 시작일, 종료일 사이에 위치하거나 시작일 또는 종료일과 같을 경우
		else if ((projectStartDate.isBefore(now) && projectEndDate.isAfter(now)) || now.equals(projectStartDate)  || now.equals(projectEndDate) ){
			addProjectBean.setPs_cd("2");
		}
		// 유지보수 시작일과 종료일 모두 비어있지 않을 경우
		else if(maint_st_dt != null && !maint_st_dt.isEmpty() && maint_ed_dt != null && !maint_ed_dt.isEmpty()) {
			LocalDate maintStartDate = LocalDate.parse(maint_st_dt);
			LocalDate maintEndDate = LocalDate.parse(maint_ed_dt);
			
			// 현재 날짜가 유지보수 시작일과 종료일 사이에 위치하거나 종료일과 같을 경우
			if((maintStartDate.isBefore(now) && maintEndDate.isAfter(now)) || maintEndDate.equals(now)) {
				addProjectBean.setPs_cd("3");
			} else {
				addProjectBean.setPs_cd("4");
			}
			
		}
		// 유지보수 시작일이 비어있지 않을 경우
		else if(maint_st_dt != null && !maint_st_dt.isEmpty()){
			// 종료일이 없으므로 유지보수 기간인 것으로 판단(ex 2023-01-01 ~ )
			addProjectBean.setPs_cd("3");
		}
		else {
			addProjectBean.setPs_cd("4");
		}
		
		try {
			// 프로젝트 등록
			projectDao.insertProject(addProjectBean);
			int prj_seq = projectDao.getPrj_seq();
			
			// 프로젝트 멤버 등록
			if(addProjectBean.getPmList() != null) {
				for(ProjectMemberBean member : addProjectBean.getPmList()) {
					member.setPrj_seq(prj_seq);
					projectMemberDao.insertProjectMember(member);
				}
			}
			
			// 프로젝트 필요기술 등록
			if(addProjectBean.getSk_cd_list() != null) {
				for(String sk_cd : addProjectBean.getSk_cd_list()) {
					System.out.println("sk_cd : " + sk_cd);
					projectDao.insertProjectSK(prj_seq, sk_cd);
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
	public int getPrj_seq() {
		return projectDao.getPrj_seq();
	}
	
	// 프로젝트 정보
	public ProjectBean getProjectInfo(int prj_seq) {
		ProjectBean projectBean = projectDao.getProjectInfo(prj_seq);
		ArrayList<ProjectMemberBean> pmList = projectMemberDao.getProjectMemberList(prj_seq);
		ArrayList<CodeBean> prj_sk_list = projectDao.getProjectSKList(prj_seq);
		
		if(pmList != null) {
			projectBean.setPmList(pmList);
		}
		if(prj_sk_list != null) {
			projectBean.setPrj_sk_list(prj_sk_list);
		}
		
		return projectBean;
		
	}
	
	// 프로젝트 상태 리스트
	public ArrayList<CodeBean> getPsList(){
		return projectDao.getPsList();
	}
	
	// 프로젝트 삭제(여러개)
	public Boolean deleteProjects(Integer[] projectSeqList) {
		DefaultTransactionDefinition def = new DefaultTransactionDefinition();
		TransactionStatus status = transactionManager.getTransaction(def);
		try {
			for(Integer seq : projectSeqList) {
				if(seq != null) {
					projectDao.deleteProject(seq);
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
	public Boolean updateProjectState(int[] projectNumber, String[] projectState) {
		
		DefaultTransactionDefinition def = new DefaultTransactionDefinition();
		TransactionStatus status = transactionManager.getTransaction(def);
		Boolean result = true;
		try {
			ProjectBean testProjectBean;
			ArrayList<String> testPsList = projectDao.getStringListProjectState();
			ProjectBean updateProjectBean;
			for(int i = 0; i < projectNumber.length; i++) {
				testProjectBean = projectDao.getProjectInfo(projectNumber[i]);
				
				// 업데이트 전 확인 없다면 result = false를 저장하고 반복문 중단
				if(testProjectBean == null && !testPsList.contains(projectState[i])) {
					result = false;
					break;
				}
				
				updateProjectBean = new ProjectBean();
				updateProjectBean.setPrj_seq(projectNumber[i]);
				updateProjectBean.setPs_cd(projectState[i]);
				
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
		String optionalQuery = "";
		
		if(mem_seqList != null && mem_seqList.length > 0) {
			optionalQuery += "and mem.mem_seq not in (" + mem_seqList[0];
			for(int i = 1; i < mem_seqList.length; i++) {
				optionalQuery += "," + mem_seqList[i];
			}
			optionalQuery += ") ";
		}
		return optionalQuery;
	}
	
	//================ 밸리데이션 =================
	// 해당 고객사가 존재하는지
	public Boolean hasCustomer(int cust_seq) {
		
		Integer tempCust_seq = projectDao.hasCustomer(cust_seq);
		
		if(tempCust_seq != null) { // 고객사가 존재한다면 false반환
			return false;
		} else {
			return true;
		}
	}
	
	// 기술이 모두 존재하는지
	public Boolean hasSkill(String[] prj_sk_list, int skLength) {
		
		String query = prj_sk_list[0];
		
		for(int i = 1; i < prj_sk_list.length; i++) {
			query += "," + prj_sk_list[i];
			System.out.println( prj_sk_list[i]);
		}
		
		Integer countSkill = projectDao.hasSkill(query);
		System.out.println("query : " + query);
		System.out.println(countSkill);
		if(countSkill == skLength) { //두개의 값이 같다면 false 반환
			return false;
		} else {
			return true;
		}
	}

}
