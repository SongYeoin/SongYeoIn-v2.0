package com.syi.project.model.club;

import java.sql.Date;

import lombok.Data;

@Data
public class ClubFileVO {

	private int fileNo; //첨부파일코드번호
	private String originalName;	//원래파일명
	private String savedName;	//저장된 파일명
	private String type;	//파일종류
	private int size;	//파일크기
	private String path;	//파일경로
	private Date regDate;	//등록날짜
	private int clubNo;	//동아리코드번호

}
