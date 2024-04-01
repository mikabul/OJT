package com.ojt.dao;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.ojt.bean.MemberBean;
import com.ojt.bean.ProjectMemberBean;
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
	public ArrayList<MemberBean> searchNotProjectMember(int prj_seq, String mem_nm) {
		return projectMemberMapper.searchNotProjectMember(prj_seq, mem_nm);
	}

	// 신규 프로젝트 멤버 인원 등록 조회
	public ArrayList<MemberBean> getNotAddProjectMember(String str, int[] memberNumbers) {
		return projectMemberMapper.getNotAddProjectMember(str, memberNumbers);
	}

	// 프로젝트 멤버 등록
	public void insertProjectMember(ProjectMemberBean insertProjectMemberBean) {
		projectMemberMapper.insertProjectMember(insertProjectMemberBean);
	}

	// 프로젝트 멤버 수정
	public void updateProjectMember(ProjectMemberBean updateProjectMemberBean) {
		projectMemberMapper.updateProjectMember(updateProjectMemberBean);
	}

	// 프로젝트 멤버 삭제
	public void deleteProjectMember(ProjectMemberBean deleteProjectMemberBean) {
		projectMemberMapper.deleteProjectMember(deleteProjectMemberBean);
	}

}
