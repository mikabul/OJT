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
import com.ojt.service.ProjectService;
import com.ojt.validator.ProjectValidator;

@Controller
@RequestMapping(value = "/project")
public class ProjectController {
	
	@Autowired
	private ProjectService projectService;
	
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
	
	@GetMapping("/addProjectModal")
	public String addProjectModal(@ModelAttribute("addProjectBean") ProjectBean addProjectbean,
								Model model) {
		
		ArrayList<CustomerBean> customerList = projectService.getCustomerList(""); //고객사 전체 리스트
		ArrayList<CodeBean> roleList = projectService.getRole(); // 역할 전체 리스트
		ArrayList<CodeBean> skList = projectService.getSKList(); // 기술 전체 리스트
				
		model.addAttribute("customerList", customerList);
		model.addAttribute("roleList", roleList);
		model.addAttribute("skList", skList);
		
		return "/project/AddProject";
	}
	
	@GetMapping("showAddPMModal")
	public String showAddPMModal() {
		return "/project/AddProjectMember";
	}
	
	@GetMapping("/getNotAddProjectMember")
	public String getNotAddProjectMember(@RequestParam("search") String search,
										@RequestParam(name = "seqList", required = false) int[] seqList,
										@RequestParam("startDate") String startDate,
										@RequestParam("endDate") String endDate,
										Model model) {
		
		ArrayList<MemberBean> memberList = projectService.getNotAddProjectMember(search, seqList); //프로젝트에 참여하지 않은 멤버 리스트
		ArrayList<CodeBean> roleList = projectService.getRole(); // 전체 역할 리스트
		
		model.addAttribute("memberList", memberList);
		model.addAttribute("startDate", startDate);
		model.addAttribute("endDate", endDate);
		model.addAttribute("roleList", roleList);
		
		return "/project/AddProjectMemberTable";
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
					pm.setMem_seq(node.get("mem_seq").asInt());
					pm.setMem_nm(node.get("mem_nm").asText());
					pm.setDept(node.get("dept").asText());
					pm.setPosition(node.get("position").asText());
					pm.setSt_dt(node.get("st_dt").asText());
					pm.setEd_dt(node.get("ed_dt").asText());
					pm.setRo_cd(node.get("ro_cd").asText());
					
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
		
		return "/project/AddProjectTable";
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
			return "/project/AddProject";
		}
		model.addAttribute("success", true);
		model.addAttribute("prj_seq", projectService.getPrj_seq());
		
		return "/project/AddProject";
	}
	
	@GetMapping("/projectInfo")
	public String projectInfo(@RequestParam("prj_seq") int prj_seq,
								Model model) {

		ProjectBean projectBean = projectService.getProjectInfo(prj_seq);
		
		model.addAttribute("projectBean", projectBean);
		
		return "/project/ProjectInfo";
	}
	
	@InitBinder
	public void initBinder(WebDataBinder binder) {
		
		if(binder.getObjectName().equals("addProjectBean")) {
			ProjectValidator projectValidator = new ProjectValidator(projectService);
			binder.addValidators(projectValidator);
		}
	}
}
