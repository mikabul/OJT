package com.ojt.controller;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.ojt.bean.ProjectBean;
import com.ojt.service.ProjectService;
import com.ojt.util.Paging;

@Controller
@RequestMapping(value = "/project")
public class ProjectController {
	
	@Autowired
	private ProjectService projectService;
	
	@Autowired
	private Paging paging;
	
	@GetMapping("/Main")
	public String main(Model model) {
		
		// 페이징 처리 초기값
		int startIndex = 1;
		int view = 20;
		int endIndex = (startIndex + view) - 1;
		int page = 1;
		
		// 처음 진입시 사용할 초기 값 - 모든 정보 조회
		String prj_nm = "";
		String cust_nm = "";
		String prj_dt_type = "prj_st_dt";
		String firstDate = "2000-01-01";
		String secondDate = "9999-12-31";
		
		// Date 날짜 제한
		SimpleDateFormat sdf = new SimpleDateFormat("YYYY-MM-dd");
		Calendar cal = Calendar.getInstance();
		String minDate = "2000-01-01";
		String maxDate = sdf.format(cal.getTime());;
		
		System.out.println(maxDate);
		
		// 프로젝트 정보를 데이터 베이스로 부터 받아옴
		ArrayList<ProjectBean> projectList = projectService.getProjectInfoList(prj_nm, cust_nm, prj_dt_type, firstDate, secondDate, startIndex, endIndex);
		// 가져온 프로젝트리스트의 각 번호를 이용하여 필요기술 목록 가져오기
		for(int i = 0; i < projectList.size(); i++) {
			int prj_seq = projectList.get(i).getPrj_seq();
			projectList.get(i).setPrj_sk_list(projectService.getProjectSKList(prj_seq));
		}
		
		// 페이징 처리
		int maxView = projectService.getMaxSearchCount(prj_nm, cust_nm, prj_dt_type, firstDate, secondDate);
		int pageBtn[] = paging.getPaging(maxView, view, page);
		
		model.addAttribute("projectList", projectList);
		model.addAttribute("pageBtn", pageBtn);
		model.addAttribute("index", 1);
		model.addAttribute("page", 1);
		model.addAttribute("view", view);
		model.addAttribute("minDate", minDate);
		model.addAttribute("maxDate", maxDate);
		
		return "/project/Main";
	}
}
