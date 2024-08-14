package com.syi.project.model.schedule;

import java.util.Date;
import java.util.List;

import com.syi.project.model.period.PeriodVO;

import lombok.Data;

@Data
public class ScheduleVO {

	private int scheduleNo;
	
	private Date enrollDate;
	
	private Date modifiedDate;
	
	private String isDeleted;
	
	private List<PeriodVO> periods;
	
	private int classNo;
	
}
