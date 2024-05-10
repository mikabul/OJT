package com.ojt.bean;

import java.util.ArrayList;
import java.util.Arrays;

import org.springframework.web.multipart.MultipartFile;

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
	private String hashedMemberPW;				// sha256
	private String memberRrnPrefix;				// 주민등록번호 앞자리
	private String memberRrnSuffix;				// 주민등록번호 뒷자리
	private String hashedMemberRrnSuffix;		// sha256
	private String tel;							// 연락처
	private String emTel;						// 비상연락처
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
	
	private String emailPrefix;					// 첫번째 이메일
	private String emailSuffix;					// 두번째 이메일
	private String gender;						// 성별
	private String department; 					// 부서
	private String position; 					// 직급
	private String status;						// 재직 상태
	private String skillString;					// 보유 기술 나열
	private ArrayList<String> skills; 			// 보유 기술 리스트
	private String skillCodeString;				// 보유 기술 코드 나열
	private ArrayList<String> skillCodes;		// 보유 기술 코드 리스트
	private MultipartFile memberImage;			// 사진
	private String memberRrn;
	
	private boolean loginState;					// 로그인 상태
	
	public void setSkillString(String skillString) {
		this.skillString = skillString;
		skills = new ArrayList<String>(Arrays.asList(skillString.split(",")));
	}
	
	public void setSkillCodeString(String skillCodeString) {
		this.skillCodeString = skillCodeString;
		skillCodes = new ArrayList<String>(Arrays.asList(skillCodeString.split(",")));
	}
	
	public void setEmail(String email) {
		this.email = email;
		String[] splitEmail = email.split("@");
		if(splitEmail.length == 2) {
			emailPrefix = splitEmail[0];
			emailSuffix = splitEmail[1];
		} else {
			emailPrefix = email;
			emailSuffix = "";
		}
	}
	
}
