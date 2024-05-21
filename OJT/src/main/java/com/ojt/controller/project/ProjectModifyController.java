package com.ojt.controller.project;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.ojt.bean.CodeBean;
import com.ojt.bean.CustomerBean;
import com.ojt.bean.MemberBean;
import com.ojt.bean.ProjectBean;
import com.ojt.bean.ProjectMemberBean;
import com.ojt.service.ProjectMemberService;
import com.ojt.service.ProjectService;
import com.ojt.validator.ProjectValidator;

@Controller
@RequestMapping("/project/modify")
public class ProjectModifyController {
	
	@Autowired
	private ProjectService projectService;
	
	@Autowired
	private ProjectMemberService projectMemberService;

	// 프로젝트 수정 모달 생성
	@GetMapping("/modal")
	public String modifyMain(@RequestParam("projectNumber")int projectNumber, Model model) {
		
		ProjectBean projectBean = projectService.getProjectInfo(projectNumber);
		ArrayList<CustomerBean> customerList = projectService.getCustomerList("");
		ArrayList<CodeBean> roleList = projectService.getRole();
		ArrayList<CodeBean> skList = projectService.getSKList();
		ArrayList<CodeBean> psList = projectService.getPsList();
		
		if(projectBean != null) {
			
			if(projectBean.getMaintStartDate() != null && !projectBean.getMaintStartDate().isEmpty()) {
				model.addAttribute("endDate", projectBean.getMaintEndDate());
			} else {
				model.addAttribute("endDate", projectBean.getProjectEndDate());
			}
			
			model.addAttribute("modifyProjectBean", projectBean);
			model.addAttribute("startDate", projectBean.getProjectStartDate());
			model.addAttribute("customerList", customerList);
			model.addAttribute("roleList", roleList);
			model.addAttribute("skList", skList);
			model.addAttribute("psList", psList);
			
			return "/project/modifyProject/ModifyProject";
		} else {
			return "Main";
		}
	}
	
	// 프로젝트 수정
	@PostMapping("/modify-project")
	public String modifyProject(
			@ModelAttribute("modifyProjectBean")ProjectBean modifyProjectBean,
			@RequestParam("deleteMemberNumbers")int[] deleteMemberNumbers,
			BindingResult result, Model model) {
		
		// 유효성 검사
		ProjectValidator projectValidator = new ProjectValidator(projectService, projectMemberService);
		projectValidator.validate(modifyProjectBean, result);
		
		// 멤버 에러 메세지 추출
//		List<FieldError> fieldErrors = result.getFieldErrors();
//		for(FieldError error : fieldErrors) {
//			System.out.println(error.getField());
//			System.out.println(error.getCode());
//		}
		
		// 삭제 될 멤버 정보 유지를 위해 리스트에 저장
		ArrayList<Integer> deleteMemberList = new ArrayList<Integer>();
		for(int i : deleteMemberNumbers) {
			deleteMemberList.add(i);
		}
		
		ArrayList<CustomerBean> customerList = projectService.getCustomerList("");
		ArrayList<CodeBean> roleList = projectService.getRole();
		ArrayList<CodeBean> skList = projectService.getSKList();
		ArrayList<CodeBean> psList = projectService.getPsList();
		
		// date max를 지정하기 위한 if문
		if(!modifyProjectBean.getMaintStartDate().isEmpty()) {
			model.addAttribute("endDate", modifyProjectBean.getMaintEndDate());
		} else {
			model.addAttribute("endDate", modifyProjectBean.getProjectEndDate());
		}
		
		model.addAttribute("deleteMemberList", deleteMemberList);
		model.addAttribute("startDate", modifyProjectBean.getProjectStartDate());
		model.addAttribute("customerList", customerList);
		model.addAttribute("roleList", roleList);
		model.addAttribute("skList", skList);
		model.addAttribute("psList", psList);
		
		if(result.hasErrors()) {// 유효성 검사 실패
			
			model.addAttribute("success", false);
			model.addAttribute("code", 400);
			
			return "/project/modifyProject/ModifyProject";
		}
		
		if(!projectService.modifyProject(modifyProjectBean)) { // 프로젝트 수정 실패
			model.addAttribute("success", false);
			model.addAttribute("code", 500);
		} else if(!projectMemberService.updateProjectMember(modifyProjectBean)){ // 프로젝트 멤버 수정 혹은 추가 실패
			model.addAttribute("success", false);
			model.addAttribute("code", 501);
		} else if(!projectMemberService.deleteProjectMember(deleteMemberNumbers, modifyProjectBean.getProjectNumber())){ // 프로젝트 멤버 삭제 실패
			model.addAttribute("success", false);
			model.addAttribute("code", 502);
		} else { // 성공
			model.addAttribute("success", true);
		}
		
		return "/project/modifyProject/ModifyProject";
	}
	
	// 프로젝트 멤버추가 모달 생성
	@PostMapping("/member-modal")
	public String modalAddProjectMember(@RequestParam("startDate")String startDate,
										@RequestParam("endDate")String endDate,
										Model model) {

		model.addAttribute("startDate", startDate);
		model.addAttribute("endDate", endDate);
		
		return "/project/modifyProject/AddProjectMember";
	}
	
	// 프로젝트 멤버 테이블에 없는 멤버 검색
	@PostMapping("/not-project-member")
	public String getNotAddProjectMember(@RequestParam("search")String search,
										@RequestParam(name = "memberNumbers[]", required = false)int[] memberNumbers,
										@RequestParam("startDate")String startDate,
										@RequestParam("endDate")String endDate,
										Model model) {
		
		ArrayList<MemberBean> memberList = projectMemberService.getNotAddProjectMember(search, memberNumbers);
		ArrayList<CodeBean> roleList = projectService.getRole();
		
		model.addAttribute("memberList", memberList);
		model.addAttribute("roleList", roleList);
		model.addAttribute("startDate", startDate);
		model.addAttribute("endDate", endDate);
		
		return "/project/modifyProject/AddProjectMemberTable";
	}
	
	// 프로젝트 수정 멤버 테이블에 멤버 추가
	@PostMapping("/add-member")
	public String modifyProjectMember(@RequestBody Map<String, Object> requestMap,
									Model model) {
		
		ArrayList<CodeBean> roleList = projectService.getRole();
		
		model.addAttribute("roleList", roleList);
		model.addAttribute("pmList", requestMap.get("pmList"));
		model.addAttribute("startDate", requestMap.get("startDate"));
		model.addAttribute("endDate", requestMap.get("endDate"));
		model.addAttribute("rowsLength", requestMap.get("rowsLength"));
		
		return "project/modifyProject/ModifyProjectMemberTable";
	}
	
	// 프로젝트 수정 멤버 테이블에서 멤버 제거
	@PostMapping("/delete-member")
	public String deleteMember(
			@ModelAttribute("modifyProjectBean") ProjectBean modifyProjectBean,
			@RequestParam("deleteIndex") int[] deleteIndex,
			Model model) {
		
		ArrayList<ProjectMemberBean> pmList = modifyProjectBean.getPmList();
		
		for(int i = deleteIndex.length - 1; i >= 0; i--) {
			pmList.remove(deleteIndex[i]);
		}
		
		ArrayList<CodeBean> roleList = projectService.getRole();
		
		model.addAttribute("pmList", pmList);
		model.addAttribute("startDate", modifyProjectBean.getProjectStartDate());
		if(!modifyProjectBean.getMaintStartDate().isEmpty()) {
			model.addAttribute("endDate", modifyProjectBean.getMaintEndDate());
		} else {
			model.addAttribute("endDate", modifyProjectBean.getProjectEndDate());
		}
		
		model.addAttribute("roleList", roleList);
		model.addAttribute("rowsLength", 0);
		return "project/modifyProject/ModifyProjectMemberTable";
	}
	
	// 프로젝트 상태 변경
	@PostMapping("/update-state")
	public ResponseEntity<String> searchMember(@RequestParam(name = "projectNumbers[]") int[] projectNumbers,
			@RequestParam(name = "projectState[]") String[] projectState) {
		Boolean result = projectService.updateProjectState(projectNumbers, projectState);
		if (result) {
			return ResponseEntity.ok("");
		} else {
			return ResponseEntity.status(500).body("");
		}
	}
}
