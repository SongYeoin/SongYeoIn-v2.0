package com.syi.project.mapper.schedule;

import com.syi.project.model.schedule.ScheduleVO;

public interface ScheduleMapper {

	/* 시간표 등록 */
	void enrollSchedule(ScheduleVO schedule);

	/* 시간표 조회 */
	ScheduleVO getSchedule(int classNo);

	/* 시간표 수정 */
	void updateSchedule(int scheduleNo);

	/* 시간표 삭제 */
	void deleteSchedule(int scheduleNo);

}
