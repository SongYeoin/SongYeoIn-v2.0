package com.syi.project.model.board;

import java.sql.Date;

import lombok.Data;

@Data
public class HeartVO {
	int heartNo;
	Date heartRegDate;
	int heartMemberNo;
	int heartBoardNo;

}
