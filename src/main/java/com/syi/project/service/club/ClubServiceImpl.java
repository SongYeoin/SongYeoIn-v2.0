package com.syi.project.service.club;

import java.sql.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.syi.project.mapper.club.ClubMapper;
import com.syi.project.model.Criteria;
import com.syi.project.model.club.ClubVO;
import com.syi.project.model.member.MemberVO;
import com.syi.project.model.syclass.SyclassVO;

@Service
public class ClubServiceImpl implements ClubService{

	@Autowired
	private ClubMapper mapper;
	
	//리스트(페이징)
	@Override
	public List<ClubVO> getListPaging(Criteria cri, int classNo) {
		System.out.println("service: " + mapper.getListPaging(cri, classNo));
		return mapper.getListPaging(cri, classNo);
	}

	//등록
//	@Override
//	public void enroll(int classNo, String join, Date studyDate, String content, int memberNo) {
//		mapper.enroll(classNo, join, studyDate, content, memberNo);
//		
//	}
	@Override
	public void enroll(ClubVO club) {
		mapper.enroll(club);
	}

	//조회
	@Override
	public ClubVO getPage(int clubNo) {
		return mapper.getPage(clubNo);
	}

	//수정
	@Override
	public int modify(ClubVO club) {
		return mapper.modify(club);
	}
	@Override
	public int modifyAdmin(ClubVO club) {
		return mapper.modifyAdmin(club);
	}

	//삭제
	@Override
	public int delete(int clubNo) {
		return mapper.delete(clubNo);
	}
	@Override
	public int deleteAdmin(int clubNo) {
		return mapper.deleteAdmin(clubNo);
	}

	//로드시 반 번호
	@Override
	public Integer getDefaultClassNoByMember(Integer memberNo) {
		return mapper.getDefaultClassNoByMember(memberNo);
	}

	//수강 반 목록
	@Override
	public List<SyclassVO> getClassNoListByMember(Integer memberNo) {
		return mapper.getClassNoListByMember(memberNo);
	}
	
	//동아리 신청 총 갯수
	@Override
	public int getTotal(Criteria cri, int classNo) {
		
		return mapper.getTotal(cri, classNo);
	}
	
	
	

}
