package com.syi.project.controller.journal;

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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.syi.project.model.Criteria;
import com.syi.project.model.PageDTO;
import com.syi.project.model.journal.EduScheduleVO;
import com.syi.project.model.member.MemberVO;
import com.syi.project.model.syclass.SyclassVO;
import com.syi.project.service.journal.EduScheduleService;
import com.syi.project.service.journal.EduScheduleServiceImpl;
import com.syi.project.service.syclass.SyclassService;

@Controller
@RequestMapping("/journal") // URL 패턴
public class EduScheduleController {
	
	// 로그를 기록하기 위한 SLF4J Logger 객체
	private static final Logger logger = LoggerFactory.getLogger(EduScheduleServiceImpl.class);
	
	@Autowired
	private EduScheduleService eduScheduleService;
	
	@Autowired
	private SyclassService syclassService;
	
	// 사용자의 수강 중인 반 목록 조회
    @GetMapping("/userClasses")
    @ResponseBody
    public List<SyclassVO> getUserClasses(HttpSession session) {
    	MemberVO member = (MemberVO) session.getAttribute("member");
        if (member == null) {
            logger.warn("세션에 사용자 정보가 없습니다.");
            return null;
        }
        logger.info("사용자의 수강 중인 반 목록 조회 요청: 회원 번호={}", member.getMemberNo());
        return eduScheduleService.getUserClasses(member.getMemberNo());
    }
	
    // 새로운 일정 등록 페이지
    @GetMapping("admin/scheduleCreate")
    public String showCreateScheduleForm(Model model, HttpSession session) {
        MemberVO member = (MemberVO) session.getAttribute("loginMember");
        if (member == null || !"ADMIN".equals(member.getMemberRole())) {
            logger.warn("권한이 없는 사용자의 접근 시도: {}", member);
            return "redirect:/login";
        }
        logger.info("새로운 일정 등록 페이지 요청됨");
        List<SyclassVO> allClasses = syclassService.getClassList();
        model.addAttribute("classes", allClasses);
        return "journal/scheduleCreate";
    }
    
    // 새로운 일정 등록 요청 처리
    @PostMapping("scheduleCreate")
    public String scheduleCreate(EduScheduleVO schedule, HttpSession session) {
        MemberVO member = (MemberVO) session.getAttribute("loginMember");
        if (member == null || !"ADMIN".equals(member.getMemberRole())) {
            logger.warn("권한이 없는 사용자의 일정 등록 시도: {}", member);
            return "redirect:/login";
        }
        logger.info("일정 등록 요청: {}", schedule);
        schedule.setMemberNo(member.getMemberNo());
        eduScheduleService.scheduleCreate(schedule);
        logger.info("일정 등록 완료");
        return "redirect:/journal/scheduleList?classNo=" + schedule.getClassNo();
    }
	
 // 일정 목록 조회
    @GetMapping("scheduleList")
    public String scheduleList(Criteria cri, @RequestParam(required = false) Integer classNo, Model model, HttpSession session) {
        MemberVO member = (MemberVO) session.getAttribute("loginMember");
        if (member == null) {
            logger.warn("로그인하지 않은 사용자의 일정 목록 조회 시도");
            return "redirect:/login";
        }
        
        // 사용자의 수강 중인 클래스 목록 가져오기
        List<SyclassVO> userClasses = eduScheduleService.getUserClasses(member.getMemberNo());
        model.addAttribute("classList", userClasses);
        
        // 클래스가 선택되지 않았다면 첫 번째 클래스 선택
        if (classNo == null && !userClasses.isEmpty()) {
            classNo = userClasses.get(0).getClassNo();
        }
        
        // 선택된 클래스의 일정 목록 가져오기
        List<EduScheduleVO> schedules = eduScheduleService.scheduleList(cri, classNo);
        if (!schedules.isEmpty()) {
            model.addAttribute("schedules", schedules);
        } else {
            model.addAttribute("listCheck", "empty");
        }
        
        model.addAttribute("pageMaker", new PageDTO(cri, eduScheduleService.scheduleGetTotal(cri, classNo)));
        
        // 선택된 클래스의 모든 일정 가져오기 (캘린더용)
        List<EduScheduleVO> scheduleAllList = eduScheduleService.scheduleAllList(classNo);
        model.addAttribute("scheduleAllList", scheduleAllList);
        
        model.addAttribute("selectedClassNo", classNo);
        
        return "journal/scheduleList";
    }
	
    // 캘린더용 전체 일정 조회
    @GetMapping("scheduleAllList")
    @ResponseBody
    public List<EduScheduleVO> scheduleAllList(@RequestParam(required = false) Integer classNo, HttpSession session) {
        MemberVO member = (MemberVO) session.getAttribute("member");
        if (member == null) {
            logger.warn("로그인하지 않은 사용자의 전체 일정 조회 시도");
            return null;
        }
        logger.info("캘린더용 전체 일정 조회 요청: 반 번호={}", classNo);
        return eduScheduleService.scheduleAllList(classNo);
    }

    // 일정 상세 조회
    @GetMapping("scheduleDetail")
    public String scheduleDetail(@RequestParam("scheduleNo") int scheduleNo, Model model, HttpSession session) {
        MemberVO member = (MemberVO) session.getAttribute("loginMember");
        if (member == null) {
            logger.warn("로그인하지 않은 사용자의 일정 상세 조회 시도");
            return "redirect:/login";
        }
        logger.info("일정 상세 조회 요청: 일정 번호={}", scheduleNo);
        EduScheduleVO schedule = eduScheduleService.scheduleDetail(scheduleNo);
        model.addAttribute("scheduleDetail", schedule);
        return "journal/scheduleDetail";
    }
    
    // 일정 수정 페이지
    @GetMapping("admin/scheduleUpdate")
    public String scheduleUpdate(@RequestParam("scheduleNo") int scheduleNo, Model model, HttpSession session) {
        MemberVO member = (MemberVO) session.getAttribute("member");
        if (member == null || !"ADMIN".equals(member.getMemberRole())) {
            logger.warn("권한이 없는 사용자의 일정 수정 페이지 접근 시도: {}", member);
            return "redirect:/login";
        }
        logger.info("일정 수정 페이지 요청: 일정 번호={}", scheduleNo);
        EduScheduleVO schedule = eduScheduleService.scheduleDetail(scheduleNo);
        model.addAttribute("schedule", schedule);
        List<SyclassVO> allClasses = syclassService.getClassList();
        model.addAttribute("classes", allClasses);
        return "journal/scheduleUpdate";
    }
    
    // 일정 수정 처리
    @PostMapping("scheduleUpdate")
    public String scheduleUpdate(EduScheduleVO schedule, HttpSession session) {
        MemberVO member = (MemberVO) session.getAttribute("member");
        if (member == null || !"ADMIN".equals(member.getMemberRole())) {
            logger.warn("권한이 없는 사용자의 일정 수정 시도: {}", member);
            return "redirect:/login";
        }
        logger.info("일정 수정 요청: {}", schedule);
        eduScheduleService.scheduleUpdate(schedule);
        return "redirect:/journal/scheduleList";
    }
    
    // 일정 삭제
    @PostMapping("admin/scheduleDelete")
    public String scheduleDelete(@RequestParam("scheduleNo") int scheduleNo, HttpSession session) {
        MemberVO member = (MemberVO) session.getAttribute("member");
        if (member == null || !"ADMIN".equals(member.getMemberRole())) {
            logger.warn("권한이 없는 사용자의 일정 삭제 시도: {}", member);
            return "redirect:/login";
        }
        logger.info("일정 삭제 요청: 일정 번호={}", scheduleNo);
        eduScheduleService.scheduleDelete(scheduleNo);
        return "redirect:/journal/scheduleList";
    }
    
}