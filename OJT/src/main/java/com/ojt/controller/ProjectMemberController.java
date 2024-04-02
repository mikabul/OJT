package com.ojt.controller;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.ojt.bean.CodeBean;
import com.ojt.bean.MemberBean;
import com.ojt.bean.ProjectBean;
import com.ojt.bean.ProjectMemberBean;
import com.ojt.service.ProjectMemberService;
import com.ojt.service.ProjectService;

@Controller
@RequestMapping("/projectMember")
public class ProjectMemberController {

	@Autowired
	private ProjectService projectService;
	
	@Autowired
	private ProjectMemberService projectMemberService;
	
	@GetMapping("/")
	public String projectMember(@RequestParam("projectNumber") int projectNumber, Model model) {
		
		ProjectBean projectBean = projectService.getProjectInfo(projectNumber); // 프로젝트 정보
		
		ArrayList<ProjectMemberBean> projectMemberList = projectMemberService.getProjectMemberList(projectNumber); //프로젝트 멤버 리스트
		projectBean.setPmList(projectMemberList);
		model.addAttribute("projectBean", projectBean);
		
		ArrayList<CodeBean> roleList = projectService.getRole();//역할 리스트
		model.addAttribute("roleList", roleList);
		return "/project/projectMember/ProjectMember";
	}
	
	@GetMapping("/modalAddProjectMember")
	public String modalAddProjectMember() {
		return "/project/projectMember/addProjectMember";
	}
	
	@PostMapping("/addProjectMemberSearch")
	public String addProjectMemberSearch(
			@RequestParam(value = "memberName") String memberName,
			@RequestParam(value = "projectNumber") int projectNumber,
			@RequestParam(value = "startDate") String startDate,
			@RequestParam(value = "endDate") String endDate,
			Model model) {
		
		ArrayList<MemberBean> memberList = projectMemberService.searchNotProjectMember(projectNumber, memberName);
		ArrayList<CodeBean> roleList = projectService.getRole();
		
		System.out.println();
		System.out.println(memberList.toString());
		System.out.println(roleList.toString());
		
		model.addAttribute("memberList", memberList);
		model.addAttribute("roleList", roleList);
		model.addAttribute("startDate", startDate);
		model.addAttribute("endDate", endDate);
		
		return "/project/projectMember/addProjectMemberTable";
	}
}
