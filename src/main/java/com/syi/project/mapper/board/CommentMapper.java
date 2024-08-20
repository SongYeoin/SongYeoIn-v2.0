package com.syi.project.mapper.board;

import java.util.List;

import com.syi.project.model.board.CommentsVO;

public interface CommentMapper {

	// 댓글 생성
	int insertComment(CommentsVO comment);

	// 댓글 조회
	List<CommentsVO> selectCommentList(int boardNo);
	
	// 댓글 총 갯수
	int selectCommentTotal(int boardNo);
	
	// 댓글 수정
	int updateComment(CommentsVO comment);
	
	// 댓글 삭제
	int deleteComment(int commentId);
}
