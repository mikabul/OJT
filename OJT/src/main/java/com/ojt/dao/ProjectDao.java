package com.ojt.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.ojt.mapper.ProjectMapper;

@Repository
public class ProjectDao {

	@Autowired
	private ProjectMapper projectMapper;
	
	
}
