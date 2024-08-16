package com.syi.project.model.syclass;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

import lombok.Data;

@Data
public class SyclassVO {

	private int classNo;
	
    private String className;
    
    private String description;
    
    private String managerName;
    
    private String teacherName;
    
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date startDate;
    
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date endDate;
    
    private String classroomName;
    
    private Date enrollDate;
    
    private Date modifiedDate;
    
    private String classStatus;
	
    private int adminNo;
    
    private String isDeleted;

}