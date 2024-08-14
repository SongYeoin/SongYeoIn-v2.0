package com.syi.project.controller.board;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.syi.project.model.board.BoardVO;
import com.syi.project.service.board.BoardService;

@Controller
@RequestMapping("/member/board")
public class BoardController {
	
	@Autowired
	private BoardService boardService;
	
	@GetMapping
	public String listBoards(Model model) {
		List<BoardVO> boardList = boardService.selectBoards();
		model.addAttribute("boardList", boardList);
		return "board/list";
	}
	
	@GetMapping("/{boardNo}")
	public String detailBoard(@PathVariable("boardNo") int boardNo, Model model) {
		BoardVO board = boardService.selectBoardByBoardNo(boardNo);
		model.addAttribute("board", board);
		return "board/detail";
	}

	@GetMapping("/enroll")
	public String insertBoard() {
		return "board/enroll";
	}
	
	@PostMapping("/enroll")
	public String insertBoard(@ModelAttribute BoardVO board) {
		boardService.insertBoard(board);
		return "redirect:/board";
	}
	
	@GetMapping("/update/{boardNo}")
	public String updateBoard(@PathVariable("boardNo") int boardNo, Model model) {
		BoardVO board = boardService.selectBoardByBoardNo(boardNo);
		model.addAttribute("board", board);
		return "board/update";
	}
	
	@PostMapping("/update")
	public String updateBoard(@ModelAttribute BoardVO board) {
		boardService.updateBoard(board);
		return "redirect:/board/boardNo";
	}
	
	@PostMapping("/delete/{boardNo}")
	public String deleteBoard(@PathVariable("boardNo") int boardNo) {
		boardService.deleteBoard(boardNo);
		return "redirect:/board/list";
	}
	
	

	

}
