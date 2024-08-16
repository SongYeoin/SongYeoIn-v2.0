package com.syi.project.controller.club;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.sql.Date;
import java.time.LocalDate;
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
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.syi.project.model.club.ClubVO;
import com.syi.project.model.member.MemberVO;
import com.syi.project.model.syclass.SyclassVO;
import com.syi.project.service.club.ClubService;
import com.syi.project.service.syclass.SyclassService;

@Controller
@RequestMapping("/admin")
public class ClubAdminController {
private static final Logger log = LoggerFactory.getLogger(ClubMemberController.class);
	
	@Autowired
	private ClubService cservice;
	
	@Autowired
	private SyclassService syclassService;
	
	//파일 업로드 경로 저장할 필드
	@Value("${file.upload.path}")
	private String fileUploadPath;   

	//리스트
	@GetMapping("/class/club/list")
	public String clubListGET(@RequestParam(value = "classNo", required = false)Integer classNo, Model model) {
		log.info("목록 페이지 진입");
		
	    System.out.println("classNo after service call: " + classNo);
	    
		List<ClubVO> list =  cservice.getList(classNo);
		System.out.println(classNo);
		System.out.println("controller : " +list);
		model.addAttribute("list", list);
		
	    return "admin/class/club/list";
		
	}
	
//	@GetMapping("/club/list/getByClass")
//	@ResponseBody
//	public List<ClubVO> getClubListByClassNo(@RequestParam(value = "classNo", required = false) Integer classNo) {
//		if (classNo == null) {
//	        // classNo가 null인 경우, 기본값 설정하거나 빈 리스트 반환
//	        return new ArrayList<>();
//	    }
//		
//		List<ClubVO> clubs = cservice.getList(classNo);
//	    return clubs != null ? clubs : new ArrayList<>(); // null을 방지하기 위해 빈 리스트 반환
//
//	}
	
	//등록페이지
//	@GetMapping("/club/enroll")
//	public void clubEnrollGET() {
//		log.info("등록 페이지 진입");
//	}
	
//	@PostMapping("/club/enroll")
//	public String clubEnrollPOST(@RequestParam(value = "classNo", required = false) Integer classNo, 
//            @RequestParam("join") String join, 
//            @RequestParam("studyDate") @DateTimeFormat(pattern = "yyyy-MM-dd") java.util.Date studyDate, 
//            @RequestParam("content") String content, HttpSession session, RedirectAttributes rttr) throws ParseException{
//		
//		MemberVO member = (MemberVO)session.getAttribute("loginMember");
//		int memberNo = member.getMemberNo();
//		
//		if(classNo == null) {
//			System.out.println("classNo null");
//			classNo = cservice.getDefaultClassNoByMember(memberNo);
//		}
//		
//		log.info("classNo : "+classNo);
//		
//		// Date 타입을 SQL Date로 변환
//	    java.sql.Date sqlDate = new java.sql.Date(studyDate.getTime());
//	 
//		cservice.enroll(classNo, join, sqlDate, content, memberNo);
//		
//		rttr.addFlashAttribute("result", "enroll success");
//		
//		return "redirect:/member/club/list";
//	}
	
//	@PostMapping("/club/enroll")
//	public String clubEnrollPOST(ClubVO club, RedirectAttributes rttr) {
//		log.info("ClubVO : "+club);
//		
//		//MemberVO member = (MemberVO)session.getAttribute("loginMember");
//		
//		cservice.enroll(club);
//		
//		rttr.addFlashAttribute("result", "enroll success");
//		
//		return "redirect:/admin/class/club/list";
//	}
	
	//조회 HttpSession session
	@GetMapping("/class/club/get")
	public void clubGetPageGET(int clubNo, Model model) {
		//MemberVO member = (MemberVO)session.getAttribute("loginMember");
		//model.addAttribute("member", member);
		
		System.out.println("controllerGET : " +cservice.getPage(clubNo));
		model.addAttribute("pageInfo", cservice.getPage(clubNo));
		
		// 선택 할 반 정보 프론트로 보내기
//		List<SyclassVO> classList = syclassService.getClassList();
//		model.addAttribute("classList", classList);
	}
	
	//수정페이지 이동
	@GetMapping("/class/club/modify")
	public void clubModifyAdminGET(int clubNo, Model model) {
		model.addAttribute("pageInfo", cservice.getPage(clubNo));
		System.out.println("modifypage : " +cservice.getPage(clubNo));
	}
	
	//수정
	@PostMapping("/class/club/modify")
	public String clubModifyAdminPOST(ClubVO club, @RequestParam(value = "classNo", required = false) Integer classNo, RedirectAttributes rttr) {

//		// 파일 업로드 처리
//	    if (file != null && !file.isEmpty()) {
//	        // 파일 이름 정리 (파일의 불필요한 경로, 요소를 제거하고 이름만 남겨놓음)
//	        String fileName = StringUtils.cleanPath(file.getOriginalFilename());
//	        // 파일이 저장될 경로 설정
//	        Path uploadPath = Paths.get(fileUploadPath);
//
//	        log.info(">>> File upload path: {}", uploadPath);
//
//	        // 업로드 경로가 존재하지 않으면 생성
//	        if (!Files.exists(uploadPath)) {
//	            log.info(">>> Creating directory: {}", uploadPath);
//	            Files.createDirectories(uploadPath);
//	        }
//
//	        // 파일 저장 경로 설정
//	        Path filePath = uploadPath.resolve(fileName);
//	        log.info(">>> File path: {}", filePath);
//
//	        try {
//	            // 기존 파일이 있을 경우 삭제
//	            if (club.getFileName() != null && !club.getFileName().isEmpty()) {
//	                Path oldFilePath = uploadPath.resolve(club.getFileName());
//	                if (Files.exists(oldFilePath)) {
//	                    log.info(">>> Deleting old file: {}", oldFilePath);
//	                    Files.delete(oldFilePath);
//	                }
//	            }
//
//	            // 파일 저장
//	            Files.copy(file.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);
//	            club.setFileName(fileName); // 파일 이름 설정
//	            log.info(">>> File uploaded successfully: {}", fileName);
//	        } catch (IOException e) {
//	            log.error(">>> File upload failed: {}", fileName, e);
//	            throw new Exception("파일 업로드 실패: " + fileName, e);
//	        }
//	    }
	    
	    cservice.modifyAdmin(club);
	    System.out.println("modify : " +cservice.modifyAdmin(club));
		rttr.addFlashAttribute("result", "modify success");

		return "redirect:/admin/class/club/list?classNo=" + (classNo != null ? classNo : "");
	}
	
	/* 첨부파일 다운로드 */
	@GetMapping("/class/club/downloadFile")
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
	        headers.add(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=" + URLEncoder.encode(cleanedFileName, "UTF-8"));
	        
	        // 파일 스트림을 ResponseEntity로 반환
	        InputStreamResource resource = new InputStreamResource(inputStream);
	        return ResponseEntity.ok()
	                .headers(headers)
	                .body(resource);
	    } catch (IOException e) {
	        // 서버 에러 시 500 에러 반환
	        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
	    }
	}
	
	//삭제
	@PostMapping("/class/club/delete")
	public String clubDeletePOST(int clubNo, @RequestParam(value = "classNo", required = false) Integer classNo, RedirectAttributes rttr) {
		cservice.delete(clubNo);
		rttr.addFlashAttribute("result", "delete success");
		return "redirect:/admin/class/club/list?classNo=" + (classNo != null ? classNo : "");
	}
	@PostMapping("/class/club/deleteadmin")
	@ResponseBody
	public String clubDeleteAdminPOST(int clubNo) throws Exception{
		
		//rttr.addFlashAttribute("result", "delete success");
		
		try {
			int deleteResult = cservice.delete(clubNo);;
			return deleteResult > 0 ? "success" : "fail";
			
		} catch (Exception e) {
			return "fail";
		}
	}
	
	
	//리스트 페이징 적용
	
	

}
