package com.syi.project.controller.member;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.syi.project.controller.chat.ChatAdminController;
import com.syi.project.model.Criteria;
import com.syi.project.model.EnrollVO;
import com.syi.project.model.PageDTO;
import com.syi.project.model.member.MemberVO;
import com.syi.project.model.syclass.SyclassVO;
import com.syi.project.service.member.AdminService;

@Controller
@RequestMapping(value = "/admin")
public class AdminController {

	private static final Logger logger = LoggerFactory.getLogger(AdminController.class);

	@Autowired
	private AdminService adminService;
	private ChatAdminController chatAdminController;

	@Autowired
	private BCryptPasswordEncoder pwdEncoder;

	// 관리자 메인페이지, 관리자 수강생 조회 페이지
	@GetMapping(value = { "main", "member/list" })
	public String memberListGet(Criteria cri, Model model) throws Exception {
		logger.info("관리자 수강 조회 페이지 접속");

		List<MemberVO> memberList = adminService.selectMemberList(cri);
		model.addAttribute("memberList", memberList);

		// 페이지 이동 인터페이스 데이터
		int total = adminService.selectTotalCount(cri);
		PageDTO pageMaker = new PageDTO(cri, total);
		model.addAttribute("pageMaker", pageMaker);

		return "admin/member/list";
	}

	// 관리자 로그인 페이지 이동
	@GetMapping("login")
	public void loginGet() {
		logger.info("관리자 로그인 페이지 이동");
	}

	// 관리자 로그인
	@PostMapping("login")
	public String loginPost(HttpServletRequest request, MemberVO requestMember, RedirectAttributes rttr)
			throws Exception {

		MemberVO loginMember = adminService.selectLoginAdmin(requestMember);

		// 사용자 존재하지 않음
		if (loginMember == null) {
			rttr.addFlashAttribute("result", 1);
			return "redirect:/admin/login";
		}

		// 비밀번호 불일치
		if (!pwdEncoder.matches(requestMember.getMemberPwd(), loginMember.getMemberPwd())) {
			rttr.addFlashAttribute("result", 1);
			return "redirect:/admin/login";
		}

		// 미승인 회원
		if (!"Y".equals(loginMember.getMemberCheckStatus())) {
			rttr.addFlashAttribute("result", 0);
			return "redirect:/admin/login";
		}

		// 로그인 성공
		loginMember.setMemberPwd("");
		HttpSession session = request.getSession();
		session.setAttribute("loginMember", loginMember);

		// 메시지의 유무(unreadRoomCount)
		try {
			int unreadRoomCount = chatAdminController.getUnreadRoomCount();
			if (unreadRoomCount > 0) {
				session.setAttribute("unreadRoomCount", unreadRoomCount);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return "redirect:/admin/main";
	}

	// 승인 처리
	@PostMapping("status-y")
	@ResponseBody
	public String memberChangeStatusYPost(int memberNo) {
		logger.info("승인 처리 중 for memberNo: {}", memberNo);
		try {
			int result = adminService.updateStatusY(memberNo);
			logger.info("승인 처리의 result: {}", result);
			return result > 0 ? "success" : "fail";
		} catch (Exception e) {
			logger.error("Error processing approval for memberNo: {}", memberNo, e);
			return "error";
		}
	}

	// 미승인 처리
	@PostMapping("status-n")
	@ResponseBody
	public String memberChangeStatusNPost(int memberNo) {
		logger.info("미승인 처리 중 for memberNo: {}", memberNo);
		try {
			int result = adminService.updateStatusN(memberNo);
			logger.info("미승인 처리의 result: {}", result);
			return result > 0 ? "success" : "fail";
		} catch (Exception e) {
			logger.error("Error processing disapproval for memberNo: {}", memberNo, e);
			return "error";
		}
	}

	// 회원 상세 페이지
	@GetMapping("/member/detail")
	public String memberDetail(int memberNo, Model model) throws Exception {
		logger.info("회원 상세 페이지");
		MemberVO member = adminService.selectMemberDetail(memberNo);
		List<SyclassVO> classList = adminService.selectClassList();
		List<EnrollVO> enrollList = adminService.selectEnrollList(memberNo);

		model.addAttribute("member", member);
		model.addAttribute("classList", classList);
		model.addAttribute("enrollList", enrollList);
		return "admin/member/detail";
	}

	// 수강 신청 등록
	@PostMapping("/member/enroll")
	@ResponseBody
	public String memberEnroll(int memberNo, int classNo, RedirectAttributes rttr) {

		EnrollVO enroll = new EnrollVO();
		enroll.setMemberNo(memberNo);
		enroll.setClassNo(classNo);

		int result = adminService.insertEnroll(enroll);
		if (result != 0) {
			return "success";
		} else {
			return "fail";
		}
	}

	// 수강 신청 삭제
	@PostMapping("/member/enroll/delete")
	@ResponseBody
	public String memberEnrollDelete(int enrollNo, RedirectAttributes rttr) {
		System.out.println("enrollNo : " + enrollNo);
		int result = adminService.deleteEnroll(enrollNo);
		System.out.println(result);
		if (result != 0) {
			return "success";
		} else {
			return "fail";
		}
	}

	// 마이페이지 이동
	@GetMapping("mypage")
	public void mypageGet() {
		logger.info("마이페이지 이동");
	}

	// 이메일 중복 체크
	@PostMapping("check-email")
	@ResponseBody
	public String checkMemberEmailCheckPost(String memberEmail) {
		int result = adminService.selectCountByMemberEmail(memberEmail);
		if (result != 0) {
			return "fail";
		} else {
			return "success";
		}
	}

	// 비밀번호 체크
	@PostMapping("check-pwd")
	@ResponseBody
	public String checkMemberPwd(MemberVO requestMember) {
		System.out.println("비밀번호 체크 : " + requestMember);

		String storedPwd = adminService.selectPwd(requestMember);

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
		if (updateMember.getMemberPwd() != null && !updateMember.getMemberPwd().isEmpty()) {
			String rawPwd = updateMember.getMemberPwd();
			String encodePwd = pwdEncoder.encode(rawPwd);
			updateMember.setMemberPwd(encodePwd);
		} else {
			updateMember.setMemberPwd(adminService.selectPwd(loginMember));
		}

		// 업데이트 진행
		updateMember.setMemberNo(loginMember.getMemberNo());
		int result = adminService.updateMember(updateMember);
		if (result != 0) {
			loginMember = adminService.selectLoginAdmin(updateMember);
			rttr.addFlashAttribute("update_result", "success");
			session.setAttribute("loginMember", loginMember);
		} else {
			rttr.addFlashAttribute("update_result", "fail");
		}
		return "redirect:/admin/mypage";
	}

	// 회원탈퇴
	@PostMapping("delete")
	public String deleteMember(HttpSession session, RedirectAttributes rttr) {
		MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
		int result = adminService.deleteMember(loginMember);
		if (result != 0) {
			session.invalidate();
			rttr.addFlashAttribute("delete_result", "success");
			return "redirect:/";
		} else {
			rttr.addFlashAttribute("delete_result", "fail");
			return "redirect:/admin/mypage";
		}
	}

}
