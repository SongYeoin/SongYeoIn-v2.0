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
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.syi.project.model.attendance.AttendanceVO;
import com.syi.project.model.member.MemberVO;
import com.syi.project.model.period.PeriodVO;
import com.syi.project.model.schedule.ScheduleVO;
import com.syi.project.model.syclass.SyclassVO;
import com.syi.project.service.attendance.AttendanceService;
import com.syi.project.service.enroll.EnrollService;
import com.syi.project.service.member.AdminService;
import com.syi.project.service.member.MemberService;
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
	@Autowired
	AdminService adminService;
	
	/* 반 별 전체 출석 조회 페이지로 이동 */
	@GetMapping("/class/attendance/attendanceList")
	public void attendanceListGET(HttpServletRequest request, Model model) {
	    
	    // 반 정보 불러오기
	    HttpSession session = request.getSession();
	    SyclassVO syclass = (SyclassVO) session.getAttribute("syclass");
	    int classNo = syclass.getClassNo();
	        
	    // 해당 반 시간표의 요일 정보 추출 : dayOfWeekList
	    List<String> dayOfWeekList = getDayOfWeekList(syclass); 
	    model.addAttribute("dayOfWeekList", dayOfWeekList);
	    
	    // 개강일 ~ 종강일 중 시간표 요일에 해당하는 날짜 리스트 생성 : attendanceDates
	    List<LocalDate> attendanceDates = getAttendanceDates(syclass, dayOfWeekList);
	    model.addAttribute("attendanceDates", attendanceDates);

	    // 해당 반 학생 불러오기 (memberNo, memberName)
	    List<MemberVO> studentList = enrollService.selectStudentList(classNo);
	    model.addAttribute("studentList",studentList);
	    
	    // 각 날짜에 해당하는 학생 별 출석 결과 불러오기 (memberNo-2024-08-16=출석, ...)
	    Map<String, String> finalAttendanceMap = new HashMap<>();
	    
	    // 각 학생에 대한 출석 정보를 가져와서 attendanceMap에 추가
	    for (MemberVO student : studentList) {
	        // 각 학생의 출석 맵을 얻기 (교시 정보를 포함한 리스트로 반환)
	        Map<String, List<AttendanceVO>> studentAttendanceMap = getAttendanceMap(classNo, student.getMemberNo());
	        
	        // 각 날짜별로 모아진 출석 상태 리스트를 순회하며 최종 상태 계산
	        for (Map.Entry<String, List<AttendanceVO>> entry : studentAttendanceMap.entrySet()) {
	            String key = entry.getKey(); // 고유 키 (학생 번호 - 날짜)
	            List<AttendanceVO> attendances = entry.getValue(); // 해당 날짜의 모든 교시 출석 상태 리스트

	            // 각 교시의 출석 상태만 추출
	            List<String> statuses = attendances.stream().map(AttendanceVO::getAttendanceStatus).collect(Collectors.toList());

	            // 최종 출석 상태 계산
	            String finalStatus = calculateFinalAttendanceStatus(statuses);
	            // 최종 출석 상태를 맵에 저장
	            finalAttendanceMap.put(key, finalStatus);
	        }
	    }

	    model.addAttribute("attendanceMap", finalAttendanceMap);
	}

	
	/* 수강생 별 출석 페이지로 이동 */
	@GetMapping("/class/attendance/attendanceDetail")
	public void attendanceDetailGET(HttpServletRequest request, Model model, @RequestParam("memberNo") int memberNo) {
	    
	    // 반 정보 불러오기
	    HttpSession session = request.getSession();
	    SyclassVO syclass = (SyclassVO) session.getAttribute("syclass");
	    int classNo = syclass.getClassNo();
	    
	    // 수강생 정보 불러오기
	    MemberVO student = adminService.selectMemberDetail(memberNo);
	    model.addAttribute("student",student);
	    
	    // 해당 반 시간표의 요일 정보 추출 : dayOfWeekList
	    List<String> dayOfWeekList = getDayOfWeekList(syclass); 
	    model.addAttribute("dayOfWeekList", dayOfWeekList);
	    System.out.println("dayOfWeekList : " + dayOfWeekList);
	    
	    // 해당 과목의 개강일 ~ 종강일 사이 날짜 불러오기
	    List<LocalDate> attendanceDates = getAttendanceDates(syclass, dayOfWeekList);
	    model.addAttribute("attendanceDates", attendanceDates);
	    System.out.println("attendanceDates : " + attendanceDates);
	    
	    // 각 날짜 별 요일에 해당하는 시간표의 교시 정보 불러오기
	    ScheduleVO schedule = scheduleService.getSchedule(classNo);
	    int scheduleNo = schedule.getScheduleNo();
	    List<PeriodVO> periods = scheduleService.getPeriods(scheduleNo);
	    model.addAttribute("periods",periods);
	    System.out.println("periods : " + periods);
	    
	    // 해당 날짜의 각 교시 별 출석, 메모 불러오기
	    Map<String, List<AttendanceVO>> studentAttendanceMap = getAttendanceMap(classNo, student.getMemberNo());
	    model.addAttribute("studentAttendanceMap",studentAttendanceMap);
	    System.out.println("studentAttendanceMap : " + studentAttendanceMap);
	    
	    // 최종 출석 판단하기
	    Map<String, String> finalAttendanceMap = new HashMap<>();
	    
	    for (Map.Entry<String, List<AttendanceVO>> entry : studentAttendanceMap.entrySet()) {
	        String key = entry.getKey(); 
	        List<AttendanceVO> attendances = entry.getValue(); 

	        // 각 교시의 출석 상태만 추출
	        List<String> statuses = attendances.stream().map(AttendanceVO::getAttendanceStatus).collect(Collectors.toList());

	        // 최종 출석 상태 계산
	        String finalStatus = calculateFinalAttendanceStatus(statuses);
	        // 최종 출석 상태를 맵에 저장
	        finalAttendanceMap.put(key, finalStatus);
	    }
	    
	    model.addAttribute("finalAttendanceMap",finalAttendanceMap);
	    System.out.println("finalAttendanceMap : " + finalAttendanceMap);
	    
	}
	
	/* 상세 출석 수정하기 */
	@PostMapping
	public void updateAttendancePOST() {
		
	}
	
	/* 일괄 결석 처리 */
	@PostMapping("/class/attendance/absent")
	public ResponseEntity<?> updateAbsentStatus() {
		
		// 현재 날짜를 조회하고 하루 전 날짜를 계산
	    LocalDate yesterday = LocalDate.now().minusDays(1);
	    
	    // LocalDate를 Date로 변환
	    Date date = Date.from(yesterday.atStartOfDay(ZoneId.systemDefault()).toInstant());
	    
		attendanceService.updateAbsentStatus(date);
		
		return ResponseEntity.ok("자동 결석 처리가 완료되었습니다!");
	}

	
	/* 최종 출석 상태를 계산하는 메서드 */
	public String calculateFinalAttendanceStatus(List<String> statuses) {
		System.out.println("calculateFinalAttendanceStatus 에서 확인한 statuses : " + statuses);
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
	
	/* syclassVO 로 시간표 요일 정보 추출 메서드 */
	public List<String> getDayOfWeekList(SyclassVO syclass) {
		
		// 1. 해당 과목의 시간표 조회 후 교시 조회하여 요일 정보 추출 : schedule, periods
		int classNo = syclass.getClassNo();
        ScheduleVO schedule = scheduleService.getSchedule(classNo);
        int scheduleNo = schedule.getScheduleNo();
        
        List<PeriodVO> periods = scheduleService.getPeriods(scheduleNo);
        
        // 2. 요일 중복제거 및 오름차순 나열 : dayOfWeekList
        
        // 2-1. dayOfWeek 중복 제거하여 Set으로 변환
        Set<String> uniqueDaysOfWeek = periods.stream()
        								.flatMap(period -> Arrays.stream(period.getDayOfWeek().split(",")))
        								.collect(Collectors.toSet());
        
        // 2-2. 중복되지 않은 요일 정보를 List로 변환
        List<String> dayOfWeekList = new ArrayList<>(uniqueDaysOfWeek); 
        
        // 2-3. 요일 순서대로 정렬
        List<String> orderedDaysOfWeek = Arrays.asList("월", "화", "수", "목", "금", "토", "일");
        dayOfWeekList.sort(Comparator.comparingInt(orderedDaysOfWeek::indexOf));
        
        return dayOfWeekList;
	}
	
	/* 개강일 ~ 종강일 중 시간표 요일에 해당하는 날짜 판별 메서드 */
	public List<LocalDate> getAttendanceDates(SyclassVO syclass, List<String> dayOfWeekList) {
		
		Date startDate = syclass.getStartDate(); // 개강일
 		Date endDate = syclass.getEndDate(); // 종강일
 		
 		// 시간표 요일에 해당하는 실제 수강 날짜 리스트
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
        
        return attendanceDates;
	}
	
	/* 학생의 특정 과목 모든 교시 출석 정보 조회 메서드 */
	public Map<String, List<AttendanceVO>> getAttendanceMap(int classNo, int studentNo) {
	    
	    Map<String, List<AttendanceVO>> dateToAttendances = new HashMap<>();
	    
	    // 특정 학생의 모든 출석 데이터를 조회
	    List<AttendanceVO> attendanceList = attendanceService.getAttendanceByClassAndMember(classNo, studentNo);
	    System.out.println(attendanceList);

	    // 조회한 출석 데이터를 날짜별로 분류
	    for (AttendanceVO attendance : attendanceList) {
	        // 출석 날짜를 LocalDate 형식으로 변환
	        LocalDate attendanceDate = attendance.getAttendanceDate().toInstant().atZone(ZoneId.systemDefault()).toLocalDate();
	        // 날짜를 문자열로 변환 (형식: 'yyyy-MM-dd')
	        String dateStr = attendanceDate.toString();

	        // 학생 번호와 날짜를 결합하여 고유 키 생성 (예: '1-2024-08-09')
	        String key = attendance.getMemberNo() + "-" + dateStr;

	        // 해당 키가 이미 존재하면 상태를 리스트에 추가하고, 없으면 새로운 리스트 생성
	        dateToAttendances.computeIfAbsent(key, k -> new ArrayList<>()).add(attendance);
	    }
	    
	    return dateToAttendances;
	}

}
