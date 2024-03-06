package com.ojt.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.ojt.service.ProjectService;

@RestController
@RequestMapping(value = "/projectFetch")
public class ProjectRestController {
	
	@Autowired
	private ProjectService projectService;
	
}
