package com.syi.project.model.board;

import java.sql.Date;

import lombok.Data;

@Data
public class BoardFileVO {
	private int fileNo;
	private String fileOriginalName;
	private String fileSavedName;
	private String fileType;
	private long fileSize;
	private String filePath;
	private Date fileRegDate;
	private int fileBoardNo;
}