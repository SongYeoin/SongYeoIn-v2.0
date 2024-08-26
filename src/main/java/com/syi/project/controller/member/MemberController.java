package com.syi.project.controller.member;

import java.util.Random;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.syi.project.controller.chat.ChatMemberController;
import com.syi.project.model.member.MemberVO;
import com.syi.project.service.member.MemberService;

@Controller
@RequestMapping(value = "/member")
public class MemberController {

	private static final Logger logger = LoggerFactory.getLogger(MemberController.class);

	@Autowired
	private MemberService memberService;
	private ChatMemberController chatMemberController;

	@Autowired
	private BCryptPasswordEncoder pwdEncoder;

	// 수강생 로그인 페이지 이동
	@GetMapping("login")
	public void loginGet() {
		logger.info("수강생 로그인 페이지 이동");
	}

	// 수강생 회원가입 페이지 이동
	@GetMapping("join")
	public void joinGet() {
		logger.info("수강생 회원가입 페이지 이동");
	}

	// 마이페이지 이동
	@GetMapping("mypage")
	public void mypageGet() {
		logger.info("마이페이지 이동");
	}

	// 아이디 중복 체크
	@PostMapping("check-id")
	@ResponseBody
	public String checkMemberIdPost(String memberId) {
		int result = memberService.selectCountByMemberId(memberId);
		if (result != 0) {
			return "fail";
		} else {
			return "success";
		}
	}

	// 이메일 중복 체크
	@PostMapping("check-email")
	@ResponseBody
	public String checkMemberEmailCheckPost(String memberEmail) {
		int result = memberService.selectCountByMemberEmail(memberEmail);
		if (result != 0) {
			return "fail";
		} else {
			return "success";
		}
	}

	// 이메일 인증
	@GetMapping("verify-email")
	@ResponseBody
	public String verifyMemberEmail(String email) {
		Random random = new Random();
		int checkNum = random.nextInt(888888) + 111111;
		logger.info("인증번호 " + checkNum);

		String setFrom = "";
		String toMail = email;
		String title = "회원가입 인증 메일입니다.";
		String content = "홈페이지를 방분해주셔서 감사합니다." + "<br><br>" + "인증 번호는 " + checkNum + "입니다. " + "<br>"
				+ "해당 인증번호를 인증번호 확인란에 기입하여 주세요.";

		/*
		 * try { MimeMessage message = mailSender.createMimeMessage(); MimeMessageHelper
		 * helper = new MimeMessageHelper(message, true, "utf-8");
		 * helper.setFrom(setFrom); helper.setTo(toMail); helper.setSubject(title);
		 * helper.setText(content, true); mailSender.send(message); } catch(Exception e)
		 * { e.printStackTrace(); }
		 */
		String num = Integer.toString(checkNum);
		return num;
	}

	// 수강생 회원가입
	@PostMapping("join")
	public String joinPost(MemberVO requestMember, RedirectAttributes rttr) {
		System.out.println("회원가입 진행 중");
		String rawPwd = requestMember.getMemberPwd();
		String encodePwd = pwdEncoder.encode(rawPwd);
		requestMember.setMemberPwd(encodePwd);

		int result = memberService.insertMember(requestMember);
		if(result != 0) {
	        rttr.addFlashAttribute("enroll_result", "success");
			return "redirect:/member/login";
		} else {
	        rttr.addFlashAttribute("enroll_result", "fail");
			return "redirect:/member/join";
		}
	}
	
	// 수강생 로그인
	@PostMapping("login")
	public String loginPost(HttpServletRequest request, MemberVO requestMember, RedirectAttributes rttr)
			throws Exception {
		
		MemberVO loginMember = memberService.selectLoginMember(requestMember);
		
		// 사용자 존재하지 않음
		if (loginMember == null) {
			rttr.addFlashAttribute("result", 1);
			return "redirect:/member/login";
		}

		// 비밀번호 불일치
		if (!pwdEncoder.matches(requestMember.getMemberPwd(), loginMember.getMemberPwd())) {
			rttr.addFlashAttribute("result", 1);
			return "redirect:/member/login";
		}

		// 미승인 회원
		if (!"Y".equals(loginMember.getMemberCheckStatus())) {
			rttr.addFlashAttribute("result", 0);
			return "redirect:/member/login";
		}

		// 로그인 성공
		loginMember.setMemberPwd("");
		HttpSession session = request.getSession();
		session.setAttribute("loginMember", loginMember);
		
		
		// 메시지의 유무(unreadRoomCount)
		int unreadRoomCount;
		try {
			chatMemberController.memberChatListGET(request, rttr);//
			unreadRoomCount = chatMemberController.getUnreadRoomCount();
			if(unreadRoomCount>0) {
				session.setAttribute("unreadRoomCount", unreadRoomCount);
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		
		
		return "redirect:/member/main";
	}
	
	// 비밀번호 체크
	@PostMapping("check-pwd")
	@ResponseBody
	public String checkMemberPwd(MemberVO requestMember) {
		System.out.println("비밀번호 체크 : " + requestMember);

		String storedPwd = memberService.selectPwd(requestMember);
		
		if (pwdEncoder.matches(requestMember.getMemberPwd(), storedPwd)) {
			return "pass";
		} else {
			return "fail";
		}
	}

	// 회원정보 수정
	@PostMapping("mypage")
	public String mypageMember(MemberVO updateMember, RedirectAttributes rttr, HttpSession session) throws Exception {
		MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
		
		// 비밀번호 암호화 및 기본값 설정
		if(updateMember.getMemberPwd() != null && !updateMember.getMemberPwd().isEmpty()) {
			String rawPwd = updateMember.getMemberPwd();
			String encodePwd = pwdEncoder.encode(rawPwd);
			updateMember.setMemberPwd(encodePwd);
		} else {
			updateMember.setMemberPwd(memberService.selectPwd(loginMember));
		}
		
		// 업데이트 진행
		updateMember.setMemberNo(loginMember.getMemberNo());
		int result = memberService.updateMember(updateMember);
		if(result != 0) {
			loginMember = memberService.selectLoginMember(updateMember);
			rttr.addFlashAttribute("update_result", "success");
			session.setAttribute("loginMember", loginMember);
		} else {
			rttr.addFlashAttribute("update_result", "fail");
		}
		return "redirect:/member/mypage";
	}

	// 로그아웃
	@GetMapping("logout")
	public String logoutMember(HttpSession session, RedirectAttributes rttr) {
		System.out.println("로그아웃 중");
		session.invalidate();
		rttr.addFlashAttribute("logout_result", "success");
		return "redirect:/";
	}

	// 회원탈퇴
	@PostMapping("delete")
	public String deleteMember(HttpSession session, RedirectAttributes rttr) {
		MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
		int result = memberService.deleteMember(loginMember);
		if(result != 0) {
			session.invalidate();
			rttr.addFlashAttribute("delete_result", "success");
			return "redirect:/";
		} else {
			rttr.addFlashAttribute("delete_result", "fail");
			return "redirect:/member/mypage";
		}
	}
}
