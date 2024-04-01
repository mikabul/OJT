package com.ojt.service;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Service;

import com.ojt.bean.MemberBean;
import com.ojt.bean.ProjectMemberBean;
import com.ojt.dao.ProjectMemberDao;

@Service
public class ProjectMemberService {

	@Autowired
	private DataSourceTransactionManager transactionManager;
	
	@Autowired
	private ProjectMemberDao projectMemberDao;
	
	public ArrayList<ProjectMemberBean> getProjectMemberList(int projectNumber){
		return projectMemberDao.getProjectMemberList(projectNumber);
	}
	
	// 신규 프로젝트 인원 등록 조회
		public ArrayList<MemberBean> getNotAddProjectMember(String str, int[] memberNumbers){
			
			return projectMemberDao.getNotAddProjectMember(str, memberNumbers);
			
		}
}
