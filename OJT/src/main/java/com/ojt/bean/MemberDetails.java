package com.ojt.bean;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Collection;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import lombok.ToString;

@ToString
public class MemberDetails implements UserDetails, Serializable{
	
	private static final long serialVersionUID = 1;
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	private final LoginMemberBean loginMemberBean;
	
	public MemberDetails(LoginMemberBean loginMemberBean) {
		this.loginMemberBean = loginMemberBean;
	}

	@Override
	public Collection<? extends GrantedAuthority> getAuthorities() {
		
		String roles = loginMemberBean.getRoles();
		String[] roleList = roles.split(",");
		
		Collection<GrantedAuthority> collectors = new ArrayList<GrantedAuthority>();
		
		for(String role : roleList) {
			collectors.add(new GrantedAuthority() {
				
				private static final long serialVersionUID = 1L;
				
				@Override
				public String getAuthority() {
					return "ROLE_" + role;
				}
			});
		}
		
		// 현재 로그인 된 계정의 권한을 콘솔에 표시 -- 나중에 지울것
		for(GrantedAuthority g : collectors) {
			logger.info("MemberDetails : " + g.getAuthority());
		}
		
		return collectors;
	}
	
	@Override
	public String getPassword() {
		return loginMemberBean.getMemberPW();
	}

	@Override
	public String getUsername() {
		return loginMemberBean.getMemberId();
	}
	
	public int getMemberNumber() {
		return loginMemberBean.getMemberNumber();
	}
	
	public String getMemberName() {
		return loginMemberBean.getMemberName();
	}

	@Override
	public boolean isAccountNonExpired() {
		return true;
	}

	@Override
	public boolean isAccountNonLocked() {
		return true;
	}

	@Override
	public boolean isCredentialsNonExpired() {
		return true;
	}

	@Override
	public boolean isEnabled() {
		return true;
	}
	
	
}
