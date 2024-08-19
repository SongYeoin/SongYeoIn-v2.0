package com.syi.project.service.board;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.syi.project.mapper.board.CommentMapper;
import com.syi.project.model.board.CommentsVO;

@Service
public class CommentServiceImpl implements CommentService {
	
	@Autowired
	private CommentMapper commentMapper;

	// 댓글 생성
	@Override
	public int insertComment(CommentsVO comment) {
		return commentMapper.insertComment(comment);
	}

	// 댓글 조회
	@Override
	public List<CommentsVO> selectCommentList(int boardNo) {
		return commentMapper.selectCommentList(boardNo);
	}

	// 댓글 수정
	@Override
	public int updateComment(CommentsVO comment) {
		return commentMapper.updateComment(comment);
	}

	// 댓글 삭제
	@Override
	public int deleteComment(int commentId) {
		return commentMapper.deleteComment(commentId);
	}

}
