package com.ojt.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.ojt.service.ProjectService;

@Controller
@RequestMapping(value = "/project")
public class ProjectController {
	
	@Autowired
	private ProjectService projectService;
	
	@GetMapping("/Main")
	public String main(Model model) {
		
		
		
		return "/project/Main";
	}
	
}
