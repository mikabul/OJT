package com.ojt.bean;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Collection;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import lombok.ToString;

@ToString
public class MemberDetails implements UserDetails, Serializable{
	
	private static final long serialVersionUID = 1L;
	
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
			collectors.add(() -> role);
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
	
	public String getMemberNumber() {
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
