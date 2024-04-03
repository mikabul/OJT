package com.ojt.bean;

import java.util.ArrayList;
import java.util.Arrays;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ProjectBean {

	private int projectNumber;							// 프로젝트 번호
	private String projectName;							// 프로젝트 이름
	private int customerNumber;							// 고객사 번호
	private String projectStartDate;						// 프로젝트 시작일
	private String projectEndDate;						// 프로젝트 종료일
	private String projectDetail;							// 프로젝트 상세 정보
	private String projectStateCode;							// 프로젝트 상태 코드
	private String maintStartDate;						// 유지보수 시작일
	private String maintEndDate;						// 유지보수 종료일
	
	private String customerName; 						// 고객사 이름
	private String[] skillCodeList;						// 필요기술 배열
	private ArrayList<CodeBean> projectSkillList;		// 필요기술 리스트
	private String projectStateName; 					// 프로젝트 상태
	
	private ArrayList<ProjectMemberBean> pmList; 	// 프로젝트 멤버 리스트
	// pmList 유효성 검사결과를 받기위한 변수
	private String memberNumberError;
	private String startDateError;
	private String endDateError;
	private String roleCodeError;
	
	@Override
	public String toString() {
		return "ProjectBean [projectNumber=" + projectNumber + ", projectName=" + projectName + ", customerNumber="
				+ customerNumber + ", projectStartDate=" + projectStartDate + ", projectEndDate=" + projectEndDate
				+ ", projectDetail=" + projectDetail + ", projectStateCode=" + projectStateCode + ", maintStartDate="
				+ maintStartDate + ", maintEndDate=" + maintEndDate + ", customerName=" + customerName
				+ ", skillCodeList=" + Arrays.toString(skillCodeList) + ", projectSkillList=" + projectSkillList
				+ ", projectStateName=" + projectStateName + ", pmList=" + pmList + ", memberNumberError="
				+ memberNumberError + ", startDateError=" + startDateError + ", endDateError=" + endDateError
				+ ", roleCodeError=" + roleCodeError + "]";
	}
	
}
