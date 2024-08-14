package com.syi.project.service.member;

import com.syi.project.model.member.MemberVO;

public interface MemberService {

	// 로그인
	public MemberVO selectLoginMember(MemberVO member) throws Exception;

	// 아이디 중복체크
	public int selectCountByMemberId(String memberId);

	// 이메일 중복체크
	public int selectCountByMemberEmail(String memberEmail);

	// 회원가입
	int insertMember(MemberVO member);

	// 회원정보 수정
	int updateMember(MemberVO originMember);

	// 비밀번호 체크
	String selectPwd(MemberVO requestMember);

	// 회원탈퇴
	int deleteMember(MemberVO loginMember);

}
