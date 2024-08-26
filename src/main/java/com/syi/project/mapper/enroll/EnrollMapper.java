package com.syi.project.mapper.enroll;

import java.util.List;

import com.syi.project.model.EnrollVO;
import com.syi.project.model.member.MemberVO;

public interface EnrollMapper {

	// 수강 중인 반 조회
	List<EnrollVO> selectEnrollList(int memberNo);

	// 수강 중인 반에서 classNo 작은 값 조회
	int selectClassNo(int memberNo);
	
	// 반 별 수강생 목록 조회
    List<MemberVO> selectStudentList(int classNo);
}
