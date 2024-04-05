package com.ojt.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.ojt.bean.CodeBean;
import com.ojt.bean.ProjectBean;
import com.ojt.bean.ProjectMemberBean;
import com.ojt.service.ProjectMemberService;
import com.ojt.service.ProjectService;
import com.ojt.validator.ProjectMemberValidator;

@RestController
@RequestMapping(value = "/projectRest")
public class ProjectRestController {
	
	@Autowired
	private ProjectService projectService;
	
	@Autowired
	private ProjectMemberService projectMemberService;
	
	// 역할을 가져옴
	@GetMapping(value = "/getRole", produces = "application/json")
	public ResponseEntity<String> getRole(){
		
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
	
	// 프로젝트 삭제
	@PostMapping("/deleteProjects")
	public ResponseEntity<Boolean> deleteProjects(@RequestParam(name = "projectNumbers") Integer[] projectNumbers){
		
		if(projectNumbers.length == 0) {
			return ResponseEntity.badRequest().body(false);
		}
		
		Boolean result = projectService.deleteProjects(projectNumbers);
		
		return ResponseEntity.ok(result);
	}
	
	// 프로젝트 멤버 추가
	@PostMapping("/searchMember")
	public ResponseEntity<String> searchMember(@RequestParam(name = "search") String search){
		return ResponseEntity.ok("성공");
	}
	
	// 프로젝트 상태 변경
	@PostMapping("/updateProjectState")
	public ResponseEntity<String> searchMember(@RequestParam(name = "projectNumbers[]") int[] projectNumbers,
												@RequestParam(name = "projectState[]") String[] projectState){
		Boolean result = projectService.updateProjectState(projectNumbers, projectState);
		if(result) {
			return ResponseEntity.ok("");
		} else {
			return ResponseEntity.status(500).body("");
		}
	}
	
	// 프로젝트 멤버 삭제(POST)
	@PostMapping("/deleteProjectMember")
	public ResponseEntity<Boolean> deleteProjectMember(@RequestParam(name = "memberNumbers") int[] memberNumbers,
														@RequestParam(name ="projectNumber") int projectNumber){
		
		if(!projectMemberService.hasProjectMemberCount(memberNumbers, projectNumber)) {// 멤버가 모두 존재하는지
			return ResponseEntity.status(400).body(false);
		}
		
		Boolean result = projectMemberService.deleteProjectMember(memberNumbers, projectNumber);// 삭제를 진행 후 성공여부 반환
		
		if(result) { //성공 했다면
			return ResponseEntity.ok(true);
		} else {
			return ResponseEntity.status(500).body(false);
		}
	}
	
	// 프로젝트 멤버 추가
	@RequestMapping(value = "/addProjectMember", produces = "application/json")
	public ResponseEntity<String> addProjectMember(@RequestBody ProjectBean projectBean, BindingResult result){
		
		ProjectMemberValidator projectMemberValidator = new ProjectMemberValidator(projectService, projectMemberService);
		projectMemberValidator.validate(projectBean, result);
		
		ObjectMapper mapper = new ObjectMapper();
		String jsonString = "";
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		if(result.hasErrors()) {
			
			map.put("result", false);
			List<FieldError> fieldError = result.getFieldErrors();
			ArrayList<String> errorMessage = new ArrayList<String>();
			for(FieldError error : fieldError) {
				errorMessage.add(error.getDefaultMessage());
			}
			map.put("errorMessage", errorMessage);
			
		} else {
			
			ArrayList<ProjectMemberBean> pmList = projectBean.getPmList();
			map.put("result", true);
			
			if(!projectMemberService.insertProjectMemberList(pmList)) {// 멤버 등록, 실패 또는 성공이 Boolean으로 반환
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
