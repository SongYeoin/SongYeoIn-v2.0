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
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.PostConstruct;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.InputStreamResource;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.format.annotation.DateTimeFormat;
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

import com.syi.project.model.Criteria;
import com.syi.project.model.EnrollVO;
import com.syi.project.model.PageDTO;
import com.syi.project.model.club.ClubVO;
import com.syi.project.model.member.MemberVO;
import com.syi.project.model.syclass.SyclassVO;
import com.syi.project.service.club.ClubService;
import com.syi.project.service.syclass.SyclassService;



@Controller
@RequestMapping("/member")
public class ClubMemberController {

	private static final Logger log = LoggerFactory.getLogger(ClubMemberController.class);
	
	@Autowired
	private ClubService cservice;
	
	@Autowired
	private SyclassService syclassService;
	
	//파일 업로드 경로 저장할 필드
	@Value("${file.upload.path}")
	private String fileUploadPath;   

	//리스트(페이징)
	@GetMapping("/club/list")
	public String clubListGET(@RequestParam(value = "classNo", required = false)Integer classNo, Criteria cri, HttpSession session, Model model) {
		log.info("목록 페이지 진입");
		
		// 로그인한 멤버 정보 가져오기
		MemberVO member = (MemberVO)session.getAttribute("loginMember");
	    if (member == null) {
	        throw new RuntimeException("로그인된 사용자가 없습니다.");
	    }
	    
	    if (classNo == null) {
	        // `classNo`가 null인 경우, 로그인한 멤버의 enroll 정보를 기반으로 classNo를 결정
	        Integer memberNo = member.getMemberNo();
	        classNo = cservice.getDefaultClassNoByMember(memberNo);
	    }
		
	    System.out.println("classNo after service call: " + classNo);
	   
		List<ClubVO> list =  cservice.getListPaging(cri, classNo);
		System.out.println("classNo : " + classNo);
		System.out.println("controller : " +list);
		model.addAttribute("list", list);
		
		int total = cservice.getTotal(cri, classNo);
		PageDTO pageMake = new PageDTO(cri, total);
		model.addAttribute("pageMaker", pageMake);
		
		//수강 반 목록
		Integer memberNo = member.getMemberNo();
		List<SyclassVO> classList = cservice.getClassNoListByMember(memberNo);
		model.addAttribute("classList", classList);
		
	    return "member/club/list";
		
	}
		
	@GetMapping("/club/list/getByClass")
	@ResponseBody
	public Map<String, Object> getClubListByClassNo(@RequestParam(value = "classNo", required = false) Integer classNo,
	                                                 @RequestParam(value = "pageNum", defaultValue = "1") int pageNum,
	                                                 @RequestParam(value = "type", required = false) String type,
	                                                 @RequestParam(value = "keyword", required = false) String keyword,
	                                                 Criteria cri) {
	    if (classNo == null) {
	        return Collections.emptyMap();
	    }
	    cri.setPageNum(pageNum);
	    cri.setType(type);
	    
	    // 승인 상태 키워드 변환	    
	    if ("C".equals(type)) {
	        cri.setKeyword("대기".equals(keyword) ? "W" : "승인".equals(keyword) ? "Y" : "미승인".equals(keyword) ? "N" : "");
	    } else {
	        cri.setKeyword(keyword);
	    }
	    
	    List<ClubVO> clubs = cservice.getListPaging(cri, classNo);
	    int total = cservice.getTotal(cri, classNo);

	    PageDTO pageMake = new PageDTO(cri, total);
	    System.out.println(classNo);
	    
	    Map<String, Object> response = new HashMap<>();
	    response.put("list", clubs);
	    response.put("pageInfo", pageMake);
	    response.put("classNo", classNo);
	    return response;
	}
	
	//등록페이지
	@GetMapping("/club/enroll")
	public void clubEnrollGET(@RequestParam(value = "classNo", required = false) Integer classNo) {
		log.info("등록 페이지 진입");
		
		System.out.println("enroll get classNo : " + classNo);
	}
	
	@PostMapping("/club/enroll")
	public String clubEnrollPOST(ClubVO club, HttpSession session, @RequestParam(value = "classNo", required = false) int classNo, RedirectAttributes rttr) {
		log.info("ClubVO : "+club);
		
		MemberVO member = (MemberVO)session.getAttribute("loginMember");
		
		int memberNo = member.getMemberNo();

	    System.out.println("enroll post classNo : " + classNo);
	    
	    cservice.enroll(club, classNo, memberNo);
	    
		rttr.addFlashAttribute("result", "enroll success");
		System.out.println("classNo : "+classNo);
		return "redirect:/member/club/list?classNo=" + classNo;
	}
	
	//조회
	@GetMapping("/club/get")
	public void clubGetPageGET(int clubNo, Model model, int rn) {
		System.out.println("controllerGET : " +cservice.getPage(clubNo));
		model.addAttribute("pageInfo", cservice.getPage(clubNo));
		model.addAttribute("rownum", rn);
		
		// 선택 할 반 정보 프론트로 보내기
		List<SyclassVO> classList = syclassService.getClassList();
		model.addAttribute("classList", classList);

	}
	
	//수정페이지 이동
	@GetMapping("/club/modify")
	public void clubModifyGET(int clubNo, Model model, int rn) {
		model.addAttribute("pageInfo", cservice.getPage(clubNo));
		System.out.println("modifypage : " +cservice.getPage(clubNo));
		
		model.addAttribute("rownum", rn);
		
		//현재 날짜 추가
		LocalDate today = LocalDate.now();
		model.addAttribute("currentDate", Date.valueOf(today));
		
		// 선택 할 반 정보 프론트로 보내기
		List<SyclassVO> classList = syclassService.getClassList();
		model.addAttribute("classList", classList);
	}
	
	//수정
	@PostMapping("/club/modify")
	public String clubModifyPOST(ClubVO club, @RequestParam(value = "classNo", required = false) int classNo, @RequestParam(value = "file", required = false) MultipartFile file, RedirectAttributes rttr) throws Exception {
		
		
		// 파일 업로드 처리
	    if (file != null && !file.isEmpty()) {
	        // 파일 이름 정리 (파일의 불필요한 경로, 요소를 제거하고 이름만 남겨놓음)
	        String fileName = StringUtils.cleanPath(file.getOriginalFilename());
	        // 파일이 저장될 경로 설정
	        Path uploadPath = Paths.get(fileUploadPath);

	        log.info(">>> File upload path: {}", uploadPath);

	        // 업로드 경로가 존재하지 않으면 생성
	        if (!Files.exists(uploadPath)) {
	            log.info(">>> Creating directory: {}", uploadPath);
	            Files.createDirectories(uploadPath);
	        }

	        // 파일 저장 경로 설정
	        Path filePath = uploadPath.resolve(fileName);
	        log.info(">>> File path: {}", filePath);

	        try {
	            // 기존 파일이 있을 경우 삭제
	            if (club.getFileName() != null && !club.getFileName().isEmpty()) {
	                Path oldFilePath = uploadPath.resolve(club.getFileName());
	                if (Files.exists(oldFilePath)) {
	                    log.info(">>> Deleting old file: {}", oldFilePath);
	                    Files.delete(oldFilePath);
	                }
	            }

	            // 파일 저장
	            Files.copy(file.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);
	            club.setFileName(fileName); // 파일 이름 설정
	            log.info(">>> File uploaded successfully: {}", fileName);
	        } catch (IOException e) {
	            log.error(">>> File upload failed: {}", fileName, e);
	            throw new Exception("파일 업로드 실패: " + fileName, e);
	        }
	    }
	    
	    cservice.modify(club);
	    System.out.println("modify : " +cservice.modify(club));
		rttr.addFlashAttribute("result", "modify success");
		
		return "redirect:/member/club/list?classNo=" + classNo;
	}
	
	/* 첨부파일 다운로드 */
	@GetMapping("/club/downloadFile")
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
	@PostMapping("/club/delete")
	public String clubDeletePOST(int clubNo, RedirectAttributes rttr, @RequestParam(value = "classNo", required = false) int classNo) {
		cservice.delete(clubNo);
		rttr.addFlashAttribute("result", "delete success");
		return "redirect:/member/club/list?classNo=" + classNo;
	}
	

}
