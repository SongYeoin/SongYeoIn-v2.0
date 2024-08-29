package com.syi.project.service.member;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.syi.project.mapper.member.AdminMapper;
import com.syi.project.model.Criteria;
import com.syi.project.model.EnrollVO;
import com.syi.project.model.member.MemberVO;
import com.syi.project.model.syclass.SyclassVO;

@Service
public class AdminServiceImpl implements AdminService {

	@Autowired
	AdminMapper adminMapper;

	// 로그인
	@Override
	public MemberVO selectLoginAdmin(MemberVO member) {
		return adminMapper.selectLoginAdmin(member);
	}

	// 수강생 리스트 조회
	@Override
	public List<MemberVO> selectMemberList(Criteria cri) throws Exception {
		return adminMapper.selectMemberList(cri);
	}

	// 회원 총 수
	@Override
	public int selectTotalCount(Criteria cri) {
		return adminMapper.selectTotalCount(cri);
	}

	// 승인 처리
	@Transactional
	@Override
	public int updateStatusY(int memberNo) {
		return adminMapper.updateStatusY(memberNo);
	}

	// 미승인 처리
	@Transactional
	@Override
	public int updateStatusN(int memberNo) {
		return adminMapper.updateStatusN(memberNo);
	}

	// 회원 상세 조회
	@Override
	public MemberVO selectMemberDetail(int memberNo) {
		return adminMapper.selectMemberDetail(memberNo);
	}

	// 반 조회
	@Override
	public List<SyclassVO> selectClassList() {
		return adminMapper.selectClassList();
	}

	// 수강이력 조회
	@Override
	public List<EnrollVO> selectEnrollList(int memberNo) {
		return adminMapper.selectEnrollList(memberNo);
	}

	// 수강 신청
	@Override
	public int insertEnroll(EnrollVO enroll) {
		return adminMapper.insertEnroll(enroll);
	}

	// 수강 신청 삭제
	@Transactional
	@Override
	public int deleteEnroll(int enrollNo) {
		return adminMapper.deleteEnroll(enrollNo);
	}

	// 이메일 중복체크
	@Override
	public int selectCountByMemberEmail(String memberEmail) {
		return adminMapper.selectCountByMemberEmail(memberEmail);
	}

	// 회원정보 수정
	@Transactional
	@Override
	public int updateMember(MemberVO originMember) {
		return adminMapper.updateMember(originMember);
	}

	// 비밀번호 체크
	@Override
	public String selectPwd(MemberVO requestMember) {
		return adminMapper.selectPwd(requestMember);
	}

	// 회원탈퇴
	@Transactional
	@Override
	public int deleteMember(MemberVO loginMember) {
		return adminMapper.deleteMember(loginMember);
	}

	@Transactional
	@Override
	public int updateMemberProfileUrl(MemberVO updateProfileMember) {
		return adminMapper.updateMemberProfileUrl(updateProfileMember);
	}

	@Override
	public int deleteMemberProfileUrl(int memberNo) {
		return adminMapper.deleteMemberProfileUrl(memberNo);
	}
}
