package com.syi.project.model.board;

import java.sql.Date;

import lombok.Data;

@Data
public class CommentsVO {
	private int commentsNo;
	private String comment;
	private Date commentRegDate;
	private Date commentModifyDate;
	private String commentStatus;
	private int commentMemberNo;
	private int commentBoardNo;

}
