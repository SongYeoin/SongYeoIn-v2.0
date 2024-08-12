package com.syi.project.controller.attendance;

import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
			
			// 교시 정보 조회
			List<PeriodVO> periodList = scheduleService.getPeriodsWithDayOfWeek(schedule.getScheduleNo(), dayOfWeek);
			schedule.setPeriods(periodList);
			
			// 현재 시간 가져오기
			LocalTime now = LocalTime.now();
			
			Map<Integer, Boolean> attendanceStatus = new HashMap<>();
			
			// 출석 가능 상태인지 확인하기
			for(PeriodVO period : periodList) {
				LocalTime periodStartTime = LocalTime.parse(period.getStartTime(), DateTimeFormatter.ofPattern("HH:mm"));
				
				// 교시 시작 5분전 ~ 교시 시작 10분 후 => 출석 가능
				LocalTime start = periodStartTime.minusMinutes(5);
				LocalTime end = periodStartTime.plusMinutes(10);
				
				System.out.println("출석 가능 시간 : " + start + "~" + end);
				
				// 몇교시가 출석 가능한 상태인지 맵에 담기 (교시번호, 출석가능상태)
				boolean isAttendanceEnabled = now.isAfter(start) && now.isBefore(end);
				System.out.println(period.getPeriodName() + "의 출석 가능 상태는? " + isAttendanceEnabled);
				attendanceStatus.put(period.getPeriodNo(), isAttendanceEnabled);
			}
			
			// 조회한 결과 프론트로 보내기
			model.addAttribute("schedule", schedule);
			model.addAttribute("attendanceStatus", attendanceStatus);
			
		} catch (NullPointerException e) {
			log.error("등록된 시간표가 없습니다.", e);
	        model.addAttribute("result", "null");
	        
		} catch (Exception e) {
			log.error("시간표 조회 중 오류 발생", e);
	        model.addAttribute("result", "error");
		}
	}
	
	
}
