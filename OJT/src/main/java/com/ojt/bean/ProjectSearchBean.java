package com.ojt.bean;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class ProjectSearchBean {

	private String name;				// 프로젝트 명
	private int customer;				// 고객사 번호
	private int dateType;			// 시작일(종료일)
	private String firstDate;			// 첫번째 날짜
	private String secondDate;			// 두번째 날짜
	private int[] state;				// 프로젝트 상태
	
	private int view;				// 한페이지에 표시할 개수
	
	public ProjectSearchBean() {
		name = "";
		customer = 0;
		dateType = 0;
		firstDate = "";
		secondDate = "";
		view = 3;
	}	
}
