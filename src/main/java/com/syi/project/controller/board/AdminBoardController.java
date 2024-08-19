package com.syi.project.controller.board;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.syi.project.model.Criteria;
import com.syi.project.model.PageDTO;
import com.syi.project.model.board.BoardVO;
import com.syi.project.model.board.CommentsVO;
import com.syi.project.model.member.MemberVO;
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

	// 댓글
	@PostMapping("/comment/add")
	public String addComment(@ModelAttribute CommentsVO comment, @RequestParam("boardNo") int boardNo,
			HttpSession session, RedirectAttributes rttr) {
		MemberVO member = (MemberVO) session.getAttribute("loginMember");
		int memberNo = member.getMemberNo();

		comment.setCommentBoardNo(boardNo);
		comment.setCommentMemberNo(memberNo);

		int result = boardService.insertComment(comment);
		if (result > 0) {
			rttr.addFlashAttribute("message", "댓글이 등록되었습니다.");
		} else {
			rttr.addFlashAttribute("message", "댓글 등록에 실패하였습니다.");
		}
		return "redirect:/member/board/detail?boardNo=" + comment.getCommentBoardNo();
	}

	@PostMapping("/comment/delete")
	@ResponseBody
	public String deleteComment(@RequestParam("commentId") int commentId) {
		int result = boardService.deleteComment(commentId);
		return result > 0 ? "success" : "fail";
	}

}
