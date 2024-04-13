package com.ojt.controller;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.PropertySource;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.ojt.bean.MemberBean;
import com.ojt.bean.SearchMemberBean;
import com.ojt.service.MemberService;

@Controller
@RequestMapping(value = "/member")
@PropertySource("/WEB-INF/properties/setting.properties")
public class MemberController {
	
	@Autowired
	MemberService memberService;
	
	@Value("${viewList}")
	private String viewList;
	
	@GetMapping("/Main")
	public String main(@RequestParam(value = "memberNumber", required = false) Integer memberNumber, Model model) {
		
		SearchMemberBean searchMemberBean = new SearchMemberBean();
		Map<String, Object> searchMap = memberService.searchMember(searchMemberBean, 0);
		Map<String, Object> codeMap = memberService.getSearchCode();
		
		model.addAttribute("searchMemberBean", searchMemberBean);
		model.addAttribute("memberList", searchMap.get("memberList"));
		model.addAttribute("pageBtns", searchMap.get("pageBtns"));
		model.addAttribute("preBtn", searchMap.get("preBtn"));
		model.addAttribute("nextBtn", searchMap.get("nextBtn"));
		model.addAttribute("departmentList", codeMap.get("departmentList"));
		model.addAttribute("positionList", codeMap.get("positionList"));
		model.addAttribute("statusList", codeMap.get("statusList"));
		model.addAttribute("viewList", viewList);
		model.addAttribute("page", 0);
		model.addAttribute("memberNumber", memberNumber);
		
		return "/member/Main";
	}
	
	// 사원 검색
	@PostMapping(value = "/searchMember", produces = "application/json; charset=utf-8")
	@ResponseBody
	public ResponseEntity<Object> searchMember(@ModelAttribute SearchMemberBean searchMemberBean,
												@RequestParam(name="page", required=false, defaultValue="0") int page){
		
		ObjectMapper mapper = new ObjectMapper();
		String jsonString = "";
		
		Map<String, Object> searchMap = memberService.searchMember(searchMemberBean, page);
		
		try {
			jsonString = mapper.writeValueAsString(searchMap);
		} catch (Exception e) {
			e.printStackTrace();
			return ResponseEntity.status(500).body("json변환에 실패하였습니다.");
		}
		System.out.println(jsonString);
		return ResponseEntity.ok(jsonString);
	}
	
	// 사원 상세 정보
	@PostMapping(value="/memberInfo", produces="application/json; charset=utf-8")
	public String memberInfo(@RequestParam("memberNumber") int memberNumber,
											Model model){
		
		Map<String, Object> memberInfoMap = memberService.getDetailMemberInfo(memberNumber);
		model.addAttribute("memberBean", memberInfoMap.get("memberBean"));
		model.addAttribute("projectList", memberInfoMap.get("projectList"));
		
		return "/member/MemberInfo";
	}
	
	@GetMapping(value="/addMember/")
	public String showAddMember(Model model) {
		
		MemberBean memberBean = new MemberBean(); // 초기 사용을 위한 값이 비어있는 bean
		Map<String, Object> codeMap = memberService.getAddMemberCode(); // CodeList
		
		model.addAttribute("addMemberBean", memberBean);
		model.addAttribute("departmentList", codeMap.get("departmentList"));
		model.addAttribute("positionList", codeMap.get("positionList"));
		model.addAttribute("statusList", codeMap.get("statusList"));
		model.addAttribute("skillList", codeMap.get("skillList"));
		
		return "/member/AddMember";
	}
	
	@PostMapping(value="/addMember/add")
	public String addMember(@ModelAttribute("addMemberBean") MemberBean addMemberBean,
							BindingResult result, Model model) {
		
		Map<String, Object> codeMap = memberService.getAddMemberCode(); // CodeList
		model.addAttribute("departmentList", codeMap.get("departmentList"));
		model.addAttribute("positionList", codeMap.get("positionList"));
		model.addAttribute("statusList", codeMap.get("statusList"));
		model.addAttribute("skillList", codeMap.get("skillList"));
		
		if(result.hasErrors()) {
			
			
			return "/member/AddMember";
		}
		
		Map<String, Object> map = memberService.addMember(addMemberBean);
		if((Boolean)map.get("success") == true) {
			model.addAttribute("memberNumber", map.get("memberNumber"));
			return "/member/AddSuccess";
		} else {
			model.addAttribute("success", false);
			return "/member/AddMember";
		}
		
	}
}
