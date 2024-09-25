package com.syi.project.service.attendance;

import java.sql.Date;
import java.time.DayOfWeek;
import java.time.Instant;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collector;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.syi.project.mapper.attendance.AttendanceMapper;
import com.syi.project.mapper.enroll.EnrollMapper;
import com.syi.project.mapper.period.PeriodMapper;
import com.syi.project.mapper.schedule.ScheduleMapper;
import com.syi.project.mapper.syclass.SyclassMapper;
import com.syi.project.model.attendance.AttendanceVO;
import com.syi.project.model.member.MemberVO;
import com.syi.project.model.period.PeriodVO;
import com.syi.project.service.schedule.ScheduleService;
import com.syi.project.service.syclass.SyclassService;

@Service
public class AttendanceService {
	
	@Autowired
	AttendanceMapper attendanceMapper;
	@Autowired
	SyclassMapper syclassMapper;
	@Autowired
	ScheduleMapper scheduleMapper;
	@Autowired
	EnrollMapper enrollMapper;
	@Autowired
	PeriodMapper periodMapper;

	/* 출석 상태 등록 */
	public void enrollAttendance(AttendanceVO attendance) {
		attendanceMapper.enrollAttendance(attendance);
	}

	/* 교시번호와 수강생번호로 단일 출석 조회하기 */
	public AttendanceVO getAttendanceByPeriodAndMember(Integer periodNo, Integer memberNo, Date date) {
		Map<String, Object> params = new HashMap<>();
	    params.put("periodNo", periodNo);
	    params.put("memberNo", memberNo);
	    params.put("attendanceDate", date);
		return attendanceMapper.getAttendanceByPeriodAndMember(params);
	}

	/* 클래스번호와 수강생번호로 전체 출석 조회하기 */
	public List<AttendanceVO> getAttendanceByClassAndMember(Integer classNo, Integer memberNo) {
		return attendanceMapper.getAttendanceByClassAndMember(classNo, memberNo);
	}
	
	/* 특정 날짜 미출석 -> 결석 처리하기 */
	public void updateAbsentStatus(java.util.Date date) {
		
		// Date 타입을 Instant로 변환
	    Instant instant = date.toInstant();
	    // Instant를 LocalDate로 변환 (시스템의 기본 시간대 사용)
	    LocalDate localDate = instant.atZone(ZoneId.systemDefault()).toLocalDate();
		
		// 결석 처리할 요일 조회
		DayOfWeek dayOfWeek = localDate.getDayOfWeek();
		int dayOfWeekNumber = dayOfWeek.getValue(); // 월:1 ~ 일:7
		String dayOfweekString = null;
		
		// 요일을 숫자 -> 문자 변경
		switch (dayOfWeekNumber) {
		case 1: dayOfweekString = "월"; break;
	    case 2: dayOfweekString = "화"; break;
	    case 3: dayOfweekString = "수"; break;
	    case 4: dayOfweekString = "목"; break;
	    case 5: dayOfweekString = "금"; break;
	    case 6: dayOfweekString = "토"; break;
	    case 7: dayOfweekString = "일"; break;
		default: break;
		}
		
		System.out.println("서비스에서 확인한 요일 = " + dayOfweekString);
		
		// 해당 요일에 수업인 교시 리스트 (요일, 시간표번호, 교시번호, 반번호)
		List<PeriodVO> periodList = periodMapper.getScheduleByDayOfWeek(dayOfweekString);
		
		// 해당 요일에 수업인 과목 리스트
		List<Integer> classNoList = new ArrayList<Integer>();
		for(PeriodVO period : periodList) {
			int classNo = period.getClassNo();
			classNoList.add(classNo);
		}
		// 과목 중복 제거
		classNoList.stream().distinct().collect(Collectors.toList());
		
		// 반 별 교시번호 맵 <반, 교시>
		Map<Integer, List<Integer>> periodNoListWithClassNoMap = new HashMap<>();
		
		for(int classNo : classNoList) {
			List<Integer> periodNoList = new ArrayList<>();
			
			for(PeriodVO period : periodList) {
				if (period.getClassNo()==classNo) {
					periodNoList.add(period.getPeriodNo());
				}
			}
			periodNoListWithClassNoMap.put(classNo, periodNoList);
		}
		
		// 해당 과목의 수강생 리스트 <반, 수강생리스트>
		Map<Integer, List<MemberVO>> studentWithClassMap = new HashMap<>();
		
		for(int classNo : classNoList) {
			List<MemberVO> studentList = enrollMapper.selectStudentList(classNo);
			studentWithClassMap.put(classNo, studentList);
		}
		
		// 해당 과목 특정 날짜의 출석 정보가 없는 학생들을 조회
		// 1. 반 별 학생리스트를 순회하며, 해당 학생이 date 의 출석을 갖고 있는지 확인
		for(Integer key : studentWithClassMap.keySet()) {
			for(MemberVO student : studentWithClassMap.get(key)) {
				List<AttendanceVO> attendanceLsit = attendanceMapper.getAttendanceByDateAndMember(date, student.getMemberNo());
				
				// 1-1. 출석이 하나도 없다면 
				if(attendanceLsit.isEmpty()) {
					
					// 모든 교시 순회
					for(Integer periodNo : periodNoListWithClassNoMap.get(key)) {
						// 결석 등록
						AttendanceVO attendance = new AttendanceVO();
						attendance.setAttendanceStatus("결석");
						attendance.setPeriodNo(periodNo);
						attendance.setMemberNo(student.getMemberNo());
						attendance.setClassNo(key);
						attendance.setAttendanceDate(date);
						attendanceMapper.enrollAttendance(attendance);
					}
					
				// 1-2. 출석이 있다면 
				} else {
					
					// 없는 교시 추출 (모든 교시 - 있는 교시)
					// 모든 교시
					List<Integer> periodNoList = periodNoListWithClassNoMap.get(key);
					// 출석 순회하며
					for(AttendanceVO attendance : attendanceLsit) {
						// 있는 교시
						int periodNo = attendance.getPeriodNo();
						// 없는 교시
						periodNoList.remove(Integer.valueOf(periodNo));
					}
					// 결석 등록
					for(Integer periodNo : periodNoList) {
						AttendanceVO attendance = new AttendanceVO();
						attendance.setAttendanceStatus("결석");
						attendance.setPeriodNo(periodNo);
						attendance.setMemberNo(student.getMemberNo());
						attendance.setClassNo(key);
						attendance.setAttendanceDate(date);
						attendanceMapper.enrollAttendance(attendance);
					}
				}
			}
		}
	}
}
