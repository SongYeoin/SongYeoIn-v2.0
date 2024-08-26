package com.syi.project.controller.board;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.syi.project.model.board.CommentsVO;
import com.syi.project.model.member.MemberVO;
import com.syi.project.service.board.CommentService;

@Controller
@RequestMapping("/member/board/comment")
public class CommentController {
	
	private static final Logger log = LoggerFactory.getLogger(CommentController.class);

	@Autowired
	private CommentService commentService;

	// 댓글 생성
	@PostMapping("/add")
	public String addComment(@ModelAttribute CommentsVO comment, @RequestParam("boardNo") int boardNo,
			@RequestParam(value = "parentCommentNo", required = false) Integer parentCommentNo,
			HttpSession session, RedirectAttributes rttr) {
		MemberVO member = (MemberVO) session.getAttribute("loginMember");
		int memberNo = member.getMemberNo();

		comment.setCommentBoardNo(boardNo);
		comment.setCommentMemberNo(memberNo);
		comment.setCommentParentNo(parentCommentNo);
		
		commentService.insertComment(comment);
		commentService.increaseComment(boardNo);
		return "redirect:/member/board/detail?boardNo=" + comment.getCommentBoardNo();
	}

	// 댓글 수정
	@PostMapping("/modify")
	@ResponseBody
	public String updateComment(CommentsVO comment) {
		int result = commentService.updateComment(comment);
		return result > 0 ? "success" : "fail";
	}

	// 댓글 삭제
	@PostMapping("/delete")
	@ResponseBody
	public String deleteComment(@RequestParam("commentNo") int commentNo, @RequestParam("boardNo") int boardNo) {
		int result = commentService.deleteComment(commentNo);
		commentService.decreaseComment(boardNo);
		return result > 0 ? "success" : "fail";
	}

}
