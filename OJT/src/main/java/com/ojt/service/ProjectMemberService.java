package com.ojt.service;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Service;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.DefaultTransactionDefinition;

import com.ojt.bean.MemberBean;
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
		
		try {
			projectMemberDao.deleteProjectMember(memberNumbers, projectNumber);
			
			transactionManager.commit(status);
			return true;
		} catch (Exception e) {
			transactionManager.rollback(status);
			return false;
		}
	}
}
