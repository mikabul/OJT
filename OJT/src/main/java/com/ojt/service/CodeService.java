package com.ojt.service;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ojt.bean.CodeBean;
import com.ojt.dao.CodeDao;

@Service
public class CodeService {
	
	@Autowired
	CodeDao codeDao;
	
	public ArrayList<CodeBean> getDetailCodeList(){
		return codeDao.getCodeList();
	}
	
	public ArrayList<CodeBean> getDetailCodeList(String masterCode){
		return codeDao.getCodeList(masterCode);
	}
}
