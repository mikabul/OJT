package com.ojt.controller;

import java.util.ArrayList;
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
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.ojt.bean.CodeBean;
import com.ojt.bean.MemberBean;
import com.ojt.bean.ProjectMemberBean;
import com.ojt.bean.SearchMemberBean;
import com.ojt.service.CodeService;
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
	CodeService codeService;
	
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
		return ResponseEntity.ok(checkId);
	}
	
	// 사원 등록
	@PostMapping(value="/addMember/add")
	public String addMember(@ModelAttribute("addMemberBean") MemberBean addMemberBean,
							BindingResult result, Model model) {
		
		System.out.println(addMemberBean.toString());
		MemberValidator memberValidator = new MemberValidator(memberService);
		memberValidator.validate(addMemberBean, result);
		
		if(result.hasErrors()) {
			List<FieldError> fieldError = result.getFieldErrors();
			MultiValueMap<String, String> errorMessageMap = errorMessage.getErrorMessage(fieldError);
			System.out.println(errorMessageMap.toString());
			model.addAttribute("errorMessage", errorMessageMap);
			return "/member/AddMember";
		}
		
		
		Map<String, Object> map = memberService.addMember(addMemberBean);
		if((Boolean)map.get("success") == true) {
			model.addAttribute("memberNumber", map.get("memberNumber"));
			return "/member/AddSuccess";
			
		} else { // 사원 등록 실패
			model.addAttribute("success", false);
			int code = (int)map.get("code");
			System.out.println("code : " + code);
			if(code == 401) {
				model.addAttribute("message", "부적절한 파일입니다.");
			} else if(code == 500){
				model.addAttribute("message", "사원 등록에 실패하였습니다.");
			} else if(code == 515) {
				model.addAttribute("message", "사진 저장에 실패하였습니다.");
			}
			return "/member/AddMember";
		}
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
		
		// 유효성 검사
		System.out.println(modifyMemberBean.toString());
		MemberValidator memberValidator = new MemberValidator(memberService);
		memberValidator.validate(modifyMemberBean, result);
		
		if(result.hasErrors()) { // 에러가 존재 한다면
			List<FieldError> fieldError = result.getFieldErrors(); // 에러를 리스트로 추출
			MultiValueMap<String, String> errorMessageMap = errorMessage.getErrorMessage(fieldError); // 에러메세지를 MultiValueMap으로 받아옴
			System.out.println(errorMessageMap.toString());
			model.addAttribute("errorMessage", errorMessageMap);
			
			return "/member/ModifyMember";
		}
		
		// 멤버 업데이트
		Map<String, Object> modifyResult = memberService.memberUpdate(modifyMemberBean); // 멤버를 업데이트하며 결과를 받아옴
		Boolean success = (Boolean)modifyResult.get("success");
		if(success == false) { // 실패하였는지
			
			model.addAttribute("success", false); // 모델에 실패저장
			int code = (int)modifyResult.get("code"); // 코드를 추출
			System.out.println("code : " + code);
			if(code == 401) { // 코드에 따른 에러메세지 저장
				model.addAttribute("message", "부적절한 파일입니다.");
			} else if(code == 500){
				model.addAttribute("message", "사원 등록에 실패하였습니다.");
			} else if(code == 515) {
				model.addAttribute("message", "사진 저장에 실패하였습니다.");
			}
			
			return "/member/ModifyMember";
		}
		
		model.addAttribute("memberNumber", modifyMemberBean.getMemberNumber());
		return "/member/ModifyMemberSuccess";
	}
	
	// 사원 삭제
	@DeleteMapping("/deleteMember/{numbers}")
	@ResponseBody
	public ResponseEntity<String> deleteMember(@PathVariable("numbers")int[] memberNumbers){
		
		Boolean isDelete = memberService.deleteMember(memberNumbers);
		
		if(isDelete) {
			return ResponseEntity.ok("true");
		} else {
			return ResponseEntity.status(500).body("false");
		}
		
	}
	
	// 사원 개인 프로젝트 관리
	@GetMapping("/memberProject/info/{memberNumber}/{memberName}/")
	public String memberProjectInfo(@PathVariable("memberNumber") int memberNumber,
									@PathVariable("memberName") String memberName,
									Model model) {
		
		ArrayList<ProjectMemberBean> memberProjectList = memberService.getMemberProjectList(memberNumber);
		ArrayList<CodeBean> roleList = codeService.getDetailCodeList("RO01");
		
		model.addAttribute("memberNumber", memberNumber);
		model.addAttribute("memberName", memberName);
		model.addAttribute("memberProjectList", memberProjectList);
		model.addAttribute("roleList", roleList);
		
		return "/member/MemberProject";
	}
	
	@GetMapping("/memberProject/addMemberProjectModal/{memberNumber}")
	public String addMemberProjectModal(@PathVariable("memberNumber") int memberNumber,
										Model model) {
		
		ArrayList<ProjectMemberBean> projectList = memberService.nonParticipatingProjects(memberNumber);
		ArrayList<CodeBean> roleList = codeService.getDetailCodeList("RO01");
		
		model.addAttribute("projectList", projectList);
		model.addAttribute("roleList", roleList);
		
		return "/member/AddMemberProject";
	}
	
	// 사원 프로젝트 추가
	@PostMapping("/memberProject/add")
	@ResponseBody
	public Boolean addMemberProject(@RequestBody ArrayList<ProjectMemberBean> projectMemberBeans,
									BindingResult bindingResult) {
		
		Boolean result = memberService.addMemberProject(projectMemberBeans);
		
		return result;
	}
	
	
	// 사원 프로젝트 수정
	@PutMapping("/memberProject/update")
	@ResponseBody
	public ResponseEntity<Boolean> updateMemeberProject(@RequestBody ArrayList<ProjectMemberBean> projectMemberBeans,
														BindingResult bidingResult) {
		
		Boolean result = memberService.updateMemberProject(projectMemberBeans);
		System.out.println("UpdateResult : " + result);
		
		System.out.println(projectMemberBeans);
		return ResponseEntity.ok(result);
	}
	
	// 사원 프로젝트 삭제
	@DeleteMapping("/memberProject/delete/{projectNumbers}/{memberNumber}/")
	@ResponseBody
	public Boolean deleteMemberProject(@PathVariable("projectNumbers") int[] projectNumbers,
										@PathVariable("memberNumber") int memberNumber) {
		
		Boolean result = memberService.deleteMemberProject(projectNumbers, memberNumber);
		return result;
	}
	
	// 페이지에 필요한 리스트를 처리하는 메서드
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
