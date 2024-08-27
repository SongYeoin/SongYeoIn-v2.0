package com.syi.project.service.attendance;

import java.sql.Date;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.syi.project.mapper.attendance.AttendanceMapper;
import com.syi.project.model.attendance.AttendanceVO;

@Service
public class AttendanceService {
	
	@Autowired
	AttendanceMapper attendanceMapper;

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
	
	/* 미출석 -> 결석 처리하기 */
	public void updateAbsentStatus(LocalDate date) {
		// 특정 날짜의 출석 정보가 없는 학생들을 조회
		
		// 결석 상태로 출석을 생성
	}

}
