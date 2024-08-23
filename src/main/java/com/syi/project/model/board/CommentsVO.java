package com.syi.project.model.board;

import java.sql.Date;
import java.util.List;

import com.syi.project.model.member.MemberVO;

import lombok.Data;

@Data
public class CommentsVO {
	private int commentNo;
	private Integer commentParentNo;
	private String commentContent;
	private Date commentRegDate;
	private Date commentModifyDate;
	private String commentStatus;
	private int commentMemberNo;
	private int commentBoardNo;
	private MemberVO member;
	private List<CommentsVO> replyList;
}
