package com.ojt.controller.project;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.ojt.service.ProjectMemberService;
import com.ojt.service.ProjectService;

@RestController
@RequestMapping(value = "/projectRest")
public class ProjectRestController {
	
	@Autowired
	private ProjectService projectService;
	
	@Autowired
	private ProjectMemberService projectMemberService;
	
	
	
}
