package com.ojt.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.ojt.bean.CodeBean;
import com.ojt.bean.CustomerBean;
import com.ojt.bean.MemberBean;
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
		
		if(projectBean != null) {
			
			if(!projectBean.getMaintStartDate().isEmpty()) {
				model.addAttribute("endDate", projectBean.getMaintEndDate());
			} else {
				model.addAttribute("endDate", projectBean.getProjectEndDate());
			}
			
			model.addAttribute("modifyProjectBean", projectBean);
			model.addAttribute("startDate", projectBean.getProjectStartDate());
			model.addAttribute("customerList", customerList);
			model.addAttribute("roleList", roleList);
			model.addAttribute("skList", skList);
			model.addAttribute("psList", psList);
			
			return "/project/modifyProject/ModifyProject";
		} else {
			return "Main";
		}
	}
	
	@PostMapping("/modify")
	public String modifyProject(
			@ModelAttribute("modifyProjectBean")ProjectBean modifyProjectBean,
			@RequestParam("deleteMemberNumbers")int[] deleteMemberNumbers,
			BindingResult result, Model model) {
		
		ProjectValidator projectValidator = new ProjectValidator(projectService, projectMemberService);
		projectValidator.validate(modifyProjectBean, result);
		
		List<FieldError> fieldErrors = result.getFieldErrors();
		for(FieldError error : fieldErrors) {
			System.out.println(error.getField());
			System.out.println(error.getCode());
		}
		System.out.println(modifyProjectBean.toString());
		ArrayList<Integer> deleteMemberList = new ArrayList<Integer>();
		for(int i : deleteMemberNumbers) {
			deleteMemberList.add(i);
		}
		
		ArrayList<CustomerBean> customerList = projectService.getCustomerList("");
		ArrayList<CodeBean> roleList = projectService.getRole();
		ArrayList<CodeBean> skList = projectService.getSKList();
		ArrayList<CodeBean> psList = projectService.getPsList();
		
		if(!modifyProjectBean.getMaintStartDate().isEmpty()) {
			model.addAttribute("endDate", modifyProjectBean.getMaintEndDate());
		} else {
			model.addAttribute("endDate", modifyProjectBean.getProjectEndDate());
		}
		
		model.addAttribute("deleteMemberList", deleteMemberList);
		model.addAttribute("startDate", modifyProjectBean.getProjectStartDate());
		model.addAttribute("customerList", customerList);
		model.addAttribute("roleList", roleList);
		model.addAttribute("skList", skList);
		model.addAttribute("psList", psList);
		
		if(result.hasErrors()) {
			
			model.addAttribute("success", false);
			model.addAttribute("code", 400);
			
			return "/project/modifyProject/ModifyProject";
		}
		
		if(projectService.modifyProject(modifyProjectBean)) {
			model.addAttribute("success", true);
		} else {
			model.addAttribute("success", false);
			model.addAttribute("code", 500);
		}
		
		return "/project/modifyProject/ModifyProject";
	}
	
	@PostMapping("/modalAddProjectMember")
	public String modalAddProjectMember(@RequestParam("startDate")String startDate,
										@RequestParam("endDate")String endDate,
										Model model) {

		model.addAttribute("startDate", startDate);
		model.addAttribute("endDate", endDate);
		
		return "/project/modifyProject/AddProjectMember";
	}
	
	@PostMapping("/getNotAddProjectMember")
	public String getNotAddProjectMember(@RequestParam("search")String search,
										@RequestParam(name = "memberNumbers[]", required = false)int[] memberNumbers,
										@RequestParam("startDate")String startDate,
										@RequestParam("endDate")String endDate,
										Model model) {
		
		ArrayList<MemberBean> memberList = projectMemberService.getNotAddProjectMember(search, memberNumbers);
		ArrayList<CodeBean> roleList = projectService.getRole();
		
		model.addAttribute("memberList", memberList);
		model.addAttribute("roleList", roleList);
		model.addAttribute("startDate", startDate);
		model.addAttribute("endDate", endDate);
		
		return "/project/modifyProject/AddProjectMemberTable";
	}
	
	@PostMapping("/modifyProjectMember")
	public String modifyProjectMember(@RequestBody Map<String, Object> requestMap,
									Model model) {
		
		ArrayList<CodeBean> roleList = projectService.getRole();
		
		model.addAttribute("roleList", roleList);
		model.addAttribute("pmList", requestMap.get("pmList"));
		model.addAttribute("startDate", requestMap.get("startDate"));
		model.addAttribute("endDate", requestMap.get("endDate"));
		model.addAttribute("rowsLength", requestMap.get("rowsLength"));
		
		return "project/modifyProject/ModifyProjectMemberTable";
	}
	
	@PostMapping("/deleteMember")
	public String deleteMember(
			@ModelAttribute("modifyProjectBean") ProjectBean modifyProjectBean,
			@RequestParam("deleteIndex") int[] deleteIndex,
			Model model) {
		
		ArrayList<ProjectMemberBean> pmList
		System.out.println(modifyProjectBean.toString());
		for(int i : deleteIndex) {
			modifyProjectBean.getPmList().remove(i);
		}
		System.out.println(modifyProjectBean.toString());
		ArrayList<CodeBean> roleList = projectService.getRole();
		
		model.addAttribute("pmList", modifyProjectBean.getPmList());
		model.addAttribute("startDate", modifyProjectBean.getProjectStartDate());
		if(!modifyProjectBean.getMaintStartDate().isEmpty()) {
			model.addAttribute("endDate", modifyProjectBean.getMaintEndDate());
		} else {
			model.addAttribute("endDate", modifyProjectBean.getProjectEndDate());
		}
		
		model.addAttribute("roleList", roleList);
		model.addAttribute("rowsLength", 0);
		return "project/modifyProject/ModifyProjectMemberTable";
	}
}
