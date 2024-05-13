package com.ojt.dao;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.ojt.bean.MemberBean;
import com.ojt.bean.ProjectMemberBean;
import com.ojt.bean.SearchMemberBean;
import com.ojt.mapper.MemberMapper;

@Repository
public class MemberDao {
	
	@Autowired
	MemberMapper memberMapper;

	// 멤버 검색
	public ArrayList<MemberBean> searchMember(SearchMemberBean searchMemberBean){
		return memberMapper.searchMember(searchMemberBean);
	}
	
	// 멤버 검색 결과 최대 개수
	public int searchMemberMaxCount(SearchMemberBean searchMemberBean) {
		return memberMapper.searchMemberMaxCount(searchMemberBean);
	}
	
	// 사원 상세정보
	public MemberBean getDetailMemberInfo(int memberNumber) {
		return memberMapper.getDetailMemberInfo(memberNumber);
	}

	// 사원이 참여중이 프로젝트
	public ArrayList<ProjectMemberBean> getMemberProject(int memberNumber){
		return memberMapper.getMemberProject(memberNumber);
	}
	
	// 사원 아이디 중복 체크
	public int checkMemberId(String memberId) {
		return memberMapper.checkMemberId(memberId);
	}
	
	// 사원의 다음 시퀀스 번호를 가져옴
	public int getNextMemberSequence() {
		return memberMapper.getNextMemberSequence();
	}
	
	/*
	 * 멤버 등록
	 * 멤버
	 * 주소
	 * 회사 관련 정보
	 * 보유 기술
	 */
	public void addMember(MemberBean addMemberBean) {
		memberMapper.addMember(addMemberBean);
	}
	public void addMemberAddress(MemberBean addMemberBean) {
		memberMapper.addMemberAddress(addMemberBean);
	}
	public void addMemberCompany(MemberBean addMemberBean) {
		memberMapper.addMemberCompany(addMemberBean);
	}
	public void addMemberSkill(int memberNumber, String skillCode) {
		memberMapper.addMemberSkill(memberNumber, skillCode);
	}
	
	// 해당 기술이 전부 있는지
	public int hasSkills(ArrayList<String> skills) {
		return memberMapper.hasSkills(skills);
	}
	
	// 사원 아이디 중복체크(수정)
	public int modifyMatchId(int memberNumber, String memberId) {
		return memberMapper.modifyMatchId(memberNumber, memberId);
	}
	
	/** 사원 정보 수정 **/
	// 사원 개인 정보 수정
	public void memberInfoUpdate(MemberBean modifyMemberBean) {
		memberMapper.memberInfoUpdate(modifyMemberBean);
	}
	// 사원 주소 수정
	public void memberAddressUpdate(MemberBean modifyMemberBean) {
		memberMapper.memberCompanyUpdate(modifyMemberBean);
	}
	// 사원 회사 정보 수정
	public void memberCompanyUpdate(MemberBean modifyMemberBean) {
		memberMapper.memberCompanyUpdate(modifyMemberBean);
	}
	// 사원 보유 기술 삭제
	public void deleteMemberSkill(int memberNumber) {
		memberMapper.deleteMemberSkill(memberNumber);
	}
	
	// 사원 삭제
	public void deleteMember(int[] memberNumbers) {
		memberMapper.deleteMember(memberNumbers);
	}
	
	// 사원이 참여중이지 않는 프로젝트 리스트
	public ArrayList<ProjectMemberBean> nonParticipatingProjects(int memberNumber) {
		return memberMapper.nonParticipatingProjects(memberNumber);
	}
	
	// 프로젝트와 사원이 모두 존재하며 프로젝트(유지보수) 시작일, 종료일이 올바른 값인지
	public int validProjectAndMember(ProjectMemberBean projectMemberBean) {
		return memberMapper.validProjectAndMember(projectMemberBean);
	}
	
	// 사원 프로젝트 추가
	public void addMemberProject(ArrayList<ProjectMemberBean> projectMemberBeans) {
		memberMapper.addMemberProject(projectMemberBeans);
	}
	
	// 사원 프로젝트 수정
	public void updateMemberProject(ProjectMemberBean projectMemberBean) {
		memberMapper.updateMemberProject(projectMemberBean);
	}
	
	// 사원 프로젝트 삭제
	public void deleteMemberProject(int[] projectNumbers, int memberNumber) {
		memberMapper.deleteMemberProject(projectNumbers, memberNumber);
	}
}
