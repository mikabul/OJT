package com.ojt.validator;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.regex.Pattern;

import org.springframework.validation.Errors;
import org.springframework.validation.Validator;

import com.ojt.bean.CodeBean;
import com.ojt.bean.ProjectBean;
import com.ojt.bean.ProjectMemberBean;
import com.ojt.service.ProjectService;

public class ProjectValidator implements Validator{
	
	private final String REGEXP_PATTERN_DATE = "^[\\d]{4}\\-(0[1-9]|1[012])\\-(0[1-9]|[12][0-9]|3[01])$";
	
	private ProjectService projectService;
	
	public ProjectValidator() { }
	
	public ProjectValidator(ProjectService projectService) {
		this.projectService = projectService;
	}
	
	@Override
	public boolean supports(Class<?> clazz) {
		return ProjectBean.class.isAssignableFrom(clazz);
	}

	@Override
	public void validate(Object target, Errors errors) {
		
		if(errors.getObjectName().equals("addProjectBean")) { // 이름이 'addProjectBean'인 객체
			
			ProjectBean addProjectBean = (ProjectBean)target; // 객체 주입
			
			// 밸리데이션을 위해 값을 하나씩 꺼냄
			String prj_nm = addProjectBean.getProjectName();
			int cust_seq = addProjectBean.getCustomerNumber();
			String prj_st_dt = addProjectBean.getProjectStartDate();
			String prj_ed_dt = addProjectBean.getProjectEndDate();
			String maint_st_dt = addProjectBean.getMaintStartDate();
			String maint_ed_dt = addProjectBean.getMaintEndDate();
			String[] sk_cd_list = addProjectBean.getSkillCodeList();
			String prj_dtl = addProjectBean.getProjectDetail();
			ArrayList<ProjectMemberBean> pmList = addProjectBean.getPmList();
			
			
			// ================== 프로젝트 명 =================
			if(prj_nm == null || prj_nm.isEmpty()) { // 프로젝트명이 비어있다면
				errors.rejectValue("projectName", "NameEmpty");
			}
			else if(prj_nm.length() > 20) { // 프로젝트명이 너무 길다면
				errors.rejectValue("projectName", "NameTooLong");
			}
			
			// ================== 고객사 ==================
			if(cust_seq == 0) { // 고객사 번호가 0이라면(= 없다면)
				errors.rejectValue("customerNumber", "CustomerEmpty");
			}
			else if(projectService.hasCustomer(cust_seq)) { // 등록된 고객사가 없다면
				errors.rejectValue("customerNumber", "NotCustomer");
			}
			
			// ================= 프로젝트 시작일 ====================
			if(prj_st_dt == null || prj_st_dt.isEmpty()) { // 시작일이 비어있다면
				errors.rejectValue("projectStartDate", "DateEmpty");
			}
			else if(!Pattern.matches(REGEXP_PATTERN_DATE, prj_st_dt)) { // 패턴에 맞지 않다면
				errors.rejectValue("projectStartDate", "DatePattern");
			}
			else {
				int year = Integer.parseInt(prj_st_dt.substring(0, 4));
				int month = Integer.parseInt(prj_st_dt.substring(5,7));
				int day = Integer.parseInt(prj_st_dt.substring(8));
				
				switch(month) {
				case 1: case 3: case 5: case 7: case 8: case 10: case 12:
					if(day > 31) {
						errors.rejectValue("projectStartDate", "DateOver31Day");
					} break;
					
				case 4: case 6: case 9: case 11:
					if(day > 30) {
						errors.rejectValue("projectStartDate", "DateOver30Day");
					} break;
				
				case 2:
					if(year % 4 == 0 && day > 29) {
						errors.rejectValue("projectStartDate", "DateOverLeapYear");
					}
					if(year % 4 != 0 && day > 28) {
						errors.rejectValue("projectStartDate", "DateOver28Day");
					} break;
				}
			}//End - prj_st_dt
			
			// ================= 프로젝트 종료일 ====================
			if (prj_ed_dt == null || prj_ed_dt.isEmpty()) { // 시작일이 비어있다면
				errors.rejectValue("projectEndDate", "DateEmpty");
			}
			else if (!Pattern.matches(REGEXP_PATTERN_DATE, prj_st_dt)) { // 패턴에 맞지 않다면
				errors.rejectValue("projectEndDate", "DatePattern");
			}
			else {
				int year = Integer.parseInt(prj_ed_dt.substring(0, 4));
				int month = Integer.parseInt(prj_ed_dt.substring(5, 7));
				int day = Integer.parseInt(prj_ed_dt.substring(8));

				switch(month) {
				case 1: case 3: case 5: case 7: case 8: case 10: case 12:
					if(day > 31) {
						errors.rejectValue("projectEndDate", "DateOver31Day");
					} break;
					
				case 4: case 6: case 9: case 11:
					if(day > 30) {
						errors.rejectValue("projectEndDate", "DateOver30Day");
					} break;
				
				case 2:
					if(year % 4 == 0 && day > 29) {
						errors.rejectValue("projectEndDate", "DateOverLeapYear");
					}
					if(year % 4 != 0 && day > 28) {
						errors.rejectValue("projectEndDate", "DateOver28Day");
					} break;
				}
			}//End - prj_ed_dt
			
			// 프로젝트 두개의 날짜를 비교
			if(!errors.hasFieldErrors("projectStartDate") && !errors.hasFieldErrors("projectEndDate")) {// 프로젝트 시작일ㅡ 종료일에 에라가 없다면
				LocalDate startDate = LocalDate.parse(prj_st_dt);
				LocalDate endDate = LocalDate.parse(prj_ed_dt);
				
				if(startDate.isAfter(endDate)) { // prj_st_dt가 prj_ed_dt보다 이후의 날짜라면
					errors.rejectValue("projectStartDate", "StartDateAfterEndDate");
				}
			}
			
			//================= 유지보수 시작일 ==================
			if(maint_st_dt != null && !maint_st_dt.isEmpty()) {
				
				if(!Pattern.matches(REGEXP_PATTERN_DATE, maint_st_dt)) {
					errors.rejectValue("maintStartDate", "DatePattern");
				}
				else {
					int year = Integer.parseInt(maint_st_dt.substring(0, 4));
					int month = Integer.parseInt(maint_st_dt.substring(5, 7));
					int day = Integer.parseInt(maint_st_dt.substring(8));
					
					switch(month) {
					case 1: case 3: case 5: case 7: case 8: case 10: case 12:
						if(day > 31) {
							errors.rejectValue("maintStartDate", "DateOver31Day");
						} break;
						
					case 4: case 6: case 9: case 11:
						if(day > 30) {
							errors.rejectValue("maintStartDate", "DateOver30Day");
						} break;
					
					case 2:
						if(year % 4 == 0 && day > 29) {
							errors.rejectValue("maintStartDate", "DateOverLeapYear");
						}
						if(year % 4 != 0 && day > 28) {
							errors.rejectValue("maintStartDate", "DateOver28Day");
						} break;
					}
				}
			}//End - maint_st_dt
			
			// ================== 유지보수 종료일 ===================
			if(maint_ed_dt != null && !maint_ed_dt.isEmpty()) {
				
				if(!Pattern.matches(REGEXP_PATTERN_DATE, maint_ed_dt)) {
					errors.rejectValue("maintEndDate", "DatePattern");
				}
				else {
					int year = Integer.parseInt(maint_ed_dt.substring(0, 4));
					int month = Integer.parseInt(maint_ed_dt.substring(5, 7));
					int day = Integer.parseInt(maint_ed_dt.substring(8));
					
					switch(month) {
					case 1: case 3: case 5: case 7: case 8: case 10: case 12:
						if(day > 31) {
							errors.rejectValue("maintEndDate", "DateOver31Day");
						} break;
						
					case 4: case 6: case 9: case 11:
						if(day > 30) {
							errors.rejectValue("maintEndDate", "DateOver30Day");
						} break;
					
					case 2:
						if(year % 4 == 0 && day > 29) {
							errors.rejectValue("maintEndDate", "DateOverLeapYear");
						}
						if(year % 4 != 0 && day > 28) {
							errors.rejectValue("maintEndDate", "DateOver28Day");
						} break;
					}
				}
				// 유지보수 두 날짜 비교
				if(!errors.hasFieldErrors("maintStartDate") && !errors.hasFieldErrors("maintEndDate")) {// 유지보수 시작일, 종료일에 에러가 없다면
					
					if(maint_st_dt == null || maint_st_dt.isEmpty()) { // 유지보수 시작일이 비어 있다면
						errors.rejectValue("maintStartDate", "MaintStartDateEmpty");
					} else {
						LocalDate startDate = LocalDate.parse(maint_st_dt);
						LocalDate endDate = LocalDate.parse(maint_ed_dt);
						
						if(startDate.isAfter(endDate)) {
							errors.rejectValue("maintStartDate", "StartDateAfterEndDate");
						}
					}
				}
				
			}//End - maint_ed_dt
			
			System.out.println("프로젝트 시작일 : " + !errors.hasFieldErrors("projectStartDate"));
			System.out.println("프로젝트 종료일 : " + !errors.hasFieldErrors("projectEndDate"));
			System.out.println("유지보수 시작일 : " + !errors.hasFieldErrors("maintStartDate"));
			System.out.println("유지보수 종료일 : " + !errors.hasFieldErrors("maintEndDate"));
			
			if(!errors.hasFieldErrors("projectStartDate") && !errors.hasFieldErrors("projectEndDate") // 프로젝트 시작일 종료일에 에러가 없고
					&& !errors.hasFieldErrors("maintStartDate") && !errors.hasFieldErrors("maintEndDate")) {// 유지보수 시작일, 종료일에 에러가 없다면
				LocalDate projectEndDate = LocalDate.parse(prj_ed_dt);
				
				if(maint_st_dt != null && !maint_st_dt.isEmpty() && maint_ed_dt != null && !maint_ed_dt.isEmpty()) {
					LocalDate maintStartDate = LocalDate.parse(maint_st_dt);
					LocalDate maintEndDate = LocalDate.parse(maint_ed_dt);
					
					if(maintStartDate.isBefore(projectEndDate)) {
						errors.rejectValue("maintStartDate", "MaintStartDateBeforeProjectStart");
					}
					
					if(maintEndDate.isBefore(projectEndDate)) {
						errors.rejectValue("maintEndDate", "MaintEndDateBeforeProjectStart");
					} 
				} else if(maint_st_dt != null && !maint_st_dt.isEmpty()) {
					LocalDate maintStartDate = LocalDate.parse(maint_st_dt);
					
					if(maintStartDate.isBefore(projectEndDate)) {
						errors.rejectValue("maintStartDate", "MaintStartDateBeforeProjectStart");
					}
				}
				
			}
			
			// ================= 프로젝트 스킬 ===================
			if(sk_cd_list != null && sk_cd_list.length > 0) {// 프로젝트 스킬이 존재한다면
				if(projectService.hasSkill(sk_cd_list, sk_cd_list.length)) { //프로젝트 스킬이 모두 존재하는지
					errors.rejectValue("skillCodeList", "NotSkill");
				}
			}
			
			// ================= 프로젝트 세부사항 ===================
			if(prj_dtl != null && !prj_dtl.isEmpty()) {
				if(prj_dtl.length() > 500) {
					errors.rejectValue("projectDetail", "ProjectDetailTooLong");
				}
			}
			
			// ================= 프로젝트 멤버 ====================
			if(pmList != null && pmList.size() > 0) {
				ArrayList<CodeBean> roleList = projectService.getRole();
				ArrayList<String> roleCdList = new ArrayList<String>();
				
				for(int i = 0; i < roleList.size(); i++) {
					roleCdList.add(roleList.get(i).getDetailCode());
				}
				
				for(ProjectMemberBean pm : pmList) {
					
					int mem_seq = pm.getMemberNumber();
					String st_dt = pm.getStartDate();
					String ed_dt = pm.getEndDate();
					String ro_cd = pm.getRoleCode();
					
					if(mem_seq == 0) {// 사원 번호가 0인지( = 비어있는지)
						errors.rejectValue("MemberNumberError", "Empty");
					}
					
					if(st_dt == null || st_dt.isEmpty() && !errors.hasFieldErrors("startDateError")) {// 투입일이 비어있는지
						errors.rejectValue("startDateError", "Empty");
					} else if(!Pattern.matches(REGEXP_PATTERN_DATE, st_dt) && !errors.hasFieldErrors("st_dt_error")) { // 투입일이 날짜 형식인지
						errors.rejectValue("startDateError", "Pattern");
					}
					
					if(ed_dt == null || ed_dt.isEmpty() && !errors.hasFieldErrors("endDateError")) { // 철수일이 비어있는지
						errors.rejectValue("endDateError", "Empty");
					} else if(!Pattern.matches(REGEXP_PATTERN_DATE, ed_dt) && !errors.hasFieldErrors("ed_dt_error")) { // 철수일이 날짜 형식인지
						errors.rejectValue("endDateError", "Pattern");
					}
					
					if(!roleCdList.contains(ro_cd)) {// 역할 전체 리스트내에 해당코드가 존재하는지
						errors.rejectValue("roleCodeError", "NotRole");
					}
					
					// 프로젝트 시작일, 종료일(유지보수 종료일)과 비교
					if(!errors.hasFieldErrors("startDateError") && !errors.hasFieldErrors("endDateError")
							&& !errors.hasFieldErrors("projectStartDate") && !errors.hasFieldErrors("projectEndDate")
							&& !errors.hasFieldErrors("maintEndDate")) { //투입일, 철수일, 시작일, 종료일, 유지보수 종료일 모두 에러가 없다면
						
						if(maint_ed_dt != null && !maint_ed_dt.isEmpty()) {
							LocalDate memberStartDate = LocalDate.parse(st_dt);
							LocalDate memberEndDate = LocalDate.parse(ed_dt);
							LocalDate projectStartDate = LocalDate.parse(prj_st_dt);
							LocalDate mainEndDate = LocalDate.parse(maint_ed_dt);
							
							if(memberStartDate.isBefore(projectStartDate)) { // 프로젝트 시작일 보다 작은지
								errors.rejectValue("startDateError", "MemberBeforeStartDate");
							} else if(memberStartDate.isAfter(mainEndDate)) { // 유지보수 종료일 보다 큰지
								errors.rejectValue("startDateError", "MemberAfterMaintEndDate");
							}
							
							if(memberEndDate.isBefore(projectStartDate)) { // 프로젝트 시작일 보다 작은지
								errors.rejectValue("endDateError", "MemberBeforeStartDate");
							} else if(memberEndDate.isAfter(mainEndDate)) { // 유지보수 종료일 보다 큰지
								errors.rejectValue("endDateError", "MemberAfterMaintEndDate");
							}
						} else if(maint_st_dt == null || maint_st_dt.isEmpty()) {
							
							LocalDate memberStartDate = LocalDate.parse(st_dt);
							LocalDate memberEndDate = LocalDate.parse(ed_dt);
							LocalDate projectStartDate = LocalDate.parse(prj_st_dt);
							LocalDate projectEndDate = LocalDate.parse(prj_ed_dt);
							
							if(memberStartDate.isBefore(projectStartDate)) { // 프로젝트 시작일 보다 작은지
								errors.rejectValue("startDateError", "MemberBeforeStartDate");
							} else if(memberStartDate.isAfter(projectEndDate)) { // 프로젝트 종료일 보다 큰지
								errors.rejectValue("startDateError", "MemberAfterEndDate");
							}
							
							if(memberEndDate.isBefore(projectStartDate)) { // 프로젝트 시작일 보다 작은지
								errors.rejectValue("endDateError", "MemberBeforeStartDate");
							} else if(memberEndDate.isAfter(projectEndDate)) { // 프로젝트 종료일 보다 큰지
								errors.rejectValue("endDateError", "MemberAfterEndDate");
							}
						} else {
							LocalDate memberStartDate = LocalDate.parse(st_dt);
							LocalDate memberEndDate = LocalDate.parse(ed_dt);
							LocalDate projectStartDate = LocalDate.parse(prj_st_dt);
							
							if(memberStartDate.isBefore(projectStartDate)) {// 프로젝트 시작일 보다 작은지
								errors.rejectValue("startDateError", "MemberBeforeStartDate");
							}
							
							if(memberEndDate.isBefore(projectStartDate)) {// 프로젝트 시작일 보다 작은지
								errors.rejectValue("endDateError", "MemberBeforeStartDate");
							}
						}
					}
				}
				
			}
			
		}//End - addProjectbean
		
	}//End - validate

}
