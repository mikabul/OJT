package com.ojt.bean;

import org.springframework.web.multipart.MultipartFile;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
@NoArgsConstructor
public class MemberBean {

	private int memberNumber;					// 사원 번호mem_seq, mmemberNumber
	private String memberName;					// 사원 이름
	private String memberId;					// 아이디
	private String memberPW;					// 비밀번호
	private String memberPW2;					// 확인용 비밀번호
	private String memberRrnPrefix;				// 주민등록번호 앞자리
	private String memberRrnSuffix;				// 주민등록번호 뒷자리
	private String tel;							// 연락처
	private String phone;						// 휴대전화
	private String email;						// 이메일
	private String genderCode;					// 성별 코드
	private String departmentCode;				// 부서 코드
	private String positionCode;				// 직급 코드
	private String zoneCode;					// 우편번호
	private String address;						// 주소
	private String detailAddress;				// 상세주소
	private String extraAddress;				// 참고주소
	private String pictureDir;					// 사진경로
	private String statusCode;					// 재직 상태 코드
	private String hireDate;					// 입사일
	private String resignationDate;				// 퇴사일
	
	private String gender;						// 성별
	private String department; 					// 부서
	private String position; 					// 직급
	private String status;						// 재직 상태
	private String[] skills; 					// 보유 기술 배열
	private String[] skillCodes;				// 보유 기술 코드 배열
	private MultipartFile memberImage;			// 사진
	
	private boolean loginState;					// 로그인 상태
	
}
