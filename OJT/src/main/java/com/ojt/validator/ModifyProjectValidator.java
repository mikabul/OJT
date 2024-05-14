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

public class ModifyProjectValidator implements Validator {

	private final String REGEXP_PATTERN_DATE = "^[\\d]{4}\\-(0[1-9]|1[012])\\-(0[1-9]|[12][0-9]|3[01])$";

	private ProjectService projectService;
	private ProjectMemberService projectMemberService;

	public ModifyProjectValidator() {
	}

	public ModifyProjectValidator(ProjectService projectService, ProjectMemberService projectMemberService) {
		this.projectService = projectService;
		this.projectMemberService = projectMemberService;
	}

	@Override
	public boolean supports(Class<?> clazz) {
		return ProjectBean.class.isAssignableFrom(clazz);
	}

	@Override
	public void validate(Object target, Errors errors) {

		if (errors.getObjectName().equals("modifyProjectBean")) { // 이름이 'modifyProjectBean'인 객체

			ProjectBean modifyProjectBean = (ProjectBean) target; // 객체 주입

			// 밸리데이션을 위해 값을 하나씩 꺼냄
			int projectNumber = modifyProjectBean.getProjectNumber();
			String projectName = modifyProjectBean.getProjectName();
			int customerNumber = modifyProjectBean.getCustomerNumber();
			String projectStartDate = modifyProjectBean.getProjectStartDate();
			String projectEndDate = modifyProjectBean.getProjectEndDate();
			String maintStartDate = modifyProjectBean.getMaintStartDate();
			String maintEndDate = modifyProjectBean.getMaintEndDate();
			String[] skillCodeList = modifyProjectBean.getSkillCodeList();
			String projectDetail = modifyProjectBean.getProjectDetail();
			ArrayList<ProjectMemberBean> pmList = modifyProjectBean.getPmList();

			// ================== 프로젝트 번호 ================
			if (projectNumber == 0) {
				errors.rejectValue("projectNumber", "NotProject");
			} else if (projectService.hasProject(projectNumber) == 0) {
				errors.rejectValue("projectNumber", "NotProject");
			}

			// ================== 프로젝트 명 =================
			if (projectName == null || projectName.isEmpty()) { // 프로젝트명이 비어있다면
				errors.rejectValue("projectName", "NameEmpty");
			} else if (projectName.length() > 20) { // 프로젝트명이 너무 길다면
				errors.rejectValue("projectName", "NameTooLong");
			}

			// ================== 고객사 ==================
			if (customerNumber == 0) { // 고객사 번호가 0이라면(= 없다면)
				errors.rejectValue("customerNumber", "CustomerEmpty");
			} else if (projectService.hasCustomer(customerNumber)) { // 등록된 고객사가 없다면
				errors.rejectValue("customerNumber", "NotCustomer");
			}

			// ================= 프로젝트 시작일 ====================
			if (projectStartDate == null || projectStartDate.isEmpty()) { // 시작일이 비어있다면
				errors.rejectValue("projectStartDate", "DateEmpty");
			} else if (!Pattern.matches(REGEXP_PATTERN_DATE, projectStartDate)) { // 패턴에 맞지 않다면
				errors.rejectValue("projectStartDate", "DatePattern");
			} else {
				int year = Integer.parseInt(projectStartDate.substring(0, 4));
				int month = Integer.parseInt(projectStartDate.substring(5, 7));
				int day = Integer.parseInt(projectStartDate.substring(8));

				switch (month) {
				case 1:
				case 3:
				case 5:
				case 7:
				case 8:
				case 10:
				case 12:
					if (day > 31) {
						errors.rejectValue("projectStartDate", "DateOver31Day");
					}
					break;

				case 4:
				case 6:
				case 9:
				case 11:
					if (day > 30) {
						errors.rejectValue("projectStartDate", "DateOver30Day");
					}
					break;

				case 2:
					if (year % 4 == 0 && day > 29) {
						errors.rejectValue("projectStartDate", "DateOverLeapYear");
					}
					if (year % 4 != 0 && day > 28) {
						errors.rejectValue("projectStartDate", "DateOver28Day");
					}
					break;
				}
			} // End - projectStartDate

			// ================= 프로젝트 종료일 ====================
			if (projectEndDate == null || projectEndDate.isEmpty()) { // 시작일이 비어있다면
				errors.rejectValue("projectEndDate", "DateEmpty");
			} else if (!Pattern.matches(REGEXP_PATTERN_DATE, projectStartDate)) { // 패턴에 맞지 않다면
				errors.rejectValue("projectEndDate", "DatePattern");
			} else {
				int year = Integer.parseInt(projectEndDate.substring(0, 4));
				int month = Integer.parseInt(projectEndDate.substring(5, 7));
				int day = Integer.parseInt(projectEndDate.substring(8));

				switch (month) {
				case 1:
				case 3:
				case 5:
				case 7:
				case 8:
				case 10:
				case 12:
					if (day > 31) {
						errors.rejectValue("projectEndDate", "DateOver31Day");
					}
					break;

				case 4:
				case 6:
				case 9:
				case 11:
					if (day > 30) {
						errors.rejectValue("projectEndDate", "DateOver30Day");
					}
					break;

				case 2:
					if (year % 4 == 0 && day > 29) {
						errors.rejectValue("projectEndDate", "DateOverLeapYear");
					}
					if (year % 4 != 0 && day > 28) {
						errors.rejectValue("projectEndDate", "DateOver28Day");
					}
					break;
				}
			} // End - projectEndDate

			// 프로젝트 두개의 날짜를 비교
			if (!errors.hasFieldErrors("projectStartDate") && !errors.hasFieldErrors("projectEndDate")) {// 프로젝트 시작일ㅡ
																											// 종료일에 에라가
																											// 없다면
				LocalDate startDate = LocalDate.parse(projectStartDate);
				LocalDate endDate = LocalDate.parse(projectEndDate);

				if (startDate.isAfter(endDate)) { // projectStartDate가 projectEndDate보다 이후의 날짜라면
					errors.rejectValue("projectStartDate", "StartDateAfterEndDate");
				}
			}

			// ================= 유지보수 시작일 ==================
			if (maintStartDate != null && !maintStartDate.isEmpty()) {

				if (!Pattern.matches(REGEXP_PATTERN_DATE, maintStartDate)) {
					errors.rejectValue("maintStartDate", "DatePattern");
				} else {
					int year = Integer.parseInt(maintStartDate.substring(0, 4));
					int month = Integer.parseInt(maintStartDate.substring(5, 7));
					int day = Integer.parseInt(maintStartDate.substring(8));

					switch (month) {
					case 1:
					case 3:
					case 5:
					case 7:
					case 8:
					case 10:
					case 12:
						if (day > 31) {
							errors.rejectValue("maintStartDate", "DateOver31Day");
						}
						break;

					case 4:
					case 6:
					case 9:
					case 11:
						if (day > 30) {
							errors.rejectValue("maintStartDate", "DateOver30Day");
						}
						break;

					case 2:
						if (year % 4 == 0 && day > 29) {
							errors.rejectValue("maintStartDate", "DateOverLeapYear");
						}
						if (year % 4 != 0 && day > 28) {
							errors.rejectValue("maintStartDate", "DateOver28Day");
						}
						break;
					}
				}
			} // End - maintStartDate

			// ================== 유지보수 종료일 ===================
			if (maintEndDate != null && !maintEndDate.isEmpty()) {

				if (!Pattern.matches(REGEXP_PATTERN_DATE, maintEndDate)) {
					errors.rejectValue("maintEndDate", "DatePattern");
				} else {
					int year = Integer.parseInt(maintEndDate.substring(0, 4));
					int month = Integer.parseInt(maintEndDate.substring(5, 7));
					int day = Integer.parseInt(maintEndDate.substring(8));

					switch (month) {
					case 1:
					case 3:
					case 5:
					case 7:
					case 8:
					case 10:
					case 12:
						if (day > 31) {
							errors.rejectValue("maintEndDate", "DateOver31Day");
						}
						break;

					case 4:
					case 6:
					case 9:
					case 11:
						if (day > 30) {
							errors.rejectValue("maintEndDate", "DateOver30Day");
						}
						break;

					case 2:
						if (year % 4 == 0 && day > 29) {
							errors.rejectValue("maintEndDate", "DateOverLeapYear");
						}
						if (year % 4 != 0 && day > 28) {
							errors.rejectValue("maintEndDate", "DateOver28Day");
						}
						break;
					}
				}
				// 유지보수 두 날짜 비교
				if (!errors.hasFieldErrors("maintStartDate") && !errors.hasFieldErrors("maintEndDate")) {// 유지보수 시작일,
																											// 종료일에 에러가
																											// 없다면

					if (maintStartDate == null || maintStartDate.isEmpty()) { // 유지보수 시작일이 비어 있다면
						errors.rejectValue("maintStartDate", "MaintStartDateEmpty");
					} else {
						LocalDate startDate = LocalDate.parse(maintStartDate);
						LocalDate endDate = LocalDate.parse(maintEndDate);

						if (startDate.isAfter(endDate)) {
							errors.rejectValue("maintStartDate", "StartDateAfterEndDate");
						}
					}
				}

			} // End - maintEndDate

			System.out.println("프로젝트 시작일 : " + !errors.hasFieldErrors("projectStartDate"));
			System.out.println("프로젝트 종료일 : " + !errors.hasFieldErrors("projectEndDate"));
			System.out.println("유지보수 시작일 : " + !errors.hasFieldErrors("maintStartDate"));
			System.out.println("유지보수 종료일 : " + !errors.hasFieldErrors("maintEndDate"));

			if (!errors.hasFieldErrors("projectStartDate") && !errors.hasFieldErrors("projectEndDate") // 프로젝트 시작일 종료일에
																										// 에러가 없고
					&& !errors.hasFieldErrors("maintStartDate") && !errors.hasFieldErrors("maintEndDate")) {// 유지보수 시작일,
																											// 종료일에 에러가
																											// 없다면
				LocalDate projectEndDateLocal = LocalDate.parse(projectEndDate);

				if (maintStartDate != null && !maintStartDate.isEmpty() && maintEndDate != null
						&& !maintEndDate.isEmpty()) {
					LocalDate maintStartDateLocal = LocalDate.parse(maintStartDate);
					LocalDate maintEndDateLocal = LocalDate.parse(maintEndDate);

					if (maintStartDateLocal.isBefore(projectEndDateLocal)) {
						errors.rejectValue("maintStartDate", "MaintStartDateBeforeProjectStart");
					}

					if (maintEndDateLocal.isBefore(projectEndDateLocal)) {
						errors.rejectValue("maintEndDate", "MaintEndDateBeforeProjectStart");
					}
				} else if (maintStartDate != null && !maintStartDate.isEmpty()) {
					LocalDate maintStartDateLocal = LocalDate.parse(maintStartDate);

					if (maintStartDateLocal.isBefore(projectEndDateLocal)) {
						errors.rejectValue("maintStartDate", "MaintStartDateBeforeProjectStart");
					}
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
					errors.rejectValue("projectDetail", "ProjectDetailTooLong");
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

						int memberNumber = pm.getMemberNumber();
						String startDate = pm.getStartDate();
						String endDate = pm.getEndDate();
						String roleCode = pm.getRoleCode();
						
						if(memberNumber == 0) {
							errors.rejectValue("memberNumberError", "Empty");
						}

						/*
						 * 투입일 패턴을 통해 검사
						 * LocalDate를 이용하여 유효한 날짜인지 검사
						 * 
						 * 철수일이 비어있지않다면 패턴을 통해 검사
						 * LocalDate를 이용하여 유효한 날짜인지 검사
						 */
						
						Boolean isStartDate = false;	// 투입일이 비어있지 않은지
						Boolean isEndDate = false;		// 철수일이 비어있지 않은지
						
						// 투입일 검사
						if(startDate != null && !startDate.isEmpty() && !errors.hasFieldErrors("startDateError")) {
							
							isStartDate = true; // 비어있지 않으므로 true
							
							if(!Pattern.matches(REGEXP_PATTERN_DATE, startDate)) {
								errors.rejectValue("startDateError", "Empty");
							} else {
								try {
									LocalDate.parse(startDate);
								} catch (Exception e) {
									errors.rejectValue("startDateError", "DateOver");
								}
							}
							
						}
						
						// 철수일 검사
						if(endDate != null && !endDate.isEmpty() && !errors.hasFieldErrors("endDateError")) {
							isEndDate = true; // 비어있지 않으므로 true
							
							if(!Pattern.matches(REGEXP_PATTERN_DATE, endDate)) {
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
						
						if(!errors.hasFieldErrors("projectStartDate")			// 프로젝트 시작일
								&& !errors.hasFieldErrors("projectEndDate")		// 프로젝트 종료일
								&& !errors.hasFieldErrors("maintEndDate")) {	// 유지보수 종료일
							
							LocalDate localProjectStartDate = LocalDate.parse(projectStartDate);
							LocalDate localProjectEndDate = null;
							LocalDate localStartDate = null;
							LocalDate localEndDate = null;
							
							/*
							 * 유지보수 시작일이 비어있지 않을
							 * 유지보수 종료일을 사용하며
							 * 유지보수 종료일이 없을 경우 NULL
							 * 유지보수 시작일이 비어있을 경우
							 * 프로젝트 종료일을 사용
							 */
							if(maintStartDate != null && !maintStartDate.isEmpty()) {
								try {
									localProjectEndDate = LocalDate.parse(maintEndDate);
								} catch (Exception e) {
									localProjectEndDate = null;
								}
							} else {
								localProjectEndDate = LocalDate.parse(projectEndDate);
							}
							
							/*
							 * 투입일이 비어있지 않고 에러가 없다면
							 * LocalDate로 변환 후
							 * 프로젝트 시작일보다 이전인지
							 * 프로젝트 종료일보다 이후인지
							 * 검사
							 */
							if(isStartDate && !errors.hasFieldErrors("startDateError")) {
								localStartDate = LocalDate.parse(startDate);
								
								if(localStartDate.isBefore(localProjectStartDate)) {
									errors.rejectValue("startDateError", "StartBeforeProjectStart");
								} else if(localStartDate.isAfter(localProjectEndDate)) {
									errors.rejectValue("startDateError", "StartAfterProjectEnd");
								}
							}
							
							/*
							 * 철수일이 비어있지 않고 에러가 없다면
							 * LocalDate로 변환 후
							 * 프로젝트 시작일보다 이전인지
							 * 프로젝트 종료일보다 이후인지
							 * 검사
							 */
							if(isEndDate && !errors.hasFieldErrors("endDateError")) {
								
								localEndDate = LocalDate.parse(endDate);
								
								if(localEndDate.isBefore(localProjectStartDate)) {
									errors.rejectValue("endDateError", "EndBeforeProjectStart");
								} else if(localEndDate.isAfter(localProjectEndDate)) {
									errors.rejectValue("endDateError", "EndAfterProjectEnd");
								}
							}
							
							// 투입일과 철수일 모두 비어있지 않다면 두날짜를 비교하여 검사
							if(localStartDate != null && localEndDate != null) {
								if(localStartDate.isAfter(localEndDate)) {
									errors.rejectValue("startDateError", "StartAfterEnd");
								}
							}
							
						}
					}
				}
			}

		} // End - modifyProjectBean

	}// End - validate

}
