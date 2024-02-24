package com.ojt.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.context.annotation.SessionScope;

import com.ojt.bean.MemberBean;

@Configuration
public class RootAppContext {

	@Bean("loginMemberBean")
	@SessionScope
	public MemberBean loginMemberBean() {
		return new MemberBean();
	}
	
}
