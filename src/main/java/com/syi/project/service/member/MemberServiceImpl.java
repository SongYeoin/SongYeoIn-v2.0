package com.syi.project.service.member;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.syi.project.mapper.member.MemberMapper;
import com.syi.project.model.member.MemberVO;

@Service
public class MemberServiceImpl implements MemberService {
	
	@Autowired
	MemberMapper memberMapper;

	// 로그인
	@Override
	public MemberVO selectLoginMember(MemberVO member) {
		return memberMapper.selectLoginMember(member);
	}

	// 아이디 중복체크
	@Override
	public int selectCountByMemberId(String memberId) {
		return memberMapper.selectCountByMemberId(memberId);
	}

	// 이메일 중복체크
	@Override
	public int selectCountByMemberEmail(String memberEmail) {
		return memberMapper.selectCountByMemberEmail(memberEmail);
	}

	// 회원가입
	@Transactional
	@Override
	public int insertMember(MemberVO member) {
		return memberMapper.insertMember(member);
	}

	// 회원정보 수정
	@Transactional
	@Override
	public int updateMember(MemberVO originMember) {
		return memberMapper.updateMember(originMember);
	}

	// 비밀번호 체크
	@Override
	public String selectPwd(MemberVO requestMember) {
		return memberMapper.selectPwd(requestMember);
	}

	// 회원탈퇴
	@Transactional
	@Override
	public int deleteMember(MemberVO loginMember) {
		return memberMapper.deleteMember(loginMember);
	}

	@Transactional
	@Override
	public int updateMemberProfileUrl(MemberVO updateProfileMember) {
		return memberMapper.updateMemberProfileUrl(updateProfileMember);
	}
	
}
