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

import com.ojt.bean.CustomerBean;
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
		
		Map<String, Object> map = projectService.searchProjectList(projectSearchBean, page);
		ArrayList<CustomerBean> customerList = projectService.getCustomerList("");
		
		// =============테스트 데이터============
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
		// =============테스트 데이터 끝==============
		
		model.addAttribute("projectList", map.get("projectList"));
		model.addAttribute("pageBtns", map.get("pageBtns"));
		model.addAttribute("preBtn", map.get("preBtn"));
		model.addAttribute("nextBtn", map.get("nextBtn"));
		model.addAttribute("customerList", customerList);
		model.addAttribute("page", page);
		
		return "/project/Main";
	}
	
}
