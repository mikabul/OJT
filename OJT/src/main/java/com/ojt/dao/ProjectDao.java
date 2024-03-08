package com.ojt.dao;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.ojt.bean.CustomerBean;
import com.ojt.bean.MemberBean;
import com.ojt.bean.ProjectBean;
import com.ojt.bean.ProjectMemberBean;
import com.ojt.mapper.ProjectMapper;

@Repository
public class ProjectDao {

	@Autowired
	private ProjectMapper projectMapper;
	
	//=========== 프로젝트 ============
	// 프로젝트 검색
	public ArrayList<ProjectBean> searchProjectList(String prj_nm, String optionalQuery, int index, int endIndex){
		return projectMapper.searchProjectList(prj_nm, optionalQuery, index, endIndex);
	}
	
	// 프로젝트 검색 - 페이징 처리
	// 같은 조건으로 검색시의 최대 개수
	public int searchProjectListMaxCount(String prj_nm, String optionalQuery){
		return projectMapper.searchProjectListMaxCount(prj_nm, optionalQuery);
	}
	
	// select2의 데이터 리스트
	public ArrayList<CustomerBean> getCustomerList(String cust_nm){
		return projectMapper.getCustomerList(cust_nm);
	}
	
	// 프로젝트 등록
	public void insertProject(ProjectBean insertProjectBean) {
		projectMapper.insertProject(insertProjectBean);
	}
	
	// 프로젝트 상태 수정
	public void updateProjectState(ProjectBean updateProjectBean) {
		projectMapper.updateProjectState(updateProjectBean);
	}
	
	// 프로젝트 수정
	public void updateProject(ProjectBean updateProjectBean) {
		projectMapper.updateProject(updateProjectBean);
	}
	
	// 프로젝트 삭제
	public void deleteProject(int prj_seq) {
		projectMapper.deleteProject(prj_seq);
	}
	
	//========== 프로젝트 필요 기술 ===========
	// 프로젝트 필요기술 조회
	public String[] getProjectSKList(String sk_cd) {
		return projectMapper.getProjectSKList(sk_cd);
	}
	
	// 프로젝트 필요기술 등록
	public void insertProjectSK(int prj_seq, String sk_cd) {
		projectMapper.insertProjectSK(prj_seq, sk_cd);
	}
	
	// 프로젝트 필요기술 삭제
	public void deleteProjectSK(int prj_seq) {
		projectMapper.deleteProjectSK(prj_seq);
	}
	
	//============== 프로젝트 멤버 ====================
	// 프로젝트 멤버 조회
	public ArrayList<ProjectMemberBean> getProjectMemberList(int prj_seq){
		return projectMapper.getProjectMemberList(prj_seq);
	}
	
	// 프로젝트 멤버 인원 등록 조회
	public ArrayList<MemberBean> searchNotProjectMember(int prj_seq, String mem_nm){
		return projectMapper.searchNotProjectMember(prj_seq, mem_nm);
	}
	
	// 프로젝트 멤버 등록
	public void insertProjectMember(ProjectMemberBean insertProjectMemberBean) {
		projectMapper.insertProjectMember(insertProjectMemberBean);
	}
	
	// 프로젝트 멤버 수정
	public void updateProjectMember(ProjectMemberBean updateProjectMemberBean) {
		projectMapper.updateProjectMember(updateProjectMemberBean);
	}
	
	// 프로젝트 멤버 삭제
	public void deleteProjectMember(ProjectMemberBean deleteProjectMemberBean) {
		projectMapper.deleteProjectMember(deleteProjectMemberBean);
	}
}
