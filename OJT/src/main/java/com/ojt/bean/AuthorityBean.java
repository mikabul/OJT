package com.ojt.bean;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class AuthorityBean {
	
	private int authorityNumber;
	private String authorityName;
	private String authorityNames;
	private String[] authorityNameList;
	
	private String menuUrl;
	private String menuUrls;
	private String[] menuUrlList;
	
	public void setMenuUrls(String menuUrls) {
		this.menuUrls = menuUrls;
		this.menuUrlList = menuUrls.split(",");
	}
	
	public void setAuthorityNames(String authorityNames) {
		this.authorityNames = authorityNames;
		this.authorityNameList = authorityNames.split(",");
	}
}
