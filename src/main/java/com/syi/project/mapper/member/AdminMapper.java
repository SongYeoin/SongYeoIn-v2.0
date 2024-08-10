package com.syi.project.mapper.member;

import java.util.List;

import com.syi.project.model.Criteria;
import com.syi.project.model.EnrollVO;
import com.syi.project.model.member.MemberVO;
import com.syi.project.model.syclass.SyclassVO;

public interface AdminMapper {
	
	// 로그인
	MemberVO selectLoginAdmin(MemberVO member);
	
	// 수강생 리스트 조회
	List<MemberVO> selectMemberList(Criteria cri); 
	
	// 회원 총 수
	int selectTotalCount(Criteria cri);
	
	// 승인 처리
	int updateStatusY(int memberNo);
	
	// 미승인 처리
	int updateStatusN(int memberNo);
	
	// 회원 상세 조회
	MemberVO selectMemberDetail(int memberNo);
	
	// 반 조회
	List<SyclassVO> selectClassList();
	
	// 수강이력 조회
	List<EnrollVO> selectEnrollList(int memberNo);
	
	// 수강 신청
	int insertEnroll(EnrollVO enroll);
	
	// 수강 신청 삭제
	int deleteEnroll(int enrollNo);
}
