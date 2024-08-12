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
		eduScheduleMapper.scheduleCreate(schedule);
	}

	// 모든 일정 조회
	@Override
	public List<EduScheduleVO> scheduleList(Criteria cri) {
		return eduScheduleMapper.scheduleList(cri);
	}
	
	// 일정 총 갯수
	@Override
	public int scheduleGetTotal(Criteria cri) {
		return eduScheduleMapper.scheduleGetTotal(cri);
	}
	
	// 일정 상세 조회
	@Override
	public EduScheduleVO scheduleDetail(int scheduleNo) {
        return eduScheduleMapper.scheduleDetail(scheduleNo);
	}

	// 일정 수정
	@Override
	public void scheduleUpdate(EduScheduleVO schedule) {
        eduScheduleMapper.scheduleUpdate(schedule);
	}
	
	// 일정 삭제
	@Override
	public int scheduleDelete(int scheduleNo) {
        return eduScheduleMapper.scheduleDelete(scheduleNo);
	}


}
