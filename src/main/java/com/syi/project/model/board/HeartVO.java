package com.syi.project.model.board;

import java.sql.Date;

import lombok.Data;

@Data
public class HeartVO {
	
	private int heartNo;
	private Date heartRegDate;
	private int heartMemberNo;
	private int heartBoardNo;

}
