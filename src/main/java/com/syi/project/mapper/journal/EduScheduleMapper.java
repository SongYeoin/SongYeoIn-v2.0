package com.syi.project.mapper.journal;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.syi.project.model.Criteria;
import com.syi.project.model.journal.EduScheduleVO;
import com.syi.project.model.syclass.SyclassVO;

@Mapper
public interface EduScheduleMapper {
	
	// 일정 등록
	void scheduleCreate(EduScheduleVO schedule)throws Exception;
	
	// 사용자의 수강 중인 반 목록 조회
    List<SyclassVO> getUserClasses(@Param("memberNo") int memberNo);

	// 모든 일정 조회 (페이징, 검색, 반별 필터링)
    List<EduScheduleVO> scheduleList(@Param("cri") Criteria cri, @Param("classNo") int classNo);
    
    // 일정 총 갯수
    int scheduleGetTotal(@Param("cri") Criteria cri, @Param("classNo") int classNo);
    
    // 일정 상세 조회
    EduScheduleVO scheduleDetail(int scheduleNo);

    // 일정 업데이트
    void scheduleUpdate(EduScheduleVO schedule);

    // 일정 삭제
    int scheduleDelete(int scheduleNo);

    // 캘린더 전체 일정 조회 (반별 필터링 포함)
    List<EduScheduleVO> scheduleAllList(int classNo);
}
