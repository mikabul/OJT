package com.ojt.dao;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.ojt.bean.CodeBean;
import com.ojt.mapper.CodeMapper;

@Repository
public class CodeDao {
	
	@Autowired
	CodeMapper codeMapper;

	// 코드 리스트
	public ArrayList<CodeBean> getCodeList(){
		return codeMapper.getCodeList();
	}

	// 특정 코드 리스트
	public ArrayList<CodeBean> getCodeList(String masterCode){
		return codeMapper.getCodeList(masterCode);
	}

	// 마스터 코드 리스트
	public ArrayList<CodeBean> getMasterCodeList(){
		return codeMapper.getMasterCodeList();
	}
}
