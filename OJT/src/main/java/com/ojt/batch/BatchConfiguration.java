package com.ojt.batch;

import org.springframework.batch.core.Job;
import org.springframework.batch.core.JobExecutionListener;
import org.springframework.batch.core.Step;
import org.springframework.batch.core.configuration.annotation.DefaultBatchConfigurer;
import org.springframework.batch.core.configuration.annotation.EnableBatchProcessing;
import org.springframework.batch.core.configuration.annotation.JobBuilderFactory;
import org.springframework.batch.core.configuration.annotation.StepBuilderFactory;
import org.springframework.batch.core.launch.JobLauncher;
import org.springframework.batch.repeat.RepeatStatus;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
@EnableBatchProcessing
public class BatchConfiguration extends DefaultBatchConfigurer{
	
	@Autowired
	private JobBuilderFactory jobBuilderFactory;
	
	@Autowired
	private StepBuilderFactory stepBuilderFactory;
	
//	@Bean  
//	 public Step simpleStep(){  
//		 return stepBuilderFactory.get("simpleStep1")  
//			 .tasklet((contribution, chunkContext) -> {  
//				 System.out.println("step1");  
//				 return RepeatStatus.FINISHED;  
//			 }) .build();  
//	 }
//
//	 @Bean  
//	 public Job simpleJob(){  
//		 return jobBuilderFactory.get("simpleJob")
//			 .listener(jobExecutionListener())
//			 .start(simpleStep())  
//		 .build();  
//	 }
//	
//	 private JobExecutionListener jobExecutionListener() {
//		 JobLauncher jsobLauncher = super.getJobLauncher();
//	 }
}
