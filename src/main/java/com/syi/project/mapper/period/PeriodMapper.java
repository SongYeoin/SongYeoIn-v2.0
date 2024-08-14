package com.syi.project.mapper.period;

import java.util.List;

import com.syi.project.model.period.PeriodVO;

public interface PeriodMapper {

	/* 교시 등록 */
	void enrollPeriod(PeriodVO period);
	
	/* 교시 조회 */
	List<PeriodVO> getPeriods(int scheduleNo);

}
