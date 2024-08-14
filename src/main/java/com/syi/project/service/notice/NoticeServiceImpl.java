package com.syi.project.service.notice;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.syi.project.mapper.notice.NoticeMapper;
import com.syi.project.model.Criteria;
import com.syi.project.model.notice.NoticeFileVO;
import com.syi.project.model.notice.NoticeVO;

@Service
public class NoticeServiceImpl implements NoticeService {

	@Autowired
	NoticeMapper noticeMapper;

	// 전체 공지사항 리스트 조회
	@Override
	public List<NoticeVO> selectNoticeList(Criteria cri, int syclassNo) throws Exception {
		return noticeMapper.selectNoticeList(cri, syclassNo);
	}

	// 공지사항 총 수
	@Override
	public int selectNoticeTotal(Criteria cri, int syclassNo) {
		return noticeMapper.selectNoticeTotal(cri, syclassNo);
	}

	// 공지사항 상세 조회
	@Override
	public NoticeVO selectNoticeDetail(int noticeNo) {
		updateNoticeCount(noticeNo);
		return noticeMapper.selectNoticeDetail(noticeNo);
	}
	
	// 공지사항 첨부파일 조회
	@Override
	public List<NoticeFileVO> selectNoticeFiles(int noticeNo) {
		return noticeMapper.selectNoticeFiles(noticeNo);
	}
	
	// 파일 정보 조회
	@Override
	public NoticeFileVO selectNoticeFile(int fileNo) {
		return noticeMapper.selectNoticeFile(fileNo);
	}

	// 공지사항 조회수 증가
	@Transactional
	@Override
	public void updateNoticeCount(int noticeNo) {
		noticeMapper.updateNoticeCount(noticeNo);
	}

	// 공지사항 등록
	@Transactional
	@Override
	public int insertNotice(NoticeVO noticeVO) {
		int result = noticeMapper.insertNotice(noticeVO);
		if(result <= 0) {
			return 0;
		}
		return noticeVO.getNoticeNo();
	}

	// 공지사항 파일 등록
	@Transactional
	@Override
	public int insertNoticeFile(NoticeFileVO noticeFileVO) {
		return noticeMapper.insertNoticeFile(noticeFileVO);
	}
	
	// 공지사항 수정
	@Override
	public int updateNotice(NoticeVO notice) {
		return noticeMapper.updateNotice(notice);
	}
	
	// 공지사항 삭제
	@Transactional
	@Override
	public int deleteNotice(int noticeNo) {
		return noticeMapper.deleteNotice(noticeNo);
	}

	// 공지사항 파일 삭제
	@Transactional
	@Override
	public int deleteNoticeFiles(int noticeNo) {
		return noticeMapper.deleteNoticeFiles(noticeNo);
	}

	// 파일 삭제
	@Override
	public int deleteNotcieFile(int fileNo) {
		return noticeMapper.deleteNoticeFile(fileNo);
	}

	

	

}
