package com.ojt.service;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ojt.bean.ProjectBean;
import com.ojt.dao.ProjectDao;

@Service
public class ProjectService {
	
	@Autowired
	private ProjectDao projectDao;
	
	// 프로젝트 검색
	public ArrayList<ProjectBean> searchProjectList(String prj_nm, int index, int endIndex){
		prj_nm = "%" + prj_nm + "%";
		
		return null;
	}

}
