package com.ojt.controller;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.ojt.bean.CodeBean;
import com.ojt.bean.CustomerBean;
import com.ojt.bean.ProjectBean;
import com.ojt.service.ProjectMemberService;
import com.ojt.service.ProjectService;
import com.ojt.validator.ProjectValidator;

@Controller
@RequestMapping("/projectModify")
public class ProjectModifyController {
	
	@Autowired
	private ProjectService projectService;
	
	@Autowired
	private ProjectMemberService projectMemberService;

	@GetMapping("/")
	public String modifyMain(@RequestParam("projectNumber")int projectNumber, Model model) {
		
		ProjectBean projectBean = projectService.getProjectInfo(projectNumber);
		ArrayList<CustomerBean> customerList = projectService.getCustomerList("");
		ArrayList<CodeBean> roleList = projectService.getRole();
		ArrayList<CodeBean> skList = projectService.getSKList();
		ArrayList<CodeBean> psList = projectService.getPsList();
		
		model.addAttribute("modifyProjectBean", projectBean);
		model.addAttribute("customerList", customerList);
		model.addAttribute("roleList", roleList);
		model.addAttribute("skList", skList);
		model.addAttribute("psList", psList);
		
		if(projectBean != null) {
			return "/project/modifyProject/ModifyProject";
		} else {
			return "Main";
		}
	}
	
	@RequestMapping("/modify")
	public String modifyProject(@ModelAttribute("modifyProjectBean")ProjectBean modifyProjectBean, BindingResult result, Model model) {
		
		ProjectValidator projectValidator = new ProjectValidator(projectService, projectMemberService);
		projectValidator.validate(modifyProjectBean, result);
		
		List<FieldError> fieldErrors = result.getFieldErrors();
		for(FieldError error : fieldErrors) {
			System.out.println(error.getField());
			System.out.println(error.getCode());
		}
		
		if(result.hasErrors()) {
			
			ArrayList<CustomerBean> customerList = projectService.getCustomerList("");
			ArrayList<CodeBean> roleList = projectService.getRole();
			ArrayList<CodeBean> skList = projectService.getSKList();
			ArrayList<CodeBean> psList = projectService.getPsList();
			
			model.addAttribute("customerList", customerList);
			model.addAttribute("roleList", roleList);
			model.addAttribute("skList", skList);
			model.addAttribute("psList", psList);
			model.addAttribute("success", false);
			model.addAttribute("code", 400);
			
			return "/project/modifyProject/ModifyProject";
		}
		model.addAttribute("success", true);
		return "/project/modifyProject/ModifyProject";
	}
}
