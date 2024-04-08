package com.ojt.controller;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.ojt.bean.CodeBean;
import com.ojt.bean.MemberBean;
import com.ojt.bean.ProjectBean;
import com.ojt.bean.ProjectMemberBean;
import com.ojt.service.ProjectMemberService;
import com.ojt.service.ProjectService;
import com.ojt.validator.ProjectMemberValidator;

@Controller
@RequestMapping("/projectMember")
public class ProjectMemberController {

	@Autowired
	private ProjectService projectService;
	
	@Autowired
	private ProjectMemberService projectMemberService;
	
	//인원 관리 모달
	@GetMapping("/")
	public String projectMember(@RequestParam("projectNumber") int projectNumber, Model model) {
		
		ProjectBean modifyProjectBean = projectService.getProjectInfo(projectNumber); // 프로젝트 정보
		ProjectBean projectBean = projectService.getProjectInfo(projectNumber);
		
		ArrayList<ProjectMemberBean> projectMemberList = projectMemberService.getProjectMemberList(projectNumber); //프로젝트 멤버 리스트
		modifyProjectBean.setPmList(projectMemberList);
		projectBean.setPmList(projectMemberList);
		model.addAttribute("modifyProjectBean", modifyProjectBean);
		model.addAttribute("projectBean", projectBean);
		
		ArrayList<CodeBean> roleList = projectService.getRole();//역할 리스트
		model.addAttribute("roleList", roleList);
		
		return "/project/projectMember/ProjectMember";
	}
	
	// 인원 추가 모달
	@GetMapping("/modalAddProjectMember")
	public String modalAddProjectMember( int projectNumber, String projectStartDate, String projectEndDate, String maintEndDate, Model model) {
		
		model.addAttribute("projectNumber", projectNumber);
		model.addAttribute("projectStartDate", projectStartDate);
		model.addAttribute("projectEndDate", projectEndDate);
		model.addAttribute("maintEndDate", maintEndDate);
		
		return "/project/projectMember/addProjectMember";
	}
	
	// 인원 추가 - 조회
	@PostMapping("/addProjectMemberSearch")
	public String addProjectMemberSearch(
			@RequestParam(value = "memberName") String memberName,
			@RequestParam(value = "projectNumber") int projectNumber,
			@RequestParam(value = "startDate") String startDate,
			@RequestParam(value = "endDate") String endDate,
			Model model) {
		
		ArrayList<MemberBean> memberList = projectMemberService.searchNotProjectMember(projectNumber, memberName);
		ArrayList<CodeBean> roleList = projectService.getRole();
		
		model.addAttribute("memberList", memberList);
		model.addAttribute("roleList", roleList);
		model.addAttribute("startDate", startDate);
		model.addAttribute("endDate", endDate);
		
		return "/project/projectMember/addProjectMemberTable";
	}
	
	// 프로젝트 멤버 수정
	@PostMapping("modifyProjectMember")
	public String modifyProjetcMember( @ModelAttribute("modifyProjectBean") ProjectBean modifyProjectBean, BindingResult result, Model model) {
		
		ProjectMemberValidator projectMemberValidator = new ProjectMemberValidator(projectService, projectMemberService);
		projectMemberValidator.validate(modifyProjectBean, result);
		
		ArrayList<CodeBean> roleList = projectService.getRole();//역할 리스트
		model.addAttribute("roleList", roleList);
		
		if(result.hasErrors()) {
			
			model.addAttribute("success", false);
			model.addAttribute("code", 400);
			
		} else if(projectMemberService.updateProjectMember(modifyProjectBean)) {
			
			model.addAttribute("success", true);
			
		} else {
			
			model.addAttribute("success", false);
			model.addAttribute("code", 500);
			
		}
		
		ProjectBean projectBean = projectService.getProjectInfo(modifyProjectBean.getProjectNumber());
		ArrayList<ProjectMemberBean> projectMemberList = projectMemberService.getProjectMemberList(modifyProjectBean.getProjectNumber()); //프로젝트 멤버 리스트
		projectBean.setPmList(projectMemberList);
		model.addAttribute("projectBean", projectBean);
		
		return "/project/projectMember/ProjectMember";
		
	}
}
