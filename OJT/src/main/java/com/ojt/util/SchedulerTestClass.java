package com.ojt.util;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import org.springframework.batch.core.Job;
import org.springframework.batch.core.JobExecution;
import org.springframework.batch.core.JobParameter;
import org.springframework.batch.core.JobParameters;
import org.springframework.batch.core.launch.JobLauncher;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Component
public class SchedulerTestClass {

	private static final SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");

	private int second = 0;
	
	@Autowired
	@Qualifier("simpleJobLauncher")
	private JobLauncher jobLauncher;

	@Autowired
	private Job projectStateChangeJob;
	
//	@Scheduled(fixedRate = 1000)
//	public void showTimer() {
//		
//		System.out.println("실행 : " + second++);
//	}
	
	// 프로젝트 상태 수정
	@Scheduled(fixedRate = 3 * 60 * 1000)
	public void batch_changeProjectState() {
		
		Date nowDate = new Date();
		String now = dateFormat.format(nowDate);
		Long currTime = System.currentTimeMillis();
		JobExecution jobExecution;
		System.out.println("Job Run");
		
		Map<String, JobParameter> parameterMap = new HashMap<String, JobParameter>();
		parameterMap.put("now", new JobParameter(now));
		parameterMap.put("currTime", new JobParameter(currTime));
		
		JobParameters jobParameters = new JobParameters(parameterMap);
		
		try {
			jobExecution = jobLauncher.run(projectStateChangeJob, jobParameters);
		} catch (Exception e) {
			System.out.println("프로젝트 상태 수정 실패");
			System.out.println(e);
		}
		
	}

}
