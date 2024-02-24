package com.ojt.mapper;

import org.apache.ibatis.annotations.Select;

import com.ojt.bean.MemberBean;

public interface MemberMapper {

	//-------- 로그인 --------
	@Select("select mem_id, mem_pw from member_info where mem_id=#{member_id}")
	public MemberBean checkMemberId(String memberId);
	
}
