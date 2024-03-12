package com.ojt.controller;

import java.util.ArrayList;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.ojt.bean.CodeBean;
import com.ojt.bean.MemberBean;
import com.ojt.service.ProjectService;

@RestController
@RequestMapping(value = "/projectFetch")
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
	public ResponseEntity<String> getNotAddProjectMember(@RequestBody Map<String, Object> map){
		
		// 사전 준비
		ObjectMapper mapper = new ObjectMapper();
		String jsonString = "";
		
		// Json분리
		String str = (String)map.get("str");
		int[] mem_seqList;
		
		try {
			ArrayList<String> str_mem_seqList = (ArrayList<String>)map.get("mem_seqList");
			mem_seqList = new int[str_mem_seqList.size()];
			for(int i = 0; i < str_mem_seqList.size(); i++) {
				mem_seqList[i] = Integer.parseInt(str_mem_seqList.get(i));
			}
		} catch (Exception e) {
			e.printStackTrace();
			mem_seqList = new int[0];
		}
		ArrayList<MemberBean> memberList = projectService.getNotAddProjectMember(str, mem_seqList);
		
		try {
			jsonString += mapper.writeValueAsString(memberList);
		} catch (Exception e) {
			e.printStackTrace();
			return ResponseEntity.internalServerError().body("json변환 에러");
		}
		
		return ResponseEntity.ok(jsonString);
	}
	
}
