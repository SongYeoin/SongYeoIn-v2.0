package com.syi.project.controller.journal;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.InputStreamResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.syi.project.model.Criteria;
import com.syi.project.model.EnrollVO;
import com.syi.project.model.PageDTO;
import com.syi.project.model.journal.EduScheduleVO;
import com.syi.project.model.journal.JournalVO;
import com.syi.project.model.member.MemberVO;
import com.syi.project.model.syclass.SyclassVO;
import com.syi.project.service.enroll.EnrollService;
import com.syi.project.service.journal.JournalService;
import com.syi.project.service.member.AdminService;
import com.syi.project.service.syclass.SyclassService;

@Controller
@RequestMapping("/journal")
public class JournalController {

	private static final Logger logger = LoggerFactory.getLogger(JournalController.class);

	@Autowired
	private JournalService journalService;
	
	@Autowired
	private EnrollService enrollService;
	
	// 파일 업로드 경로를 저장할 필드
	@Value("${file.upload.path}")
	private String fileUploadPath;

	@GetMapping("journalMain")
	public void journalMainGET() {
		logger.info("교육일지 메인 페이지 접속");
	}

	/* 일지 등록 페이지로 이동 */
	@GetMapping("journalEnroll")
	public String journalEnrollGET(Model model, HttpSession session) throws Exception {
		logger.info("일지 등록 폼 페이지 접속");
		MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) {
            return "redirect:/login";
        }
        List<EnrollVO> classList = enrollService.selectEnrollList(loginMember.getMemberNo());
        model.addAttribute("classList", classList);
		return "journal/journalEnroll";
	}

	/* 일지 등록 */
	@PostMapping("/journalEnroll")
	public String addJournal(JournalVO journal, @RequestParam("file") MultipartFile file, @RequestParam("classNo") int classNo, HttpSession session, RedirectAttributes rttr) throws Exception {
		logger.info("교육일지 등록");

		MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) {
            return "redirect:/member/login";
        }

        journal.setMemberNo(loginMember.getMemberNo());
        journal.setClassNo(classNo);
		
		// 파일 업로드 처리
		if (!file.isEmpty()) {
			// 파일 이름 정리 (파일의 불필요한 경로, 요소를 제거하고 이름만 남겨놓음)
			String fileName = StringUtils.cleanPath(file.getOriginalFilename());
			// 파일이 저장될 경로 설정
			Path uploadPath = Paths.get(fileUploadPath);

			logger.info(">>> File upload path: {}", uploadPath);

			// 업로드 경로가 존재하지 않으면 생성
			if (!Files.exists(uploadPath)) {
				logger.info(">>> Creating directory: {}", uploadPath);
				Files.createDirectories(uploadPath);
			}

			// 파일 저장 경로 설정
			Path filePath = uploadPath.resolve(fileName);
			logger.info(">>> File path: {}", filePath);

			try {
				// 파일 저장
				Files.copy(file.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);
				journal.setFileName(fileName); // 일지에 파일 이름 설정
				logger.info(">>> File uploaded successfully: {}", fileName);
			} catch (IOException e) {
				logger.error(">>> File upload failed: {}", fileName, e);
				throw new Exception("파일 업로드 실패: " + fileName, e);
			}
		}

		// 일지 등록 처리
		logger.info(">>> Received journal date: {}", journal.getJournalWriteDate());
		journalService.journalEnroll(journal, file);
		rttr.addFlashAttribute("message", "교육일지가 등록되었습니다.");
		return "redirect:/journal/journalList";
	}

	/* 첨부파일 다운로드 */
	@GetMapping("/downloadFile")
	public ResponseEntity<InputStreamResource> downloadFile(@RequestParam("fileName") String fileName) {
		try {
			// 파일 이름 정리(불필요한 경로 구분기호 제거하고 이름만 남기기)
			String cleanedFileName = StringUtils.cleanPath(fileName);
			// 파일 객체 생성(최종적인 파일 경로를 생성함 (파일 저장할 경로 + 정리된 파일 이름)
			File file = new File(fileUploadPath, cleanedFileName);

			// 파일이 존재하지 않으면 404 에러 반환
			if (!file.exists()) {
				return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null);
			}

			// 파일 입력 스트림 생성
			InputStream inputStream = new FileInputStream(file);

			// HTTP 헤더 설정 (파일 다운로드를 위한 설정)
			HttpHeaders headers = new HttpHeaders();
			headers.add(HttpHeaders.CONTENT_DISPOSITION,
					"attachment; filename=" + URLEncoder.encode(cleanedFileName, "UTF-8"));

			// 파일 스트림을 ResponseEntity로 반환
			InputStreamResource resource = new InputStreamResource(inputStream);
			return ResponseEntity.ok().headers(headers).body(resource);
		} catch (IOException e) {
			logger.error("파일 다운로드 실패", e);
			// 서버 에러 시 500 에러 반환
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
		}
	}

	/* 교육일지 목록 조회 페이지 */
	@GetMapping("journalList")
	public String journalListGET(Criteria cri, Model model, HttpSession session
	        , @RequestParam(value = "classNo", required = false) Integer classNo
	        , @RequestParam(value = "memberNo", required = false) Integer selectedMemberNo) throws Exception {
	    logger.info(">>>>>>>>>>       교육일지 목록 페이지 접속             >>>>>>>>>>");

	    MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
	    int memberNo = loginMember.getMemberNo();

	    // 관리자 여부 확인
	    boolean isAdmin = "ROLE_ADMIN".equals(loginMember.getMemberRole());

	    if (isAdmin) {
	        // 관리자의 경우 세션에서 syclass 정보를 가져옴
	        SyclassVO syclass = (SyclassVO) session.getAttribute("syclass");
	        if (syclass == null) {
	            return "error";
	        }
	        classNo = syclass.getClassNo();
	        
	        // 수강 중인 수강생 정보 조회
	        List<EnrollVO> enrollList = enrollService.selectEnrollListByClassNo(classNo);
	        model.addAttribute("enrollList", enrollList);
	    } else {
	        // 일반 사용자의 경우
	        if (classNo == null) {
	            classNo = (Integer) session.getAttribute("selectedClassNo");
	            if (classNo == null) {
	                classNo = enrollService.selectClassNo(memberNo);
	                if (classNo == null) {
	                    return "error";
	                }
	            }
	        }
	        // 사용자의 수강 중인 반 목록 조회
	        List<EnrollVO> classList = enrollService.selectEnrollList(memberNo);
	        model.addAttribute("classList", classList);
	    }
	    
	    // 세션에 선택된 클래스 번호 저장
	    session.setAttribute("selectedClassNo", classNo);
	    
	    List<JournalVO> journalList;
	    int total;

	    if (isAdmin) {
	        // 관리자: 선택된 클래스의 모든 일지 또는 특정 학생의 일지 조회
	        if (selectedMemberNo != null) {
	            journalList = journalService.journalList(cri, classNo, selectedMemberNo);
	            total = journalService.journalGetTotal(cri, classNo, selectedMemberNo);
	        } else {
	            journalList = journalService.journalList(cri, classNo, memberNo);
	            total = journalService.journalGetTotal(cri, classNo, memberNo);
	        }
	    } else {
	        // 일반 사용자: 자신의 일지만 조회
	        journalList = journalService.journalList(cri, classNo, memberNo);
	        total = journalService.journalGetTotal(cri, classNo, memberNo);
	    }
	    
	    model.addAttribute("journalList", journalList);
	    model.addAttribute("pageMaker", new PageDTO(cri, total));
	    
	 // 캘린더용 전체 일지 조회
	    List<JournalVO> journalAllList = journalService.journalAllList(classNo);
	    model.addAttribute("journalAllList", journalAllList);

	    model.addAttribute("selectedClassNo", classNo);
	    model.addAttribute("selectedMemberNo", selectedMemberNo);
	    model.addAttribute("isAdmin", isAdmin);

	    return "journal/journalList";
	}
    
	/* 교육일지 상세 정보 페이지 */
	@GetMapping("journalDetail")
	public void journalDetailGET(@RequestParam("journalNo") int journalNo, Model model) throws Exception {
		logger.info("교육일지 상세 페이지 접속 / 일지 글번호 ---> " + journalNo);
		JournalVO journal = journalService.journalDetail(journalNo);
		model.addAttribute("journalDetail", journal);
	}

	/* 교육일지 수정 페이지 요청 처리 */
	@GetMapping("journalModify")
	public String journalModifylGET(@RequestParam("journalNo") int journalNo, Model model) throws Exception {
		logger.info("교육일지 수정 페이지 접속 / 일지 글번호 ---> " + journalNo);

		JournalVO journal = journalService.journalDetail(journalNo);
		model.addAttribute("journal", journal);
		return "journal/journalModify";
	}

	/* 교육일지 수정 처리 */
	@PostMapping("journalModify.do")
	public String journalModifyPOST(JournalVO journal, @RequestParam(value = "file", required = false) MultipartFile file, HttpSession session,
			RedirectAttributes rttr) throws Exception {
		logger.info("교육일지 수정 요청 / 일지 글번호 ---> " + journal.getJournalNo());

		// 파일이 업로드된 경우
		if (file != null && !file.isEmpty()) {
			String fileName = StringUtils.cleanPath(file.getOriginalFilename());
			Path uploadPath = Paths.get(fileUploadPath);

			logger.info(">>> File upload path: {}", uploadPath);

			if (!Files.exists(uploadPath)) {
				logger.info(">>> Creating directory: {}", uploadPath);
				Files.createDirectories(uploadPath);
			}

			Path filePath = uploadPath.resolve(fileName);
			logger.info(">>> File path: {}", filePath);

			try {
				Files.copy(file.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);
				journal.setFileName(fileName);
				logger.info(">>> File uploaded successfully: {}", fileName);
			} catch (IOException e) {
				logger.error(">>> File upload failed: {}", fileName, e);
				throw new Exception("파일 업로드 실패: " + fileName, e);
			}
		}

		// 일지 수정 처리
		journalService.journalModify(journal);

		return "redirect:/journal/journalList";
	}

	/* 교육일지 삭제 처리 */
	@PostMapping("journalDelete")
	public String journalDelete(@RequestParam("journalNo") int journalNo) throws Exception {
		logger.info("교육일지 삭제 요청 / 일지 글번호 ---> " + journalNo);

		// 일지 상세 정보를 조회하여 파일 이름을 가져옴
		JournalVO journal = journalService.journalDetail(journalNo);
		if (journal != null && journal.getFileName() != null) {
			// 파일 삭제 처리
			String fileName = journal.getFileName();
			Path filePath = Paths.get(fileUploadPath).resolve(fileName);

			try {
				Files.deleteIfExists(filePath);
				logger.info(">>> File deleted successfully: {}", fileName);
			} catch (IOException e) {
				logger.error(">>> File deletion failed: {}", fileName, e);
			}
		}

		// 일지 삭제 처리
		journalService.journalDelete(journalNo);

		return "redirect:/journal/journalList";
	}
}