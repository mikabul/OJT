package com.ojt.mapper;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Mapper;

import com.ojt.bean.CodeBean;

@Mapper
public interface CodeMapper {
	
	// 디테일 코드 리스트
	public ArrayList<CodeBean> getCodeList();
	
	// 특정 디테일 코드 리스트
	public ArrayList<CodeBean> getCodeList(String masterCode);
	
	// 마스터 코드 리스트
	public ArrayList<CodeBean> getMasterCodeList();
	
	// 특정 코드 리스트(코드만 반환)
	public ArrayList<String> getCodes(String masterCode);
}
