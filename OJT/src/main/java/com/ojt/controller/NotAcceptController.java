package com.ojt.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/Accept")
public class NotAcceptController {
	
	@RequestMapping(value = "/NotAccept")
	public String notAccept() {
		return "/NotAccept";
	}
	
}
