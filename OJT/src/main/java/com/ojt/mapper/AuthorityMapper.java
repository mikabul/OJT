package com.ojt.mapper;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.ojt.bean.AuthorityBean;
import com.ojt.bean.MenuBean;

@Mapper
public interface AuthorityMapper {
	
	// 모든 권한 정보
	public ArrayList<AuthorityBean> getAllAuthority();
	
	// 메뉴 리스트
	public ArrayList<MenuBean> getShowMenu(@Param("memberNumber") int memberNumber);
}
