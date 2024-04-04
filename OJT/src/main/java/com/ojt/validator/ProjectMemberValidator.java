package com.ojt.validator;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.regex.Pattern;

import org.springframework.validation.Errors;
import org.springframework.validation.Validator;

import com.ojt.bean.CodeBean;
import com.ojt.bean.ProjectBean;
import com.ojt.bean.ProjectMemberBean;
import com.ojt.service.ProjectMemberService;
import com.ojt.service.ProjectService;

public class ProjectMemberValidator implements Validator{
	
	private final String REGEXP_PATTERN_DATE = "^[\\d]{4}\\-(0[1-9]|1[012])\\-(0[1-9]|[12][0-9]|3[01])$";
	
	ProjectService projectService;
	
	ProjectMemberService projectMemberSevice;
	
	public ProjectMemberValidator(ProjectService projectService, ProjectMemberService projectMemberService) {
		this.projectService = projectService;
		this.projectMemberSevice = projectMemberService;
	}
	
	@Override
	public boolean supports(Class<?> clazz) {
		return ProjectBean.class.isAssignableFrom(clazz);
	}

	@Override
	public void validate(Object target, Errors errors) {
		
		ProjectBean projectBean = (ProjectBean)target;
		
		int projectNumber = projectBean.getProjectNumber();
		String projectStartDate = projectBean.getProjectStartDate();
		String projectEndDate = projectBean.getProjectEndDate();
		String maintEndDate = projectBean.getMaintEndDate();
		ArrayList<ProjectMemberBean> pmList = projectBean.getPmList();
		
		ArrayList<CodeBean> roleList = projectService.getRole();
		ArrayList<String> roleCodeList = new ArrayList<String>();
		for(CodeBean codeBean : roleList) {
			roleCodeList.add(codeBean.getDetailCode());
		}
//		ArrayList<String> roleCodeList = projectService.getRoleCodeList();
		int memberNumbers[] = new int[pmList.size()];
		
		// 프로젝트 번호 검사, 0이라면 비어있는 것
		if(projectNumber == 0) {
			errors.rejectValue("projectNumber", "projectNumberEmpty");
		}
		
		// 프로젝트 시작일
		if(projectStartDate == null || projectStartDate.isEmpty()) { // 비어있는지
			errors.rejectValue("projectStartDate", "ProjectStartDateEmpty");
		} else if(!Pattern.matches(REGEXP_PATTERN_DATE, projectStartDate)) { // 날짜형식에 맞는지
			errors.rejectValue("projectStartDate", "ProjectStartDatePattern");
		}
		
		// 프로젝트 종료일
		if(projectEndDate == null || projectEndDate.isEmpty()) { // 비어있는지
			errors.rejectValue("projectEndDate", "ProjectEndDateEmpty");
		} else if(!Pattern.matches(REGEXP_PATTERN_DATE, projectEndDate)) { // 날짜 형식에 맞는지
			errors.rejectValue("projectEndDate", "ProjectEndDatePattern");
		}
		
		// 유지보수 종료일
		if(maintEndDate != null && !maintEndDate.isEmpty()) { // 비어있지 않은지
			if(!Pattern.matches(REGEXP_PATTERN_DATE, maintEndDate)) { // 비어있지 않다면 날짜형식에 맞는지
				errors.rejectValue("maintEndDate", "MaintEndDatePattern");
			}
		}
		
		// 프로젝트
		if(!errors.hasErrors()) { // 에러가 없는지
			if(projectService.matchProjectInfo(projectBean) != 1) { // 프로젝트가 존재하는지, 하나만 존재하는지
				errors.rejectValue("projectNumber", "NotProject");
			}
		}
		
		/*							*/
		/*		멤버 유효성 검사		*/
		/*							*/
		for(int i = 0; i < pmList.size(); i++) {
			int memberNumber = pmList.get(i).getMemberNumber();
			if(memberNumber == 0) { // 사원 번호가 비어있는지, 0은 비어있는 것
				errors.rejectValue("memberNumberError", "MemberNumberEmpty");
				break;
			}
			memberNumbers[i] = memberNumber;
		}
		
		if(errors.hasFieldErrors("memberNumberError") || memberNumbers.length == 0) { // 에러가 있거나 배열의 길이가 0인지
			errors.rejectValue("memberNumberError", "MemberEmpty");
			return; // 유효성 검사 종료
		}
		
		if(projectMemberSevice.hasMember(memberNumbers) != memberNumbers.length) { // 멤버가 모두 존재하는지
			errors.rejectValue("memberNumberError", "NotMember");
		}
		
		for(ProjectMemberBean pm : pmList) {
			
			String startDate = pm.getStartDate();
			String endDate = pm.getEndDate();
			String roleCode = pm.getRoleCode();
			
			//투입일 검사
			if(!errors.hasFieldErrors("startDateError") && startDate != null && !startDate.isEmpty()) {
				if(!Pattern.matches(REGEXP_PATTERN_DATE, startDate)) {
					errors.rejectValue("startDateError", "StartDatePattern");
				}
			}
			
			//철수일 검사
			if(!errors.hasFieldErrors("endDateError") && endDate != null && !endDate.isEmpty()) {
				if(!Pattern.matches(REGEXP_PATTERN_DATE, endDate)) {
					errors.rejectValue("endDateError", "EndDatePattern");
				}
			}
			
			// 투입일이 철수일보다 큰지
			if(!errors.hasFieldErrors("startDateError") && !errors.hasFieldErrors("startDateError")
				&& startDate != null && !startDate.isEmpty()
				&& endDate != null && !endDate.isEmpty()) {
				
				LocalDate startDateLocal = LocalDate.parse(startDate);
				LocalDate endDateLocal = LocalDate.parse(endDate);
				
				if(startDateLocal.isBefore(endDateLocal)) {
					errors.rejectValue("startDateError", "StartDateAfterEndDate");
				}
			}
			
			// 역할이 존재하는지
			if(!roleCodeList.contains(roleCode)) {
				errors.rejectValue("roleCodeError", "NotRoleCode");
			}
		}
	}

}
