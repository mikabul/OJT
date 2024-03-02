package com.ojt.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.ojt.service.ProjectService;
import com.ojt.util.Paging;

@Controller
@RequestMapping(value = "/project")
public class ProjectController {
	
	@Autowired
	private ProjectService projectService;
	
	@Autowired
	private Paging paging;
	
	@GetMapping("/Main")
	public String main(Model model) {
		
		return "/project/Main";
	}
	
	@GetMapping(value = "/projectMemberRegi")
	public String projectMemberRegi(@RequestParam(value = "prj_seq") int prj_seq,
									@RequestParam(value = "prj_nm") String prj_nm,
									@RequestParam(value = "cust_nm") String cust_nm,
									Model model) {
		
		model.addAttribute("prj_seq", prj_seq);
		model.addAttribute("prj_nm", prj_nm);
		model.addAttribute("cust_nm", cust_nm);
		
		return "/project/ProjectMemberRegi";
	}
}
