package com.ojt.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Service;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.DefaultTransactionDefinition;

import com.ojt.bean.CodeBean;
import com.ojt.bean.MemberBean;
import com.ojt.bean.ProjectMemberBean;
import com.ojt.bean.SearchMemberBean;
import com.ojt.dao.CodeDao;
import com.ojt.dao.MemberDao;
import com.ojt.util.DevMultiPartFile;
import com.ojt.util.Pagination;
import com.ojt.util.Sha256;

@Service
public class MemberService {
	
	@Autowired
	MemberDao memberDao;
	
	@Autowired
	CodeDao codeDao;
	
	@Autowired
	Pagination pagination;
	
	@Autowired
	DevMultiPartFile devMultiPartFile;
	
	@Autowired
	Sha256 encoder;
	
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
	
	// 멤버 상세정보(프로젝트 포함)
	public Map<String, Object> getDetailMemberInfo(int memberNumber){
		
		MemberBean memberBean = memberDao.getDetailMemberInfo(memberNumber);
		ArrayList<ProjectMemberBean> projectMemberList = memberDao.getMemberProject(memberNumber);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("memberBean", memberBean);
		map.put("projectMemberList", projectMemberList);
		
		return map;
	}
	
	// 멤버 상세정보
	public MemberBean getMemberInfo(int memberNumber) {
		
		MemberBean memberBean = memberDao.getDetailMemberInfo(memberNumber);
		return memberBean;
	}
	
	// 멤버 추가 코드들(부서 직급 재직상태 기술)
	public Map<String, Object> getAddMemberCode(){
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		ArrayList<CodeBean> departmentList = codeDao.getCodeList("DP01");
		ArrayList<CodeBean> positionList = codeDao.getCodeList("RA01");
		ArrayList<CodeBean> statusList = codeDao.getCodeList("ST01");
		ArrayList<CodeBean> skillList = codeDao.getCodeList("SK01");
		ArrayList<CodeBean> genderList = codeDao.getCodeList("GD01");
		ArrayList<CodeBean> emailList = codeDao.getCodeList("EM01");
		
		map.put("departmentList", departmentList);
		map.put("positionList", positionList);
		map.put("statusList", statusList);
		map.put("skillList", skillList);
		map.put("genderList", genderList);
		map.put("emailList", emailList);
		
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
			
			// 비밀번호와 주민번호 뒷자리 해싱
			String hashPassword = encoder.encrypt(addMemberBean.getMemberPW());
			String hashRrnSuffix = encoder.encrypt(addMemberBean.getMemberRrnSuffix());
			addMemberBean.setHashedMemberPW(hashPassword);
			addMemberBean.setHashedMemberRrnSuffix(hashRrnSuffix);
			
			// 이메일 앞 뒤를 합친 후 addMemberBean에 저장
			String emailPrefix = addMemberBean.getEmailPrefix();
			String emailSuffix = addMemberBean.getEmailSuffix();
			String email = emailPrefix + "@" + emailSuffix;
			addMemberBean.setEmail(email);
			
			// 업로드 된 이미지 파일을 서버에 저장 후 파일의 이름을 addMemberBean에 저장
			Map<String, Object> resultMap = devMultiPartFile.saveFile(addMemberBean.getMemberImage(), "/images/member/", String.valueOf(memberNumber));
			if ((Boolean) resultMap.get("success")) {
				String fileName = (String) resultMap.get("fileName");
				addMemberBean.setPictureDir(fileName);
			} else {
				map.put("success", false);
				map.put("code", resultMap.get("code"));
				return map;
			}
			
			memberDao.addMember(addMemberBean); // member_info 테이블에 추가
			memberDao.addMemberAddress(addMemberBean); // member_address테이블에 추가
			memberDao.addMemberCompany(addMemberBean); // member_company 테이블에 추가
			
			ArrayList<String> skillCodes = addMemberBean.getSkillCodes();
			if(skillCodes != null) {
				for(String skillCode : skillCodes) {
					memberDao.addMemberSkill(memberNumber, skillCode);
				}
			}
			
			map.put("success", true);
			map.put("memberNumber", memberNumber);
			
			transactionManager.commit(status);
			return map;
		} catch (Exception e) {
			e.printStackTrace();
			transactionManager.rollback(status);
			map.put("success", false);
			map.put("code", 500);
			return map;
		}
	}
	
	// 마스터 코드에 대한 코드 리스트를 가져옴(코드만)
	public ArrayList<String> getCodes(String masterCode){
		return codeDao.getCodes(masterCode);
	}
	
	// 해당 기술이 전부 있는지
	public int hasSkills(ArrayList<String> skills) {
		return memberDao.hasSkills(skills);
	}
	
	// 사원 아이디 중복체크(수정)
	public Boolean modifyMatchId(int memberNumber, String memberId) {
		Boolean result;
		int matchCount = memberDao.modifyMatchId(memberNumber, memberId);
		
		if(matchCount > 0) {
			result = false;
		} else {
			result = true;
		}
		
		return result;
	}
	
	// 사원 정보 수정
	public Map<String, Object> memberUpdate(MemberBean modifyMemberBean){
		
		DefaultTransactionDefinition def = new DefaultTransactionDefinition();
		TransactionStatus status = transactionManager.getTransaction(def);
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		try {
			
			// 사원번호, 비밀번호, 주민등록번호뒷자리 추출
			int memberNumber = modifyMemberBean.getMemberNumber();
			String memberPW = modifyMemberBean.getMemberPW();
			String memberRrnSuffix = modifyMemberBean.getMemberRrnSuffix();
			
			// 비밀번호가 비어있지 않다면 해싱 후 저장
			if(memberPW != null && !memberPW.isEmpty()) {
				String hashPassword = encoder.encrypt(modifyMemberBean.getMemberPW());
				modifyMemberBean.setHashedMemberPW(hashPassword);
			}
			
			// 주민등록번호 뒷자리가 비어있지 않다면 해싱 후 저장
			if(memberRrnSuffix != null && !memberRrnSuffix.isEmpty()) {
				String hashRrnSuffix = encoder.encrypt(modifyMemberBean.getMemberRrnSuffix());
				modifyMemberBean.setHashedMemberRrnSuffix(hashRrnSuffix);
			}

			// 이메일 앞 뒤를 합친 후 addMemberBean에 저장
			String emailPrefix = modifyMemberBean.getEmailPrefix();
			String emailSuffix = modifyMemberBean.getEmailSuffix();
			String email = emailPrefix + "@" + emailSuffix;
			modifyMemberBean.setEmail(email);

			// 업로드된 이미지가 존재한다면
			if(modifyMemberBean.getMemberImage().getSize() != 0) {
				// 업로드 된 이미지 파일을 서버에 저장 후 파일의 이름을 addMemberBean에 저장
				Map<String, Object> resultMap = devMultiPartFile.saveFile(modifyMemberBean.getMemberImage(), "/images/member/", String.valueOf(memberNumber));
				if ((Boolean) resultMap.get("success")) {
					String fileName = (String) resultMap.get("fileName");
					modifyMemberBean.setPictureDir(fileName);
				} else {
					map.put("success", false);
					System.out.println("code : " + resultMap.get("code"));
					map.put("code", resultMap.get("code"));
					return map;
				}
			}
			
			// 수정된 정보들을 데이터베이스에 업데이트
			memberDao.memberInfoUpdate(modifyMemberBean);
			memberDao.memberAddressUpdate(modifyMemberBean);
			memberDao.memberCompanyUpdate(modifyMemberBean);
			
			// 사원 스킬 삭제 후 등록
			memberDao.deleteMemberSkill(memberNumber);
			ArrayList<String> skillCodes = modifyMemberBean.getSkillCodes();
			if(skillCodes != null) {
				for(String skillCode : skillCodes) {
					memberDao.addMemberSkill(memberNumber, skillCode);
				}
			}
			
			transactionManager.commit(status);
			map.put("success", true);
			return map;
			
		} catch (Exception e) {
			transactionManager.rollback(status);
			e.printStackTrace();
			map.put("success", false);
			map.put("code", 500);
			return map;
		}
	}
	
	// 사원 삭제
	public Boolean deleteMember(int[] memberNumbers) {
		DefaultTransactionDefinition def = new DefaultTransactionDefinition();
		TransactionStatus status = transactionManager.getTransaction(def);
		
		try {
			memberDao.deleteMember(memberNumbers);
			transactionManager.commit(status);
			return true;
		} catch (Exception e) {
			e.printStackTrace();
			transactionManager.rollback(status);
			return false;
		}
	}
	
	// 사원의 프로젝트 목록
	public ArrayList<ProjectMemberBean> getMemberProjectList(int memberNumber){
		return memberDao.getMemberProject(memberNumber);
	}
	
	// 사원이 참여중이지 않는 프로젝트 리스트
	public ArrayList<ProjectMemberBean> nonParticipatingProjects(int memberNumber) {
		return memberDao.nonParticipatingProjects(memberNumber);
	}
	
	// 프로젝트와 사원이 모두 존재하며 프로젝트(유지보수) 시작일, 종료일이 올바른 값인지
	public int validProjectAndMember(ProjectMemberBean projectMemberBean) {
		return memberDao.validProjectAndMember(projectMemberBean);
	}
	
	// 사원 프로젝트 추가
	public Boolean addMemberProject(ArrayList<ProjectMemberBean> projectMemberBeans) {
		DefaultTransactionDefinition def = new DefaultTransactionDefinition();
		TransactionStatus status = transactionManager.getTransaction(def);
		
		Boolean result;
		
		try {
			
			memberDao.addMemberProject(projectMemberBeans);
			result = true;
			transactionManager.rollback(status);
		} catch (Exception e) {
			result = false;
			transactionManager.rollback(status);
			e.printStackTrace();
		}
		
		return result;
	}
	
	// 사원 프로젝트 수정
	public Boolean updateMemberProject(ArrayList<ProjectMemberBean> projectMemberBeans) {
		DefaultTransactionDefinition def = new DefaultTransactionDefinition();
		TransactionStatus status = transactionManager.getTransaction(def);

		Boolean result;

		try {

			for(ProjectMemberBean projectMemberBean : projectMemberBeans) {
				memberDao.updateMemberProject(projectMemberBean);
			}
			
			result = true;
			transactionManager.rollback(status);
		} catch (Exception e) {
			result = false;
			transactionManager.rollback(status);
		}

		return result;
	}
	
	// 사원 프로젝트 삭제
	public Boolean deleteMemberProject(int[] projectNumbers, int memberNumber) {
		
		DefaultTransactionDefinition def = new DefaultTransactionDefinition();
		TransactionStatus status = transactionManager.getTransaction(def);
		
		Boolean result;
		
		try {
			memberDao.deleteMemberProject(projectNumbers, memberNumber);
			
			result = true;
			transactionManager.commit(status);
		} catch (Exception e) {
			result = false;
			transactionManager.rollback(status);
			e.printStackTrace();
		}
		
		return result;
	}
}
