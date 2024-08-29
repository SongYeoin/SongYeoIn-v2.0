package com.syi.project.controller.member;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Random;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import com.syi.project.model.member.MemberVO;
import com.syi.project.service.chat.MessageService;
import com.syi.project.service.member.MemberService;

import net.coobird.thumbnailator.Thumbnails;

@Controller
@RequestMapping(value = "/member")
public class MemberController {

	private static final Logger logger = LoggerFactory.getLogger(MemberController.class);

	@Autowired
	private MemberService memberService;

	@Autowired
	private BCryptPasswordEncoder pwdEncoder;

	@Autowired
	private MessageService messageService;

	// 파일 업로드 경로를 저장할 필드
	@Value("C:/upload/temp")
	private String fileUploadPath;

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
		if (result != 0) {
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

		// 메시지 수 유무
		messageService.getUnReadRoomCount(session);
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
		if (updateMember.getMemberPwd() != null && !updateMember.getMemberPwd().isEmpty()) {
			String rawPwd = updateMember.getMemberPwd();
			String encodePwd = pwdEncoder.encode(rawPwd);
			updateMember.setMemberPwd(encodePwd);
		} else {
			updateMember.setMemberPwd(memberService.selectPwd(loginMember));
		}

		// 업데이트 진행
		updateMember.setMemberNo(loginMember.getMemberNo());
		int result = memberService.updateMember(updateMember);
		if (result != 0) {
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
		if (result != 0) {
			session.invalidate();
			rttr.addFlashAttribute("delete_result", "success");
			return "redirect:/";
		} else {
			rttr.addFlashAttribute("delete_result", "fail");
			return "redirect:/member/mypage";
		}
	}

	// 프로필 등록
	@PostMapping("profile/upload")
	public String uploadProfilePOST(MemberVO updateProfileMember, HttpSession session,
			@RequestParam("file") MultipartFile file, @RequestParam("memberNo") int memberNo, RedirectAttributes rttr)
			throws IOException {
		// 프로필 저장하기- memberNo만 매핑되서 넘어옴

		logger.info("fileUploadPath :{} " + fileUploadPath);// upload/temp

		if (!file.isEmpty()) {
			// 사용자별 디렉토리 생성
			Path userDir = Paths.get(fileUploadPath, "member", Integer.toString(memberNo));
			if (!Files.exists(userDir)) {
				Files.createDirectories(userDir);
				logger.info("Created directory: {}", userDir.toString());
			}

			// 파일 이름 변경
			String originalFileName = file.getOriginalFilename();
			String extension = originalFileName.substring(originalFileName.lastIndexOf("."));
			String uniqueFileName = UUID.randomUUID().toString() + extension;

			Path filePath = userDir.resolve(uniqueFileName);
			logger.info("filePath: {}" + filePath);
			Files.copy(file.getInputStream(), filePath);// 원본 이미지
			logger.info("File saved to: {}", filePath.toString());
			
			// 썸네일 파일 이름 및 경로
	        String thumbnailFileName = "thumb_" + uniqueFileName;
	        Path thumbnailPath = userDir.resolve(thumbnailFileName);
	        logger.info("thumbnailPath: {}" + thumbnailPath);

	        // 썸네일 생성
	        try {
				Thumbnails.of(file.getInputStream())
				        .size(150, 150) // 썸네일 크기
				        .toFile(thumbnailPath.toFile());
				logger.info("Thumbnails saved to: {}", thumbnailPath.toString());
			} catch (IOException e) {
				e.printStackTrace();
			}

			// 파일 URL 생성
			String fileDownloadUri = ServletUriComponentsBuilder.fromCurrentContextPath().path("/member/profile/")
					.path(Integer.toString(memberNo)).path("/").path(thumbnailFileName).toUriString();
			logger.info("Generated file download URI: {}", fileDownloadUri);

			// 파일 URL 저장
			updateProfileMember.setMemberProfileUrl(fileDownloadUri);
			int result = memberService.updateMemberProfileUrl(updateProfileMember);

			if (result > 0) {
				rttr.addFlashAttribute("upload_profile", "success");

				MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
				loginMember.setMemberProfileUrl(fileDownloadUri);
				session.setAttribute("loginMember", loginMember);

			} else {
				rttr.addFlashAttribute("upload_profile", "fail");
			}

		}
		return "redirect:/member/main";

	}

	@GetMapping("profile/{memberNo}/{fileName:.+}")
	public ResponseEntity<Resource> serveFile(@PathVariable String memberNo, @PathVariable String fileName) {

		Path fileStorageLocation = Paths.get("C:/upload/temp/member");

		try {
			Path file = fileStorageLocation.resolve(Paths.get(memberNo, fileName)).normalize();
			Resource resource = new UrlResource(file.toUri());

			if (resource.exists() || resource.isReadable()) {
				String contentType = Files.probeContentType(file); // MIME 타입 자동 감지
				if (contentType == null) {
					contentType = "application/octet-stream";
				}
				return ResponseEntity.ok().header(HttpHeaders.CONTENT_TYPE, contentType).body(resource);
			} else {
				return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
			}
		} catch (Exception e) {
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
		}
	}
}