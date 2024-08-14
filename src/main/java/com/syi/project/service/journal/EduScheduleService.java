package com.syi.project.service.journal;

import java.util.List;

import com.syi.project.model.Criteria;
import com.syi.project.model.journal.EduScheduleVO;

public interface EduScheduleService {
	
	// 교육 일정 등록
	void scheduleCreate(EduScheduleVO schedule);
	
	// 모든 교육 일정 조회
    List<EduScheduleVO> scheduleList(Criteria cri);
    
    // 교육 일정 총 갯수
    int scheduleGetTotal(Criteria cri);
    
    // 교육 일정 상세 조회
    EduScheduleVO scheduleDetail(int scheduleNo);
    
    // 교육 일정 수정
    void scheduleUpdate(EduScheduleVO schedule);
    
    // 교육 일정 삭제
    int scheduleDelete(int scheduleNo);
    
    // 캘린더 전체 교육 일정 조회 
	List<EduScheduleVO> scheduleAllList();
}
