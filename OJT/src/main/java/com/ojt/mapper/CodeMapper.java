package com.ojt.mapper;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Mapper;

import com.ojt.bean.CodeBean;

@Mapper
public interface CodeMapper {
	
	// 코드 리스트
	public ArrayList<CodeBean> getCodeList();
	
	// 특정 코드 리스트
	public ArrayList<CodeBean> getCodeList(String masterCode);
	
	// 마스터 코드 리스트
	public ArrayList<CodeBean> getMasterCodeList();
	
}
