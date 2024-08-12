package com.syi.project.service.notice;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.syi.project.mapper.notice.NoticeMapper;
import com.syi.project.model.Criteria;
import com.syi.project.model.notice.NoticeVO;

@Service
public class NoticeServiceImpl implements NoticeService{
	
	@Autowired
	NoticeMapper noticeMapper;

	// 전체 공지사항 리스트 조회
	@Override
	public List<NoticeVO> selectNoticeList(Criteria cri) throws Exception {
		return noticeMapper.selectNoticeList(cri);
	}

	// 반 공지사항 리스트 조회
	@Override
	public List<NoticeVO> selectNoticeClassList(Criteria cri, int syclassNo) {
		return noticeMapper.selectNoticeClassList(cri, syclassNo);
	}

	// 공지사항 총 수
	@Override
	public int selectNoticeCount(Criteria cri, int syclassNo) {
		return noticeMapper.selectNoticeCount(cri, syclassNo);
	}
	
}
