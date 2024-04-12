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
	
}
