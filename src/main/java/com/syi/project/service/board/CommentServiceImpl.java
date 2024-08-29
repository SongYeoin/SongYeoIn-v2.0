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
	
	// 댓글 생성
	@Transactional
	@Override
	public int insertComment(CommentsVO comment) {
		int result = commentMapper.insertComment(comment);
		if(result > 0) {
			increaseComment(comment.getCommentBoardNo());
		}
		return result;
	}
	
	// 댓글 수 증가
	@Override
	public void increaseComment(int boardNo) {
		commentMapper.increaseComment(boardNo);
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
	public String deleteComment(int commentNo, int boardNo) {
		CommentsVO comment = commentMapper.getCommentByNo(commentNo);

        if (comment == null) {
            return "fail";
        }

        List<CommentsVO> replies = commentMapper.getRepliesBycommentNo(commentNo);

        if (!replies.isEmpty()) {
            // 자식 댓글이 존재하는 경우 논리적 삭제
            int updateResult = commentMapper.updateCommentStatus(commentNo);
            if (updateResult > 0) {
                decreaseComment(boardNo); 
                return "deleted";
            } else {
                return "fail";
            }
        } else {
            // 자식 댓글이 존재하지 않으면 물리적 삭제
            int deleteResult = commentMapper.deleteComment(commentNo);
            if (deleteResult > 0) {
            	decreaseComment(boardNo);

                // 부모 댓글도 삭제할지 검사
                Integer parentCommentNo = comment.getCommentParentNo();
                return deleteParentIfNecessary(parentCommentNo);
            } else {
            	return "fail";
            }
        }
    }

	// 부모 댓글 재귀적으로 처리
    private String deleteParentIfNecessary(Integer parentcommentNo) {
        if (parentcommentNo == null) {
            return "success";
        }

        CommentsVO parentComment = commentMapper.getCommentByNo(parentcommentNo);

        if (parentComment != null && "N".equals(parentComment.getCommentStatus())) {
            List<CommentsVO> siblingReplies = commentMapper.getRepliesBycommentNo(parentcommentNo);

            if (siblingReplies.isEmpty()) {
                commentMapper.deleteComment(parentcommentNo);
                return deleteParentIfNecessary(parentComment.getCommentParentNo());
            }
        }

        return "success";
    }

    // 댓글 수 감소
	@Override
	public void decreaseComment(int boardNo) {
		commentMapper.decreaseComment(boardNo);
	}
   
}
