package com.ojt.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.ojt.bean.LoginMemberBean;
import com.ojt.mapper.MemberMapper;

@Repository
public class LoginMemberDao {
	
	@Autowired
	private MemberMapper memberMapper;
	
	public LoginMemberBean findByUsername(String memberId) {
		System.out.println("loginMemberDao : " + memberId);
		LoginMemberBean b = memberMapper.findByUsername(memberId);
		System.out.println("login");
		System.out.println(b.toString());
		return memberMapper.findByUsername(memberId);
	}
	
}
