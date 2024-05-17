package com.ojt.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class LoginController{
	
	@RequestMapping("/login")
	public String login(Boolean error, Model model) {
		
		model.addAttribute("error", error);
		
		return "/Login";
	}
}
