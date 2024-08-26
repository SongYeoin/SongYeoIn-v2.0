package com.syi.project.controller.attendance;

import java.time.LocalDate;
import java.time.ZoneId;
import java.time.format.TextStyle;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.syi.project.model.attendance.AttendanceVO;
import com.syi.project.model.member.MemberVO;
import com.syi.project.model.period.PeriodVO;
import com.syi.project.model.schedule.ScheduleVO;
import com.syi.project.model.syclass.SyclassVO;
import com.syi.project.service.attendance.AttendanceService;
import com.syi.project.service.enroll.EnrollService;
import com.syi.project.service.schedule.ScheduleService;
import com.syi.project.service.syclass.SyclassService;

import lombok.extern.log4j.Log4j2;

@Controller
@RequestMapping("/admin")
@Log4j2
public class AdminAttendanceController {

	@Autowired
	AttendanceService attendanceService;
	
	@Autowired
	SyclassService syclassService;
	
	@Autowired
	ScheduleService scheduleService;
	
	@Autowired
	EnrollService enrollService;
	
	/* 출석 등록 페이지로 이동 */
	@GetMapping("/class/attendance/attendanceList")
	public void attendanceListGET(HttpServletRequest request, Model model) {
		
		// 반 정보 불러오기
		HttpSession session = request.getSession();
		SyclassVO syclass = (SyclassVO) session.getAttribute("syclass");
		int classNo = syclass.getClassNo();
		
		// 개강일 ~ 종강일 중 시간표 요일에 해당하는 날짜 불러오기
		Date startDate = syclass.getStartDate();
		Date endDate = syclass.getEndDate();
		
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
        
        // 개강일 ~ 종강일 중 시간표 요일에 해당하는 날짜 리스트 생성
        List<LocalDate> attendanceDates = new ArrayList<>();
        LocalDate current = startDate.toInstant().atZone(ZoneId.systemDefault()).toLocalDate();
        LocalDate end = endDate.toInstant().atZone(ZoneId.systemDefault()).toLocalDate();

        while (!current.isAfter(end)) {
            // 요일에 해당하는 한글 이름 얻기
            String dayOfWeekKorean = current.getDayOfWeek().getDisplayName(TextStyle.SHORT, Locale.KOREAN);

            // 시간표에 해당하는 요일인지 확인
            if (dayOfWeekList.contains(dayOfWeekKorean)) {
                attendanceDates.add(current);
            }
            current = current.plusDays(1);
        }
		
        model.addAttribute("attendanceDates", attendanceDates);
        model.addAttribute("dayOfWeekList", dayOfWeekList);
        System.out.println("AdminAttendanceControll 에서 확인한 attendanceDates : " + attendanceDates);
        System.out.println("AdminAttendanceControll 에서 확인한 dayOfWeekList : " + dayOfWeekList);

        
		// 해당 반 학생 불러오기 (memberNo, memberName)
        List<MemberVO> studentList = enrollService.selectStudentList(classNo);
        model.addAttribute("studentList",studentList);
        System.out.println("AdminAttendanceControll 에서 확인한 수강생 목록 : " + studentList);
		
		// 각 날짜에 해당하는 학생 별 출석 결과 불러오기
		Map<String, String> attendanceMap = new HashMap<>();
		
		// 각 학생에 대한 출석 정보를 가져와서 attendanceMap에 추가
		for (MemberVO student : studentList) {
		    // 특정 학생의 모든 출석 데이터를 조회
		    List<AttendanceVO> attendanceList = attendanceService.getAttendanceByClassAndMember(classNo, student.getMemberNo());
		    System.out.println(attendanceList);

		    // 날짜별 출석 상태를 모으기 위한 맵 (날짜별로 여러 출석 상태를 저장하기 위해 List를 사용)
		    Map<String, List<String>> dateToStatuses = new HashMap<>();

		    // 조회한 출석 데이터를 날짜별로 분류
		    for (AttendanceVO attendance : attendanceList) {
		        // 출석 날짜를 LocalDate 형식으로 변환
		        LocalDate attendanceDate = attendance.getAttendanceDate().toInstant().atZone(ZoneId.systemDefault()).toLocalDate();
		        // 날짜를 문자열로 변환 (형식: 'yyyy-MM-dd')
		        String dateStr = attendanceDate.toString();

		        // 학생 번호와 날짜를 결합하여 고유 키 생성 (예: '1-2024-08-09')
		        String key = attendance.getMemberNo() + "-" + dateStr;
		        System.out.println("key : " + key);

		        // 해당 키가 이미 존재하면 상태를 리스트에 추가하고, 없으면 새로운 리스트 생성
		        dateToStatuses.computeIfAbsent(key, k -> new ArrayList<>()).add(attendance.getAttendanceStatus());
		    }

		    // 각 날짜별로 모아진 출석 상태 리스트를 순회하며 최종 상태 계산
		    for (Map.Entry<String, List<String>> entry : dateToStatuses.entrySet()) {
		        String key = entry.getKey(); // 고유 키 (학생 번호 - 날짜)
		        List<String> statuses = entry.getValue(); // 해당 날짜의 모든 교시 출석 상태 리스트

		        // 최종 출석 상태 계산
		        String finalStatus = calculateFinalAttendanceStatus(statuses);
		        // 최종 출석 상태를 맵에 저장
		        attendanceMap.put(key, finalStatus);
		    }
		}

        System.out.println("AdminAttendanceController에서 확인한 attendanceMap : " + attendanceMap);

        model.addAttribute("attendanceMap", attendanceMap);
		
	}
	
	// 최종 출석 상태를 계산하는 메서드
	private String calculateFinalAttendanceStatus(List<String> statuses) {
	    boolean hasLateness = false; // 지각 여부
	    boolean allAbsent = true; // 모든 교시가 결석인지 확인
	    boolean allPresent = true; // 모든 교시가 출석인지 확인
	    boolean hasEarlyLeave = false; // 조퇴 여부

	    // 각 교시의 출석 상태를 검사하여 최종 출석 상태를 결정
	    for (int i = 0; i < statuses.size(); i++) {
	        String status = statuses.get(i); // 현재 교시의 출석 상태

	        // 지각이 하나라도 있으면 지각 플래그를 설정
	        if (status.equals("지각")) {
	            hasLateness = true;
	        }
	        // 결석이 아닌 상태가 하나라도 있으면 allAbsent 플래그를 해제
	        if (!status.equals("결석")) {
	            allAbsent = false;
	        }
	        // 출석이 아닌 상태가 하나라도 있으면 allPresent 플래그를 해제
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

	    // 최종 출석 상태를 결정하는 우선순위 로직
	    if (hasLateness) {
	        return "지각"; // 지각이 하나라도 있으면 '지각'
	    } else if (allAbsent) {
	        return "결석"; // 모든 교시가 결석이면 '결석'
	    } else if (allPresent) {
	        return "출석"; // 모든 교시가 출석이면 '출석'
	    } else if (hasEarlyLeave) {
	        return "조퇴"; // 조퇴 조건이 만족되면 '조퇴'
	    } else {
	        return "출석"; // 그 외의 경우 기본값으로 '출석'
	    }
	}

}
