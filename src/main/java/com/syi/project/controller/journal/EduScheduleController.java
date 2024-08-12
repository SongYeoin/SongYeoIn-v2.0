package com.syi.project.controller.journal;

import java.util.List;

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

@Controller
@RequestMapping({"journal", "journal/admin"}) // URL 패턴
public class EduScheduleController {
	
	@Autowired
	private EduScheduleService eduScheduleService;
	
	// 새로운 일정 등록 페이지
	@GetMapping("scheduleCreate")
	public String showCreateScheduleForm() {
		return "journal/scheduleCreate"; // 새로운 일정 생성 폼을 포함하는 JSP 페이지 경로
	}
	
	// 새로운 일정 등록 요청 처리
	@PostMapping("scheduleCreate")
	public String scheduleCreate(EduScheduleVO schedule) {
		eduScheduleService.scheduleCreate(schedule); // 일정 생성
		return "redirect:/journal/scheduleList"; // 일정 목록 페이지로 리다이렉트
	}
	
	// 모든 일정 목록 조회
    @GetMapping("scheduleList")
    public void scheduleList(Criteria cri, Model model) {
        List<EduScheduleVO> schedules = eduScheduleService.scheduleList(cri); // 일정 리스트 조회
        
        if (!schedules.isEmpty()) {
			model.addAttribute("schedules", schedules);
		} else {
			model.addAttribute("listCheck", "empty");
		}
        
        model.addAttribute("pageMaker", new PageDTO(cri, eduScheduleService.scheduleGetTotal(cri)));
    }

    // 일정 상세 조회
    @GetMapping("scheduleDetail")
    public void scheduleDetail(@RequestParam("scheduleNo") int scheduleNo, Model model) {
        EduScheduleVO schedule = eduScheduleService.scheduleDetail(scheduleNo); // 특정 일정 조회
        model.addAttribute("scheduleDetail", schedule);
    }

    // 일정 수정 페이지
    @GetMapping("scheduleUpdate")
    public String scheduleUpdate(@RequestParam("scheduleNo") int scheduleNo, Model model) {
        EduScheduleVO schedule = eduScheduleService.scheduleDetail(scheduleNo); // 특정 일정 조회
        model.addAttribute("schedule", schedule);
        return "journal/scheduleUpdate"; // 일정 수정 폼을 포함하는 JSP 페이지 경로
    }

    // 일정 수정 처리
    @PostMapping("scheduleUpdate")
    public String scheduleUpdate(EduScheduleVO schedule) {
        eduScheduleService.scheduleUpdate(schedule); // 일정 업데이트
        return "redirect:/journal/scheduleList"; // 일정 목록 페이지로 리다이렉트
    }

    // 일정 삭제
    @PostMapping("scheduleDelete")
    public String scheduleDelete(@RequestParam("scheduleNo") int scheduleNo) {
        eduScheduleService.scheduleDelete(scheduleNo); // 일정 삭제
        return "redirect:/journal/scheduleList"; // 일정 목록 페이지로 리다이렉트
    }
}
