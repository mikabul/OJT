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
	public ArrayList<ProjectBean> searchProjectList(String projectName, String optionalQuery, int index, int endIndex){
		return projectMapper.searchProjectList(projectName, optionalQuery, index, endIndex);
	}
	
	// 프로젝트 검색 - 페이징 처리
	// 같은 조건으로 검색시의 최대 개수
	public int searchProjectListMaxCount(String projectName, String optionalQuery){
		return projectMapper.searchProjectListMaxCount(projectName, optionalQuery);
	}
	
	// select2의 데이터 리스트
	public ArrayList<CustomerBean> getCustomerList(String customer){
		return projectMapper.getCustomerList(customer);
	}
	
	// 프로젝트 번호, 시작일, 종료일, 유지보수 종료일이 모두 일치하는지
	public int matchProjectInfo(ProjectBean projectBean) {
		return projectMapper.matchProjectInfo(projectBean);
	}
	
	// 프로젝트 등록
	public void insertProject(ProjectBean insertProjectBean) {
		projectMapper.insertProject(insertProjectBean);
	}
	
	// 프로젝트 현재 시퀀스
	public int getProjectNumber() {
		return projectMapper.getProjectNumber();
	}
	
	// 프로젝트 정보
	public ProjectBean getProjectInfo(int projectNumber) {
		return projectMapper.getProjectInfo(projectNumber);
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
	public void deleteProject(int projectNumber) {
		projectMapper.deleteProject(projectNumber);
	}
	
	//========== 프로젝트 필요 기술 ===========
	// 프로젝트 필요기술 조회
	public ArrayList<CodeBean> getProjectSKList(int projectNumber) {
		return projectMapper.getProjectSKList(projectNumber);
	}
	
	// 기술 전체 리스트
	public ArrayList<CodeBean> getSKList(){
		return projectMapper.getSKList();
	}
	
	// 프로젝트 필요기술 등록
	public void insertProjectSK(int projectNumber, String skillCode) {
		projectMapper.insertProjectSK(projectNumber, skillCode);
	}
	
	// 프로젝트 필요기술 삭제
	public void deleteProjectSK(int projectNumber) {
		projectMapper.deleteProjectSK(projectNumber);
	}
	
	// 프로젝트 역할 리스트
	public ArrayList<CodeBean> getRole() {
		return projectMapper.getRole();
	}
	
	// 프로젝트 역할 코드 배열
	public ArrayList<String> getRoleCodeList() {
		return projectMapper.getRoleCodeList();
	}
	
	//================== 밸리데이션 =========================
	public Integer hasCustomer(int customerNumber) {
		return projectMapper.hasCustomer(customerNumber);
	}
	
	public Integer hasSkill(String query) {
		return projectMapper.hasSkill(query);
	}
}
