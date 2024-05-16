package com.ojt.controller.project;

import java.util.ArrayList;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.ojt.bean.CodeBean;
import com.ojt.bean.CustomerBean;
import com.ojt.bean.ProjectBean;
import com.ojt.bean.ProjectSearchBean;
import com.ojt.service.ProjectService;

@Controller
@RequestMapping(value = "/project")
public class ProjectController {
	
	@Autowired
	private ProjectService projectService;
	
	@RequestMapping("/main")
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
	
	@GetMapping("/info")
	public String projectInfo(@RequestParam("projectNumber") int projectNumber,
								Model model) {

		ProjectBean projectBean = projectService.getProjectInfo(projectNumber);
		
		model.addAttribute("projectBean", projectBean);
		
		return "/project/ProjectInfo";
	}
	
	// 프로젝트 삭제
	@PostMapping("/delete")
	public ResponseEntity<Boolean> deleteProjects(@RequestParam(name = "projectNumbers") Integer[] projectNumbers) {

		if (projectNumbers.length == 0) {
			return ResponseEntity.badRequest().body(false);
		}

		Boolean result = projectService.deleteProjects(projectNumbers);

		return ResponseEntity.ok(result);
	}
	
	// 역할을 가져옴
	@GetMapping(value = "/getRole", produces = "application/json")
	public ResponseEntity<String> getRole() {

		ObjectMapper mapper = new ObjectMapper();
		String jsonString = "";

		ArrayList<CodeBean> role_list = projectService.getRole();

		try {
			jsonString = mapper.writeValueAsString(role_list);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return ResponseEntity.ok(jsonString);
	}
}
