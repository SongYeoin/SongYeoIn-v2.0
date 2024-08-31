package com.syi.project.config;

import javax.sql.DataSource;

import org.springframework.batch.core.Job;
import org.springframework.batch.core.JobParametersBuilder;
import org.springframework.batch.core.Step;
import org.springframework.batch.core.configuration.annotation.DefaultBatchConfigurer;
import org.springframework.batch.core.configuration.annotation.EnableBatchProcessing;
import org.springframework.batch.core.configuration.annotation.JobBuilderFactory;
import org.springframework.batch.core.configuration.annotation.StepBuilderFactory;
import org.springframework.batch.core.launch.JobLauncher;
import org.springframework.batch.core.launch.support.RunIdIncrementer;
import org.springframework.batch.core.launch.support.SimpleJobLauncher;
import org.springframework.batch.core.repository.JobRepository;
import org.springframework.batch.core.step.tasklet.Tasklet;
import org.springframework.batch.repeat.RepeatStatus;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.Scheduled;

@Configuration
@EnableBatchProcessing
public class BatchConfig extends DefaultBatchConfigurer {

	private final JobBuilderFactory jobBuilderFactory;
	private final StepBuilderFactory stepBuilderFactory;
	
	@Autowired
    private DataSource dataSource;
	@Autowired
	private JobLauncher jobLauncher;
	@Autowired
	private Job updateAbsentJob;
	
	public BatchConfig(JobBuilderFactory jobBuilderFactory, StepBuilderFactory stepBuilderFactory) {
        this.jobBuilderFactory = jobBuilderFactory;
        this.stepBuilderFactory = stepBuilderFactory;
    }
	
	@Override
    public void setDataSource(DataSource dataSource) {
        // Spring Batch가 사용할 DataSource 설정
        super.setDataSource(this.dataSource);
    }
	
	@Bean
	public JobLauncher jobLauncher(JobRepository jobRepository) throws Exception {
		SimpleJobLauncher  jobLauncher = new SimpleJobLauncher();
		jobLauncher.setJobRepository(jobRepository);
		jobLauncher.afterPropertiesSet();
		return jobLauncher;
	}
	
	/* Job: 여러 개의 Step으로 구성된 작업 흐름 (하나의 배치 작업을 의미) */
	@Bean
	public Job updateAbsentJob() {
		return jobBuilderFactory.get("updateAbsentJob")
				.incrementer(new RunIdIncrementer()) // job실행할떄마다 파라미터 id를 자동생성
				.start(updateAbsentStep()) // 최초 실행 step
				.build();
	}
	
	/* Step: Job을 구성하는 하나의 작업 단위. (여러 Step이 모여 하나의 Job을 구성) */
	@Bean
	public Step updateAbsentStep() {
		return stepBuilderFactory.get("updateAbsentStep")
				.tasklet(updateAbsentTasklet())
				.build();
	}

	/* Tasklet: Step 안에서 수행되는 실제 작업을 정의 (하나의 Tasklet은 Step에서 실행할 구체적인 로직을 구현) */
	@Bean
	public Tasklet updateAbsentTasklet() {
		return (contribution, ChunkContext) -> {
			// 배치 로직 구현
			System.out.println("학생의 미출석을 결석으로 상태 업데이트중...");
			
			// 특정 날짜에 출석 정보가 없는 학생들을 조회하고 "결석"으로 상태 업데이트
			
			return RepeatStatus.FINISHED; // Tasklet 의 성공적 완료 반환
		};
	}
	
	@Scheduled(cron = "0 0 0 * * ?") // 매일 자정에 실행
    public void performJob() throws Exception {
        System.out.println("Scheduled job started...");
        jobLauncher.run(updateAbsentJob, new JobParametersBuilder().toJobParameters());
    }
	
}
