package com.ojt.dao;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.ojt.bean.CodeBean;
import com.ojt.bean.CustomerBean;
import com.ojt.bean.ProjectBean;
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
	public ArrayList<CustomerBean> getCustomerList(String customer){
		return projectMapper.getCustomerList(customer);
	}
	
	// 프로젝트 등록
	public void insertProject(ProjectBean insertProjectBean) {
		projectMapper.insertProject(insertProjectBean);
	}
	
	// 프로젝트 현재 시퀀스
	public int getPrj_seq() {
		return projectMapper.getPrj_seq();
	}
	
	// 프로젝트 정보
	public ProjectBean getProjectInfo(int prj_seq) {
		return projectMapper.getProjectInfo(prj_seq);
	}
	
	// 프로젝트 상태 리스트
	public ArrayList<CodeBean> getPsList(){
		return projectMapper.getPsList();
	}
	
	// 프로젝트 상태 리스트 String 배열
	public ArrayList<String> getStringListProjectState() {
		return projectMapper.getStringListProjectState();
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
	public ArrayList<CodeBean> getProjectSKList(int prj_seq) {
		return projectMapper.getProjectSKList(prj_seq);
	}
	
	// 기술 전체 리스트
	public ArrayList<CodeBean> getSKList(){
		return projectMapper.getSKList();
	}
	
	// 프로젝트 필요기술 등록
	public void insertProjectSK(int prj_seq, String sk_cd) {
		projectMapper.insertProjectSK(prj_seq, sk_cd);
	}
	
	// 프로젝트 필요기술 삭제
	public void deleteProjectSK(int prj_seq) {
		projectMapper.deleteProjectSK(prj_seq);
	}
	
	// 프로젝트 역할 리스트
	public ArrayList<CodeBean> getRole() {
		return projectMapper.getRole();
	}
	
	//================== 밸리데이션 =========================
	public Integer hasCustomer(int cust_seq) {
		return projectMapper.hasCustomer(cust_seq);
	}
	
	public Integer hasSkill(String query) {
		return projectMapper.hasSkill(query);
	}
}
