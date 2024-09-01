package com.syi.project.controller.board;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.syi.project.model.Criteria;
import com.syi.project.model.PageDTO;
import com.syi.project.model.board.BoardVO;
import com.syi.project.service.board.BoardService;

@Controller
@RequestMapping("/admin/board")
public class AdminBoardController {

	private static final Logger log = LoggerFactory.getLogger(AdminBoardController.class);

	@Autowired
	private BoardService boardService;

	@GetMapping("/list")
	public void listBoards(Criteria cri, Model model) {
		List<BoardVO> boardList = boardService.selectBoards(cri);
		model.addAttribute("boardList", boardList);
		int total = boardService.selectBoardTotal(cri);
		PageDTO pageMaker = new PageDTO(cri, total);
		model.addAttribute("pageMaker", pageMaker);
	}

	@GetMapping("/detail")
	public void detailBoard(int boardNo, Model model) {
		BoardVO board = boardService.selectBoardByBoardNo(boardNo);
		model.addAttribute("board", board);
	}

	@PostMapping("/delete")
	@ResponseBody
	public String deleteBoard(int boardNo) {
		int result = boardService.deleteBoard(boardNo);
		return result > 0 ? "success" : "fail";
	}

}
