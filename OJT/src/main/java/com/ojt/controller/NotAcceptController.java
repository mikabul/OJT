package com.ojt.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class NotAcceptController {
	
	@RequestMapping(value = "/access-denied")
	public String notAccept() {
		
		return "/AccessDenied";
	}
	
}
