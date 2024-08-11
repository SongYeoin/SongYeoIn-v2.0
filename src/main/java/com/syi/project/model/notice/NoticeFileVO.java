package com.syi.project.model.notice;

import java.sql.Date;

import lombok.Data;

@Data
public class NoticeFileVO {
	private int fileNo;
	private String fileOriginalName;
	private String fileSavedName;
	private String fileType;
	private int fileSize;
	private String filePath;
	private Date fileRegDate;
	private int fileNoticeNo;
}