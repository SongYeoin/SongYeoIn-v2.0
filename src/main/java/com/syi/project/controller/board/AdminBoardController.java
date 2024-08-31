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
import com.syi.project.model.board.HeartVO;
import com.syi.project.model.member.MemberVO;
import com.syi.project.service.board.BoardService;
import com.syi.project.service.board.CommentService;

@Controller
@RequestMapping("/admin/board")
public class AdminBoardController {

	private static final Logger log = LoggerFactory.getLogger(AdminBoardController.class);

	@Autowired
	private BoardService boardService;
	
	@Autowired
	private CommentService commentService;

	@GetMapping("/list")
	public void listBoards(Criteria cri, Model model) {
		List<BoardVO> boardList = boardService.selectBoards(cri);
		model.addAttribute("boardList", boardList);
		int total = boardService.selectBoardTotal(cri);
		PageDTO pageMaker = new PageDTO(cri, total);
		model.addAttribute("pageMaker", pageMaker);
	}

	@GetMapping("/detail")
	public String detailBoard(int boardNo, Criteria cri, HeartVO heart, Model model, HttpSession session) {
		long start = System.currentTimeMillis();
		MemberVO member = (MemberVO) session.getAttribute("loginMember");
		
		BoardVO board = boardService.selectBoardByBoardNo(boardNo);
		List<CommentsVO> commentList = commentService.selectCommentList(boardNo, cri);
		
		heart.setHeartBoardNo(boardNo);
		heart.setHeartMemberNo(member.getMemberNo());
		int heartCount = boardService.selectMyHeart(heart);
		
		model.addAttribute("board", board);
		model.addAttribute("commentList", commentList);
		model.addAttribute("heartCount", heartCount);
		
		long end = System.currentTimeMillis();
		double timeInSeconds = (end - start) / 1000.0;
		
		int total = commentService.selectCommentTotal(boardNo);
		PageDTO pageMaker = new PageDTO(cri, total);
		model.addAttribute("pageMaker", pageMaker);
		
	    System.out.println(">>> 조회 소요 시간 : " + timeInSeconds + " 초");
	    
	    System.out.println("역할 : " + commentList);
		return "admin/board/detail";
	}

	@PostMapping("/delete")
	@ResponseBody
	public String deleteBoard(int boardNo) {
		int result = boardService.deleteBoard(boardNo);
		return result > 0 ? "success" : "fail";
	}
	
	// 댓글 생성
	@PostMapping("/comment/add")
	public String addComment(@ModelAttribute CommentsVO comment, @RequestParam("boardNo") int boardNo,
			@RequestParam(value = "parentCommentNo", required = false) Integer parentCommentNo, HttpSession session,
			RedirectAttributes rttr) {
		MemberVO member = (MemberVO) session.getAttribute("loginMember");
		int memberNo = member.getMemberNo();

		comment.setCommentBoardNo(boardNo);
		comment.setCommentMemberNo(memberNo);
		comment.setCommentParentNo(parentCommentNo);

		commentService.insertComment(comment);
		return "redirect:/admin/board/detail?boardNo=" + comment.getCommentBoardNo();
	}

	// 댓글 수정
	@PostMapping("/comment/modify")
	@ResponseBody
	public String updateComment(CommentsVO comment) {
		int result = commentService.updateComment(comment);
		return result > 0 ? "success" : "fail";
	}

	// 댓글 삭제
	@PostMapping("/comment/delete")
	@ResponseBody
	public String deleteComment(@RequestParam("commentNo") int commentNo, @RequestParam("boardNo") int boardNo) {
		String result = commentService.deleteComment(commentNo, boardNo);
		return result;
	}

}
