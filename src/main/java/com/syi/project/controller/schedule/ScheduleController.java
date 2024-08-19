package com.syi.project.controller.schedule;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

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
	public String scheduleEnrollGET(HttpServletRequest request, Model model, RedirectAttributes redirectAttributes) throws Exception{
		log.info("시간표 등록 페이지 이동");
		
		// 세션에서 반 정보 얻기
		HttpSession session = request.getSession();
		SyclassVO syclass = (SyclassVO) session.getAttribute("syclass");
		int classNo = syclass.getClassNo();
		
		// 등록된 시간표 유무 확인
		ScheduleVO schedule = scheduleService.getSchedule(classNo);
		
		// 모든 요일 배열 준비
	    List<String> allDays = Arrays.asList("월", "화", "수", "목", "금", "토", "일");
	    
	    // 남은 요일 목록 초기화
	    List<String> availableDays = new ArrayList<>(allDays); 
		
		// 등록된 시간표가 있다면
		if(schedule != null) {
			// 교시 정보에서 등록된 요일 확인
			List<PeriodVO> periodList = scheduleService.getPeriods(schedule.getScheduleNo());
			
			for(PeriodVO period : periodList) {
				String[] days = period.getDayOfWeek().split(",");
				
				for(String day : days) {
					availableDays.remove(day); // 이미 등록된 요일 제거
				}
			}
		}
		
		if(availableDays.isEmpty()) {
			redirectAttributes.addFlashAttribute("message", "추가 등록 가능한 요일이 없습니다.");
			return "redirect:/admin/class/getSchedule";
			
		} else {
			// 남은 요일 프론트에 보내기
		    model.addAttribute("availableDays", availableDays);
		}
		return "admin/class/enrollSchedule";
	}
	
	/* 시간표 조회 페이지 이동 */
	@GetMapping("/class/getSchedule")
	public void getScheduleGET(HttpServletRequest request, Model model) throws Exception{
		log.info("시간표 조회 페이지 이동");
		
		// 세션에서 반 정보 얻기
		HttpSession session = request.getSession();
		SyclassVO syclass = (SyclassVO) session.getAttribute("syclass");
		int classNo = syclass.getClassNo();
		
		// classNo 으로 시간표 조회
		try {
			ScheduleVO schedule = scheduleService.getSchedule(classNo);
			
			// 교시 정보 조회
			List<PeriodVO> periodList = scheduleService.getPeriods(schedule.getScheduleNo());
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
	
	/* 시간표 등록 */
	@PostMapping("/class/enrollSchedule")
	public void enrollSchedulePOST(HttpServletRequest request, ScheduleVO schedule) throws Exception{
		
		HttpSession session = request.getSession();
		int classNo = ((SyclassVO) session.getAttribute("syclass")).getClassNo();
		schedule.setClassNo(classNo);
		
		scheduleService.enrollSchedule(request, schedule);
		
	}
	
	/* 시간표 수정 */
	@PostMapping("/class/updateSchedule")
	public ResponseEntity<String> updateSchedulePOST(@RequestBody ScheduleVO schedule) throws Exception {
		try {
            scheduleService.updateSchedule(schedule);
            return new ResponseEntity<>(HttpStatus.OK);
            
        } catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
		
	}
	
	
}
