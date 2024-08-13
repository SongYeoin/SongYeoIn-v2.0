package com.syi.project.service.attendance;

import java.util.HashMap;
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
	public AttendanceVO getAttendanceByPeriodAndMember(Integer periodNo, Integer memberNo) {
		Map<String, Object> params = new HashMap<>();
	    params.put("periodNo", periodNo);
	    params.put("memberNo", memberNo);
		return attendanceMapper.getAttendanceByPeriodAndMember(params);
	}

}
