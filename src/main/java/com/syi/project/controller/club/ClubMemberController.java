package com.syi.project.controller.club;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.syi.project.model.Criteria;
import com.syi.project.model.club.ClubVO;
import com.syi.project.model.member.MemberVO;
import com.syi.project.service.club.ClubService;

@Controller
@RequestMapping("/member")
public class ClubMemberController {

	private static final Logger log = LoggerFactory.getLogger(ClubMemberController.class);
	
	@Autowired
	private ClubService cservice;
	
	//리스트
	@GetMapping("/club/list")
	public String clubListGET(Model model) {
		log.info("목록 페이지 진입");

		List<ClubVO> list =  cservice.getList();
		
		System.out.println("controller : " +list);
		model.addAttribute("list", list);
		
		return "member/club/list";
		
	}
	
	
	//등록페이지
	@GetMapping("/club/enroll")
	public void clubEnrollGET() {
		log.info("등록 페이지 진입");
	}
	
	//HttpSession session
	@PostMapping("/club/enroll")
	public String clubEnrollPOST(ClubVO club, RedirectAttributes rttr) {
		log.info("ClubVO : "+club);
		
		//MemberVO member = (MemberVO)session.getAttribute("loginMember");
		
		cservice.enroll(club);
		
		rttr.addFlashAttribute("result", "enroll success");
		
		return "redirect:/member/club/list";
	}
	
	//조회
	@GetMapping("/club/get")
	public void clubGetPageGET(int clubNo, Model model) {
		model.addAttribute("pageInfo", cservice.getPage(clubNo));
	}
	
	
	
	
	//리스트 페이징 적용
	
	
	

}
