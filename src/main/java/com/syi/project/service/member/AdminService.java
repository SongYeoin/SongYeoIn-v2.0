package com.syi.project.service.member;

import java.util.List;

import com.syi.project.model.Criteria;
import com.syi.project.model.member.MemberVO;

public interface AdminService {

	// 로그인
	MemberVO selectLoginAdmin(MemberVO member) throws Exception;
	
	// 수강생 리스트 조회
	List<MemberVO> selectMemberList(Criteria cri) throws Exception;


}
