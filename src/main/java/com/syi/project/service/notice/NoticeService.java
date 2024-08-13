package com.syi.project.service.notice;

import java.util.List;

import com.syi.project.model.Criteria;
import com.syi.project.model.notice.NoticeFileVO;
import com.syi.project.model.notice.NoticeVO;

public interface NoticeService {

	// 전체 공지 리스트 조회
	List<NoticeVO> selectNoticeList(Criteria cri) throws Exception;

	// 반 공지 리스트 조회
	List<NoticeVO> selectNoticeClassList(Criteria cri, int syclassNo);

	// 공지 총 수
	int selectNoticeTotal(Criteria cri, int syclassNo);

	// 공지사항 상세 조회
	NoticeVO selectNoticeDetail(int noticeNo);

	// 공지사항 첨부파일 조회
	List<NoticeFileVO> selectNoticeFiles(int noticeNo);

	// 파일 정보 조회
	NoticeFileVO selectNoticeFile(int fileNo);

	// 공지사항 등록
	int insertNotice(NoticeVO noticeVO);

	// 공지사항 파일 등록
	int insertNoticeFile(NoticeFileVO noticeFileVO);

	// 공지사항 조회수 증가
	void updateNoticeCount(int noticeNo);
	
	// 공지사항 수정
	int updateNotice(NoticeVO notice);

	// 공지사항 삭제
	int deleteNotice(int noticeNo);
	
	// 공지사항 파일 삭제
	int deleteNoticeFiles(int noticeNo);
	
	// 파일 삭제
	int deleteNotcieFile(int fileNo);

}
