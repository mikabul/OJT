package com.ojt.controller.project;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.ojt.bean.CodeBean;
import com.ojt.bean.MemberBean;
import com.ojt.bean.ProjectBean;
import com.ojt.bean.ProjectMemberBean;
import com.ojt.service.ProjectMemberService;
import com.ojt.service.ProjectService;
import com.ojt.validator.ProjectMemberValidator;

@Controller
@RequestMapping("/project/member")
public class ProjectMemberController {

	@Autowired
	private ProjectService projectService;
	
	@Autowired
	private ProjectMemberService projectMemberService;
	
	//인원 관리 모달
	@GetMapping("/modal")
	public String projectMember(@RequestParam("projectNumber") int projectNumber, Model model) {
		
		ProjectBean modifyProjectBean = projectService.getProjectInfo(projectNumber); // 프로젝트 정보
		ProjectBean projectBean = projectService.getProjectInfo(projectNumber);
		
		ArrayList<ProjectMemberBean> projectMemberList = projectMemberService.getProjectMemberList(projectNumber); //프로젝트 멤버 리스트
		modifyProjectBean.setPmList(projectMemberList);
		projectBean.setPmList(projectMemberList);
		model.addAttribute("modifyProjectBean", modifyProjectBean);
		model.addAttribute("projectBean", projectBean);
		
		ArrayList<CodeBean> roleList = projectService.getRole();//역할 리스트
		model.addAttribute("roleList", roleList);
		
		return "/project/projectMember/ProjectMember";
	}
	
	// 인원 추가 모달
	@GetMapping("/addModal")
	public String modalAddProjectMember( int projectNumber, String projectStartDate, String projectEndDate, String maintEndDate, Model model) {
		
		model.addAttribute("projectNumber", projectNumber);
		model.addAttribute("projectStartDate", projectStartDate);
		model.addAttribute("projectEndDate", projectEndDate);
		model.addAttribute("maintEndDate", maintEndDate);
		
		return "/project/projectMember/addProjectMember";
	}
	
	// 인원 추가 - 조회
	@PostMapping("/search")
	public String addProjectMemberSearch(
			@RequestParam(value = "memberName") String memberName,
			@RequestParam(value = "projectNumber") int projectNumber,
			@RequestParam(value = "startDate") String startDate,
			@RequestParam(value = "endDate") String endDate,
			Model model) {
		
		ArrayList<MemberBean> memberList = projectMemberService.searchNotProjectMember(projectNumber, memberName);
		ArrayList<CodeBean> roleList = projectService.getRole();
		
		model.addAttribute("memberList", memberList);
		model.addAttribute("roleList", roleList);
		model.addAttribute("startDate", startDate);
		model.addAttribute("endDate", endDate);
		
		return "/project/projectMember/addProjectMemberTable";
	}
	
	// 프로젝트 멤버 수정
	@PostMapping("/modify")
	public String modifyProjetcMember( @ModelAttribute("modifyProjectBean") ProjectBean modifyProjectBean, BindingResult result, Model model) {
		
		ProjectMemberValidator projectMemberValidator = new ProjectMemberValidator(projectService, projectMemberService);
		projectMemberValidator.validate(modifyProjectBean, result);
		
		ArrayList<CodeBean> roleList = projectService.getRole();//역할 리스트
		model.addAttribute("roleList", roleList);
		
		if(result.hasErrors()) {
			
			model.addAttribute("success", false);
			model.addAttribute("code", 400);
			
		} else if(projectMemberService.updateProjectMember(modifyProjectBean)) {
			
			model.addAttribute("success", true);
			
		} else {
			
			model.addAttribute("success", false);
			model.addAttribute("code", 500);
			
		}
		
		ProjectBean projectBean = projectService.getProjectInfo(modifyProjectBean.getProjectNumber());
		ArrayList<ProjectMemberBean> projectMemberList = projectMemberService.getProjectMemberList(modifyProjectBean.getProjectNumber()); //프로젝트 멤버 리스트
		projectBean.setPmList(projectMemberList);
		model.addAttribute("projectBean", projectBean);
		
		return "/project/projectMember/ProjectMember";
		
	}
	
	// 프로젝트 멤버 삭제(POST)
	@PostMapping("/delete")
	public ResponseEntity<Boolean> deleteProjectMember(@RequestParam(name = "memberNumbers") int[] memberNumbers,
			@RequestParam(name = "projectNumber") int projectNumber) {

		if (!projectMemberService.hasProjectMemberCount(memberNumbers, projectNumber)) {// 멤버가 모두 존재하는지
			return ResponseEntity.status(400).body(false);
		}

		Boolean result = projectMemberService.deleteProjectMember(memberNumbers, projectNumber);// 삭제를 진행 후 성공여부 반환

		if (result) { // 성공 했다면
			return ResponseEntity.ok(true);
		} else {
			return ResponseEntity.status(500).body(false);
		}
	}
	
	// 프로젝트 멤버 추가
	@PostMapping(value = "/add-member", produces = "application/json")
	public ResponseEntity<String> addProjectMember(@RequestBody ProjectBean projectBean, BindingResult result) {

		ProjectMemberValidator projectMemberValidator = new ProjectMemberValidator(projectService,
				projectMemberService);
		projectMemberValidator.validate(projectBean, result);

		ObjectMapper mapper = new ObjectMapper();
		String jsonString = "";

		Map<String, Object> map = new HashMap<String, Object>();

		if (result.hasErrors()) {

			map.put("result", false);
			List<FieldError> fieldError = result.getFieldErrors();
			ArrayList<String> errorMessage = new ArrayList<String>();
			for (FieldError error : fieldError) {
				errorMessage.add(error.getDefaultMessage());
			}
			map.put("errorMessage", errorMessage);

		} else {

			ArrayList<ProjectMemberBean> pmList = projectBean.getPmList();
			map.put("result", true);

			if (!projectMemberService.insertProjectMemberList(pmList)) {// 멤버 등록, 실패 또는 성공이 Boolean으로 반환
				return ResponseEntity.status(516).body("등록에 실패하였습니다.");
			}

		}

		try {
			jsonString = mapper.writeValueAsString(map);
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("json변환 실패");
			return ResponseEntity.status(515).body("등록에 실패하였습니다.");
		}

		return ResponseEntity.ok(jsonString);
	}
}
