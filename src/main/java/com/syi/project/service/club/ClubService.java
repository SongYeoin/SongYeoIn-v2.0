package com.syi.project.service.club;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import com.syi.project.model.Criteria;
import com.syi.project.model.club.ClubVO;
import com.syi.project.model.member.MemberVO;

public interface ClubService {

	//동아리 리스트
	public List<ClubVO> getList();
	
	//동아리 등록
	public void enroll(ClubVO club);
	
	//동아리 조회
	public ClubVO getPage(int clubNo);
	
	//동아리 수정
	public int modify(ClubVO club);
	
	//동아리 삭제
	public int delete(int clubNo);
}
