package com.syi.project.controller.board;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/commnet")
public class CommentController {
	
	/*
	 * @Autowired privatge CommentService commentService;
	 * 
	 * @PostMapping("/insert") public String createComment(CommentsVO comment) {
	 * commentService.createComment(comment); return "redirect:/board/view/" +
	 * comment.getCommentBoardNo(); }
	 * 
	 * @GetMapping("/update/{id}") public String editCommentForm(@PathVariable("id")
	 * Long id, Model model) { Comment comment = commentService.getCommentById(id);
	 * model.addAttribute("comment", comment); return "comment/edit"; }
	 * 
	 * @PostMapping("/update") public String editComment(CommentsVO comment) {
	 * commentService.updateComment(comment); return "redirect:/board/view/" +
	 * comment.getCommentBoardNo(); }
	 * 
	 * @GetMapping("/delete/{id}") public String deleteComment(@PathVariable("id")
	 * Long id) { Comment comment = commentService.getCommentById(id);
	 * commentService.deleteComment(id); return "redirect:/board/view/" +
	 * comment.getCommentBoardNo(); }
	 */

}
