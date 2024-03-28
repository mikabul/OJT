package com.ojt.mapper;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.ojt.bean.MemberBean;
import com.ojt.bean.ProjectMemberBean;

@Mapper
public interface ProjectMemberMapper {
	
		// 프로젝트 멤버 조회
		public ArrayList<ProjectMemberBean> getProjectMemberList(int prj_seq);
		
		// 프로젝트 멤버 인원 등록 조회
		public ArrayList<MemberBean> searchNotProjectMember(@Param("prj_seq") int prj_seq, @Param("mem_nm") String mem_nm);
		
		// 신규 프로젝트 멤버 인원 등록 조회
		public ArrayList<MemberBean> getNotAddProjectMember(@Param("str") String str, 
															@Param("optionalQuery") String optionalQuery);
		
		// 프로젝트 멤버 등록
		public void insertProjectMember(ProjectMemberBean insertProjectMemberBean);
		
		// 프로젝트 멤버 수정
		public void updateProjectMember(ProjectMemberBean updateProjectMemberBean);
		
		// 프로젝트 멤버 삭제
		public void deleteProjectMember(ProjectMemberBean deleteProjectMemberBean);
		
}
