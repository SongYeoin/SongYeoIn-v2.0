package com.syi.project.service.journal;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.syi.project.mapper.journal.EduScheduleMapper;
import com.syi.project.model.Criteria;
import com.syi.project.model.journal.EduScheduleVO;
import com.syi.project.model.syclass.SyclassVO;

@Service
public class EduScheduleServiceImpl implements EduScheduleService{
	
	// 로그를 기록하기 위한 SLF4J Logger 객체
	private static final Logger logger = LoggerFactory.getLogger(EduScheduleServiceImpl.class);

	@Autowired
	private EduScheduleMapper eduScheduleMapper;

	// 일정 등록
	@Override
	public void scheduleCreate(EduScheduleVO schedule) throws Exception {
		
		try {
            logger.info("교육일정 등록 시작");
            logger.info("등록할 일정 정보: {}", schedule.toString());
            
            eduScheduleMapper.scheduleCreate(schedule);
            
            // 일정 번호가 제대로 생성되었는지 확인
            logger.info("교육일정 등록 완료. 생성된 일정 번호: {}", schedule.getScheduleNo());
        } catch (Exception e) {
            logger.error("교육일정 등록 중 오류 발생", e);
            throw e;
        }
    
    
	}

	// 사용자의 수강 중인 반 조회
	@Override
	public List<SyclassVO> getUserClasses(int memberNo) {
        List<SyclassVO> classes = eduScheduleMapper.getUserClasses(memberNo);
        return classes;
	}
	
	// 모든 일정 조회 (페이징)
	@Override
	public List<EduScheduleVO> scheduleList(Criteria cri, int classNo) {
		List<EduScheduleVO> schedules = eduScheduleMapper.scheduleList(cri, classNo);
	    // 로그 추가
	    logger.info("Service scheduleList size: " + schedules.size());
	    return schedules;
	}
	
	// 일정 총 갯수
	@Override
	public int scheduleGetTotal(Criteria cri, int classNo) {
        return eduScheduleMapper.scheduleGetTotal(cri, classNo);
	}
	
	// 일정 상세 조회
	@Override
	public EduScheduleVO scheduleDetail(int scheduleNo) {
		EduScheduleVO schedule = eduScheduleMapper.scheduleDetail(scheduleNo);
		return schedule;
	}

	// 일정 수정
	@Override
	public void scheduleUpdate(EduScheduleVO schedule) {
		eduScheduleMapper.scheduleUpdate(schedule);
	}
	
	// 일정 삭제
	@Override
	public int scheduleDelete(int scheduleNo) {
		int result = eduScheduleMapper.scheduleDelete(scheduleNo);
		return result;
	}

	// 캘린더 전체 일정 조회
	@Override
	public List<EduScheduleVO> scheduleAllList(int classNo) {
        List<EduScheduleVO> scheduleAllList = eduScheduleMapper.scheduleAllList(classNo);
        return scheduleAllList;
	}
}
