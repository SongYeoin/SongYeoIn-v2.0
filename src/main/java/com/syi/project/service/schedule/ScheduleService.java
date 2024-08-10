package com.syi.project.service.schedule;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.syi.project.mapper.period.PeriodMapper;
import com.syi.project.mapper.schedule.ScheduleMapper;
import com.syi.project.model.period.PeriodVO;
import com.syi.project.model.schedule.ScheduleVO;

import lombok.extern.log4j.Log4j2;

@Service
@Log4j2
public class ScheduleService {
	
	@Autowired
	ScheduleMapper scheduleMapper;
	
	@Autowired
	PeriodMapper periodMapper;

	/* 시간표 등록 */
	public void enrollSchedule(ScheduleVO schedule) {
		
		// NullPointerException이 발생할 수 있는 부분을 로그로 확인
		System.out.println("Schedule: " + schedule);
		System.out.println("Periods: " + schedule.getPeriods());
		
		// 시간표 등록
		scheduleMapper.enrollSchedule(schedule);
		
		// 교시 등록
		for(PeriodVO period : schedule.getPeriods()) {
			period.setScheduleNo(schedule.getScheduleNo());
			periodMapper.enrollPeriod(period);
		}
	}
	
	/* 시간표 조회 */
	public ScheduleVO getSchedule(int classNo) {
		return scheduleMapper.getSchedule(classNo);
	}

	/* 교시 조회 */
	public List<PeriodVO> getPeriods(int scheduleNo) {
		return periodMapper.getPeriods(scheduleNo);
	}

}
