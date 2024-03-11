package com.ojt.controller;

import java.util.ArrayList;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.ojt.bean.MemberBean;
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
		
		// 테스트 데이터
		ArrayList<ProjectMemberBean> addPMList = new ArrayList<ProjectMemberBean>();
		ProjectMemberBean projectMemberBean;
		
		for(int i = 1; i <= 5; i++) {
			projectMemberBean = new ProjectMemberBean();
			projectMemberBean.setMem_seq(i);
			projectMemberBean.setMem_nm("홍길동");
			projectMemberBean.setDept("부서");
			projectMemberBean.setPosition("직급");
			projectMemberBean.setRole("");
			addPMList.add(projectMemberBean);
		}
		
		addProjectBean.setProjectMemberList(addPMList);
		
		model.addAttribute("projectList", map.get("projectList"));
		model.addAttribute("maxPage", map.get("maxPage"));
		model.addAttribute("pageBtns", map.get("pageBtns"));
		model.addAttribute("preBtn",map.get("preBtn"));
		model.addAttribute("nextBtn",map.get("nextBtn"));
		model.addAttribute("buttonCount",map.get("buttonCount"));
		model.addAttribute("page", page);
		model.addAttribute("showAddProjectPop", false);
		model.addAttribute("showAddPMPop", false);
		
		return "/project/Main";
	}
	
	@PostMapping("/test")
	public String test_(@ModelAttribute("addProjectBean") ProjectBean addProjectBean) {
		for(ProjectMemberBean member : addProjectBean.getProjectMemberList()) {
			System.out.println("mem_seq : " + member.getMem_seq());
			System.out.println("mem_nm : " + member.getMem_nm());
			System.out.println("dept : " + member.getDept());
			System.out.println("position : " + member.getPosition());
			System.out.println("st_dt : " + member.getSt_dt());
			System.out.println("ed_dt : " + member.getEd_dt());
			System.out.println("\n=======================\n");
		}
		return "test";
	}
	
}
