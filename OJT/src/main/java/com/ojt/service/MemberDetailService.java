package com.ojt.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.ojt.bean.LoginMemberBean;
import com.ojt.bean.MemberDetails;
import com.ojt.mapper.MemberMapper;

@Service
public class MemberDetailService implements UserDetailsService {
	
	@Autowired
	private MemberMapper memberMapper;
	
	@Override
	public UserDetails loadUserByUsername(String memberId) throws UsernameNotFoundException {
		
		try {
			LoginMemberBean loginMemberBean = memberMapper.findByUsername(memberId);
			
			if(loginMemberBean != null) {
				return new MemberDetails(loginMemberBean);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return null;
	}

	
}
