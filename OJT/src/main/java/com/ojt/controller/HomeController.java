package com.ojt.controller;

import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {
	
	@GetMapping("/")
	public String home() {
		
		if(SecurityContextHolder.getContext().getAuthentication() == null) {
			return "redirect:/login";
		} else {
			return "redirect:/main";
		}
		
//		return "redirect:/login";
		
	}
}
