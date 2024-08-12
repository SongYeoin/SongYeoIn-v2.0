package com.syi.project.model.club;

import java.sql.Date;

import com.syi.project.model.EnrollVO;

import lombok.Data;

@Data
public class ClubVO {
	
	private int clubNo;	//동아리코드번호
	private String content;	//동아리신청내용
	private String join;	//참가자명단
	private Date studyDate;	//활동날짜
	private Date regDate;	//등록날짜
	private String checkStatus;	//'Y', 'N', 'W' 승인
	private String checkCmt;	//승인메시지
	private EnrollVO enroll;	//수강코드번호
	private String fileName; //첨부파일
	
}
