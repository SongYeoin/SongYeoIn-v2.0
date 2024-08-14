package com.syi.project.service.journal;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.syi.project.mapper.journal.EduScheduleMapper;
import com.syi.project.model.Criteria;
import com.syi.project.model.journal.EduScheduleVO;

@Service
public class EduScheduleServiceImpl implements EduScheduleService{
	
	// 로그를 기록하기 위한 SLF4J Logger 객체
	private static final Logger logger = LoggerFactory.getLogger(EduScheduleServiceImpl.class);

	@Autowired
	private EduScheduleMapper eduScheduleMapper;

	// 일정 등록
	@Override
	public void scheduleCreate(EduScheduleVO schedule) {
		logger.info("일정 등록 요청: {}", schedule);
		eduScheduleMapper.scheduleCreate(schedule);
		logger.info("일정 등록 완료: {}", schedule);
	}

	// 모든 일정 조회 (페이징)
	@Override
	public List<EduScheduleVO> scheduleList(Criteria cri) {
		logger.info("일정 목록 조회 요청: {}", cri);
		List<EduScheduleVO> schedules = eduScheduleMapper.scheduleList(cri);
		if (schedules.isEmpty()) {
			logger.info("조회된 일정이 없습니다.");
		} else {
			logger.info("조회된 일정 개수: {}", schedules.size());
		}
		return schedules;
	}
	
	// 일정 총 갯수
	@Override
	public int scheduleGetTotal(Criteria cri) {
		logger.info("일정 총 갯수 조회 요청: {}", cri);
		int total = eduScheduleMapper.scheduleGetTotal(cri);
		logger.info("조회된 일정 총 갯수: {}", total);
		return total;
	}
	
	// 일정 상세 조회
	@Override
	public EduScheduleVO scheduleDetail(int scheduleNo) {
		logger.info("일정 상세 조회 요청: 일정 번호={}", scheduleNo);
		EduScheduleVO schedule = eduScheduleMapper.scheduleDetail(scheduleNo);
		if (schedule == null) {
			logger.warn("일정 번호 {}에 대한 일정이 존재하지 않습니다.", scheduleNo);
		} else {
			logger.info("조회된 일정: {}", schedule);
		}
		return schedule;
	}

	// 일정 수정
	@Override
	public void scheduleUpdate(EduScheduleVO schedule) {
		logger.info("일정 수정 요청: {}", schedule);
		eduScheduleMapper.scheduleUpdate(schedule);
		logger.info("일정 수정 완료: {}", schedule);
	}
	
	// 일정 삭제
	@Override
	public int scheduleDelete(int scheduleNo) {
		logger.info("일정 삭제 요청: 일정 번호={}", scheduleNo);
		int result = eduScheduleMapper.scheduleDelete(scheduleNo);
		if (result > 0) {
			logger.info("일정 삭제 완료: 일정 번호={}", scheduleNo);
		} else {
			logger.warn("일정 삭제 실패: 일정 번호={}", scheduleNo);
		}
		return result;
	}

	// 캘린더 전체 일정 조회
	@Override
	public List<EduScheduleVO> scheduleAllList() {
		List<EduScheduleVO> scheduleAllList = eduScheduleMapper.scheduleAllList();
        logger.info("---------> 서비스 : scheduleAllList : " + scheduleAllList);

		return scheduleAllList;
	}
}
