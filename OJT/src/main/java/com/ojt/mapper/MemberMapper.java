package com.ojt.mapper;

import java.util.ArrayList;

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
	
	// 사원이 참여중이 프로젝트
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
	 */
	public void addMember(MemberBean addMemberBean);
	public void addMemberAddress(MemberBean addMemberBean);
	public void addMemberCompany(MemberBean addMemberBean);
	
}
