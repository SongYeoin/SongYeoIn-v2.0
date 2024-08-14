package com.syi.project.service.club;

import java.sql.Date;
import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import com.syi.project.model.Criteria;
import com.syi.project.model.club.ClubVO;
import com.syi.project.model.member.MemberVO;
import com.syi.project.model.syclass.SyclassVO;

public interface ClubService {

	//동아리 리스트
	public List<ClubVO> getList(int classNo);
	
	//동아리 등록
	public void enroll(int classNo, String join, Date studyDate, String content, int memberNo);
	
	//동아리 조회
	public ClubVO getPage(int clubNo);
	
	//동아리 수정
	public int modify(ClubVO club);
	
	//동아리 삭제
	public int delete(int clubNo);

	//동아리 로드시 반 번호
	public Integer getDefaultClassNoByMember(Integer memberNo);

	//수강 반 목록
	public List<SyclassVO> getClassNoListByMember(Integer memberNo);
}
