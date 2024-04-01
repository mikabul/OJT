package com.ojt.bean;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class CodeBean {

	private String masterCode;
	private String detailCode;
	private String codeName;
	
	@Override
	public String toString() {
		return "마스터 코드 : " + masterCode + " || 디테일 코드 : " + detailCode + " || 디테일 코드 네임 : " + codeName;
	}
}
