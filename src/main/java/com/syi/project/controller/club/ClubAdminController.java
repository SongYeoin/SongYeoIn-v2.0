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
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

import com.syi.project.model.Criteria;
import com.syi.project.model.PageDTO;
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
	public String clubListGET(@RequestParam(value = "classNo", required = false)Integer classNo, Criteria cri, Model model) {
		log.info("목록 페이지 진입");
		
	    System.out.println("classNo after service call: " + classNo);
	    
	    List<ClubVO> list =  cservice.getListPaging(cri, classNo);
		System.out.println("classNo : " + classNo);
		System.out.println("controller : " +list);
		model.addAttribute("list", list);
		
		int total = cservice.getTotal(cri, classNo);
		PageDTO pageMake = new PageDTO(cri, total);
		model.addAttribute("pageMaker", pageMake);
		
	    return "admin/class/club/list";
		
	}
	
	@GetMapping("/class/club/list/getByClass")
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
	
	//조회
	@GetMapping("/class/club/get")
	public void clubGetPageGET(int clubNo, Model model, int rn) {
		System.out.println("controllerGET : " +cservice.getPage(clubNo));
		model.addAttribute("pageInfo", cservice.getPage(clubNo));
		model.addAttribute("rownum", rn);
	}
	
	//수정페이지 이동
	@GetMapping("/class/club/modify")
	public void clubModifyAdminGET(int clubNo, Model model, int rn) {
		model.addAttribute("pageInfo", cservice.getPage(clubNo));
		System.out.println("modifypage : " +cservice.getPage(clubNo));
		model.addAttribute("rownum", rn);
	}
	
	//수정
	@PostMapping("/class/club/modify")
	public String clubModifyAdminPOST(ClubVO club, @RequestParam(value = "classNo", required = false) Integer classNo, RedirectAttributes rttr) {	    
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
			int deleteResult = cservice.delete(clubNo);
			return deleteResult > 0 ? "success" : "fail";
			
		} catch (Exception e) {
			return "fail";
		}
	}
	

}
