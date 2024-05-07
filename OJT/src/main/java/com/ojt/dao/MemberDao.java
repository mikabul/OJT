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
}
