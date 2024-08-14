package com.syi.project.model.board;

import java.sql.Date;

import lombok.Data;

@Data
public class CommentsVO {
	int commentsNo;
	String comment;
	Date commentRegDate;
	Date commentModifyDate;
	String commentStatus;
	int commentMemberNo;
	int commentBoardNo;

}
