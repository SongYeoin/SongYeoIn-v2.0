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

	// 댓글 수 증가
	void increaseComment(int boardNo);

	// 댓글 수정
	int updateComment(CommentsVO comment);

	// 자식 댓글 조회
	int selectChildrenCommentTotal(int commentNo);

	// 댓글 삭제 상태로 변경
	int updateCommentStatus(int commentNo);

	// 댓글 삭제
	int deleteComment(int commentNo);

	// 댓글수 감소
	void decreaseComment(int boardNo);

	// 부모 번호 조회
	int selectParentNo(int commentNo);

	// 부모 댓글 조회
	CommentsVO selectParentComment(int commentNo);

	// 댓글 상태 조회
	String selectCommentStatus(int commentNo);

}
