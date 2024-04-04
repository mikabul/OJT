package com.ojt.dao;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.ojt.bean.MemberBean;
import com.ojt.bean.ProjectMemberBean;
import com.ojt.mapper.ProjectMapper;
import com.ojt.mapper.ProjectMemberMapper;

@Repository
public class ProjectMemberDao {
	
	@Autowired
	private ProjectMemberMapper projectMemberMapper;

	// ============== 프로젝트 멤버 ====================
	// 프로젝트 멤버 조회
	public ArrayList<ProjectMemberBean> getProjectMemberList(int prj_seq) {
		return projectMemberMapper.getProjectMemberList(prj_seq);
	}

	// 프로젝트 멤버 인원 등록 조회
	public ArrayList<MemberBean> searchNotProjectMember(int projectNumber, String memberName) {
		return projectMemberMapper.searchNotProjectMember(projectNumber, memberName);
	}

	// 신규 프로젝트 멤버 인원 등록 조회
	public ArrayList<MemberBean> getNotAddProjectMember(String str, int[] memberNumbers) {
		return projectMemberMapper.getNotAddProjectMember(str, memberNumbers);
	}
	
	// 멤버가 모두 존재하는지
	public int hasMember(int[] memberNumbers) {
		return projectMemberMapper.hasMember(memberNumbers);
	}

	// 프로젝트 멤버 등록
	public void insertProjectMember(ProjectMemberBean insertProjectMemberBean) {
		projectMemberMapper.insertProjectMember(insertProjectMemberBean);
	}

	// 프로젝트 멤버 수정
	public void updateProjectMember(ProjectMemberBean updateProjectMemberBean) {
		projectMemberMapper.updateProjectMember(updateProjectMemberBean);
	}
	
	public int hasProjectMemberCount(int[] memberNumbers, int projectNumber) {
		return projectMemberMapper.hasProjectMemberCount(memberNumbers, projectNumber);
	}

	// 프로젝트 멤버 삭제
	public void deleteProjectMember(int[] memberNumbers, int projectNumber) {
		projectMemberMapper.deleteProjectMember(memberNumbers, projectNumber);
	}

}
