package com.syi.project.service.journal;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.syi.project.mapper.journal.JournalMapper;
import com.syi.project.model.Criteria;
import com.syi.project.model.journal.JournalVO;

/* 일지를 데이터베이스에 추가하고, 관련 파일을 삽입하는 비즈니스 로직을 담당 */
@Service
public class JournalServiceImpl implements JournalService {

	// 로그를 기록하기 위한 SLF4J Logger 객체
	private static final Logger logger = LoggerFactory.getLogger(JournalServiceImpl.class);

	// 의존성 주입을 위한 JournalMapper 객체
	@Autowired
	private JournalMapper journalMapper;

	// 일지 등록
	@Override
	public void journalEnroll(JournalVO journal, MultipartFile file) throws Exception {
		logger.info(">>>>>>>>>>>>>>>>>  journalEnroll  >>");
		journalMapper.journalEnroll(journal);
	}

	// 일지 목록 조회 (페이징)
	@Override
	public List<JournalVO> journalList(Criteria cri) throws Exception {
		logger.info(">>>>>>>>>>>>>>>>>  journalList  >>");
		return journalMapper.journalList(cri);
	}

	// 일지 갯수
	@Override
	public int journalGetTotal(Criteria cri) throws Exception {
		logger.info(">>>>>>>>>>>>>>>>>  journalGetTotal  >>");
		return journalMapper.journalGetTotal(cri);
	}

	// 일지 상세 조회
	@Override
	public JournalVO journalDetail(int journalNo) {
		logger.info(">>>>>>>>>>>>>>>>>  journalDetail  >>" + journalNo);
		return journalMapper.journalDetail(journalNo);
	}

	// 일지 수정
	@Override
	public void journalModify(JournalVO journal) throws Exception {
	    logger.info(">>>>>>>>>>>>>>>>>  journalModify  >>");
	    // 일지 정보를 수정하는 메서드 호출
	    journalMapper.journalModify(journal);
	}

	// 일지 삭제
	@Override
	public int journalDelete(int journalNo) throws Exception {
		logger.info(">>>>>>>>>>>>>>>>>  journalDelete  >>");
		return journalMapper.journalDelete(journalNo);
	}

	// 캘린더 전체 일지 조회
	@Override
	public List<JournalVO> journalAllList(int classNo) {
        logger.info("---------> 서비스 : journalAllList : classNo = " + classNo);
		List<JournalVO> journalAllList = journalMapper.journalAllList(classNo);
		return journalAllList;
	}


}
