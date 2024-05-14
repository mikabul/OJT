package com.ojt.validator;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.regex.Pattern;

import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;

import com.ojt.bean.CodeBean;
import com.ojt.bean.ProjectBean;
import com.ojt.bean.ProjectMemberBean;
import com.ojt.service.CodeService;
import com.ojt.service.MemberService;

public class MemberProjectValidator{
	
	MemberService memberService;
	
	ArrayList<String> roleCodeList;	// 역할이 존재하는지 확인하기 위한 리스트
	
	private final String REGEXP_PATTERN_DATE = "^[\\d]{4}\\-(0[1-9]|1[012])\\-(0[1-9]|[12][0-9]|3[01])$"; //날짜 정규식
	
	public MemberProjectValidator(MemberService memberService, CodeService codeService) {
		this.memberService = memberService;
		ArrayList<CodeBean> roleList = codeService.getDetailCodeList("RO01");
		roleCodeList = new ArrayList<String>();
		for(CodeBean role : roleList) {
			this.roleCodeList.add(role.getDetailCode());
		}
	}

	public boolean supports(Class<?> clazz) {
		return ArrayList.class.isAssignableFrom(clazz);
	}

	public Map<Integer, MultiValueMap<String, Object>> validate(Object target) {
		
		ArrayList<ProjectMemberBean> projectMemberBeans;
		Map<Integer, MultiValueMap<String, Object>> map = new HashMap<>();
		
		try {
			projectMemberBeans = (ArrayList)target;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
		
		Iterator<ProjectMemberBean> it = projectMemberBeans.iterator();
		while(it.hasNext()) {
			ProjectMemberBean projectMemberBean = it.next();
			MultiValueMap<String, Object> errorMap = new LinkedMultiValueMap<String, Object>();
			
			ProjectBean projectBean = memberService.getProjectInfo(projectMemberBean.getProjectNumber());
			
			// 데이터 분리
			String projectStartDate = projectBean.getProjectStartDate();	// 프로젝트 시작일
			String projectEndDate = projectBean.getProjectEndDate();		// 프로젝트 종료일
			String maintStartDate = projectBean.getMaintStartDate();	// 유지보수 시작일
			String maintEndDate = projectBean.getMaintEndDate();	// 유지보수 종료일
			
			String memberStartDate = projectMemberBean.getStartDate();			// 투입일
			String memberEndDate = projectMemberBean.getEndDate();				// 철수일
			String roleCode = projectMemberBean.getRoleCode();					// 역할 코드
			int index = projectMemberBean.getIndex();							// validation index
			
			Boolean isMemberStartDate;											// 투입일이 비어있는지 비어있다면 false
			Boolean isMemberEndDate;											// 철수일이 비어있는지 비어있다면 false
			
			// 유효성검사에 사용할 시작일과 종료일 선택
			String startDate = projectStartDate;
			String endDate;
			if(maintStartDate != null && !maintStartDate.isEmpty()) {
				endDate = maintEndDate;
			} else {
				endDate = projectEndDate;
			}
			
			System.out.println("index : " + index);
			System.out.println("projectStartDate : " + projectStartDate);
			System.out.println("projectEndDate : " + projectEndDate);
			System.out.println("maintStartDate : " + maintStartDate);
			System.out.println("maintEndDate : " + maintEndDate);
			System.out.println("memberStartDate:" + memberStartDate);
			System.out.println("memberEndDate : " + memberEndDate);
			
			// 투입일 패턴
			if(memberStartDate != null && !memberStartDate.isEmpty()) { // 투입일이 비어있지 않다면
				if(!Pattern.matches(REGEXP_PATTERN_DATE, memberStartDate)) { // 투입일이 날짜 패턴에 일치하는지
					errorMap.add("startDate", "Pattern");
				} else {
					
					LocalDate localMemberStartDate = LocalDate.parse(memberStartDate);
					LocalDate localStartDate = LocalDate.parse(startDate);
					
					if(localMemberStartDate.isBefore(localStartDate)) { // 프로젝트 시작일 보다 이전이라면
						errorMap.add("startDate", "Before");
						
					} else if(endDate != null && !endDate.isEmpty()) { // 종료일 이 비어있지않다면
						
						LocalDate localEndDate = LocalDate.parse(endDate); // 로컬데이트로 변환
						
						if(localMemberStartDate.isAfter(localEndDate)) { // 투입일이 프로젝트 종료일 보다 이후인지
							errorMap.add("startDate", "After");
						}
					}
				}
				
				isMemberStartDate = true;
			} else {
				isMemberStartDate = false;
			}
			
			// 철수일 패턴
			if(memberEndDate != null && !memberEndDate.isEmpty()) { // 철수일이 비어있지 않다면
				if(!Pattern.matches(REGEXP_PATTERN_DATE, memberEndDate)) {	// 철수일이 날짜 패턴에 일치하는지
					errorMap.add("endDate", "Pattern");
					
				} else {
					LocalDate localMemberEndDate = LocalDate.parse(memberEndDate);
					LocalDate localStartDate = LocalDate.parse(startDate);
					
					if(localMemberEndDate.isBefore(localStartDate)) {
						errorMap.add("endDate", "Before");
						
					} else if (endDate != null && !endDate.isEmpty()) {
						LocalDate localEndDate = LocalDate.parse(endDate);
						if(localMemberEndDate.isAfter(localEndDate)) {
							errorMap.add("endDate", "After");
						}
					}
				}
				isMemberEndDate = true;
			} else {
				isMemberEndDate = false;
			}
			
			if(isMemberStartDate && isMemberEndDate
				&& errorMap.get("startDate") == null 
				&& errorMap.get("endDate") == null) {
				
				LocalDate localMemberStartDate = LocalDate.parse(memberStartDate);
				LocalDate localMemberEndDate = LocalDate.parse(memberEndDate);
				
				if(localMemberStartDate.isAfter(localMemberEndDate)) {
					errorMap.add("startDate", "AfterMemberEnd");
				}
			}
			
			if(!roleCodeList.contains(roleCode)) {
				errorMap.add("roleCode", "NotRole");
			}
			
			if(errorMap.size() != 0) { // 에러가 존재할때만 추가
				map.put(index, errorMap);
			}
			
		}
		
		return map;
		
	}

	
}
