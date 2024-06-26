package com.ojt.controller.project;

import java.util.ArrayList;

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
@RequestMapping(value = "/project/add")
public class ProjectAddController {
	
	@Autowired
	private ProjectService projectService;
	
	@Autowired
	private ProjectMemberService projectMemberService;
	
	// 프로젝트 추가 모달
	@GetMapping({"/modal", ""})
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
	
	// 프로젝트 멤버 추가 모달
	@GetMapping("/modal-member")
	public String showAddPMModal(@RequestParam("startDate") String startDate,
								@RequestParam("endDate") String endDate,
								Model model) {
		
		model.addAttribute("startDate", startDate);
		model.addAttribute("endDate", endDate);
		
		return "/project/addProject/AddProjectMember";
	}
	
	// 프로젝트에 참여중이지 않은 사원
	@GetMapping("/not-project-member")
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
	
	// 프로젝트 멤버 테이블
	@PostMapping("/member-table")
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
	
	// 멤버 테이블에서 삭제
	@PostMapping("/delete-member")
	public String deleteProjectMember(ProjectBean projectBean,
									@RequestParam("deleteIndex")int[] deleteIndex,
									Model model) {
		
		ArrayList<ProjectMemberBean> pmList = projectBean.getPmList();
		for(int i = deleteIndex.length - 1; i >= 0; i--) {
			pmList.remove(deleteIndex[i]);
		}
		
		ArrayList<CodeBean> roleList = projectService.getRole();
		
		model.addAttribute("addPMList", pmList);
		model.addAttribute("rowsLength", 0);
		model.addAttribute("roleList", roleList);
		model.addAttribute("startDate", projectBean.getProjectStartDate());
		if(projectBean.getMaintStartDate() != null && !projectBean.getMaintStartDate().isEmpty()) {
			model.addAttribute("endDate", projectBean.getMaintEndDate());
		} else {
			model.addAttribute("endDate", projectBean.getProjectEndDate());
		}
		
		return "project/addProject/AddProjectTable";
	}
	
	// 프로젝트 추가
	@PostMapping("/add-project")
	public String addProject(@ModelAttribute("addProjectBean") ProjectBean addProjectBean,
							BindingResult result, Model model) {
		
		if(result.hasErrors() || !projectService.insertProject(addProjectBean)) {// 에러가 존재하는지 또는 등록에 실패했는지
			ArrayList<CustomerBean> customerList = projectService.getCustomerList("");
			ArrayList<CodeBean> roleList = projectService.getRole();
			ArrayList<CodeBean> skList = projectService.getSKList();
			
			model.addAttribute("customerList", customerList);
			model.addAttribute("roleList", roleList);
			model.addAttribute("skList", skList);
			model.addAttribute("success", false);
			model.addAttribute("startDate", addProjectBean.getProjectStartDate());
			if(addProjectBean.getMaintStartDate() != null && !addProjectBean.getMaintStartDate().isEmpty()) {
				model.addAttribute("endDate", addProjectBean.getMaintEndDate());
			} else {
				model.addAttribute("endDate", addProjectBean.getProjectEndDate());
			}
			return "/project/addProject/AddProject";
		}
		model.addAttribute("success", true);
		model.addAttribute("projectNumber", projectService.getProjectNumber());
		
		return "/project/addProject/AddProject";
	}
	
	@InitBinder
	public void initBinder(WebDataBinder binder) {
		
		if(binder.getObjectName().equals("addProjectBean")) {
			ProjectValidator projectValidator = new ProjectValidator(projectService, projectMemberService);
			binder.addValidators(projectValidator);
		}
	}
}
