package com.syi.project.mapper.attendance;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.syi.project.model.attendance.AttendanceVO;

public interface AttendanceMapper {

	/* 출석 상태 등록 */
	void enrollAttendance(AttendanceVO attendance);

	/* 교시번호와 수강생번호로 단일 출석 조회하기 */
	AttendanceVO getAttendanceByPeriodAndMember(Map<String, Object> params);

	/* 클래스번호와 수강생번호로 전체 출석 조회하기 */
	List<AttendanceVO> getAttendanceByClassAndMember(@Param("classNo")Integer classNo, @Param("memberNo")Integer memberNo);

}
