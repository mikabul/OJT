package com.ojt.bean;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class MemberBean {

	private int mem_seq;					// 사원 번호
	private String mem_nm;					// 사원 이름
	private String mem_id;					// 아이디
	private String mem_pw;					// 비밀번호
	private String mem_pw2;					// 확인용 비밀번호
	private String mem_rrn_prefix;			// 주민등록번호 앞자리
	private String mem_rrn_suffix;			// 주민등록번호 뒷자리
	private String mem_tel;					// 연락처
	private String mem_phone;				// 휴대전화
	private String mem_email;				// 이메일
	private String gd_cd;					// 성별 코드
	private String dp_cd;					// 부서 코드
	private String ra_cd;					// 직급 코드
	private String mem_zoneCode;			// 우편번호
	private String mem_addr;				// 주소
	private String mem_detailAddr;			// 상세주소
	private String mem_extraAddr;			// 참고주소
	private String mem_pic;					// 사진경로
	private String st_cd;					// 재직 상태 코드
	private String mem_hire_date;			// 입사일
	private String mem_resignation_date;	//퇴사일
	
	private String gender;					//성별
	private String dept; 					// 부서
	private String position; 				// 직급
	private String[] sk_nm; 				// 보유 기술 목록
	
	private boolean loginState;
	
}
