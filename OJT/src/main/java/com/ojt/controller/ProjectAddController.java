package com.ojt.controller;

import java.util.ArrayList;

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
import com.ojt.service.ProjectMemberService;
import com.ojt.service.ProjectService;
import com.ojt.validator.ProjectValidator;

@Controller
@RequestMapping(value = "/addProject")
public class ProjectAddController {
	
	@Autowired
	private ProjectService projectService;
	
	@Autowired
	private ProjectMemberService projectMemberService;
	
	@GetMapping("/addProjectModal")
	public String addProjectModal(@ModelAttribute("addProjectBean") ProjectBean addProjectbean,
								Model model) {
		
		ArrayList<CustomerBean> customerList = projectService.getCustomerList(""); //고객사 전체 리스트
		ArrayList<CodeBean> roleList = projectService.getRole(); // 역할 전체 리스트
		ArrayList<CodeBean> skList = projectService.getSKList(); // 기술 전체 리스트
				
		model.addAttribute("customerList", customerList);
		model.addAttribute("roleList", roleList);
		model.addAttribute("skList", skList);
		
		return "/project/addProject/AddProject";
	}
	
	@GetMapping("showAddPMModal")
	public String showAddPMModal() {
		return "/project/addProject/AddProjectMember";
	}
	
	@GetMapping("/getNotAddProjectMember")
	public String getNotAddProjectMember(@RequestParam("search") String search,
										@RequestParam(name = "memberNumbers", required = false) int[] memberNumbers,
										@RequestParam("startDate") String startDate,
										@RequestParam("endDate") String endDate,
										Model model) {
		
		ArrayList<MemberBean> memberList = projectMemberService.getNotAddProjectMember(search, memberNumbers); //프로젝트에 참여하지 않은 멤버 리스트
		ArrayList<CodeBean> roleList = projectService.getRole(); // 전체 역할 리스트
		
		model.addAttribute("memberList", memberList);
		model.addAttribute("startDate", startDate);
		model.addAttribute("endDate", endDate);
		model.addAttribute("roleList", roleList);
		
		return "/project/addProject/AddProjectMemberTable";
	}
	
	@PostMapping("/addProjectTable")
	public String AddProjectTable(@RequestBody String jsonString, Model model) {
		
		ObjectMapper mapper = new ObjectMapper();
		
		ArrayList<ProjectMemberBean> addPMList = new ArrayList<ProjectMemberBean>();
		String startDate;
		String endDate;
		int rowsLength;
		
		try {
			
			JsonNode jsonNode = mapper.readTree(jsonString);
			
			startDate = jsonNode.get("startDate").asText();
			endDate = jsonNode.get("endDate").asText();
			rowsLength = jsonNode.get("rowsLength").asInt();
			
			//리스트 추출
			JsonNode addPMListNode = jsonNode.get("addPMList");
			if(addPMListNode != null && addPMListNode.isArray()) {
				for(JsonNode node : addPMListNode) {
					ProjectMemberBean pm = new ProjectMemberBean();
					pm.setMemberNumber(node.get("memberNumber").asInt());
					pm.setMemberName(node.get("memberName").asText());
					pm.setDepartment(node.get("department").asText());
					pm.setPosition(node.get("position").asText());
					pm.setStartDate(node.get("startDate").asText());
					pm.setEndDate(node.get("endDate").asText());
					pm.setRoleCode(node.get("roleCode").asText());
					
					addPMList.add(pm);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			return "redirect:/";
		}
		
		ArrayList<CodeBean> roleList = projectService.getRole();
		
		model.addAttribute("addPMList", addPMList);
		model.addAttribute("rowsLength", rowsLength);
		model.addAttribute("startDate", startDate);
		model.addAttribute("endDate", endDate);
		model.addAttribute("roleList", roleList);
		
		return "/project/addProject/AddProjectTable";
	}
	
	@PostMapping("/addProject")
	public String addProject(@Valid @ModelAttribute("addProjectBean") ProjectBean addProjectBean,
							BindingResult result, Model model) {
		
		if(result.hasErrors() || !projectService.insertProject(addProjectBean)) {// 에러가 존재하는지 또는 등록에 실패했는지
			ArrayList<CustomerBean> customerList = projectService.getCustomerList("");
			ArrayList<CodeBean> roleList = projectService.getRole();
			ArrayList<CodeBean> skList = projectService.getSKList();
			
			model.addAttribute("customerList", customerList);
			model.addAttribute("roleList", roleList);
			model.addAttribute("skList", skList);
			model.addAttribute("success", false);
			return "/project/addProject/AddProject";
		}
		model.addAttribute("success", true);
		model.addAttribute("projectNumber", projectService.getProjectNumber());
		
		return "/project/addProject/AddProject";
	}
	
	@InitBinder
	public void initBinder(WebDataBinder binder) {
		
		if(binder.getObjectName().equals("addProjectBean")) {
			ProjectValidator projectValidator = new ProjectValidator(projectService);
			binder.addValidators(projectValidator);
		}
	}
}
