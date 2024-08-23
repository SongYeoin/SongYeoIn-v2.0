package com.syi.project.service.board;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.syi.project.mapper.board.CommentMapper;
import com.syi.project.model.board.CommentsVO;

@Service
public class CommentServiceImpl implements CommentService {
	
	@Autowired
	private CommentMapper commentMapper;

	// 댓글 생성
	@Transactional
	@Override
	public int insertComment(CommentsVO comment) {
		return commentMapper.insertComment(comment);
	}

	// 댓글 조회
	@Override
	public List<CommentsVO> selectCommentList(int boardNo) {
		
		// 댓글 전체 조회
		List<CommentsVO> comments = commentMapper.selectCommentList(boardNo);
		
		// 댓글과 대댓글 계층 구조로 정리
		Map<Integer, CommentsVO> commentMap = new HashMap<>();
		for(CommentsVO comment : comments) {
			commentMap.put(comment.getCommentNo(), comment);
		}
		
		// 대댓글을 부모 댓글에 추가
		for(CommentsVO comment : comments) {
			if(comment.getCommentParentNo() != null) {
				CommentsVO parent = commentMap.get(comment.getCommentParentNo());
				if(parent != null) {
					if(parent.getReplyList() == null)
						parent.setReplyList(new ArrayList<>());
					parent.getReplyList().add(comment);
				}
			}
		}
		
		// 부모 댓글만 반환
		return comments.stream()
				.filter(comment -> comment.getCommentParentNo() == null)
				.collect(Collectors.toList());
	}
	
	// 댓글 총 갯수
	@Override
	public int selectCommentTotal(int boardNo) {
		return commentMapper.selectCommentTotal(boardNo);
	}

	// 댓글 수정
	@Transactional
	@Override
	public int updateComment(CommentsVO comment) {
		return commentMapper.updateComment(comment);
	}

	// 댓글 삭제
	@Transactional
	@Override
	public int deleteComment(int commentId) {
		return commentMapper.deleteComment(commentId);
	}

	

}
