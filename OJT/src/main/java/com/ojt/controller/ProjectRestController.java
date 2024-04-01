package com.ojt.controller;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.ojt.bean.CodeBean;
import com.ojt.bean.MemberBean;
import com.ojt.service.ProjectMemberService;
import com.ojt.service.ProjectService;

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
	public ResponseEntity<String> searchMember(@RequestParam(name = "projectNumbers") int[] projectNumbers,
												@RequestParam(name = "projectState") String[] projectState){
		Boolean result = projectService.updateProjectState(projectNumbers, projectState);
		if(result) {
			return ResponseEntity.ok("");
		} else {
			return ResponseEntity.status(500).body("");
		}
	}
}
