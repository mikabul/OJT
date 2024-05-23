package com.ojt.batch;

import java.time.LocalDate;

import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.batch.MyBatisBatchItemWriter;
import org.mybatis.spring.batch.MyBatisPagingItemReader;
import org.mybatis.spring.batch.builder.MyBatisBatchItemWriterBuilder;
import org.springframework.batch.core.Job;
import org.springframework.batch.core.Step;
import org.springframework.batch.core.configuration.annotation.DefaultBatchConfigurer;
import org.springframework.batch.core.configuration.annotation.EnableBatchProcessing;
import org.springframework.batch.core.configuration.annotation.JobBuilderFactory;
import org.springframework.batch.core.configuration.annotation.JobScope;
import org.springframework.batch.core.configuration.annotation.StepBuilderFactory;
import org.springframework.batch.core.configuration.annotation.StepScope;
import org.springframework.batch.item.ItemProcessor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import com.ojt.bean.ProjectBean;

import lombok.extern.slf4j.Slf4j;

@Configuration
@EnableBatchProcessing
@Slf4j
public class ProjectStateJob extends DefaultBatchConfigurer{
	
	@Autowired
	private JobBuilderFactory jobBuilderFactory;

	@Autowired
	private StepBuilderFactory stepBuilderFactory;
	
	@Autowired
	private SqlSessionFactory sqlSessionFactory;

	@Bean
	public Job projectStateChangeJob() {
		return jobBuilderFactory.get("projectStateChangeJob")
				.start(projectStateStartStep())
				.next(projectStatePostStartStep())
				.next(projectStateEndStep())
				.build();
	}
	
	// 프로젝트의 상태가 진행예정인
	@Bean
	@JobScope
	public Step projectStateStartStep() {
		return stepBuilderFactory.get("projectStateStartStep")
				.<ProjectBean, ProjectBean>chunk(10)
				.reader(readPreStartProject(null))
				.processor(procPreStartProject())
				.writer(writerPreStartProject())
				.build();
	}
	
	// 프로젝트의 상태가 진행중인
	@Bean
	@JobScope
	public Step projectStatePostStartStep() {
		return stepBuilderFactory.get("projectStatePostStartStep")
				.<ProjectBean, ProjectBean>chunk(10)
				.reader(readPostStartProject(null))
				.processor(procPostStartProject(null))
				.writer(writerPostStartProject())
				.build();
	}
	
	// 프로젝트의 상태가 유지보수인
	@Bean
	@JobScope
	public Step projectStateEndStep() {
		return stepBuilderFactory.get("projectStateEndStep")
				.<ProjectBean, ProjectBean>chunk(10)
				.reader(readEndProject(null))
				.processor(procEndProject())
				.writer(writerEndProject())
				.build();
	}
	
	/*
	 * 프로젝트의 상태가 진행 예정이며
	 * 프로젝트의 시작일과 종료일 사이에 위치하는 프로젝트
	 * 상태를 진행 으로 변경
	 */
	@Bean
	@StepScope
	public MyBatisPagingItemReader<ProjectBean> readPreStartProject(@Value("#{jobParameters['pagesize']}") Integer pagesize) {
		
		MyBatisPagingItemReader<ProjectBean> reader = new MyBatisPagingItemReader<ProjectBean>();
		reader.setPageSize(pagesize != null ? pagesize : 10);
		reader.setSqlSessionFactory(sqlSessionFactory);
		reader.setQueryId("com.ojt.mapper.BatchMapper.getPreStartProject");
		
		return reader;
	}
	
	@Bean
	@StepScope
	public ItemProcessor<ProjectBean, ProjectBean> procPreStartProject() {
		return item -> {
			log.info("preStartProject {}", item);
			item.setProjectStateCode("2");
			return item;
		};
	}
	
	@Bean
	@StepScope
	public MyBatisBatchItemWriter<ProjectBean> writerPreStartProject() {
		return new MyBatisBatchItemWriterBuilder<ProjectBean>()
				.sqlSessionFactory(sqlSessionFactory)
				.statementId("com.ojt.mapper.BatchMapper.projectStatusUpdate")
				.build();
	}
	
	/*
	 * 프로젝트의 상태가 진행중이면서
	 * 현재날짜가 프로젝트 종료일보다 큰 프로젝트의 상태를
	 * 유지보수 혹은 종료로 변경
	 */
	@Bean
	@StepScope
	public MyBatisPagingItemReader<ProjectBean> readPostStartProject(@Value("#{jobParameters['pagesize']}") Integer pagesize) {
		MyBatisPagingItemReader<ProjectBean> reader = new MyBatisPagingItemReader<ProjectBean>();
		reader.setPageSize(pagesize != null ? pagesize : 10);
		reader.setSqlSessionFactory(sqlSessionFactory);
		reader.setQueryId("com.ojt.mapper.BatchMapper.getPostStartProject");
		
		return reader;
	}
	
	@Bean
	@StepScope
	public ItemProcessor<ProjectBean, ProjectBean> procPostStartProject(@Value("#{jobParameters['now']}") String now) {
		return item -> {
			log.info("procPostStartProject {}", item);
			LocalDate localNow = LocalDate.parse(now);
			LocalDate localProjectEndDate = LocalDate.parse(item.getProjectEndDate());
			String maintStartDate = item.getMaintStartDate();
			String maintEndDate = item.getMaintEndDate();
			
			/*
			 * 유지보수 시작일이 비어있지않다면
			 * 
			 * 유지보수 종료일이 비어있지않다면
			 * 유지보수 시작일과 종료일 사이에 현재날짜가 위치하는지
			 * 위치한다면 유지보수, 그렇지않다면 종료
			 * 
			 * 유지보수 종료일이 비어있다면
			 * 현재날짜가 유지보수 시작일 이후라면 유지보수
			 * 
			 * 유지보수 시작일이 비어있다면
			 * 현재날짜가 프로젝트 종료일 이후라면 프로젝트 상태를 종료로
			 */
			if(maintStartDate != null && !maintStartDate.isEmpty()) {
				LocalDate localMaintStartDate = LocalDate.parse(maintStartDate);
				
				if(maintEndDate != null && !maintEndDate.isEmpty()) {
					LocalDate localMaintEndDate = LocalDate.parse(maintEndDate);
					
					if(localNow.isAfter(localMaintStartDate) && localNow.isBefore(localMaintEndDate)) {
						item.setProjectStateCode("3");
					} else {
						item.setProjectStateCode("4");
					}
					
				} else if(localNow.isAfter(localMaintStartDate)){
					item.setProjectStateCode("3");
				}
			} else if(localNow.isAfter(localProjectEndDate)) {
				item.setProjectStateCode("4");
			}
			
			return item;
		};
	}
	
	@Bean
	@StepScope
	public MyBatisBatchItemWriter<ProjectBean> writerPostStartProject() {
		return new MyBatisBatchItemWriterBuilder<ProjectBean>()
				.sqlSessionFactory(sqlSessionFactory)
				.statementId("com.ojt.mapper.BatchMapper.projectStatusUpdate")
				.build();
	}
	
	/*
	 * 프로젝트의 상태가 유지보수이고
	 * 현재날짜가 유지보수 종료일보다 큰 프로젝트를
	 * 상태 종료로 변경
	 */
	@Bean
	@StepScope
	public MyBatisPagingItemReader<ProjectBean> readEndProject(@Value("#{jobParameters['pagesize']}") Integer pagesize) {
		MyBatisPagingItemReader<ProjectBean> reader = new MyBatisPagingItemReader<ProjectBean>();
		reader.setPageSize(pagesize != null ? pagesize : 10);
		reader.setSqlSessionFactory(sqlSessionFactory);
		reader.setQueryId("com.ojt.mapper.BatchMapper.getEndProject");
		
		return reader;
	}
	
	@Bean
	@StepScope
	public ItemProcessor<ProjectBean, ProjectBean> procEndProject() {
		return item -> {
			log.info("procEndProject {}", item);
			item.setProjectStateCode("4");
			return item;
		};
	}
	
	@Bean
	@StepScope
	public MyBatisBatchItemWriter<ProjectBean>writerEndProject() {
		return new MyBatisBatchItemWriterBuilder<ProjectBean>()
				.sqlSessionFactory(sqlSessionFactory)
				.statementId("com.ojt.mapper.BatchMapper.projectStatusUpdate")
				.build();
	}

}
