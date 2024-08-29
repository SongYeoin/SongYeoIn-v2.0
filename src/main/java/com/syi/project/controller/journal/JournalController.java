package com.syi.project.controller.journal;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
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
import com.syi.project.model.journal.JournalVO;
import com.syi.project.model.member.MemberVO;
import com.syi.project.model.syclass.SyclassVO;
import com.syi.project.service.enroll.EnrollService;
import com.syi.project.service.journal.JournalService;

@Controller
@RequestMapping("/journal")
public class JournalController {

    private static final Logger logger = LoggerFactory.getLogger(JournalController.class);

    @Autowired
    private JournalService journalService;

    @Autowired
    private EnrollService enrollService;

    @Value("${file.upload.path}")
    private String fileUploadPath;
    
    // 교육일지 목록 조회
    @GetMapping("journalList")
    public String journalListGET(Criteria cri, Model model, HttpSession session,
                                 @RequestParam(value = "classNo", required = false) Integer classNo,
                                 @RequestParam(value = "memberNo", required = false) Integer selectedMemberNo) throws Exception {
        logger.info("교육일지 목록 페이지 접속");

        // 세션에서 로그인한 회원 정보 가져오기
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        int memberNo = loginMember.getMemberNo();
        boolean isAdmin = "ROLE_ADMIN".equals(loginMember.getMemberRole());

        // 관리자와 일반 사용자에 따른 처리
        if (isAdmin) {
            // 관리자의 경우
            SyclassVO syclass = (SyclassVO) session.getAttribute("syclass");
            classNo = syclass.getClassNo();
            
            // 수강생 목록 조회
            List<EnrollVO> memberList = enrollService.selectMemberList(classNo);
            model.addAttribute("memberList", memberList); // 모델에 수강생 목록 추가
        } else {
            // 일반 사용자의 경우
            if (classNo == null) {
                classNo = (Integer) session.getAttribute("selectedClassNo");
                if (classNo == null) {
                    classNo = enrollService.selectClassNo(memberNo);
                }
            }
            // 사용자의 수강 중인 반 목록 조회
            List<EnrollVO> classList = enrollService.selectEnrollList(memberNo);
            model.addAttribute("classList", classList); // 모델에 클래스 목록 추가
        }

        // 선택된 클래스 번호 세션에 저장
        session.setAttribute("selectedClassNo", classNo);

        List<JournalVO> journalList;
        int total;

        // 관리자와 일반 사용자에 따른 일지 목록 조회
        // 로그인한 사용자가 관리자 역할인지 확인
        if (isAdmin) {
            // 관리자인 경우
            if (selectedMemberNo != null) { 
                // 특정 회원 번호가 선택된 경우
                // 선택된 회원 번호와 클래스 번호를 기준으로 일지 목록 조회
                journalList = journalService.journalList(cri, classNo, selectedMemberNo);
                // 선택된 회원 번호와 클래스 번호를 기준으로 일지 총 개수 조회
                total = journalService.journalGetTotal(cri, classNo, selectedMemberNo);
            } else {
                // 특정 회원 번호가 선택되지 않은 경우
                // 현재 로그인된 회원의 번호와 클래스 번호를 기준으로 일지 목록 조회
                journalList = journalService.journalList(cri, classNo, memberNo);
                // 현재 로그인된 회원의 번호와 클래스 번호를 기준으로 일지 총 개수 조회
                total = journalService.journalGetTotal(cri, classNo, memberNo);
            }
        } else {
            // 관리자가 아닌 경우 (일반 사용자)
            // 현재 로그인된 회원의 번호와 클래스 번호를 기준으로 일지 목록 조회
            journalList = journalService.journalList(cri, classNo, memberNo);
            // 현재 로그인된 회원의 번호와 클래스 번호를 기준으로 일지 총 개수 조회
            total = journalService.journalGetTotal(cri, classNo, memberNo);
        }


        // 모델에 데이터 추가
        model.addAttribute("journalList", journalList); // 일지 목록 추가
        model.addAttribute("pageMaker", new PageDTO(cri, total)); // 페이지 정보 추가
        model.addAttribute("journalAllList", journalService.journalAllList(classNo, memberNo)); // 전체 일지 목록 추가
        model.addAttribute("selectedClassNo", classNo); // 선택된 클래스 번호 추가
        model.addAttribute("selectedMemberNo", selectedMemberNo); // 선택된 회원 번호 추가
        model.addAttribute("isAdmin", isAdmin); // 관리자인지 여부 추가
        model.addAttribute("keyword", cri.getKeyword()); // 검색어 추가
        model.addAttribute("year", cri.getYear()); // 년도 추가
        model.addAttribute("month", cri.getMonth()); // 월 추가

        return "journal/journalList"; // 뷰 페이지로 이동
    }

    // 캘린더용 일지 데이터 조회
    @GetMapping("getJournalForCalendar")
    @ResponseBody
    public List<Map<String, Object>> getJournalForCalendar(@RequestParam("classNo") int classNo, HttpSession session) {
        // 세션에서 로그인한 회원 정보 가져오기
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) return new ArrayList<>(); // 로그인 정보가 없으면 빈 리스트 반환

        int memberNo = loginMember.getMemberNo();
        
        // 해당 클래스의 모든 일지 조회
        List<JournalVO> journals = journalService.journalAllList(classNo, memberNo);

        // 캘린더 이벤트 형식으로 데이터 변환
        List<Map<String, Object>> events = new ArrayList<>();
        for (JournalVO journal : journals) {
            Map<String, Object> event = new HashMap<>();
            event.put("title", journal.getJournalTitle()); // 이벤트 제목
            event.put("start", journal.getJournalWriteDate()); // 이벤트 시작 날짜
            event.put("url", "/journal/journalDetail?journalNo=" + journal.getJournalNo() + "&classNo=" + classNo); // 이벤트 URL
            events.add(event);
        }
        return events; // 캘린더 이벤트 리스트 반환
    }

    // 교육일지 상세 정보 조회
    @GetMapping("journalDetail")
    public void journalDetailGET(@RequestParam("journalNo") int journalNo, Model model) throws Exception {
        logger.info("교육일지 상세 페이지 접속 / 일지 글번호 ---> " + journalNo);
        
        // 일지 상세 정보 조회 및 모델에 추가
        model.addAttribute("journalDetail", journalService.journalDetail(journalNo));
    }
    
    // 일지 등록 페이지 이동
    @GetMapping("journalEnroll")
    public String journalEnrollGET(Model model, HttpSession session) throws Exception {
        logger.info("일지 등록 폼 페이지 접속");
        
        // 세션에서 로그인한 회원 정보 가져오기
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) {
            return "redirect:/login"; // 로그인 정보가 없으면 로그인 페이지로 리다이렉트
        }
        
        // 로그인한 회원의 수강 중인 클래스 목록 조회
        List<EnrollVO> classList = enrollService.selectEnrollList(loginMember.getMemberNo());
        model.addAttribute("classList", classList); // 모델에 클래스 목록 추가
        
        return "journal/journalEnroll"; // 일지 등록 페이지로 이동
    }

    // 일지 등록 처리
    @PostMapping("/journalEnroll")
    public String addJournal(JournalVO journal, @RequestParam("file") MultipartFile file,
                             @RequestParam("classNo") int classNo, HttpSession session, RedirectAttributes rttr) throws Exception {
        logger.info("교육일지 등록");

        // 세션에서 로그인한 회원 정보 가져오기
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) {
            return "redirect:/member/login"; // 로그인 정보가 없으면 로그인 페이지로 리다이렉트
        }

        // 일지 정보 설정
        journal.setMemberNo(loginMember.getMemberNo());
        journal.setClassNo(classNo);

        // 파일 업로드 처리
        if (!file.isEmpty()) {
            String fileName = StringUtils.cleanPath(file.getOriginalFilename());
            Path uploadPath = Paths.get(fileUploadPath);
            Files.createDirectories(uploadPath); // 업로드 경로 디렉토리 생성
            Path filePath = uploadPath.resolve(fileName);
            Files.copy(file.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING); // 파일 저장
            journal.setFileName(fileName); // 파일 이름 설정
        }

        // 일지 등록 서비스 호출
        journalService.journalEnroll(journal, file);
        
        // 등록 성공 메시지 설정
        rttr.addFlashAttribute("message", "교육일지가 등록되었습니다.");
        
        // 일지 목록 페이지로 리다이렉트
        return "redirect:/journal/journalList";
    }

    // 첨부파일 다운로드
    @GetMapping("/downloadFile")
    public ResponseEntity<InputStreamResource> downloadFile(@RequestParam("fileName") String fileName) throws IOException {
        // 파일 이름 정리
        String cleanedFileName = StringUtils.cleanPath(fileName);
        File file = new File(fileUploadPath, cleanedFileName);

        // 파일이 존재하지 않으면 404 에러 반환
        if (!file.exists()) {
            return ResponseEntity.notFound().build();
        }

        // 파일 스트림 생성 및 ResponseEntity 반환
        InputStreamResource resource = new InputStreamResource(new FileInputStream(file));
        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=" + URLEncoder.encode(cleanedFileName, "UTF-8"))
                .body(resource);
    }

    // 교육일지 수정 페이지 이동
    @GetMapping("journalModify")
    public String journalModifylGET(@RequestParam("journalNo") int journalNo, Model model) throws Exception {
        logger.info("교육일지 수정 페이지 접속 / 일지 글번호 ---> " + journalNo);
        
        // 수정할 일지 정보 조회 및 모델에 추가
        model.addAttribute("journal", journalService.journalDetail(journalNo));
        return "journal/journalModify"; // 일지 수정 페이지로 이동
    }

    // 교육일지 수정 처리
    @PostMapping("journalModify.do")
    public String journalModifyPOST(JournalVO journal,
                                    @RequestParam(value = "file", required = false) MultipartFile file,
                                    HttpSession session) throws Exception {
        logger.info("교육일지 수정 요청 / 일지 글번호 ---> " + journal.getJournalNo());

        // 새로운 파일이 업로드된 경우 처리
        if (file != null && !file.isEmpty()) {
            String fileName = StringUtils.cleanPath(file.getOriginalFilename());
            Path uploadPath = Paths.get(fileUploadPath);
            Files.createDirectories(uploadPath); // 업로드 경로 디렉토리 생성
            Path filePath = uploadPath.resolve(fileName);
            Files.copy(file.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING); // 파일 저장
            journal.setFileName(fileName); // 파일 이름 설정
        }

        // 일지 수정 서비스 호출
        journalService.journalModify(journal);
        return "redirect:/journal/journalList"; // 수정 후 일지 목록 페이지로 리다이렉트
    }

    // 교육일지 삭제 처리
    @PostMapping("journalDelete")
    public String journalDelete(@RequestParam("journalNo") int journalNo) throws Exception {
        logger.info("교육일지 삭제 요청 / 일지 글번호 ---> " + journalNo);

        // 삭제할 일지 정보 조회
        JournalVO journal = journalService.journalDetail(journalNo);
        
        // 첨부 파일이 있는 경우 파일 삭제
        if (journal != null && journal.getFileName() != null) {
            Path filePath = Paths.get(fileUploadPath).resolve(journal.getFileName());
            Files.deleteIfExists(filePath); // 파일 삭제
        }

        // 일지 삭제 서비스 호출
        journalService.journalDelete(journalNo);
        return "redirect:/journal/journalList"; // 삭제 후 일지 목록 페이지로 리다이렉트
    }
}