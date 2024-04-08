package com.ojt.controller;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.ojt.bean.CodeBean;
import com.ojt.bean.CustomerBean;
import com.ojt.bean.ProjectBean;
import com.ojt.service.ProjectMemberService;
import com.ojt.service.ProjectService;

@Controller
@RequestMapping("/projectModify")
public class ProjectModifyController {
	
	@Autowired
	private ProjectService projectService;
	
	@Autowired
	private ProjectMemberService projectMemberService;

	@RequestMapping("/")
	public String modifyMain(@RequestParam("projectNumber")int projectNumber, Model model) {
		
		ProjectBean projectBean = projectService.getProjectInfo(projectNumber);
		ArrayList<CustomerBean> customerList = projectService.getCustomerList("");
		ArrayList<CodeBean> roleList = projectService.getRole();
		ArrayList<CodeBean> skList = projectService.getSKList();
		
		model.addAttribute("modifyProjectBean", projectBean);
		model.addAttribute("customerList", customerList);
		model.addAttribute("roleList", roleList);
		model.addAttribute("skList", skList);
		
		System.out.println(projectBean.toString());
		
//		if(projectBean != null) {
//			return "/project/modifyProject/ModifyProject";
//		} else {
//			return "Main";
//		}
		
		return "/project/modifyProject/ModifyProject";
	}
}
