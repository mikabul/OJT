package com.ojt.controller;

import java.util.ArrayList;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.ojt.bean.ProjectBean;
import com.ojt.bean.ProjectMemberBean;
import com.ojt.bean.ProjectSearchBean;
import com.ojt.service.ProjectService;

@Controller
@RequestMapping(value = "/project")
public class ProjectController {
	
	@Autowired
	private ProjectService projectService;
	
	@RequestMapping("/Main")
	public String main(@ModelAttribute("projectSearchBean") ProjectSearchBean projectSearchBean,
						@ModelAttribute("addProjectBean") ProjectBean addProjectBean,
						@RequestParam(name="page", defaultValue = "0", required=false) int page,
						BindingResult result,
						Model model) {
		
		int view = projectSearchBean.getView();
		
		Map<String, Object> map = projectService.searchProjectList(projectSearchBean, page, view);
		
		//테스트 데이터
		ArrayList<ProjectMemberBean> projectMemberList = new ArrayList<ProjectMemberBean>();
		ProjectMemberBean projectMember = new ProjectMemberBean();
		projectMember.setMem_seq(0);
		projectMember.setMem_nm("홍길동");
		projectMember.setDept("test");
		projectMember.setPosition("test");
		projectMember.setSt_dt("2023-01-01");
		projectMember.setEd_dt("2024-01-01");
		projectMember.setRole("무언가");
		projectMemberList.add(projectMember);
		addProjectBean.setProjectMemberList(projectMemberList);
				
		model.addAttribute("projectList", map.get("projectList"));
		model.addAttribute("maxPage", map.get("maxPage"));
		model.addAttribute("pageBtns", map.get("pageBtns"));
		model.addAttribute("preBtn",map.get("preBtn"));
		model.addAttribute("nextBtn",map.get("nextBtn"));
		model.addAttribute("buttonCount",map.get("buttonCount"));
		model.addAttribute("page", page);
		model.addAttribute("showAddProjectPop", false);
		
		return "/project/Main";
	}
	
}
