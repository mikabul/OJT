package com.ojt.validator;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.Errors;
import org.springframework.validation.Validator;

import com.ojt.bean.ProjectBean;
import com.ojt.service.ProjectService;

public class ProjectMemberValidator implements Validator{
	
	@Autowired
	ProjectService projectService;
	
	@Override
	public boolean supports(Class<?> clazz) {
		return ProjectBean.class.isAssignableFrom(clazz);
	}

	@Override
	public void validate(Object target, Errors errors) {
		
		ProjectBean projectBean = (ProjectBean)target;
		
		Integer memberNumber = pm.getMemberNumber();
		String startDate = pm.getStartDate();
		String endDate = pm.getEndDate();
	}

}
