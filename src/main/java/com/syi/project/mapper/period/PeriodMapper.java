package com.syi.project.mapper.period;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.syi.project.model.period.PeriodVO;

public interface PeriodMapper {

	/* 교시 등록 */
	void enrollPeriod(PeriodVO period);
	
	/* 교시 조회 */
	List<PeriodVO> getPeriods(int scheduleNo);
	
	/* 교시 조회 */
	List<PeriodVO> getPeriodsWithDayOfWeek(@Param(value = "scheduleNo") Integer scheduleNo, @Param(value = "dayOfWeek") String dayOfWeek);

	/* 교시 단일 조회 */
	PeriodVO getPeriod(Integer periodNo);

	/* 교시 수정 */
	void updatePeriod(int periodNo);

}
