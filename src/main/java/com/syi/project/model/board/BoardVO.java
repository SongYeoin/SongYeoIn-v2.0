package com.syi.project.model.board;

import java.sql.Date;
import java.util.List;

import com.syi.project.model.member.MemberVO;

import lombok.Data;

@Data
public class BoardVO {
	private int boardNo;
	private String boardTitle;
	private String boardContent;
	private Date boardRegDate;
	private Date boardModifyDate;
	private int boardCount;
	private int boardHeartCount;
	private int boardCommentsCount;
	private String boardStatus;
	private int boardMemberNo;
	private MemberVO member;
	private List<CommentsVO> commentsList;
}
