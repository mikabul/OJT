package com.ojt.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.ojt.bean.ProjectBean;
import com.ojt.bean.ProjectSearchBean;
import com.ojt.service.ProjectService;

@Controller
@RequestMapping(value = "/project")
public class ProjectController {
	
	@Autowired
	private ProjectService projectService;
	
	@GetMapping("/Main")
	public String main(@ModelAttribute("projectSearchBean") ProjectSearchBean projectSearchBean,
						@RequestParam(name="page", defaultValue = "0") int page,
						@RequestParam(name="view", defaultValue = "20") int view,
						BindingResult result,
						Model model) {
		
		Map<String, Object> map = projectService.searchProjectList(projectSearchBean, page, view);
				
		model.addAttribute("projectList", map.get("projectList"));
		model.addAttribute("projectList", map.get("projectList"));
		model.addAttribute("projectList", map.get("projectList"));
		
		return "/project/Main";
	}
	
}
