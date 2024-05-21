package com.ojt.interceptor;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Iterator;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.servlet.HandlerInterceptor;

import com.ojt.bean.MemberDetails;
import com.ojt.bean.MenuBean;
import com.ojt.service.AuthorityService;

public class PostLoginInterceptor implements HandlerInterceptor{
	
	private final AuthorityService authorityService;
	
	public PostLoginInterceptor(AuthorityService authorityService) {
		this.authorityService = authorityService;
	}

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		
		if(SecurityContextHolder.getContext().getAuthentication() != null) {
			Object memberPrincipal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
			MemberDetails memberDetails = (MemberDetails)memberPrincipal;
			
			// 사원의 이름을 request에 추가
			request.setAttribute("loginMemberName", memberDetails.getMemberName());
			
			// 메뉴를 reqeust에 추사
			int memberNumber = memberDetails.getMemberNumber();
			ArrayList<MenuBean> menuList = authorityService.getShowMenu(memberNumber);
			request.setAttribute("menuList", menuList);
			
			// 권한을 request에 추가
			Collection<? extends GrantedAuthority> collector = memberDetails.getAuthorities();
			Iterator<?> it = collector.iterator();
			while(it.hasNext()) {
				GrantedAuthority authority = (GrantedAuthority)it.next();
				String authorityName = authority.getAuthority();
				request.setAttribute(authorityName, true);
			}
		}
		
		return true;
	}
	
}
