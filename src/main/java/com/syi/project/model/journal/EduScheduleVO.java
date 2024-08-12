package com.syi.project.model.journal;

import java.sql.Date;

import lombok.Data;

@Data
public class EduScheduleVO {

	private int scheduleNo; // 일정 번호
	
	private Date scheduleDate; // 일정 날짜
	
	private Date scheduleRegDate; // 일정 등록날짜
	
	private Date scheduleModifyDate; // 일정 수정날짜
	
	private String scheduleTitle; // 일정 제목
	
	private String scheduleDescription; // 일정 설명
	
	private String scheduleInstructor; // 강사
	
	private int classNo; // 반 번호

	
	
}