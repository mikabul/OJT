package com.ojt.bean;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class ProjectMemberBean {
	
	private int projectNumber;		// 프로젝트 번호
	private String projectName;		// 프로젝트 이름
	private String customerName;	// 고객사 이름
	private int memberNumber; 		// 사원 번호
	private String memberName; 		// 사원 이름
	private String startDate; 		// 투입일
	private String endDate; 		// 철수일
	private String roleCode; 		// 역할 코드
	
	private String department; 		// 부서
	private String position; 		// 직급
	private String roleName;		// 역할
	
	private String projectStartDate;		// 프로젝트 시작일
	private String projectEndDate;			// 프로젝트 종료일
	private String projectMaintStartDate;	// 프로젝트 유지보수 시작일
	private String projectMaintEndDate;		// 프로젝트 유지보수 종료일
	
	private int index;						// validation index
	private String validProjectAndMember;   // Member And Project Validation
	
	public ProjectMemberBean() {
		projectStartDate = "";
		projectEndDate = "";
		projectMaintStartDate = "";
		projectMaintEndDate = "";
	}
}
