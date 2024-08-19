package com.syi.project.controller.board;

import java.util.List;

import javax.servlet.http.HttpSession;

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

import com.syi.project.model.board.CommentsVO;
import com.syi.project.model.member.MemberVO;
import com.syi.project.service.board.CommentService;

@Controller
@RequestMapping("/commnet")
public class CommentController {

	@Autowired
	private CommentService commentService;

	// 댓글 생성
	@PostMapping("/add")
	public String addComment(@ModelAttribute CommentsVO comment, @RequestParam("boardNo") int boardNo,
			HttpSession session, RedirectAttributes rttr) {
		MemberVO member = (MemberVO) session.getAttribute("loginMember");
		int memberNo = member.getMemberNo();

		comment.setCommentBoardNo(boardNo);
		comment.setCommentMemberNo(memberNo);

		int result = commentService.insertComment(comment);
		if (result > 0) {
			rttr.addFlashAttribute("message", "댓글이 등록되었습니다.");
		} else {
			rttr.addFlashAttribute("message", "댓글 등록에 실패하였습니다.");
		}
		return "redirect:/member/board/detail?boardNo=" + comment.getCommentBoardNo();
	}

	// 댓글 조회
	@GetMapping("/list")
	public String selectCommentList(int boardNo, Model model) {
		List<CommentsVO> commentList = commentService.selectCommentList(boardNo);
		model.addAttribute("commentList", commentList);
		return "commentList";
	}

	// 댓글 수정
	@PostMapping("/modify")
	public String updateComment(CommentsVO comment) {
		int result = commentService.updateComment(comment);
		return result > 0 ? "success" : "fail";
	}

	// 댓글 삭제
	@PostMapping("/delete")
	@ResponseBody
	public String deleteComment(@RequestParam("commentId") int commentId) {
		int result = commentService.deleteComment(commentId);
		return result > 0 ? "success" : "fail";
	}

}
