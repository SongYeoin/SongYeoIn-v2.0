package com.syi.project.model.attendance;

import java.util.Date;

import lombok.Data;

@Data
public class AttendanceVO {

	private Integer attendanceNo;        // ATTENDENCE_NO
	
    private String attendanceStatus;  // ATTENDENCE_STATUS
    
    private Date attendanceDate;      // ATTENDENCE_DATE
    
    private Date enrollDate;          // ENROLL_DATE
    
    private Date modifiedDate;        // MODIFIED_DATE
    
    private Integer periodNo;            // PERIOD_NO
    
    private Integer classNo;             // CLASS_NO
    
    private Integer memberNo;            // MEMBER_NO
    
    private String memo;				// MEMO
    	
}
