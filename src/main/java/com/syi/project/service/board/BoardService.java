package com.syi.project.service.board;

import java.util.List;

import com.syi.project.model.board.BoardVO;
import com.syi.project.model.board.CommentsVO;
import com.syi.project.model.board.HeartVO;

public interface BoardService {

	// 게시글 목록
	List<BoardVO> selectBoards();
	
	// 게시글 조회수 증가
	void updateBoardCount(int boardNo);

	// 게시글 상세 조회
	BoardVO selectBoardByBoardNo(int boardNo);

	// 게시글 등록
	int insertBoard(BoardVO board);

	// 게시글 수정
	int updateBoard(BoardVO board);

	// 게시글 삭제
	int deleteBoard(int boardNo);

}
