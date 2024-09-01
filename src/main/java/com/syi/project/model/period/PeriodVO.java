package com.syi.project.model.period;

import lombok.Data;

@Data
public class PeriodVO {
	
	private int periodNo;
	
	private int scheduleNo;
	
	private String dayOfWeek;
	
	private String periodName;
	
	private String startTime;
	
	private String endTime;
	
	private int classNo;
	
}
