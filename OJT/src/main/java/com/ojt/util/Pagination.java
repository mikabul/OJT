package com.ojt.util;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.PropertySource;
import org.springframework.stereotype.Component;

@Component
@PropertySource("/WEB-INF/properties/setting.properties")
public class Pagination {
	
	@Value("${buttonCount}")
	int buttonCount; //생성할 버튼의 개수

	public Map<String, Object> getPageBtns(int page, int maxCount, int view){
		
		// 결과를 담을 맵 생성
		Map<String, Object> map = new HashMap<String, Object>();
		
		// 최대 페이지 개수와 페이지버튼을 담을 변수 생성(초기화 X)
		int maxPage = maxCount % view == 0 ? maxCount / view : maxCount / view + 1;
		int pageBtns[];
		
		// 이전(다음)페이지 버튼 integer
		Integer preBtn = null;
		Integer nextBtn = null;
		
		page = (page / buttonCount) * buttonCount;
		if(maxPage - (page) > buttonCount) { // 페이지 버튼이 'buttonCount'개초과로 생성되는지
			pageBtns = new int[buttonCount];
			
			for(int i = 0; i < pageBtns.length; i++) {
				pageBtns[i] = page + i;
			}
		} else {
			pageBtns = new int[maxPage - (page)];
			
			for(int i = 0; i < pageBtns.length; i++) {
				pageBtns[i] = page + i;
			}
		}
		
		if(page >= buttonCount) preBtn = page - buttonCount;
		if(maxPage - (page) > buttonCount) nextBtn = page + buttonCount;
		
		map.put("pageBtns", pageBtns);
		map.put("preBtn", preBtn);
		map.put("nextBtn", nextBtn);
		
		return map;
		
	}
}
