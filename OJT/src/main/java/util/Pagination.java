package util;

import java.util.HashMap;
import java.util.Map;

import org.springframework.stereotype.Component;

@Component
public class Pagination {

	public Map<String, Object> getPageBtns(int page, int maxCount, int view){
		
		// 결과를 담을 맵 생성
		Map<String, Object> map = new HashMap<String, Object>();
		
		// 최대 페이지 개수와 페이지버튼을 담을 변수 생성(초기화 X)
		int maxPage = maxCount % view == 0 ? maxCount / view : maxCount / view + 1;
		int pageBtns[];
		
		// page는 0, 10, 20 이므로 계산을 위해 + 1
		if(maxPage - (page + 1) > 10) { // 페이지 버튼이 10개이상 생성되는지
			pageBtns = new int[10];
			
			for(int i = 0; i < pageBtns.length; i++) {
				pageBtns[i] = page + i;
			}
		} else {
			pageBtns = new int[maxPage - (page + 1)];
			
			for(int i = 0; i < pageBtns.length; i++) {
				pageBtns[i] = page + i;
			}
		}
		
		map.put("maxPage", maxPage);
		map.put("pageBtns", pageBtns);
		
		return map;
		
	}
}
