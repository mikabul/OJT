package com.ojt.mapper;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.ojt.bean.ProjectBean;

@Mapper
public interface BatchMapper {

	// 진행 예정 프로젝트
	public ArrayList<ProjectBean> getPreStartProject(@Param("_page") int _page, @Param("_pagesize") int _pagesize);
	
	// 진행 중인 프로젝트
	public ArrayList<ProjectBean> getPostStartProject(@Param("_page") int _page, @Param("_pagesize") int _pagesize);
	
	// 종료 예정 프로젝트
	public ArrayList<ProjectBean> getEndProject(@Param("_page") int _page, @Param("_pagesize") int _pagesize);
	
	// 프로젝트 상태 업데이트
	public void projectStatusUpdate(ProjectBean projectBean);
}
