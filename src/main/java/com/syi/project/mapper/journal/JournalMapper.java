package com.syi.project.mapper.journal;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.syi.project.model.Criteria;
import com.syi.project.model.journal.JournalVO;
import com.syi.project.model.syclass.SyclassVO;

@Mapper
public interface JournalMapper {

	// 일지 등록
	public void journalEnroll(JournalVO journal);
    
	// 일지 목록 (페이징)
    public List<JournalVO> journalList(@Param("cri") Criteria cri, @Param("classNo") Integer classNo, @Param("memberNo") Integer memberNo);

	// 일지 총 갯수
    public int journalGetTotal(@Param("cri") Criteria cri, @Param("classNo") Integer classNo, @Param("memberNo") Integer memberNo);

	// 일지 상세
	public JournalVO journalDetail(int journalNo);

	// 일지 수정
	public void journalModify(JournalVO journal);

	// 일지 삭제
	public int journalDelete(int journalNo);
	
	// 캘린더 전체 일지 조회
    public List<JournalVO> journalAllList(@Param("classNo") int classNo, @Param("memberNo") int memberNo);
}