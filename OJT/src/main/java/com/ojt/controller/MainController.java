package com.ojt.controller;

import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.ojt.bean.MemberDetails;

@Controller
public class MainController {

	@GetMapping("/main")
	public String main(@AuthenticationPrincipal MemberDetails memberDetails, Model model){
		
		return "Main";
	}
}
