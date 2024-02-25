package com.ojt.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
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
	
	@GetMapping(value = "/searchProject", produces = "application/json; charset-utF-8")
	@ResponseBody
	public ResponseEntity<String> searchProject(@RequestParam(value = "prj_nm") String prj_nm,
								@RequestParam(value = "cust_nm") String cust_nm,
								@RequestParam(value = "dateType") String dateType,
								@RequestParam(value = "firstDate", defaultValue="2000-01-01") String firstDate,
								@RequestParam(value = "secondDate", defaultValue="9999-12-31") String secondDate,
								@RequestParam(value = "index", defaultValue="1") int index
								) {
		// json 준비
		ObjectMapper mapper = new ObjectMapper();
		Map<String, Object> map = new HashMap<String, Object>();
		String jsonString = "";
		boolean validator = false;
		
		// 유효성 검사
		// 프로젝트 명
		if(prj_nm.contains("-") || prj_nm.contains("/") || prj_nm.contains("'") || prj_nm.contains("\"") || prj_nm.contains(";")) {
			validator = true;
			map.put("prj_nm_error", "잘못된 문자가 포함되어 있습니다.");
		}
		// 고객사
		if(cust_nm.contains("-") || cust_nm.contains("/") || cust_nm.contains("'") || cust_nm.contains("\"") || cust_nm.contains(";")) {
			validator = true;
			map.put("cust_nm_error", "잘못된 문자가 포함되어 있습니다.");
		}
		// 날짜 검색 타입
		if(dateType.contains("-") || dateType.contains("/") || dateType.contains("'") || dateType.contains("\"") || dateType.contains(";")) {
			validator = true;
			map.put("dateType_error", "잘못된 문자가 포함되어 있습니다.");
		} else if(!(dateType.equals("prj_st_dt") || dateType.equals("prj_ed_dt"))) {
			validator = true;
			map.put("dateType_error", "검색 타입이 아닙니다.");
		}
		// 첫번째 날짜
		if(firstDate.contains("/") || firstDate.contains("'") || firstDate.contains("\"") || firstDate.contains(";")) {
			validator = true;
			map.put("firstDate_error", "잘못된 문자가 포함되어 있습니다.");
		}
		// 두번째 날짜
		if(secondDate.contains("/") || secondDate.contains("'") || secondDate.contains("\"") || secondDate.contains(";")) {
			validator = true;
			map.put("secondDate_error", "잘못된 문자가 포함되어 있습니다.");
		}
		if(validator) {
			try {
				jsonString = mapper.writeValueAsString(map);
			} catch (Exception e) {
				e.printStackTrace();
			}
			return ResponseEntity.badRequest().body(jsonString);
		}
		
		// 페이징 처리를 위한 값
		int view = 20;
		int endindex = (index + view) - 1;
		int page = index / view + 1;
		
		// 검색 결과
		ArrayList<ProjectBean> projectList = projectService.getProjectInfoList(prj_nm, cust_nm, dateType, firstDate, secondDate, index, endindex);
		
		// 페이징 처리
		int maxView = projectService.getMaxSearchCount(prj_nm, cust_nm, dateType, firstDate, secondDate);
		int pageBtns[] = paging.getPaging(maxView, view, page);
		
		map.put("projectList", projectList);
		map.put("pageBtns", pageBtns);
		map.put("page", page);
		map.put("view", view);
		
		try {
			jsonString = mapper.writeValueAsString(map);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return ResponseEntity.ok(jsonString);
		
	}
	
}
