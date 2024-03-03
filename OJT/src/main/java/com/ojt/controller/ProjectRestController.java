package com.ojt.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.ojt.bean.CustomerBean;
import com.ojt.bean.ProjectBean;
import com.ojt.service.ProjectService;
import com.ojt.util.Paging;

@RestController
@RequestMapping(value = "/projectFetch")
public class ProjectRestController {
	
	@Autowired
	private ProjectService projectService;
	
	@Autowired
	private Paging paging;
	
	@GetMapping(value = "/searchCustomer", produces = "application/json; charset=UTF-8")
	@ResponseBody
	public ResponseEntity<String> searchCustomer(@RequestParam(value="cust_nm") String cust_nm) {
		
		ObjectMapper mapper = new ObjectMapper();
		String jsonString = "";
		
		if(cust_nm.contains("-") || cust_nm.contains("/") || cust_nm.contains("'") || cust_nm.contains("\"") || cust_nm.contains(";")) {
			
			try {
				jsonString = mapper.writeValueAsString("잘못된 문자가 포함되어 있습니다.");
			} catch (Exception e) {
				e.printStackTrace();
			}
			
			return ResponseEntity.badRequest().body(jsonString);
		}
		
		cust_nm = "%" + cust_nm + "%";
		ArrayList<CustomerBean> customerList = projectService.getCustomerList(cust_nm);
		
		try {
			jsonString = mapper.writeValueAsString(customerList);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return ResponseEntity.ok(jsonString);
	}
	
	@PostMapping(value = "/searchProject", produces = "application/json; charset-utF-8")
	@ResponseBody
	public ResponseEntity<String> searchProject(@RequestBody Map<String, Object> requestBody) {
		
		// requestBody 분리
		String prj_nm = (String)requestBody.get("prj_nm");
		int cust_seq = (Integer)requestBody.get("cust_seq") == null ? 0 : (int)requestBody.get("cust_seq");
		String dateType = (String)requestBody.get("dateType");
		String firstDate = (String)requestBody.get("firstDate");
		String secondDate = (String)requestBody.get("secondDate");
		int index = (int)requestBody.get("index");
		
		// json 준비
		ObjectMapper mapper = new ObjectMapper();
		Map<String, Object> map = new HashMap<String, Object>();
		String jsonString = "";
		
		// 페이징 처리를 위한 값
		int view = 20;
		int endindex = (index + view) - 1;
		int page = index / view + 1;
		
		// 검색 결과
		ArrayList<ProjectBean> projectList = projectService.getProjectInfoList(prj_nm, cust_seq, dateType, firstDate, secondDate, index, endindex);
		
		// 페이징 처리
		int maxView = projectService.getMaxSearchCount(prj_nm, cust_seq, dateType, firstDate, secondDate);
		int pageBtns[] = paging.getPaging(maxView, view, page);
		
		map.put("projectList", projectList);
		map.put("pageBtns", pageBtns);
		map.put("page", page);
		map.put("view", view);
		
		// Map -> JSON
		try {
			jsonString = mapper.writeValueAsString(map);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return ResponseEntity.ok(jsonString);
		
	}
	
}
