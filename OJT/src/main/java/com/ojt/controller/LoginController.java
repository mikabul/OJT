package com.ojt.controller;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;

import com.ojt.bean.MemberBean;

@Controller
public class LoginController{
	
	@Resource(name = "loginMemberBean")
	MemberBean loginMemberBean;

	@PostMapping("/Login")
	public String login(@ModelAttribute("loginMemberBean") MemberBean loginMemberBean) {
		this.loginMemberBean.setLoginState(true);
		System.out.println(this.loginMemberBean.isLoginState());
		return "redirect:/Main";
		
	}
	
	@GetMapping("Logout")
	public String logout() {
		loginMemberBean.setLoginState(false);
		System.out.println(loginMemberBean.isLoginState());
		return "redirect:/";
	}
	
	
}
