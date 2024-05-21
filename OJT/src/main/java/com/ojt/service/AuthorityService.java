package com.ojt.service;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ojt.bean.AuthorityBean;
import com.ojt.bean.MenuBean;
import com.ojt.dao.AuthorityDao;

@Service
public class AuthorityService {
	
	@Autowired
	private AuthorityDao authorityDao;

	// 모든 권한 정보
	public ArrayList<AuthorityBean> getAllAuthority() {
		
		return authorityDao.getAllAuthority();
	}
	
	// 메뉴 리스트
	public ArrayList<MenuBean> getShowMenu(int memberNumber) {
		return authorityDao.getShowMenu(memberNumber);
	}

}
