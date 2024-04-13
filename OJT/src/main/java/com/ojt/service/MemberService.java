package com.ojt.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Service;
import org.springframework.transaction.TransactionManager;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.DefaultTransactionDefinition;

import com.ojt.bean.CodeBean;
import com.ojt.bean.MemberBean;
import com.ojt.bean.ProjectMemberBean;
import com.ojt.bean.SearchMemberBean;
import com.ojt.dao.CodeDao;
import com.ojt.dao.MemberDao;
import com.ojt.util.Pagination;

@Service
public class MemberService {
	
	@Autowired
	MemberDao memberDao;
	
	@Autowired
	CodeDao codeDao;
	
	@Autowired
	Pagination pagination;
	
	@Autowired
	private DataSourceTransactionManager transactionManager;
	
	// 사원 검색
	public Map<String, Object> searchMember(SearchMemberBean searchMemberBean, int page){
		
		// 검색 전 처리
		int view = searchMemberBean.getView();
		int startIndex = (page * view) + 1;
		int endIndex = (startIndex + view) - 1;
		
		// 검색을 위해 값 저장
		searchMemberBean.setStartIndex(startIndex);
		searchMemberBean.setEndIndex(endIndex);
		
		// 검색
		ArrayList<MemberBean> memberList = memberDao.searchMember(searchMemberBean);
		int maxCount = memberDao.searchMemberMaxCount(searchMemberBean);
		
		// 페이징 버튼 생성
		Map<String, Object> map = pagination.getPageBtns(page, maxCount, view);
		map.put("memberList", memberList);
		map.put("page", page);
		
		return map;
	}
	
	// 검색 조건 코드들(부서 직급 재직상태)
	public Map<String, Object> getSearchCode(){
		// 검색 조건
		ArrayList<CodeBean> departmentList = codeDao.getCodeList("DP01");
		ArrayList<CodeBean> positionList = codeDao.getCodeList("RA01");
		ArrayList<CodeBean> statusList = codeDao.getCodeList("ST01");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("departmentList", departmentList);
		map.put("positionList", positionList);
		map.put("statusList", statusList);
		
		return map;
	}
	
	// 멤버 상세정보
	public Map<String, Object> getDetailMemberInfo(int memberNumber){
		
		MemberBean memberBean = memberDao.getDetailMemberInfo(memberNumber);
		ArrayList<ProjectMemberBean> projectList = memberDao.getMemberProject(memberNumber);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("memberBean", memberBean);
		map.put("projectList", projectList);
		
		return map;
	}
	
	// 멤버 추가 코드들(부서 직급 재직상태 기술)
	public Map<String, Object> getAddMemberCode(){
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		ArrayList<CodeBean> departmentList = codeDao.getCodeList("DP01");
		ArrayList<CodeBean> positionList = codeDao.getCodeList("RA01");
		ArrayList<CodeBean> statusList = codeDao.getCodeList("ST01");
		ArrayList<CodeBean> skillList = codeDao.getCodeList("SK01");
		
		map.put("departmentList", departmentList);
		map.put("positionList", positionList);
		map.put("statusList", statusList);
		map.put("skillList", skillList);
		
		return map;
	}
	
	// 사원 아이디 중복 체크
	public Boolean checkMemberId(String memberId) {
		int result = memberDao.checkMemberId(memberId);
		
		if(result == 0) {
			return true;
		} else {
			return false;
		}
	}
	
	// 사원 등록
	public Map<String, Object> addMember(MemberBean addMemberBean) {
		
		DefaultTransactionDefinition def = new DefaultTransactionDefinition();
		TransactionStatus status = transactionManager.getTransaction(def);
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		try {
			
			int memberNumber = memberDao.getNextMemberSequence();
			addMemberBean.setMemberNumber(memberNumber);
			addMemberBean.setGenderCode("1");
			
			memberDao.addMember(addMemberBean);
			memberDao.addMemberAddress(addMemberBean);
			memberDao.addMemberCompany(addMemberBean);
			
			map.put("success", true);
			map.put("memberNumber", memberNumber);
			
			transactionManager.commit(status);
			return map;
		} catch (Exception e) {
			e.printStackTrace();
			transactionManager.rollback(status);
			map.put("success", false);
			return map;
		}
		
	}
}
