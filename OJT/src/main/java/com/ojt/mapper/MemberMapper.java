package com.ojt.mapper;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Param;

import com.ojt.bean.MemberBean;
import com.ojt.bean.ProjectMemberBean;
import com.ojt.bean.SearchMemberBean;

public interface MemberMapper {
	
	// 멤버 검색
	public ArrayList<MemberBean> searchMember(SearchMemberBean searchMemberBean);
	
	// 멤버 검색 결과 최대 갯수
	public int searchMemberMaxCount(SearchMemberBean searchMemberBean);
	
	// 사원 상세정보
	public MemberBean getDetailMemberInfo(int memberNumber);
	
	// 사원이 참여중인 프로젝트
	public ArrayList<ProjectMemberBean> getMemberProject(int memberNumber);
	
	// 사원 아이디 중복체크
	public int checkMemberId(String memberId);
	
	// 사원의 다음 시퀀스 번호를 가져옴
	public int getNextMemberSequence();
	
	/*
	 * 멤버 등록
	 * 멤버
	 * 주소
	 * 회사 관련 정보
	 * 보유 기술
	 */
	public void addMember(MemberBean addMemberBean);
	public void addMemberAddress(MemberBean addMemberBean);
	public void addMemberCompany(MemberBean addMemberBean);
	public void addMemberSkill(@Param("memberNumber")int memberNumber, @Param("skillCode")String skillCode);
	
	// 해당 기술이 전부 있는지
	public int hasSkills(ArrayList<String> skills);
	
	// 사원 아이디 중복체크(수정)
	public int modifyMatchId(@Param("memberNumber")int memberNumber, @Param("memberId")String memberId);
	
	/** 사원 정보 수정 **/
	// 사원 개인 정보 수정
	public void memberInfoUpdate(MemberBean modifyMemberBean);
	// 사원 주소 수정
	public void memberAddressUpdate(MemberBean modifyMemberBean);
	// 사원 회사 정보 수정
	public void memberCompanyUpdate(MemberBean modifyMemberBean);
	// 사원 보유 기술 삭제
	public void deleteMemberSkill(int memberNumber);
	
	// 사원 삭제
	public void deleteMember(@Param("memberNumbers")int[] memberNumbers);
	
	// 사원 프로젝트 추가
	
	// 사원 프로젝트 수정
	
	
	// 사원 프로젝트 삭제
	public void deleteMemberProject(@Param("projectNumbers") int[] projectNumbers, @Param("memberNumber") int memberNumber);
}
