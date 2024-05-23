package com.ojt.config;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.batch.core.configuration.annotation.EnableBatchProcessing;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.InterceptorRegistration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.ViewResolverRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import com.ojt.interceptor.PostLoginInterceptor;
import com.ojt.service.AuthorityService;

@Configuration
@EnableWebMvc
@EnableScheduling
@EnableBatchProcessing
@ComponentScan("com.ojt.controller")
@ComponentScan("com.ojt.service")
@ComponentScan("com.ojt.dao")
@ComponentScan("com.ojt.util")
@MapperScan("com.ojt.mapper")
public class ServletAppContext implements WebMvcConfigurer{
	
	@Autowired
	private AuthorityService authorityService;
	
	@Override
	public void configureViewResolvers(ViewResolverRegistry registry) {
		WebMvcConfigurer.super.configureViewResolvers(registry);
		registry.jsp("/WEB-INF/views/", ".jsp");
	}
	
	@Override
	public void addResourceHandlers(ResourceHandlerRegistry registry) {
		WebMvcConfigurer.super.addResourceHandlers(registry);
		registry.addResourceHandler("/**").addResourceLocations("/resources");
	}

	@Override
	public void addInterceptors(InterceptorRegistry registry) {
		WebMvcConfigurer.super.addInterceptors(registry);
		
		PostLoginInterceptor postLogin = new PostLoginInterceptor(authorityService);
		InterceptorRegistration regLogin = registry.addInterceptor(postLogin);
		
		regLogin.addPathPatterns("/**");
		regLogin.excludePathPatterns("/", "/login", "/logout");
	}
}
