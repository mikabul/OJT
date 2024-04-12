package com.ojt.bean;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class SearchMemberBean {

	private String memberName;		// 사원명
	private String departmentCode;	// 부서 코드
	private String positionCode;	// 직급 코드
	private String firstDate;		// 첫 번째 날짜
	private String secondDate;		// 두 번째 날짜
	private String statusCode;		// 재직 상태 코드
	
	private int startIndex;			// 페이징 시작 값
	private int endIndex;			// 페이징 끝 값
	private int view;				// 한페이지 표시할 검색결과의 갯수
	
	public SearchMemberBean() {
		memberName = "";
		departmentCode = "";
		positionCode = "";
		firstDate = "";
		secondDate = "";
		statusCode = "";
		view = 3;
	}
}
