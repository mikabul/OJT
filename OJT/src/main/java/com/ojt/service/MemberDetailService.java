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
		System.out.println("UserDetailService userName : " + memberId);
		try {
			LoginMemberBean loginMemberBean = memberMapper.findByUsername(memberId);
			System.out.println("loginMemberBean");
			System.out.println(loginMemberBean.toString());
			
			if(loginMemberBean != null) {
				System.out.println(loginMemberBean);
				return new MemberDetails(loginMemberBean);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		
		return null;
	}

	
}
