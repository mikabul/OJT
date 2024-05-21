package com.ojt.dao;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.ojt.bean.AuthorityBean;
import com.ojt.bean.MenuBean;
import com.ojt.mapper.AuthorityMapper;

@Repository
public class AuthorityDao {
	
	@Autowired
	private AuthorityMapper authorityMapper;

	// 모든 권한 정보
	public ArrayList<AuthorityBean> getAllAuthority(){
		return authorityMapper.getAllAuthority();
	}
	
	// 메뉴 리스트
	public ArrayList<MenuBean> getShowMenu(int memberNumber) {
		return authorityMapper.getShowMenu(memberNumber);
	}
}
