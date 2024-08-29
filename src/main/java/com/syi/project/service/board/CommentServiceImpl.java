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

	// 댓글 조회
	@Override
	public List<CommentsVO> selectCommentList(int boardNo) {
		return commentMapper.selectCommentList(boardNo);
	}

	/*
	// 댓글 조회
	@Override
	public List<CommentsVO> selectCommentList(int boardNo) {

		// 댓글 전체 조회
		List<CommentsVO> comments = commentMapper.selectCommentList(boardNo);

		Map<Integer, CommentsVO> commentMap = new HashMap<>();
		for (CommentsVO comment : comments) {
			commentMap.put(comment.getCommentNo(), comment);
		}

		// 댓글을 계층적으로 정리
		for (CommentsVO comment : comments) {
			if (comment.getCommentParentNo() != null) {
				CommentsVO parent = commentMap.get(comment.getCommentParentNo());
				if (parent != null) {
					if (parent.getReplyList() == null) {
						parent.setReplyList(new ArrayList<>());
					}
					parent.getReplyList().add(comment);
				}
			}
		}

		// 최상위 댓글을 찾고 재귀적으로 정리
		List<CommentsVO> topLevelComments = new ArrayList<>();
		for (CommentsVO comment : comments) {
			if (comment.getCommentParentNo() == null) {
				organizeReplies(comment);
				topLevelComments.add(comment);
			}
		}
		return topLevelComments;
	}

	// 댓글을 재귀적으로 정리
	private void organizeReplies(CommentsVO comment) {
		if (comment.getReplyList() != null) {
			for (CommentsVO reply : comment.getReplyList()) {
				organizeReplies(reply);
			}
		}
	}
	*/

	// 댓글 총 갯수
	@Override
	public int selectCommentTotal(int boardNo) {
		return commentMapper.selectCommentTotal(boardNo);
	}
	
	// 댓글 수 증가
	@Override
	public void increaseComment(int boardNo) {
		commentMapper.increaseComment(boardNo);
	}
	
	// 댓글 생성
	@Transactional
	@Override
	public int insertComment(CommentsVO comment) {
		return commentMapper.insertComment(comment);
	}
	
	// 댓글 수정
	@Transactional
	@Override
	public int updateComment(CommentsVO comment) {
		return commentMapper.updateComment(comment);
	}
	
	
	// 댓글 삭제
	// 자식 댓글이 존재하지 않을 때 댓글 삭제되지 않는 오류
	// 부모 댓글 재귀가 제대로 되지 않음
	@Transactional
	@Override
	public String deleteComment(int commentNo, int boardNo) {
		try {
			int childCommentCount = commentMapper.selectChildrenCommentTotal(commentNo);

			if (childCommentCount > 0) {
				// 자식 댓글 있는 경우 논리적 삭제
				int result = commentMapper.updateCommentStatus(commentNo);
				if (result > 0) {
					commentMapper.decreaseComment(boardNo);
				}
				return result > 0 ? "deleted" : "fail";
			} else {
				// 자식 댓글 없는 경우 물리적 삭제
				int parentNo = commentMapper.selectParentNo(commentNo);
				int result = commentMapper.deleteComment(commentNo);
				if (result > 0) {
					commentMapper.decreaseComment(boardNo);
				}
				checkAndDeleteParentComments(parentNo);
				return result > 0 ? "success" : "fail";
			}
		} catch (Exception e) {
			throw new RuntimeException("댓글 삭제 실패", e);
		}
	}

	// 부모 댓글 재귀적으로 처리
	private void checkAndDeleteParentComments(int commentNo) {
		CommentsVO parentComment = commentMapper.selectParentComment(commentNo);

		while (parentComment != null) {
			int parentCommentNo = parentComment.getCommentNo();
			String status = commentMapper.selectCommentStatus(parentComment.getCommentNo());
			int childCount = commentMapper.selectChildrenCommentTotal(parentCommentNo);

			if ("N".equals(status) && childCount == 0) {
				int result = commentMapper.deleteComment(parentCommentNo);
				if (result > 0) {
					commentMapper.decreaseComment(parentCommentNo);
				}
				parentComment = commentMapper.selectParentComment(parentCommentNo);
			} else {
				break;
			}
		}
	}
}
