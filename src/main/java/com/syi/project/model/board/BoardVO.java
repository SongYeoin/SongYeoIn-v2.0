package com.syi.project.model.board;

import java.sql.Date;

import com.syi.project.model.member.MemberVO;

import lombok.Data;

@Data
public class BoardVO {
	int boardNo;
	String boardTitle;
	String boardContent;
	Date boardRegDate;
	Date boardModifyDate;
	int boardCount;
	int boardCommentsCount;
	String boardStatus;
	int memberNo;
	MemberVO member;
}
