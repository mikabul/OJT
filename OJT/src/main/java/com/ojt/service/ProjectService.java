package com.ojt.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ojt.dao.ProjectDao;

@Service
public class ProjectService {
	
	@Autowired
	private ProjectDao projectDao;

}
