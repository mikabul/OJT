package com.ojt.service;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Service;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.DefaultTransactionDefinition;

import com.ojt.bean.MemberBean;
import com.ojt.bean.ProjectBean;
import com.ojt.bean.ProjectMemberBean;
import com.ojt.dao.ProjectMemberDao;

@Service
public class ProjectMemberService {

	@Autowired
	private DataSourceTransactionManager transactionManager;
	
	@Autowired
	private ProjectMemberDao projectMemberDao;
	
	// 프로젝트 인원 조회
	public ArrayList<ProjectMemberBean> getProjectMemberList(int projectNumber){
		return projectMemberDao.getProjectMemberList(projectNumber);
	}
	
	public ArrayList<MemberBean> searchNotProjectMember(int projectMember, String memberName){
		return projectMemberDao.searchNotProjectMember(projectMember, memberName);
	}
	
	// 신규 프로젝트 인원 등록 조회
	public ArrayList<MemberBean> getNotAddProjectMember(String str, int[] memberNumbers){
		
		return projectMemberDao.getNotAddProjectMember(str, memberNumbers);
			
	}
	
	// 프로젝트에 인원이 전부 있는지
	public boolean hasProjectMemberCount(int[] memberNumbers, int projectNumber) {
		int memberCount = projectMemberDao.hasProjectMemberCount(memberNumbers, projectNumber);
		
		if(memberCount == memberNumbers.length && memberNumbers.length != 0) {
			return true;
		} else {
			return false;
		}
	}
	
	// 멤버가 전부 존재하는지
	public int hasMember(int[] memberNumbers) {
		return projectMemberDao.hasMember(memberNumbers);
	}
	
	// 프로젝트 멤버 삭제
	public boolean deleteProjectMember(int[] memberNumbers, int projectNumber) {
		
		DefaultTransactionDefinition def = new DefaultTransactionDefinition();
		TransactionStatus status = transactionManager.getTransaction(def);
		
		if(memberNumbers.length == 0) {
			return true;
		}
		
		try {
			projectMemberDao.deleteProjectMember(memberNumbers, projectNumber);
			System.out.println("프로젝트 멤버 삭제중");
			transactionManager.commit(status);
			return true;
		} catch (Exception e) {
			transactionManager.rollback(status);
			return false;
		}
	}
	
	// 프로젝트 수정 멤버 수정 혹은 등록
	public Boolean insertProjectMemberList(ProjectBean modifyProjectBean) {
		
		DefaultTransactionDefinition def = new DefaultTransactionDefinition();
		TransactionStatus status = transactionManager.getTransaction(def);
		
		try {
			int projectNumber = modifyProjectBean.getProjectNumber();
			ArrayList<ProjectMemberBean> pmList = modifyProjectBean.getPmList();
			
			for(ProjectMemberBean pm : pmList) {
				pm.setProjectNumber(projectNumber);
				if(projectMemberDao.hasProjectMember(projectNumber, pm.getMemberNumber()) == 0) { // 프로젝트에 멤버가 없는지
					projectMemberDao.insertProjectMember(pm);// 추가
				} else {
					projectMemberDao.updateProjectMember(pm);// 수정
				}
			}
			
			transactionManager.commit(status);
			return false;
		} catch (Exception e) {
			transactionManager.rollback(status);
			return false;
		}
		
	}
	
	// 프로젝트 멤버 등록
	public Boolean insertProjectMemberList(ArrayList<ProjectMemberBean> pmList) {
		
		DefaultTransactionDefinition def = new DefaultTransactionDefinition();
		TransactionStatus status = transactionManager.getTransaction(def);
		
		try {
			
			for(ProjectMemberBean projectMemberBean : pmList) {
				projectMemberDao.insertProjectMember(projectMemberBean);
			}
			
			transactionManager.commit(status);
			return true;
		} catch (Exception e) {
			e.printStackTrace();
			transactionManager.rollback(status);
			return false;
		}
	}
	
	// 프로젝트 멤버 업데이트
	public Boolean updateProjectMember(ProjectBean projectBean) {
		
		DefaultTransactionDefinition def = new DefaultTransactionDefinition();
		TransactionStatus status = transactionManager.getTransaction(def);
		
		try {
			ArrayList<ProjectMemberBean> pmList = projectBean.getPmList();
			
			for(ProjectMemberBean projectMemberBean : pmList) {
				
				int projectNumber = projectBean.getProjectNumber();
				int memberNumber = projectMemberBean.getMemberNumber();
				
				projectMemberBean.setProjectNumber(projectNumber);
				if(projectMemberDao.hasProjectMember(projectNumber, memberNumber) == 0) {
					projectMemberDao.insertProjectMember(projectMemberBean);
				} else {
					projectMemberDao.updateProjectMember(projectMemberBean);
				}
				
				System.out.println("프로젝트 멤버 수정중");
			}
			
			transactionManager.commit(status);
			return true;
		} catch (Exception e) {
			e.printStackTrace();
			transactionManager.rollback(status);
			return false;
		}
	}
}
