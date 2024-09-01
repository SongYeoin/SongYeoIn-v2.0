package com.syi.project.service.enroll;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.syi.project.mapper.enroll.EnrollMapper;
import com.syi.project.model.EnrollVO;
import com.syi.project.model.member.MemberVO;

@Service
public class EnrollServiceImpl implements EnrollService {

	
	@Autowired
	EnrollMapper enrollMapper;
	
	// 수강 중인 반 조회
	@Override
	public List<EnrollVO> selectEnrollList(int memberNo) {
		return enrollMapper.selectEnrollList(memberNo);
	}

	// 수강 중인 반에서 classNo 작은 값 조회
	@Override
	public int selectClassNo(int memberNo) {
		return enrollMapper.selectClassNo(memberNo);
	}

	// 특정 클래스의 수강 중인 수강생 조회
	@Override
	public List<EnrollVO> selectMemberList(int classNo) {
		return enrollMapper.selectMemberList(classNo);
	}

	// 반 별 수강생 리스트 조회
	@Override
	public List<MemberVO> selectStudentList(int classNo) {
		return enrollMapper.selectStudentList(classNo);
	}
	
}
