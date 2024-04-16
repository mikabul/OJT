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

public class ProjectValidator implements Validator {

	private final String REGEXP_PATTERN_DATE = "^[\\d]{4}\\-(0[1-9]|1[012])\\-(0[1-9]|[12][0-9]|3[01])$";

	private ProjectService projectService;
	private ProjectMemberService projectMemberService;

	public ProjectValidator() {
	}

	public ProjectValidator(ProjectService projectService, ProjectMemberService projectMemberService) {
		this.projectService = projectService;
		this.projectMemberService = projectMemberService;
	}

	@Override
	public boolean supports(Class<?> clazz) {
		return ProjectBean.class.isAssignableFrom(clazz);
	}

	@Override
	public void validate(Object target, Errors errors) {

		ProjectBean projectBean = (ProjectBean) target; // 객체 주입

		// 밸리데이션을 위해 값을 하나씩 꺼냄
		int projectNumber = projectBean.getProjectNumber();
		String projectName = projectBean.getProjectName();
		int customerNumber = projectBean.getCustomerNumber();
		String projectStartDate = projectBean.getProjectStartDate();
		String projectEndDate = projectBean.getProjectEndDate();
		String maintStartDate = projectBean.getMaintStartDate();
		String maintEndDate = projectBean.getMaintEndDate();
		String[] skillCodeList = projectBean.getSkillCodeList();
		String projectDetail = projectBean.getProjectDetail();
		ArrayList<ProjectMemberBean> pmList = projectBean.getPmList();
		
		if(errors.getObjectName().equals("modifyProjectBean")) {
			if(projectNumber == 0 || projectService.hasProject(projectNumber) == 0) {
				errors.rejectValue("projectNumber", "NotProject");
			}
		}

		// ================== 프로젝트 명 =================
		if (projectName == null || projectName.isEmpty()) { // 프로젝트명이 비어있다면
			errors.rejectValue("projectName", "Empty");
		} else if (5 > projectName.length() || projectName.length() > 20) { // 프로젝트명이 너무 길다면
			errors.rejectValue("projectName", "Size");
		}

		// ================== 고객사 ==================
		if (customerNumber == 0) { // 고객사 번호가 0이라면(= 없다면)
			errors.rejectValue("customerNumber", "Empty");
		} else if (projectService.hasCustomer(customerNumber)) { // 등록된 고객사가 없다면
			errors.rejectValue("customerNumber", "NotCustomer");
		}

		// ================= 프로젝트 시작일 ====================
		if (projectStartDate == null || projectStartDate.isEmpty()) { // 시작일이 비어있다면
			errors.rejectValue("projectStartDate", "Empty");
		} else if (!Pattern.matches(REGEXP_PATTERN_DATE, projectStartDate)) { // 패턴에 맞지 않다면
			errors.rejectValue("projectStartDate", "Pattern");
		} else {
			try {
				LocalDate.parse(projectStartDate);
			} catch (Exception e) {
				errors.rejectValue("projectStartDate", "DateOver");
			}
		} // End - projectStartDate

		// ================= 프로젝트 종료일 ====================
		if (projectEndDate == null || projectEndDate.isEmpty()) { // 시작일이 비어있다면
			errors.rejectValue("projectEndDate", "Empty");
		} else if (!Pattern.matches(REGEXP_PATTERN_DATE, projectStartDate)) { // 패턴에 맞지 않다면
			errors.rejectValue("projectEndDate", "Pattern");
		} else {
			try {
				LocalDate.parse(projectEndDate);
			} catch (Exception e) {
				errors.rejectValue("projectEndDate", "DateOver");
			}
		} // End - projectEndDate

		// 프로젝트 두개의 날짜를 비교
		if (!errors.hasFieldErrors("projectStartDate") && !errors.hasFieldErrors("projectEndDate")) {// 프로젝트 시작일ㅡ 종료일에
																										// 에라가 없다면
			LocalDate startDate = LocalDate.parse(projectStartDate);
			LocalDate endDate = LocalDate.parse(projectEndDate);

			if (startDate.isAfter(endDate)) { // projectStartDate가 projectEndDate보다 이후의 날짜라면
				errors.rejectValue("projectStartDate", "StartAfterEnd");
			}
		}

		// ================= 유지보수 시작일 ==================
		if (maintStartDate != null && !maintStartDate.isEmpty()) {

			if (!Pattern.matches(REGEXP_PATTERN_DATE, maintStartDate)) {
				errors.rejectValue("maintStartDate", "Pattern");
			} else {
				try {
					LocalDate.parse(maintStartDate);
				} catch (Exception e) {
					errors.rejectValue("maintStartDate", "DateOver");
				}
			}
		} // End - maintStartDate

		// ================== 유지보수 종료일 ===================
		if (maintEndDate != null && !maintEndDate.isEmpty()) {

			if (!Pattern.matches(REGEXP_PATTERN_DATE, maintEndDate)) {
				errors.rejectValue("maintEndDate", "Pattern");
			} else {
				try {
					LocalDate.parse(maintEndDate);
				} catch (Exception e) {
					errors.rejectValue("maintEndDate", "DateOver");
				}
			}
			// 유지보수 두 날짜 비교
			if (!errors.hasFieldErrors("maintStartDate") && !errors.hasFieldErrors("maintEndDate")) {// 유지보수 시작일, 종료일에
				
				if (maintStartDate == null || maintStartDate.isEmpty()) { // 유지보수 시작일이 비어 있다면
					errors.rejectValue("maintStartDate", "Empty");
				} else {
					LocalDate startDate = LocalDate.parse(maintStartDate);
					LocalDate endDate = LocalDate.parse(maintEndDate);

					if (startDate.isAfter(endDate)) {
						errors.rejectValue("maintStartDate", "StartDateAfterEndDate");
					}
				}
			}

		} // End - maintEndDate

		/*
		 *  프로젝트 종료일과 유지보수 시작일에 에러가없고
		 *  유지보수 시작일이 비어있지 않다면
		 *  프로젝트 종료일 이후로 유지보수 시작일이 되어있는지 확인
		 */
		if (!errors.hasFieldErrors("projectEndDate") && !errors.hasFieldErrors("maintStartDate") 
			&& maintStartDate != null && !maintStartDate.isEmpty()) {
			
			LocalDate projectEndDateLocal = LocalDate.parse(projectEndDate);
			LocalDate maintStartDateLocal = LocalDate.parse(maintStartDate);

			if(maintStartDateLocal.isBefore(projectEndDateLocal)) {
				errors.rejectValue("maintStartDate", "MaintStartBeforeProjectStart");
			}
		}

		// ================= 프로젝트 스킬 ===================
		if (skillCodeList != null && skillCodeList.length > 0) {// 프로젝트 스킬이 존재한다면
			if (projectService.hasSkill(skillCodeList, skillCodeList.length)) { // 프로젝트 스킬이 모두 존재하는지
				errors.rejectValue("skillCodeList", "NotSkill");
			}
		}

		// ================= 프로젝트 세부사항 ===================
		if (projectDetail != null && !projectDetail.isEmpty()) {
			if (projectDetail.length() > 500) {
				errors.rejectValue("projectDetail", "TooLong");
			}
		}

		// ================= 프로젝트 멤버 ====================
		if (pmList != null && pmList.size() > 0) {
			ArrayList<CodeBean> roleList = projectService.getRole();
			ArrayList<String> roleCdList = new ArrayList<String>();

			int[] memberNumbers = new int[pmList.size()];

			for (int i = 0; i < memberNumbers.length; i++) {
				memberNumbers[i] = pmList.get(i).getMemberNumber();
			}

			for (int i = 0; i < roleList.size(); i++) {
				roleCdList.add(roleList.get(i).getDetailCode());
			}

			if (projectMemberService.hasMember(memberNumbers) != pmList.size()) {
				errors.rejectValue("MemberNumberError", "Empty");
			} else {

				for (ProjectMemberBean pm : pmList) {

					String startDate = pm.getStartDate();
					String endDate = pm.getEndDate();
					String roleCode = pm.getRoleCode();

					/*
					 * 투입일과 철수일중에 하나라도 존재하고 에러가없다면 검사
					 * 투입일이 비어있다면 에러
					 * 투입일 패턴을 통해 검사
					 * LocalDate를 이용하여 유효한 날짜인지 검사
					 * 
					 * 철수일이 비어있지않다면 패턴을 통해 검사
					 * LocalDate를 이용하여 유효한 날짜인지 검사
					 */
					if( ((startDate != null && !startDate.isEmpty()) || (endDate != null && !endDate.isEmpty()))
							&& !errors.hasFieldErrors("startDateError") && !errors.hasFieldErrors("endDateError")) {
						
						if((startDate == null || startDate.isEmpty())) {
							errors.rejectValue("startDateError", "Empty");
						} else if(!Pattern.matches(REGEXP_PATTERN_DATE, startDate)){
							errors.rejectValue("startDateError", "Pattern");
						} else {
							try {
								LocalDate.parse(startDate);
							} catch (Exception e) {
								errors.rejectValue("startDateError", "DateOver");
							}
						}
						
						if(endDate != null && !endDate.isEmpty() && !Pattern.matches(REGEXP_PATTERN_DATE, endDate)) {
							errors.rejectValue("endDateError", "Pattern");
						} else {
							try {
								LocalDate.parse(endDate);
							} catch (Exception e) {
								errors.rejectValue("endDateError", "DateOver");
							}
						}
					}

					if (!roleCdList.contains(roleCode)) {// 역할 전체 리스트내에 해당코드가 존재하는지
						errors.rejectValue("roleCodeError", "NotRole");
					}

					// 프로젝트 시작일, 종료일(유지보수 종료일)과 비교
					if (!errors.hasFieldErrors("startDateError") && !errors.hasFieldErrors("endDateError")
							&& !errors.hasFieldErrors("projectStartDate") && !errors.hasFieldErrors("projectEndDate")
							&& !errors.hasFieldErrors("maintEndDate")
							&& ((startDate != null && !startDate.isEmpty()) || (endDate != null && !endDate.isEmpty()))) { // 투입일, 철수일, 시작일, 종료일, 유지보수 종료일 모두 에러가 없다면
						
						LocalDate memberStartDateLocal = null;
						LocalDate memberEndDateLocal = null;
						LocalDate startDateLocal = LocalDate.parse(projectStartDate);
						LocalDate endDateLocal;
						
						// 멤버 투입일 로컬데이트 변환
						if(startDate != null && !startDate.isEmpty()) {
							memberStartDateLocal = LocalDate.parse(startDate);
						}
						// 멤버 철수일 로컬데이트 변환
						if(endDate != null && !endDate.isEmpty()) {
							memberEndDateLocal = LocalDate.parse(endDate);
						}
						/*
						 * 유지보수 시작일이 비어있지 않고 유지보수 종료일이 비어있지 않다면 
						 * 유지보수 종료일을 이용하고
						 * 유지보수 시작일이 비어있다면 프로젝트 종료일을 이용
						 * 유지보수 시작일이 비어있지 않고 유지보수 종료일이 비어있다면
						 * 종료일 관련 유효성 검사를 하지 않음
						 */
						if(maintStartDate != null && !maintStartDate.isEmpty()) { // 유지보수 시작일이 비어있지 않다면
							if(maintEndDate != null && !maintEndDate.isEmpty()) { // 유지보수 종료일이 비어있지 않다면
								endDateLocal = LocalDate.parse(maintEndDate);
							} else { // 유지보수 종료일이 비어있다면
								endDateLocal = null;
							}
						} else { // 유지보수 시작일이 비어있을때
							endDateLocal = LocalDate.parse(projectEndDate);
						}
						
						if(memberStartDateLocal != null) { // 투입일이 비어있지 않다면
							if(memberStartDateLocal.isBefore(startDateLocal)) { // 투입일이 프로젝트시작일보다 이전이라면
								errors.rejectValue("startDateError", "StartBeforeProjectStart");
							} else if(endDateLocal != null && memberStartDateLocal.isAfter(endDateLocal)) { // 투입일이 프로젝트 종료일보다 이후라면
								errors.rejectValue("startDateError", "StartAfterProjectEnd");
							}
						}
						
						if(memberEndDateLocal != null) { // 철수일이 비어있지 않다면
							if(memberEndDateLocal.isBefore(startDateLocal)) { // 철수일이 프로젝트 시작일보다 이전이라면
								errors.rejectValue("endDateError", "EndBeforeProjectStart");
							} else if(endDateLocal != null && memberEndDateLocal.isAfter(endDateLocal)) { // 철수일이 프로젝트 종료일보다 이후라면
								errors.rejectValue("endDateError", "EndAfterProjectEnd");
							}
						}
						if(memberStartDateLocal != null && memberEndDateLocal != null) { // 투입일, 철수일 모두 비어있지 않다면
							if(memberStartDateLocal.isAfter(memberEndDateLocal)) { // 투입일이 철수일 이후라면
								errors.rejectValue("startDateError", "StartAfterEnd");
							}
						}
					}// End - 프로젝트 시작일, 종료일(유지보수 종료일)과 비교
				}// End - for (ProjectMemberBean pm : pmList)
			}
		}// End - 프로젝트 멤버

	}// End - validate

}
