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
		public ArrayList<ProjectMemberBean> getProjectMemberList(int projectNumber);
		
		// 프로젝트 멤버 인원 등록 조회
		public ArrayList<MemberBean> searchNotProjectMember(
				@Param("projectNumber") int projectNumber,
				@Param("memberName") String memberName);
		
		// 신규 프로젝트 멤버 인원 등록 조회
		public ArrayList<MemberBean> getNotAddProjectMember(@Param("str") String str, 
															@Param("memberNumbers") int[] memberNumbers);
		
		// 멤버가 모두 존재하는지
		public int hasMember(@Param("memberNumbers")int[] memberNumbers);
		
		// 프로젝트 멤버 등록
		public void insertProjectMember(ProjectMemberBean insertProjectMemberBean);
		
		// 프로젝트 멤버 수정
		public void updateProjectMember(ProjectMemberBean updateProjectMemberBean);
		
		// 프로젝트 멤버 모두 있는지 확인
		public int hasProjectMemberCount(
				@Param("memberNumbers") int[] memberNumbers,
				@Param("projectNumber") int projectNumber);
		
		// 프로젝트 멤버 삭제
		public void deleteProjectMember(
				@Param("memberNumbers") int[] memberNumbers,
				@Param("projectNumber") int projectNumber);
		
}
