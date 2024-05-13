package com.ojt.validator;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.regex.Pattern;

import org.springframework.validation.Errors;
import org.springframework.validation.Validator;

import com.ojt.bean.CodeBean;
import com.ojt.bean.ProjectMemberBean;
import com.ojt.service.CodeService;
import com.ojt.service.MemberService;

public class MemberProjectValidator implements Validator{
	
	MemberService memberService;
	
	ArrayList<String> roleCodeList;	// 역할이 존재하는지 확인하기 위한 리스트
	
	private final String REGEXP_PATTERN_DATE = "^[\\d]{4}\\-(0[1-9]|1[012])\\-(0[1-9]|[12][0-9]|3[01])$"; //날짜 정규식
	
	public MemberProjectValidator(MemberService memberService, CodeService codeService) {
		this.memberService = memberService;
		ArrayList<CodeBean> roleList = codeService.getDetailCodeList("RO01");
		
		for(CodeBean role : roleList) {
			this.roleCodeList.add(role.getDetailCode());
		}
	}

	@Override
	public boolean supports(Class<?> clazz) {
		return ArrayList.class.isAssignableFrom(clazz);
	}

	@Override
	public void validate(Object target, Errors errors) {
		
		ArrayList<ProjectMemberBean> projectMemberBeans;
		
		try {
			projectMemberBeans = (ArrayList)target;
		} catch (Exception e) {
			System.out.println("ProjectMemberBean이 아님");
			return;
		}
		
		Iterator<ProjectMemberBean> it = projectMemberBeans.iterator();
		while(it.hasNext()) {
			
			ProjectMemberBean projectMemberBean = it.next();
			
			// 멤버와 프로젝트가 존재하는지
			int validCount = memberService.validProjectAndMember(projectMemberBean);
			if(validCount != 2) {
				errors.rejectValue("validProjectAndMember", "NotProjectOrMember");
				return;
			}
			
			// 데이터 분리
			String projectStartDate = projectMemberBean.getProjectStartDate();	// 프로젝트 시작일
			String projectEndDate = projectMemberBean.getProjectEndDate();		// 프로젝트 종료일
			String maintEndDate = projectMemberBean.getProjectMaintStartDate();	// 유지보수 시작일
			String maintStartDate = projectMemberBean.getProjectMaintEndDate();	// 유지보수 종료일
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
			
			// 투입일 패턴
			if(memberStartDate != null && !memberStartDate.isEmpty()) { // 투입일이 비어있지 않다면
				if(!Pattern.matches(REGEXP_PATTERN_DATE, memberStartDate)) { // 투입일이 날짜 패턴에 일치하는지
					errors.rejectValue("startDate[" + index + "]", "Pattern");
				} else {
					
					LocalDate localMemberStartDate = LocalDate.parse(memberStartDate);
					LocalDate localStartDate = LocalDate.parse(startDate);
					
					if(localMemberStartDate.isBefore(localStartDate)) { // 프로젝트 시작일 보다 이전이라면
						errors.rejectValue("startDate[" + index + "]", "Before");
						
					} else if(endDate != null && !endDate.isEmpty()) { // 종료일 이 비어있지않다면
						
						LocalDate localEndDate = LocalDate.parse(endDate); // 로컬데이트로 변환
						
						if(localMemberStartDate.isAfter(localEndDate)) { // 투입일이 프로젝트 종료일 보다 이후인지
							errors.rejectValue("startDate[" + index + "]", "After");
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
					errors.rejectValue("endDate[" + index + "]", "Pattern");
					
				} else {
					LocalDate localMemberEndDate = LocalDate.parse(memberEndDate);
					LocalDate localStartDate = LocalDate.parse(startDate);
					
					if(localMemberEndDate.isBefore(localStartDate)) {
						errors.rejectValue("endDate[" + index + "]", "Before");
						
					} else if (endDate != null && !endDate.isEmpty()) {
						LocalDate localEndDate = LocalDate.parse(endDate);
						if(localMemberEndDate.isAfter(localEndDate)) {
							errors.rejectValue("endDate[" + index + "]", "After");
						}
					}
				}
				isMemberEndDate = true;
			} else {
				isMemberEndDate = false;
			}
			
			// 투입일과 프로젝트 시작일, 종료일 비교
			if(isMemberStartDate && !errors.hasFieldErrors("startDate[" + index + "]")) {
				
			}
			
		}
		
	}

	
}
