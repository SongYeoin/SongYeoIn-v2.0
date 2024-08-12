package com.syi.project.controller.attendance;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.syi.project.model.period.PeriodVO;
import com.syi.project.model.schedule.ScheduleVO;
import com.syi.project.model.syclass.SyclassVO;
import com.syi.project.service.attendance.AttendanceService;
import com.syi.project.service.schedule.ScheduleService;
import com.syi.project.service.syclass.SyclassService;

import lombok.extern.log4j.Log4j2;

@Controller
@RequestMapping("/member")
@Log4j2
public class AttendanceController {

	@Autowired
	AttendanceService attendanceService;
	
	@Autowired
	SyclassService syclassService;
	
	@Autowired
	ScheduleService scheduleService;
	
	/* 출석 등록 페이지로 이동 */
	@GetMapping("/attendance/enroll")
	public void attendanceEnrollGET(Integer classNo, String dayOfWeek, Model model) throws Exception{
		log.info("출석 등록 페이지 이동");
		
		// 선택 할 반 정보 보내기
		List<SyclassVO> classList = syclassService.getClassList();
		model.addAttribute("classList", classList);
		
		// 해당반의 시간표 정보 보내기
		try {
			ScheduleVO schedule = scheduleService.getSchedule(classNo);
			System.out.println("서버로 도착한 dayOfweek : " + dayOfWeek);
			// 교시 정보 조회
			List<PeriodVO> periodList = scheduleService.getPeriodsWithDayOfWeek(schedule.getScheduleNo(), dayOfWeek);
			schedule.setPeriods(periodList);
			
			// 조회한 결과 프론트로 보내기
			model.addAttribute("schedule", schedule);
			
		} catch (NullPointerException e) {
			log.error("등록된 시간표가 없습니다.", e);
	        model.addAttribute("result", "null");
	        
		} catch (Exception e) {
			log.error("시간표 조회 중 오류 발생", e);
	        model.addAttribute("result", "error");
		}
	}
	
	
}
