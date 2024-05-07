package com.ojt.validator;

import java.util.ArrayList;
import java.util.regex.Pattern;

import org.springframework.validation.Errors;
import org.springframework.validation.Validator;
import org.springframework.web.multipart.MultipartFile;

import com.ojt.bean.MemberBean;
import com.ojt.service.MemberService;

public class MemberValidator implements Validator{
	
	MemberService memberService;
	
	private final String REGXP_KORNAME_PATTERN = "^[가-힣]+$";
	private final String REGXP_ENGNAME_PATTERN = "^[a-zA-Z ]+$";
	private final String REGXP_ID_PATTERN = "^[a-zA-Z0-9]+$";
	private final String REGXP_PW_PATTERN = "^[a-zA-Z0-9!@\\^]+$";
	private final String REGXP_RNNPREFIX_PATTERN = "^\\d{2}(0[1-9]|1[0-2])(0[1-9]|[1-2]\\d|3[0-1])$";
	private final String REGXP_RNNSUFFIX_PATTERN = "^(1|2|3|4)\\d{6}$";
	private final String REGXP_TEL_PATTERN = "^(01[016789])-(\\d{3,4})-(\\d{4})|(\\d{2,3})-(\\d{3,4})-(\\d{4})$";
	private final String REGXP_EMAIL_PATTERN = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$";
	private final String REGXP_DATE_PATTERN = "^\\d{4}-(0[1-9]|1[0-2])-(0[1-9]|[1-2]\\d|3[0-1])$";
	private final String REGXP_ZONECODE_PATTERN = "^\\d{5}$";

	public MemberValidator(MemberService memberService) {
		this.memberService = memberService;
	}
	
	@Override
	public boolean supports(Class<?> clazz) {
		return MemberBean.class.isAssignableFrom(clazz);
	}

	@Override
	public void validate(Object target, Errors errors) {
		
		String targetName = errors.getObjectName(); // 현재 객체의 이름
		MemberBean memberBean = (MemberBean)target; // 객체를 받아옴
		
		// 유효성 검사를 위한 코드 리스트들
		ArrayList<String> departmentCodes = memberService.getCodes("DP01"); 	// 부서 코드
		ArrayList<String> positionCodes = memberService.getCodes("RA01"); 		// 직급 코드
		ArrayList<String> genderCodes = memberService.getCodes("GD01"); 		// 성별 코드
		ArrayList<String> statusCodes = memberService.getCodes("ST01"); 		// 상태 코드
		
		String memberName = memberBean.getMemberName();
		String memberId = memberBean.getMemberId();
		String memberPW = memberBean.getMemberPW();
		String memberPW2 = memberBean.getMemberPW2();
		String memberRrnPrefix = memberBean.getMemberRrnPrefix();
		String memberRrnSuffix = memberBean.getMemberRrnSuffix();
		String tel = memberBean.getTel();
		String emTel = memberBean.getEmTel();
		String departmentCode = memberBean.getDepartmentCode();
		String positionCode = memberBean.getDepartmentCode();
		String genderCode = memberBean.getGenderCode();
		String statusCode = memberBean.getStatusCode();
		ArrayList<String> skills = memberBean.getSkills();
		String hireDate = memberBean.getHireDate();
		String resignationDate = memberBean.getResignationDate();
		String email = memberBean.getEmailPrefix() + "@" + memberBean.getEmailSuffix();
		String zoneCode = memberBean.getZoneCode();
		String address = memberBean.getAddress();
		String detailAddress = memberBean.getDetailAddress();
		String extraAddress = memberBean.getExtraAddress();
		MultipartFile memberImage = memberBean.getMemberImage();
		
		/*
		 * 사원명
		 * 비어있는지
		 * 한글이라면 2글자에서 6글자 사이인지
		 * 영어라면 5글자에서 20글자 사이인지
		 */
		if(memberName != null && !memberName.isEmpty()) {
			if(Pattern.matches(REGXP_KORNAME_PATTERN, memberName)) {
				if(memberName.length() > 6 || memberName.length() < 2) {
					errors.rejectValue("memberName", "KorLength");
				}
			} else if(Pattern.matches(REGXP_ENGNAME_PATTERN, memberName)) {
				if(memberName.length() > 20 || memberName.length() < 5) {
					errors.rejectValue("memberName", "EngLength");
				}
			} else { // 두개의 패턴모두 일치하지 않을때
				errors.rejectValue("memberName", "Pattern");
			}
		} else {
			errors.rejectValue("memberName", "Empty");
		}
		
		/*
		 * 사원 ID
		 * 비어있는지
		 * 패턴에 맞는지
		 * 5글자 에서 20글자 사이인지
		 */
		if(memberId == null || memberId.isEmpty()) {
			errors.rejectValue("memberId", "Empty");
		} else if(!Pattern.matches(REGXP_ID_PATTERN, memberId)){
			errors.rejectValue("memberId", "Pattern");
		} else if(memberId.length() > 20 || memberId.length() < 5) {
			errors.rejectValue("memberId", "Length");
		}
		
		/*
		 * 패스워드
		 * targetName이 modifyMemberBean 인지
		 * 비어있지 않은지
		 * 패턴에 맞는지
		 * 패스워드, 패스워드2가 일치하는지
		 * 최소 8글자 최대 20글자의 조건에 일치하는지
		 */
		if((targetName.equals("modifyMemberBean") && memberPW != null && !memberPW.isEmpty()) || targetName.equals("addMemberBean")) {
			if(memberPW != null && !memberPW.isEmpty()) {
				if(!Pattern.matches(REGXP_PW_PATTERN, memberPW)) {
					errors.rejectValue("memberPW", "Pattern");
				} else if(!memberPW.equals(memberPW2)) {
					errors.rejectValue("memberPW2", "Match");
				} else if(memberPW.length() < 8 && memberPW.length() > 20) {
					errors.rejectValue("memberPW", "Length");
				}
			} else {
				errors.rejectValue("memberPW", "Empty");
			}
		}
		
		/*
		 * 주민등록번호 앞자리
		 * 비어있지 않은지
		 * 패턴에 맞는지
		 */
		if(memberRrnPrefix != null && !memberRrnPrefix.isEmpty()) {
			if(!Pattern.matches(REGXP_RNNPREFIX_PATTERN, memberRrnPrefix)) {
				errors.rejectValue("memberRrn", "Pattern");
			}
		} else { //비어있다면
			errors.rejectValue("memberRrn", "Empty");
		}
		
		/*
		 * 주민등록번호 뒷자리
		 * 주민등록번호 앞자리에 에러가 없을때
		 * 주민등록번호 뒷자리가 비어있는지
		 * 주민등혹번호 뒷자리의 패턴이 일치하는지
		 */
		if(!errors.hasFieldErrors("memberRrn")) {
			if(memberRrnSuffix != null && !memberRrnSuffix.isEmpty()) {
				if(!Pattern.matches(REGXP_RNNSUFFIX_PATTERN, memberRrnSuffix)) {
					errors.rejectValue("memberRrn", "Pattern");
				}
			} else {
				errors.rejectValue("memberRrn", "Empty");
			}
		}
		
		/*
		 * 연락처
		 * 비어있지 않은지
		 * 패턴이 일치하는지
		 */
		if(tel != null && !tel.isEmpty()) {
			if(!Pattern.matches(REGXP_TEL_PATTERN, tel)) {
				errors.rejectValue("tel", "Pattern");
			}
		} else {
			errors.rejectValue("tel", "Empty");
		}
		
		/*
		 * 비상연락처
		 * 비어있지않다면 패턴이 일치하는지
		 */
		if(emTel != null && !tel.isEmpty()) {
			if(!Pattern.matches(REGXP_TEL_PATTERN, emTel)) {
				errors.rejectValue("emTel", "Pattern");
			}
		}
		
		// 해당 코드가 존재하는지
		if(!departmentCodes.contains(departmentCode)) { 	// 부서
			errors.rejectValue("departmentCode", "NotCode");
		}
		if(!positionCodes.contains(positionCode)) { 		// 직급
			errors.rejectValue("positionCode", "NotCode");
		}
		if(!genderCodes.contains(genderCode)) { 			// 성별
			errors.rejectValue("genderCode", "NotCode");
		}
		if(!statusCodes.contains(statusCode)) { 			// 상태
			errors.rejectValue("statusCode", "NotCode");
		}
		
		// 해당 기술들이 전부 있는지
		if(skills != null) {
			if(memberService.hasSkills(skills) != skills.size()) {
				errors.rejectValue("skills", "NotCode");
			}
		}
		
		/*
		 * 입사일
		 * 비어있지 않은지
		 * 패턴에 일치하는지
		 */
		if(hireDate != null && !hireDate.isEmpty()) {
			if(!Pattern.matches(REGXP_DATE_PATTERN, hireDate)) {
				errors.rejectValue("hireDate", "Pattern");
			}
		} else {
			errors.rejectValue("hireDate", "Empty");
		}
		
		/*
		 * 퇴사일
		 * 재직상태 코드가 3 이라면
		 * 비어있지 않은지
		 * 패턴에 일치하는지
		 */
		if(statusCode.equals("3")) {
			if(resignationDate != null && !resignationDate.isEmpty()) {
				if(!Pattern.matches(REGXP_DATE_PATTERN, resignationDate)) {
					errors.rejectValue("resignationDate", "Pattern");
				}
			} else {
				errors.rejectValue("resignationDate", "Empty");
			}
		}
		
		/*
		 * 이메일
		 * 비어있지 않다면
		 * 패턴이 일치하는지
		 * 길이가 31글자를 초과한다면 에러
		 */
		if(email.length() > 1) { // @ 가 기본으로 들어가므로 1을 초과하는 것을 조건으로함
			if(!Pattern.matches(REGXP_EMAIL_PATTERN, email)) {
				errors.rejectValue("email", "Pattern");
			} else if(email.length() > 31) {
				errors.rejectValue("email", "Length");
			}
		}
		
		/*
		 * 우편번호
		 * 비어있지 않은지
		 * 패턴이 일치하는지
		 */
		if(zoneCode != null && !zoneCode.isEmpty()) {
			if(!Pattern.matches(REGXP_ZONECODE_PATTERN, zoneCode)) {
				errors.rejectValue("address", "Pattern");
			}
		} else {
			errors.rejectValue("address", "ZoneCodeEmpty");
		}
		
		/*
		 * 주소
		 * 비어있지 않은지
		 * 길이가 40글자 초과한다면 에러
		 */
		if(address != null && !address.isEmpty()) {
			if(address.length() > 40) {
				errors.rejectValue("address", "Length");
			}
		} else {
			errors.rejectValue("address", "AddressEmpty");
		}
		
		/*
		 * 상세주소
		 * 길이가 30글자 이하인지
		 */
		if(detailAddress != null && detailAddress.length() > 30) {
			errors.rejectValue("address", "DetailLength");
		}
		
		/*
		 * 참고주소
		 * 길이가 10글자 이하인지
		 */
		if(extraAddress != null && extraAddress.length() > 10) {
			errors.rejectValue("address", "ExtraLength");
		}
		
		if(memberImage.getSize() != 0) {
			System.out.println(memberImage.getContentType().substring(0, 6));
			System.out.println(memberImage.getContentType());
			System.out.println(memberImage.getSize());
		}
	}

}
