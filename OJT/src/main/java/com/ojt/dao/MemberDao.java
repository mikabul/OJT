package com.ojt.dao;

import java.util.ArrayList;

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
}
