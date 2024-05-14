package com.ojt.util;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.context.annotation.PropertySource;
import org.springframework.stereotype.Component;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.validation.FieldError;

@Component
@PropertySource("/WEB-INF/properties/error_message.properties")
public class ErrorMessage {
	
	@Autowired
	MessageSource messageSource;
	
	// 에러필드 리스트를 받아서 에러메세지를 반환하는 메서드
	public MultiValueMap<String, String> getErrorMessage(List<FieldError> fieldError) {
		
		MultiValueMap<String, String> map = new LinkedMultiValueMap<String, String>();
		
		for(FieldError error : fieldError) {
			
			String errorCode = error.getCode();
			String errorField = error.getField();
			String objectName = error.getObjectName();
			String errorMessage = messageSource.getMessage(errorCode + "." + objectName + "." + errorField, null, Locale.getDefault());
			
			map.add(errorField, errorMessage);
		}
		
		return map;
	}
	
	// 에러 정보가 담긴 맵을 받아서 에러메세지를 반환하는 메서드
	public Map<String, Object> getErrorMessage(Map<Integer, MultiValueMap<String, Object>> errorMap, String className) {
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		for(Integer key : errorMap.keySet()) {
			ArrayList<String> errorMessages = new ArrayList<String>();
			
			for(String errorField : errorMap.get(key).keySet()) {
				List<String> errorList = (ArrayList)errorMap.get(key).get(errorField);
				for(String errorCode : errorList) {
					String errorMessage = messageSource.getMessage(errorCode + "." + className + "." + errorField, null, Locale.getDefault());
					errorMessages.add(errorMessage);
				}
			}
			
			map.put(key.toString(), errorMessages);
		}
		
		return map;
	}
}
