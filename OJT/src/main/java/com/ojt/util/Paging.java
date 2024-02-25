package com.ojt.util;

import org.springframework.stereotype.Component;

@Component
public class Paging {
	
	public int[] getPaging(int maxView, int view, int page){
		
		int pageBtn[];
		
		int maxPage = maxView / view;
		
		maxPage = maxPage == 0 ? 1 : maxPage;
		
		if(maxPage <= 10) {
			pageBtn = new int[maxPage];
			
			for(int i = 0; i < pageBtn.length; i++) {
				pageBtn[i] = i + 1;
			}
		} else {
			pageBtn = new int[10];
			
			if(page < 6) {
				for(int i = 0; i < pageBtn.length; i++) {
					pageBtn[i] = i + 1;
				}
			} else if( page >= 6 && (maxPage - 5) <= page) {
				for(int i = 0; i < 10; i++) {
					pageBtn[i] = (i - 5) + page;
				}
			} else {
				for(int i = 9; i > 0; i--) {
					pageBtn[i] = maxPage - i;
				}
			}
		}
		
		return pageBtn;
		
	}
	
}
