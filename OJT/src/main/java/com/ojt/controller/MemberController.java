package com.ojt.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.PropertySource;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.MultiValueMap;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
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
import com.ojt.util.ErrorMessage;
import com.ojt.validator.MemberValidator;

@Controller
@RequestMapping(value = "/member")
@PropertySource("/WEB-INF/properties/setting.properties")
public class MemberController {
	
	@Value("${viewList}")
	private String viewList;
	
	@Autowired
	MemberService memberService;
	
	@Autowired
	ErrorMessage errorMessage;
	
	public Map<String, Object> codeMap;
	
	@GetMapping("/Main")
	public String main(@RequestParam(value = "memberNumber", required = false) Integer memberNumber, Model model) {
		
		SearchMemberBean searchMemberBean = new SearchMemberBean();
		Map<String, Object> searchMap = memberService.searchMember(searchMemberBean, 0);
		
		model.addAttribute("searchMemberBean", searchMemberBean);
		model.addAttribute("memberList", searchMap.get("memberList"));
		model.addAttribute("pageBtns", searchMap.get("pageBtns"));
		model.addAttribute("preBtn", searchMap.get("preBtn"));
		model.addAttribute("nextBtn", searchMap.get("nextBtn"));
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
		model.addAttribute("projectMemberList", memberInfoMap.get("projectMemberList"));
		
		return "/member/MemberInfo";
	}
	
	// 사원 등록 페이지
	@GetMapping(value="/addMember/")
	public String showAddMember(Model model) {
		
		MemberBean memberBean = new MemberBean(); // 초기 사용을 위한 값이 비어있는 bean
		model.addAttribute("addMemberBean", memberBean);
		
		return "/member/AddMember";
	}
	
	// 아이디 중복 체크
	@GetMapping(value = "/addMember/matchId")
	@ResponseBody
	public ResponseEntity<Boolean> matchId(String inputId){
		Boolean checkId = memberService.checkMemberId(inputId);
		System.out.println(checkId);
		return ResponseEntity.ok(checkId);
	}
	
	// 사원 등록
	@PostMapping(value="/addMember/add")
	public String addMember(@ModelAttribute("addMemberBean") MemberBean addMemberBean,
							BindingResult result, Model model) {
		
		System.out.println(addMemberBean.toString());
		MemberValidator memberValidator = new MemberValidator(memberService);
		memberValidator.validate(addMemberBean, result);
		
//		if(result.hasErrors()) {
//			return "/member/AddMember";
//		}
		
		List<FieldError> fieldError = result.getFieldErrors();
		MultiValueMap<String, String> errorMessageMap = errorMessage.getErrorMessage(fieldError);
		System.out.println(errorMessageMap.toString());
		
		model.addAttribute("errorMessage", errorMessageMap);
		return "/member/AddMember";
		
//		Map<String, Object> map = memberService.addMember(addMemberBean);
//		if((Boolean)map.get("success") == true) {
//			model.addAttribute("memberNumber", map.get("memberNumber"));
//			
//			return "/member/AddSuccess";
//		} else { // 사원 등록 실패
//			model.addAttribute("success", false);
//			String code = (String)map.get("code");
//			System.out.println("code : " + code);
//			if(code.equals("401")) {
//				model.addAttribute("message", "부적절한 파일입니다.");
//			} else if(code.equals("500")){
//				model.addAttribute("message", "사원 등록에 실패하였습니다.");
//			} else if(code.equals("515")) {
//				model.addAttribute("message", "사진 저장에 실패하였습니다.");
//			}
//			return "/member/AddMember";
//		}
	}
	
	@GetMapping(value = "/modifyMember/")
	public String modifyMemberMain(@RequestParam("memberNumber")int memberNumber, Model model) {
		
		MemberBean modifyMemberBean = memberService.getMemberInfo(memberNumber);
		
		model.addAttribute("modifyMemberBean", modifyMemberBean);
		
		return "/member/ModifyMember";
	}
	
	// 아이디 중복 체크(수정)
	@GetMapping(value = "/modifyMember/matchId")
	@ResponseBody
	public ResponseEntity<Boolean> modifyMatchId(String inputId, int memberNumber){
		Boolean matchResult = memberService.modifyMatchId(memberNumber, inputId);
		
		return ResponseEntity.ok(matchResult);
	}
	
	// 멤버 수정
	@PostMapping(value="/modifyMember/modify")
	public String modifyMember(@ModelAttribute("modifyMemberBean") MemberBean modifyMemberBean,
								Model model, BindingResult result) {
		
	}
	
	@ModelAttribute
	private void initBinder(HttpServletRequest request, Model model) {
		
		String requestURI = request.getRequestURI();
		
		switch(requestURI) {
		case "/OJT/member/Main":
			codeMap = memberService.getSearchCode();
			model.addAttribute("departmentList", codeMap.get("departmentList"));
			model.addAttribute("positionList", codeMap.get("positionList"));
			model.addAttribute("statusList", codeMap.get("statusList"));
			break;
			
		case "/OJT/member/addMember/": case "/OJT/member/addMember/add":
		case "/OJT/member/modifyMember/": case "/OJT/member/modifyMember/modify":
			codeMap = memberService.getAddMemberCode();
			model.addAttribute("departmentList", codeMap.get("departmentList"));
			model.addAttribute("positionList", codeMap.get("positionList"));
			model.addAttribute("statusList", codeMap.get("statusList"));
			model.addAttribute("skillList", codeMap.get("skillList"));
			model.addAttribute("genderList", codeMap.get("genderList"));
			model.addAttribute("emailList", codeMap.get("emailList"));
			break;
		}
	}
}
