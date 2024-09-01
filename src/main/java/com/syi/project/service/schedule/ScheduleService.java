package com.syi.project.service.schedule;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

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
	public void enrollSchedule(HttpServletRequest request, ScheduleVO schedule) {
		int scheduleNo;
		
		// 이미 있는 시간표라면 그 시간표 번호로 교시만 등록하기
		if(scheduleMapper.getSchedule(schedule.getClassNo())!=null) {
			scheduleNo = scheduleMapper.getSchedule(schedule.getClassNo()).getScheduleNo();
			
		} else {
			// 없다면 새롭게 시간표 등록
			scheduleMapper.enrollSchedule(schedule);
			scheduleNo = schedule.getScheduleNo();
		}
		
		// 교시 등록
		for(PeriodVO period : schedule.getPeriods()) {
			period.setScheduleNo(scheduleNo);
			periodMapper.enrollPeriod(period);
		}
	}
	
	/* 시간표 조회 */
	public ScheduleVO getSchedule(int classNo) {
		return scheduleMapper.getSchedule(classNo);
	}

	/* 교시 리스트 조회 */
	public List<PeriodVO> getPeriods(int scheduleNo) {
		return periodMapper.getPeriods(scheduleNo);
	}
	
	/* 교시 리스트 조회 */
	public List<PeriodVO> getPeriodsWithDayOfWeek(int scheduleNo, String dayOfWeek) {
		System.out.println("서비스에 도착한 dayOfWeek : " + dayOfWeek);
		return periodMapper.getPeriodsWithDayOfWeek(scheduleNo, dayOfWeek);
	}

	/* 교시 조회 */
	public PeriodVO getPeriod(Integer periodNo) {
		return periodMapper.getPeriod(periodNo);
	}

	/* 시간표 수정 */
	public void updateSchedule(ScheduleVO schedule) {
		
		// 시간표 업데이트
		scheduleMapper.updateSchedule(schedule.getScheduleNo());
		
		// 교시 업데이트
		for(PeriodVO period : schedule.getPeriods()) {
			periodMapper.updatePeriod(period);
		}
		
	}

	/* 시간표 삭제 */
	public void deleteSchedule(ScheduleVO schedule) {
		 scheduleMapper.deleteSchedule(schedule.getScheduleNo());
		 
		 for(PeriodVO period : schedule.getPeriods()) {
			 periodMapper.deletePeriod(period);
		 }
		
	}

}
