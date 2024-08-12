package com.syi.project.controller.schedule;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.syi.project.model.period.PeriodVO;
import com.syi.project.model.schedule.ScheduleVO;
import com.syi.project.model.syclass.SyclassVO;
import com.syi.project.service.schedule.ScheduleService;

import lombok.extern.log4j.Log4j2;

@Controller
@RequestMapping("/admin")
@Log4j2
public class ScheduleController {

	@Autowired
	ScheduleService scheduleService;
	
	/* 시간표 등록 페이지 이동 */
	@GetMapping("/class/enrollSchedule")
	public void scheduleEnrollGET() throws Exception{
		log.info("시간표 등록 페이지 이동");
	}
	
	/* 시간표 조회 페이지 이동 */
	@GetMapping("/class/getSchedule")
	public void getScheduleGET(HttpServletRequest request, Model model) throws Exception{
		log.info("시간표 조회 페이지 이동");
		
		HttpSession session = request.getSession();
		SyclassVO syclass = (SyclassVO) session.getAttribute("syclass");
		int classNo = syclass.getClassNo();
		System.out.println(classNo);
		
		// classNo 으로 시간표 조회
		ScheduleVO schedule = scheduleService.getSchedule(classNo);
		
		// 교시 정보 조회
		List<PeriodVO> periodList = scheduleService.getPeriods(schedule.getScheduleNo());
		schedule.setPeriods(periodList);
		
		// 조회한 정보 프론트로 보내기
		model.addAttribute("schedule", schedule);
	}
	
	/* 시간표 등록 */
	@PostMapping("/class/enrollSchedule")
	public void enrollSchedulePOST(ScheduleVO schedule) throws Exception{
		log.info("시간표 등록 기능 시작");

		System.out.println("Received Schedule: " + schedule);
		System.out.println("Received Periods: " + schedule.getPeriods());
		
		scheduleService.enrollSchedule(schedule);
		
	}
}
