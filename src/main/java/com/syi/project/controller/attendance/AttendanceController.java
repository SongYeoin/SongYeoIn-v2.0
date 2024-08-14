package com.syi.project.controller.attendance;

import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import java.net.URLEncoder;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.net.util.SubnetUtils;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.syi.project.model.attendance.AttendanceVO;
import com.syi.project.model.member.MemberVO;
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
	public void attendanceEnrollGET(HttpServletRequest request, Integer classNo, String dayOfWeek, Model model) throws Exception{
		
		// 수강생 정보 조회
		HttpSession session = request.getSession();
		MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
		
		// 선택 할 반 정보 보내기
		List<SyclassVO> classList = syclassService.getClassList();
		model.addAttribute("classList", classList);
		
		// 해당반의 시간표 정보 보내기
		try {
			ScheduleVO schedule = scheduleService.getSchedule(classNo);
			
			// 교시 정보 조회
			List<PeriodVO> periodList = scheduleService.getPeriodsWithDayOfWeek(schedule.getScheduleNo(), dayOfWeek);
			schedule.setPeriods(periodList);
			
			Map<Integer, Boolean> attendanceStatus = new HashMap<>();
			Map<Integer, String> periodAttendanceStatus = new HashMap<>();
			
			// 출석 가능 상태인지 확인하기
			for(PeriodVO period : periodList) {
				
				// 해당 교시의 출석 상태 조회
				AttendanceVO attendance = attendanceService.getAttendanceByPeriodAndMember(period.getPeriodNo(), loginMember.getMemberNo());
				if(attendance != null) {
					periodAttendanceStatus.put(period.getPeriodNo(), attendance.getAttendanceStatus());
				} else {
					periodAttendanceStatus.put(period.getPeriodNo(), "미출석");
				}
				
				// 몇교시가 출석 가능한 상태인지 맵에 담기 (교시번호, 출석가능상태)
				boolean isAttendanceEnabled = checkIfWithinTimeWindow(period).equals("출석") || checkIfWithinTimeWindow(period).equals("지각");
				System.out.println(period.getPeriodName() + "의 출석 가능 상태는? " + isAttendanceEnabled);
				attendanceStatus.put(period.getPeriodNo(), isAttendanceEnabled);
			}
			
			// 조회한 결과 프론트로 보내기
			model.addAttribute("schedule", schedule);
			model.addAttribute("attendanceStatus", attendanceStatus);
			model.addAttribute("periodAttendanceStatus", periodAttendanceStatus);
			
		} catch (NullPointerException e) {
			log.error("등록된 시간표가 없습니다.", e);
	        model.addAttribute("result", "null");
	        
		} catch (Exception e) {
			log.error("시간표 조회 중 오류 발생", e);
	        model.addAttribute("result", "error");
		}
	}
	
	/* 출석 등록 */
	@PostMapping("/attendance/enroll")
	public String enrollAttendancePOST(HttpServletRequest request, Integer periodNo, Integer classNo, String dayOfWeek, Model model) {
		System.out.println("컨트롤러 도착 : " +dayOfWeek);
		// 수강생 정보 조회
		HttpSession session = request.getSession();
		MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
		
		// 사용자의 IP 주소 확인
	    String userIp = getClientIp(request);
	    System.out.println("User IP: " + userIp);
		
		// periodNo 으로 periodVO 조회
		PeriodVO period = scheduleService.getPeriod(periodNo);
		
		// 해당 교시가 현재 출석 가능 시간인지 확인
		String status = checkIfWithinTimeWindow(period);
		
		// AttendanceVO 객체 생성 및 데이터 설정
		AttendanceVO attendance = new AttendanceVO();
		attendance.setAttendanceStatus(status);
		attendance.setPeriodNo(periodNo);
		attendance.setMemberNo(loginMember.getMemberNo());
		attendance.setClassNo(classNo);
		attendance.setAttendanceDate(java.sql.Date.valueOf(java.time.LocalDate.now()));
		
		System.out.println("출석 등록 전 모든 값 체크 : "+ attendance);
		
//		// 네트워크 범위에 있는지 확인
//		if(!isWithinNetwork(userIp)) {
//			System.out.println("User IP is not within the allowed network range: " + userIp);
//			model.addAttribute("resultMessage", "학원 네트워크에서만 출석이 가능합니다.");
//			return "redirect:/member/attendance/enroll?classNo=" + classNo;
//		}
		
		// db에 출석 정보 저장
		try {
			attendanceService.enrollAttendance(attendance);
			
			String encodedDayOfWeek = URLEncoder.encode(dayOfWeek, "UTF-8");
			return "redirect:/member/attendance/enroll?classNo=" + classNo + "&dayOfWeek=" + encodedDayOfWeek + "&resultMessage=" + URLEncoder.encode(period.getPeriodName() + " 교시가 " + status + " 처리되었습니다.", "UTF-8");
			
		} catch (DataIntegrityViolationException e) {
			log.error("출석 상태 저장 중 제약 조건 위반", e);
	        model.addAttribute("result", "checkError");
	        
		} catch (Exception e) {
			log.error("출석 등록 중 오류 발생", e);
	        model.addAttribute("result", "error");
		}
		
		return "redirect:/member/attendance/enroll?classNo=" + classNo;
		
	}
	
	/* 출석 가능 시간 확인 */
	private String checkIfWithinTimeWindow(PeriodVO period) {
		
		// 현재 시간
        LocalTime now = LocalTime.now();
        
        // 교시 시작 시간
        LocalTime periodStartTime = LocalTime.parse(period.getStartTime(), DateTimeFormatter.ofPattern("HH:mm"));
        
        // 교시 종료 시간
        LocalTime periodEndTime = LocalTime.parse(period.getEndTime(), DateTimeFormatter.ofPattern("HH:mm"));
        
        
        LocalTime start = periodStartTime.minusMinutes(5);
        LocalTime end = periodStartTime.plusMinutes(10);
        
        // 교시 시작 5분 전 ~ 교시 시작 10분 후 => 출석 가능
        if(now.isAfter(start) && now.isBefore(end)) {
        		return "출석";
        		
        	// 교시 시작 10분 후 ~ 종료 전 => 지각	
        } else if(now.isAfter(end) && now.isBefore(periodEndTime)) {
        		return "지각";
        		
        	// 교시 종료 후 => 결석
        } else return "결석";
        
    }
	
	/* 유저의 ip 주소 조회 */
	public String getClientIp(HttpServletRequest request) {
		
		String ip = request.getHeader("X-Forwarded-For");
		
	    if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
	        ip = request.getHeader("Proxy-Client-IP");
	    }
	    if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
	        ip = request.getHeader("WL-Proxy-Client-IP");
	    }
	    if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
	        ip = request.getHeader("HTTP_CLIENT_IP");
	    }
	    if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
	        ip = request.getHeader("HTTP_X_FORWARDED_FOR");
	    }
	    if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
	        ip = request.getRemoteAddr();
	    }
	    
	    // IPv6 루프백 주소 처리
	    if ("0:0:0:0:0:0:0:1".equals(ip) || "::1".equals(ip)) {
	        ip = "127.0.0.1";
	    }
	    
	    return ip;
	}
	
	/* 센터 네트워크를 사용하는 pc 인지 확인 */
	public static boolean isWithinNetwork(String targetIp) {
		SubnetUtils utils = new SubnetUtils("192.168.0.0/24");
	    utils.setInclusiveHostCount(true);
	    return utils.getInfo().isInRange(targetIp);

	}
	
	
}
