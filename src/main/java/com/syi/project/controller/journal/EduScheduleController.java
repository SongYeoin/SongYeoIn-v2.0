package com.syi.project.controller.journal;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.syi.project.model.Criteria;
import com.syi.project.model.PageDTO;
import com.syi.project.model.journal.EduScheduleVO;
import com.syi.project.service.journal.EduScheduleService;
import com.syi.project.service.journal.EduScheduleServiceImpl;

@Controller
@RequestMapping("/journal") // URL 패턴
public class EduScheduleController {
	
	// 로그를 기록하기 위한 SLF4J Logger 객체
	private static final Logger logger = LoggerFactory.getLogger(EduScheduleServiceImpl.class);
	
	@Autowired
	private EduScheduleService eduScheduleService;
	
	// 새로운 일정 등록 페이지
	@GetMapping("admin/scheduleCreate")
	public String showCreateScheduleForm() {
		logger.info("새로운 일정 등록 페이지 요청됨");

		return "journal/scheduleCreate"; // 새로운 일정 생성 폼을 포함하는 JSP 페이지 경로
	}
	
	// 새로운 일정 등록 요청 처리
	@PostMapping("scheduleCreate")
	public String scheduleCreate(EduScheduleVO schedule) {
		logger.info("일정 등록 요청: {}", schedule);
		
		eduScheduleService.scheduleCreate(schedule); // 일정 생성
		
		logger.info("일정 등록 완료");
		
		return "redirect:/journal/scheduleList"; // 일정 목록 페이지로 리다이렉트
	}
	
	// 모든 일정 목록 조회
	@GetMapping("scheduleList")
    public void scheduleList(Criteria cri, Model model) {
    	logger.info("일정 목록 조회 요청: {}", cri);
    	
        List<EduScheduleVO> schedules = eduScheduleService.scheduleList(cri); // 페이징된 일정 리스트 조회
        
        if (!schedules.isEmpty()) {
			model.addAttribute("schedules", schedules);
		} else {
			model.addAttribute("listCheck", "empty");
		}
        
        model.addAttribute("pageMaker", new PageDTO(cri, eduScheduleService.scheduleGetTotal(cri)));
        
        List<EduScheduleVO> scheduleAllList = eduScheduleService.scheduleAllList(); // 모둔 일정 리스트 조회
        logger.info("---------> scheduleAllList : " + scheduleAllList);
        model.addAttribute("scheduleAllList", scheduleAllList);
        
    }

    // 일정 상세 조회
    @GetMapping("scheduleDetail")
    public void scheduleDetail(@RequestParam("scheduleNo") int scheduleNo, Model model) {
    	logger.info("일정 상세 조회 요청: 일정 번호={}", scheduleNo);
    	
        EduScheduleVO schedule = eduScheduleService.scheduleDetail(scheduleNo); // 특정 일정 조회
        model.addAttribute("scheduleDetail", schedule);
    }

    // 일정 수정 페이지
    @GetMapping("admin/scheduleUpdate")
    public String scheduleUpdate(@RequestParam("scheduleNo") int scheduleNo, Model model) {
        logger.info("일정 수정 페이지 요청: 일정 번호={}", scheduleNo);

        EduScheduleVO schedule = eduScheduleService.scheduleDetail(scheduleNo); // 특정 일정 조회
        model.addAttribute("schedule", schedule);
        return "journal/scheduleUpdate"; // 일정 수정 폼을 포함하는 JSP 페이지 경로
    }

    // 일정 수정 처리
    @PostMapping("scheduleUpdate")
    public String scheduleUpdate(EduScheduleVO schedule) {
        logger.info("일정 수정 요청: {}", schedule);

        eduScheduleService.scheduleUpdate(schedule); // 일정 업데이트
        return "redirect:/journal/scheduleList"; // 일정 목록 페이지로 리다이렉트
    }

    // 일정 삭제
    @PostMapping("admin/scheduleDelete")
    public String scheduleDelete(@RequestParam("scheduleNo") int scheduleNo) {
        logger.info("일정 삭제 요청: 일정 번호={}", scheduleNo);

        eduScheduleService.scheduleDelete(scheduleNo); // 일정 삭제
        return "redirect:/journal/scheduleList"; // 일정 목록 페이지로 리다이렉트
    }
    
}