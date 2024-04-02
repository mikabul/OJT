package com.ojt.controller;

import java.util.ArrayList;
import java.util.Map;

import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.ojt.bean.CodeBean;
import com.ojt.bean.CustomerBean;
import com.ojt.bean.MemberBean;
import com.ojt.bean.ProjectBean;
import com.ojt.bean.ProjectMemberBean;
import com.ojt.bean.ProjectSearchBean;
import com.ojt.service.ProjectMemberService;
import com.ojt.service.ProjectService;
import com.ojt.validator.ProjectValidator;

@Controller
@RequestMapping(value = "/project")
public class ProjectController {
	
	@Autowired
	private ProjectService projectService;
	
	@Autowired
	private ProjectMemberService projectMemberService;
	
	@RequestMapping("/Main")
	public String main(@ModelAttribute("projectSearchBean") ProjectSearchBean projectSearchBean,
						@RequestParam(name="page", defaultValue = "0", required=false) int page,
						BindingResult result,
						Model model) {
		
		Map<String, Object> map = projectService.searchProjectList(projectSearchBean, page);
		ArrayList<CustomerBean> customerList = projectService.getCustomerList(""); // 고객사 전체 리스트
		ArrayList<CodeBean> psList;
		String psListJSON;
		
		ObjectMapper mapper = new ObjectMapper();
		
		if(map.get("psList") instanceof ArrayList) {
			psList = (ArrayList<CodeBean>)map.get("psList");
		} else {
			psList = new ArrayList<CodeBean>();
		}
		
		try {
			psListJSON = mapper.writeValueAsString(psList);
		} catch (Exception e) {
			psListJSON = "";
		}
		
		model.addAttribute("projectList", map.get("projectList"));
		model.addAttribute("pageBtns", map.get("pageBtns"));
		model.addAttribute("preBtn", map.get("preBtn"));
		model.addAttribute("nextBtn", map.get("nextBtn"));
		model.addAttribute("psList", psList);
		model.addAttribute("psListJSON", psListJSON);
		model.addAttribute("customerList", customerList);
		model.addAttribute("page", page);
		
		return "/project/Main";
	}
	
	@GetMapping("/projectInfo")
	public String projectInfo(@RequestParam("projectNumber") int projectNumber,
								Model model) {

		ProjectBean projectBean = projectService.getProjectInfo(projectNumber);
		
		model.addAttribute("projectBean", projectBean);
		
		return "/project/ProjectInfo";
	}
}
