package com.ojt.controller;

import java.util.ArrayList;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.ojt.bean.CodeBean;
import com.ojt.bean.CustomerBean;
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
						@RequestParam(name="page", defaultValue = "0", required=false) int page,
						BindingResult result,
						Model model) {
		
		Map<String, Object> map = projectService.searchProjectList(projectSearchBean, page);
		ArrayList<CustomerBean> customerList = projectService.getCustomerList("");
		
		model.addAttribute("projectList", map.get("projectList"));
		model.addAttribute("pageBtns", map.get("pageBtns"));
		model.addAttribute("preBtn", map.get("preBtn"));
		model.addAttribute("nextBtn", map.get("nextBtn"));
		model.addAttribute("customerList", customerList);
		model.addAttribute("page", page);
		
		return "/project/Main";
	}
	
	@GetMapping("/addProjectModal")
	public String addProjectModal(@ModelAttribute("addProjectBean") ProjectBean addProjectbean,
								Model model) {
		
		ArrayList<CustomerBean> customerList = projectService.getCustomerList("");
		ArrayList<CodeBean> roleList = projectService.getRole();
		ArrayList<CodeBean> skList = projectService.getSKList();
				
		model.addAttribute("customerList", customerList);
		model.addAttribute("roleList", roleList);
		model.addAttribute("skList", skList);
		
		//====== test data =====
		ArrayList<ProjectMemberBean> pmList = new ArrayList<ProjectMemberBean>();
		ProjectMemberBean pmBean;
		for(int i = 0; i < 5; i++) {
			pmBean = new ProjectMemberBean();
			pmBean.setMem_seq(i);
			pmBean.setMem_nm("홍길동");
			pmBean.setDept("개발");
			pmBean.setPosition("사원");
			pmBean.setRo_cd("1");
			pmBean.setSt_dt("2024-01-01");
			pmBean.setEd_dt("2024-12-31");
			pmList.add(pmBean);
		}
		addProjectbean.setPmList(pmList);
		//========= test data ========
		
		return "/project/AddProject";
	}
	
	@GetMapping("showAddPMModal")
	public String showAddPMModal() {
		return "/project/AddProjectMember";
	}
	
	@GetMapping("/getNotAddProjectMember")
	public String getNotAddProjectMember(@RequestParam("search") String search,
										@RequestParam(name = "seqList", required = false) int[] seqList,
										@RequestParam("projectStartDate") String projectStartDate,
										@RequestParam("projectEndDate") String projectEndDate,
										Model model) {
		
		ArrayList<MemberBean> memberList = projectService.getNotAddProjectMember(search, seqList);
		ArrayList<CodeBean> roleList = projectService.getRole();
		
		model.addAttribute("memberList", memberList);
		model.addAttribute("projectStartDate", projectStartDate);
		model.addAttribute("projectEndDate", projectEndDate);
		model.addAttribute("roleList", roleList);
		
		return "/project/AddProjectMemberTable";
	}
	
	@PostMapping("/addProjectTable")
	public String AddProjectTable(@RequestBody String jsonString,
									Model model) {
		
		ObjectMapper mapper = new ObjectMapper();
		
		System.out.println("jsonString : " + jsonString);
		
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
	
}
