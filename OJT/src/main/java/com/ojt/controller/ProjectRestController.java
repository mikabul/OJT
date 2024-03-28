package com.ojt.controller;

import java.util.ArrayList;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.ojt.bean.CodeBean;
import com.ojt.bean.MemberBean;
import com.ojt.service.ProjectService;

@RestController
@RequestMapping(value = "/projectRest")
public class ProjectRestController {
	
	@Autowired
	private ProjectService projectService;
	
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
	
	@PostMapping(value = "/getNotAddProjectMember", produces = "application/json")
	public ResponseEntity<String> getNotAddProjectMember(@RequestParam(name = "search") String search,
														@RequestParam(name = "seqList") int[] seqList){
		
		// 사전 준비
		ObjectMapper mapper = new ObjectMapper();
		String jsonString = "";
		
		ArrayList<MemberBean> memberList = projectService.getNotAddProjectMember(search, seqList);
		
		try {
			jsonString += mapper.writeValueAsString(memberList);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return ResponseEntity.ok(jsonString);
	}
	
	@PostMapping("/deleteProjects")
	public ResponseEntity<Boolean> deleteProjects(@RequestParam(name = "projectSeq") Integer[] projectSeqList){
		
		if(projectSeqList.length == 0) {
			return ResponseEntity.badRequest().body(false);
		}
		
		Boolean result = projectService.deleteProjects(projectSeqList);
		
		return ResponseEntity.ok(result);
	}
	
	@PostMapping("/searchMember")
	public ResponseEntity<String> searchMember(@RequestParam(name = "search") String search){
		return ResponseEntity.ok("성공");
	}
	
	@PostMapping("/updateProjectState")
	public ResponseEntity<String> searchMember(@RequestParam(name = "projectNumber") int[] projectNumber,
												@RequestParam(name = "projectState") String[] projectState){
		Boolean result = projectService.updateProjectState(projectNumber, projectState);
		if(result) {
			return ResponseEntity.ok("");
		} else {
			return ResponseEntity.status(500).body("");
		}
	}
}
