package com.ojt.mapper;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.ojt.bean.CodeBean;
import com.ojt.bean.CustomerBean;
import com.ojt.bean.ProjectBean;

@Mapper
public interface ProjectMapper {

	//=============== 프로젝트 ==============
	// 프로젝트 검색
	// 프로젝트 번호, 프로젝트 이름, 고객사 이름, 시작일, 종료일, 프로젝트 상태
	// 'optionalQuery'는 ProjectService에서 쿼리를 작성한 것
	public ArrayList<ProjectBean> searchProjectList(@Param("projectName") String projectName,
													@Param("optionalQuery") String optionalQuery,
													@Param("index") int index,
													@Param("endIndex") int endIndex);
	
	// 프로젝트 검색 - 페이징 처리
	// 같은 조건으로 검색시의 최대 개수
	public int searchProjectListMaxCount(@Param("projectName") String projectName,
										@Param("optionalQuery") String optionalQuery);
	
	// select2의 데이터 리스트
	// 고객사 번호, 이름
	public ArrayList<CustomerBean> getCustomerList(String customer);
	
	// 프로젝트가 존재하는지
	public int hasProject(int projectNumber);
	
	// 프로젝트 번호, 시작일, 종료일, 유지보수 종료일을 검사
	public int matchProjectInfo(ProjectBean projectBean);
	
	// 프로젝트 등록
	public void insertProject(ProjectBean insertProjectBean);
	
	// 프로젝트 현재 시퀀스 받아오기
	public int getProjectNumber();
	
	// 프로젝트 정보
	public ProjectBean getProjectInfo(int projectNumber);
	
	// 프로젝트 상태 코드 리스트
	public ArrayList<CodeBean> getPsList();
	
	// 프로젝트 상태 코드 리스트 String배열
	public ArrayList<String> getStringListProjectState();
	
	// 프로젝트 상태 수정
	public void updateProjectState(ProjectBean updateProjectBean);
	
	// 프로젝트 수정
	public void updateProject(ProjectBean updateProjectBean);
	
	// 프로젝트 삭제
	public void deleteProject(int projectNumber);
	
	//========== 프로젝트 필요 기술 ===========
	// 프로젝트 필요기술 조회
	public ArrayList<CodeBean> getProjectSKList(int projectNumber);
	
	// 전체 기술 리스트
	public ArrayList<CodeBean> getSKList();
	
	// 프로젝트 필요기술 등록
	public void insertProjectSK(@Param("projectNumber") int projectNumber, @Param("skillCode") String skillCode);
	
	// 프로젝트 필요기술 삭제
	public void deleteProjectSK(int projectNumber);
	
	// 프로젝트 역할 리스트
	public ArrayList<CodeBean> getRole();
	
	// 프로젝트 역할 코드 배열
	public ArrayList<String> getRoleCodeList();
	//================== 밸리데이션 ===================
	// 고객사가 존재하는지
	public Integer hasCustomer(int customerNumber);
	
	// 기술이 모두 존재하는지 확인
	public Integer hasSkill(String query);
}
