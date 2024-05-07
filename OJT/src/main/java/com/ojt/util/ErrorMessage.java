package com.ojt.util;

import java.util.List;
import java.util.Locale;

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
}
