package com.syi.project.mapper.board;

import java.util.List;

import com.syi.project.model.board.BoardVO;

public interface BoardMapper {
	
	// 게시글 목록
	List<BoardVO> selectBoards();
	
	// 게시글 상세 조회
	BoardVO selectBoardByBoardNo(int boardNo);

	// 게시글 등록
	int insertBoard(BoardVO board);
	
	// 게시글 수정
	int updateBoard(BoardVO board);
	
	// 게시글 삭제
	int deleteBoard(int boardNo);
	
	// 좋아요 수
	
	
}
