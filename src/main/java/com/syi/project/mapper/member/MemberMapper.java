package com.syi.project.mapper.member;

import java.util.List;

import com.syi.project.model.member.MemberVO;

public interface MemberMapper {
	
	// 로그인
	MemberVO selectLoginMember(MemberVO member);
	
	// 아이디 중복체크
	int selectCountByMemberId(String memberId);
	
	// 이메일 중복체크
	int selectCountByMemberEmail(String memberEmail);
	
	// 회원가입
	int insertMember(MemberVO member);
	
	// 회원정보 수정
	int updateMember(MemberVO originMember);
	
	// 비밀번호 체크
	String selectPwd(MemberVO requestMember);
	
	// 회원탈퇴
	int deleteMember(MemberVO loginMember);

	int updateMemberProfileUrl(MemberVO updateProfileMember);

	int deleteMemberProfileUrl(int memberNo);

	// 관리자 목록 불러오기
	List<MemberVO> getAdminList();

}
