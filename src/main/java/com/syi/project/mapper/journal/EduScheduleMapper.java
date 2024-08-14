package com.syi.project.mapper.journal;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.syi.project.model.Criteria;
import com.syi.project.model.journal.EduScheduleVO;

@Mapper
public interface EduScheduleMapper {
	
	// 일정 등록
	void scheduleCreate(EduScheduleVO schedule);

	// 모든 일정 조회 (페이징)
    List<EduScheduleVO> scheduleList(Criteria cri);
    
    // 일정 총 갯수
    int scheduleGetTotal(Criteria cri);
    
    // 일정 상세 조회
    EduScheduleVO scheduleDetail(int scheduleNo);

    // 일정 업데이트
    void scheduleUpdate(EduScheduleVO schedule);

    // 일정 삭제
    int scheduleDelete(int scheduleNo);

    // 캘린더 전체 일정 조회
	List<EduScheduleVO> scheduleAllList();
}
