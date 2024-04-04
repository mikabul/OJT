package com.ojt.bean;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class MemberBean {

	private int memberNumber;					// 사원 번호mem_seq, mmemberNumber
	private String memberName;					// 사원 이름
	private String memberId;					// 아이디
	private String memberPW;					// 비밀번호
	private String memberPW2;					// 확인용 비밀번호
	private String memberRnnPrefix;			// 주민등록번호 앞자리
	private String memberRnnsuffix;			// 주민등록번호 뒷자리
	private String tel;					// 연락처
	private String phone;				// 휴대전화
	private String email;				// 이메일
	private String genderCode;					// 성별 코드
	private String departmentCode;					// 부서 코드
	private String positionCode;					// 직급 코드
	private String zoneCode;			// 우편번호
	private String address;				// 주소
	private String detailAddress;			// 상세주소
	private String extraAddress;			// 참고주소
	private String picture;					// 사진경로
	private String statusCode;					// 재직 상태 코드
	private String hireDate;			// 입사일
	private String resignationDate;	//퇴사일
	
	private String gender;					//성별
	private String department; 					// 부서
	private String position; 				// 직급
	private String[] skillList; 				// 보유 기술 목록
	
	private boolean loginState;
	
	@Override
	public String toString() {
		return "번호 : " + memberNumber + ", 이름 : " + memberName + ", 부서 : " + department + ", 직급 : " + position + "\n";
	}
}
