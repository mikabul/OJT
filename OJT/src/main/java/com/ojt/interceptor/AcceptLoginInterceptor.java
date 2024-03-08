package com.ojt.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.HandlerInterceptor;

import com.ojt.bean.MemberBean;

public class AcceptLoginInterceptor implements HandlerInterceptor{
	
	MemberBean loginMemberBean;
	
	public AcceptLoginInterceptor(MemberBean loginMemberBean) {
		this.loginMemberBean = loginMemberBean;
	}

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		
		return true;
		
//		if(loginMemberBean.isLoginState() == false) {
//			
//			String contextPath = request.getContextPath();
//			response.sendRedirect(contextPath + "/Accept/NotAccept");
//			
//			return false;
//		} else {
//			return true;
//		}
		
	}
	
	
	
}
