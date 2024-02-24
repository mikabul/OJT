package com.ojt.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.ojt.bean.CustomerBean;
import com.ojt.bean.ProjectBean;
import com.ojt.dao.ProjectDao;
import com.ojt.service.ProjectService;

@RestController
@RequestMapping(value = "/projectFetch")
public class ProjectRestController {
	
	@Autowired
	private ProjectService projectService;
	
	@GetMapping(value = "/searchCustomer", produces = "application/json; charset=UTF-8")
	@ResponseBody
	public String searchCustomer(@RequestParam(value="cust_nm") String cust_nm) {
		
		ObjectMapper mapper = new ObjectMapper();
		String jsonString = "";
		
		cust_nm = "%" + cust_nm + "%";
		ArrayList<CustomerBean> customerList = projectService.getCustomerList(cust_nm);
		
		try {
			jsonString = mapper.writeValueAsString(customerList);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return jsonString;
	}
	
	@GetMapping(value = "/searchProject", produces = "application/json; charset-utF-8")
	@ResponseBody
	public String searchProject(@RequestParam(value = "prj_nm") String prj_nm,
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
		
		// 페이징 처리를 위한 값
		int view = 20;
		int endindex = (index + view) - 1;
		int page = index / view + 1;
		
		// 검색 결과
		ArrayList<ProjectBean> projectList = projectService.getProjectInfoList(prj_nm, cust_nm, dateType, firstDate, secondDate, index, endindex);
		
		// 페이징 처리
		int pageBtns = projectService.getMaxSearchCount(prj_nm, cust_nm, dateType, firstDate, secondDate);
		
		for(ProjectBean pro : projectList) {
			System.out.println(pro.getPrj_nm());
		}
		
		System.out.println("pageBtns : " + pageBtns);
		
		map.put("projectList", projectList);
		map.put("pageBtns", pageBtns);
		map.put("page", page);
		map.put("view", view);
		
		try {
			jsonString = mapper.writeValueAsString(map);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return jsonString;
		
	}
	
}
