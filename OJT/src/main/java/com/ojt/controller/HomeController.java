package com.ojt.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.ojt.bean.MemberBean;

@Controller
@RequestMapping("/")
public class HomeController {
	
	@GetMapping("/")
	public String home(Model model) {
		
		MemberBean loginMemberBean = new MemberBean();
		model.addAttribute(loginMemberBean);
		
		return "Login";
	}
}
