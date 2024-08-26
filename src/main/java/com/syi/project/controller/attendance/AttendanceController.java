package com.syi.project.controller.attendance;

import java.time.LocalDate;
import java.time.LocalTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.time.format.TextStyle;
import java.time.temporal.ChronoField;
import java.time.temporal.ChronoUnit;
import java.sql.Date;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;
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
	public void attendanceEnrollGET(HttpServletRequest request, Integer classNo, String dayOfWeek, String attendanceDate, Model model) throws Exception{
		
		// 현재 날짜를 기본값으로 설정 (프론트엔드에서 보내지 않았을 경우)
	    if (attendanceDate == null || attendanceDate.isEmpty()) {
	        attendanceDate = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
	    }
		
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
			
			// 출석 가능한 교시 정보 담기
			Map<Integer, Boolean> attendanceStatus = new HashMap<>();
			// 교시 별 출석 상태 담기
			Map<Integer, String> periodAttendanceStatus = new HashMap<>();
			
			// 출석 가능 상태인지 확인하기
			for(PeriodVO period : periodList) {
				
				// 해당 교시의 출석 상태 조회
				AttendanceVO attendance = attendanceService.getAttendanceByPeriodAndMember(period.getPeriodNo(), loginMember.getMemberNo(), Date.valueOf(attendanceDate));
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
	
	/* 출석 전체 조회 페이지로 이동_수강생 */
	@GetMapping("/attendance/attendanceList")
	public void attendanceListGET(HttpServletRequest request, Integer classNo, Model model) {
		
		// 선택 할 반 정보 보내기
		List<SyclassVO> classList = syclassService.getClassList();
		model.addAttribute("classList", classList);
		
		// 만약 classNo가 null이라면, 기본적으로 첫 번째 반을 선택한 것으로 간주
	    if (classNo == null && !classList.isEmpty()) {
	        classNo = classList.get(0).getClassNo();
	    }
		
		// 선택된 반 정보 가져오기
		SyclassVO syclass = syclassService.getClassDetail(classNo);
		
		/* 해당 과목이 몇주차 과정인지 계산 */
		// 1. 날짜를 LocalDate로 변환
        LocalDate startDate = syclass.getStartDate().toInstant().atZone(ZoneId.systemDefault()).toLocalDate();
        LocalDate endDate = syclass.getEndDate().toInstant().atZone(ZoneId.systemDefault()).toLocalDate();
		
        // 2. 시작일과 종강일 사이의 주차 계산
        long weeksBetween = ChronoUnit.WEEKS.between(startDate, endDate) + 1; // 1주차도 포함
        model.addAttribute("weeksBetween", weeksBetween); 
        
		// 해당 과목의 시간표 조회하여 요일 정보 추출
        ScheduleVO schedule = scheduleService.getSchedule(classNo);
        int scheduleNo = schedule.getScheduleNo();
        
        List<PeriodVO> periods = scheduleService.getPeriods(scheduleNo);
        
        // dayOfWeek 중복 제거하여 Set으로 변환
        Set<String> uniqueDaysOfWeek = periods.stream()
        								.flatMap(period -> Arrays.stream(period.getDayOfWeek().split(",")))
        								.collect(Collectors.toSet());
        // 중복되지 않은 요일 정보를 List로 변환
        List<String> dayOfWeekList = new ArrayList<>(uniqueDaysOfWeek); 
        
        // 요일 순서대로 정렬
        List<String> orderedDaysOfWeek = Arrays.asList("월", "화", "수", "목", "금", "토", "일");
        dayOfWeekList.sort(Comparator.comparingInt(orderedDaysOfWeek::indexOf));
        model.addAttribute("dayOfWeekList", dayOfWeekList); 
        
        // 수강생 정보 조회
 		HttpSession session = request.getSession();
 		MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
 		
 		// 해당반 + 해당 학생의 출석 정보 조회
        List<AttendanceVO> attendanceList = attendanceService.getAttendanceByClassAndMember(classNo, loginMember.getMemberNo());
		Map<String, List<String>> attendanceMap = new HashMap<>();
		
		for (AttendanceVO attendance : attendanceList) {
			LocalDate attendanceDate = attendance.getAttendanceDate().toInstant().atZone(ZoneId.systemDefault()).toLocalDate();
			long weekNumber = ChronoUnit.WEEKS.between(startDate, attendanceDate) + 1;
			String dayOfWeek = attendanceDate.getDayOfWeek().getDisplayName(TextStyle.SHORT, Locale.KOREAN);
			String key = "week-" + weekNumber + "-" + dayOfWeek;
			
			// 키가 존재하지 않으면 람다식 실행
		    attendanceMap.computeIfAbsent(key, k -> new ArrayList<String>());
		    
		    // 출석 상태를 리스트에 추가
		    attendanceMap.get(key).add(attendance.getAttendanceStatus());
		}
		
		Map<String, String> finalAttendanceMap = new HashMap<>();
		
		// 각 요일별로 최종 출석 상태 계산
		for (Map.Entry<String, List<String>> entry : attendanceMap.entrySet()) {
		    String key = entry.getKey();
		    List<String> statuses = entry.getValue();

		    // 초기값 설정
		    boolean hasLateness = false;
		    boolean allAbsent = true;
		    boolean allPresent = true;
		    boolean hasEarlyLeave = false;

		    for (int i = 0; i < statuses.size(); i++) {
		        String status = statuses.get(i);
		        if (status.equals("지각")) {
		            hasLateness = true;
		        }
		        if (!status.equals("결석")) {
		            allAbsent = false;
		        }
		        if (!status.equals("출석")) {
		            allPresent = false;
		        }
		        // 앞 교시가 결석이고, 뒷 교시가 출석일 경우 지각으로 처리
		        if (i > 0 && statuses.get(i - 1).equals("결석") && status.equals("출석")) {
		            hasLateness = true;
		        }
		        // 앞 교시가 출석이고, 뒷 교시가 결석일 경우 조퇴로 처리
		        if (i > 0 && statuses.get(i - 1).equals("출석") && status.equals("결석")) {
		            hasEarlyLeave = true;
		        }
		    }

		    String finalStatus;
		    if (hasLateness) {
		        finalStatus = "지각";
		    } else if (allAbsent) {
		        finalStatus = "결석";
		    } else if (allPresent) {
		        finalStatus = "출석";
		    } else if (hasEarlyLeave) {
		        finalStatus = "조퇴";
		    } else {
		        finalStatus = "출석";
		    }

		    // 최종 출석 상태 저장
		    finalAttendanceMap.put(key, finalStatus);
		}

		System.out.println(finalAttendanceMap);
		model.addAttribute("finalAttendanceMap", finalAttendanceMap);
		
		// 컨트롤러에서 각 주차와 요일에 해당하는 실제 날짜 계산
		Map<String, LocalDate> dateMap = new HashMap<>();

		for (long week = 1; week <= weeksBetween; week++) {
		    for (String dayOfWeek : dayOfWeekList) {
		        LocalDate date = startDate.plusWeeks(week - 1).with(ChronoField.DAY_OF_WEEK, orderedDaysOfWeek.indexOf(dayOfWeek) + 1);
		        String key = "week-" + week + "-" + dayOfWeek;
		        dateMap.put(key, date);
		    }
		}

		model.addAttribute("dateMap", dateMap);

	}
	
	/* 출석 등록 */
	@PostMapping("/attendance/enroll")
	public String enrollAttendancePOST(HttpServletRequest request, Integer periodNo, Integer classNo, String dayOfWeek, Model model) {
		System.out.println("컨트롤러 도착 : " +dayOfWeek);
		// 수강생 정보 조회
		HttpSession session = request.getSession();
		MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
		
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
		
		// 사용자의 IP 주소 확인
		String userIp = getClientIp(request);
		System.out.println("User IP: " + userIp);

		if (!isWithinNetwork(userIp)) {
		    System.out.println("User IP is not within the allowed network range: " + userIp);
		    model.addAttribute("resultMessage", "학원 네트워크에서만 출석이 가능합니다.");
		    return "redirect:/member/attendance/enroll?classNo=" + classNo;
		}
		
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
	    if (ip != null && ip.length() != 0 && !"unknown".equalsIgnoreCase(ip)) {
	        return ip.split(",")[0].trim();
	    }

	    ip = request.getHeader("Proxy-Client-IP");
	    if (ip != null && ip.length() != 0 && !"unknown".equalsIgnoreCase(ip)) {
	        return ip;
	    }

	    ip = request.getHeader("WL-Proxy-Client-IP");
	    if (ip != null && ip.length() != 0 && !"unknown".equalsIgnoreCase(ip)) {
	        return ip;
	    }

	    ip = request.getHeader("HTTP_CLIENT_IP");
	    if (ip != null && ip.length() != 0 && !"unknown".equalsIgnoreCase(ip)) {
	        return ip;
	    }

	    ip = request.getHeader("HTTP_X_FORWARDED_FOR");
	    if (ip != null && ip.length() != 0 && !"unknown".equalsIgnoreCase(ip)) {
	        return ip;
	    }

	    ip = request.getRemoteAddr();
	    
	    // 로그로 IP 주소 확인
	    System.out.println("Detected IP Address: " + ip);

	    // IPv6 로컬 주소(::1)를 IPv4로 변환
	    if ("0:0:0:0:0:0:0:1".equals(ip) || "::1".equals(ip)) {
	        ip = "127.0.0.1";
	    }

	    return ip;
	}
	
	/* 센터 네트워크를 사용하는 pc 인지 확인 */
	public static boolean isWithinNetwork(String targetIp) {
		
		// 학원 와이파이 네트워크 범위를 설정
	    // 192.168.1.0/24 네트워크 범위를 사용하는 경우
	    String[] allowedNetworks = {
	        "127.0.0.1/32", // 로컬, 추가 네트워크 범위가 있을 경우 추가 가능
	    		"192.168.0.0/24" // 학원 와이파이
	    };
	    
	    for (String network : allowedNetworks) {
	        SubnetUtils utils = new SubnetUtils(network);
	        utils.setInclusiveHostCount(true);
	        
	        if (utils.getInfo().isInRange(targetIp)) {
	            return true; // IP가 지정된 네트워크 범위 내에 있으면 true 반환
	        }
	    }
	    // 만약 클라이언트 IP가 어느 네트워크 범위에도 포함되지 않으면 false 반환
	    return false;

	}
	
	
}
