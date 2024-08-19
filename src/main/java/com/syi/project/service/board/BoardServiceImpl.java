package com.syi.project.service.board;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.syi.project.mapper.board.BoardMapper;
import com.syi.project.model.Criteria;
import com.syi.project.model.board.BoardVO;
import com.syi.project.model.board.HeartVO;

@Service
public class BoardServiceImpl implements BoardService {

	@Autowired
	private BoardMapper boardMapper;

	// 게시글 목록
	@Override
	public List<BoardVO> selectBoards(Criteria cri) {
		return boardMapper.selectBoards(cri);
	}
	
	// 게시글 총 수
	@Override
	public int selectBoardTotal(Criteria cri) {
		return boardMapper.selectBoardTotal(cri);
	}

	// 게시글 조회수 증가
	@Transactional
	@Override
	public void updateBoardCount(int boardNo) {
		boardMapper.updateBoardCount(boardNo);
	}

	// 게시글 조회
	@Override
	public BoardVO selectBoardByBoardNo(int boardNo) {
		updateBoardCount(boardNo);
		return boardMapper.selectBoardByBoardNo(boardNo);
	}

	// 게시글 등록
	@Transactional
	@Override
	public int insertBoard(BoardVO board) {
		return boardMapper.insertBoard(board);
	}

	// 게시글 수정
	@Transactional
	@Override
	public int updateBoard(BoardVO board) {
		return boardMapper.updateBoard(board);
	}

	// 게시글 삭제
	@Transactional
	@Override
	public int deleteBoard(int boardNo) {
		return boardMapper.deleteBoard(boardNo);
	}

	// 좋아요 추가
	@Override
	public int insertHeart(HeartVO heart) {
		return boardMapper.insertHeart(heart);
	}

	// 좋아요 확인
	@Override
	public int selectMyHeart(HeartVO heart) {
		return boardMapper.selectMyHeart(heart);
	}

	// 좋아요 취소
	@Override
	public int deleteHeart(HeartVO heart) {
		return boardMapper.deleteHeart(heart);
	}

	// 좋아요 총 갯수
	@Override
	public int selectHeartTotal(HeartVO heart) {
		return boardMapper.selectHeartTotal(heart);
	}

}
