package com.syi.project.service.notice;

import java.util.List;

import com.syi.project.model.Criteria;
import com.syi.project.model.notice.NoticeVO;

public interface NoticeService {
	
	// 전체 공지 리스트 조회
	List<NoticeVO> selectNoticeList(Criteria cri) throws Exception;
	
	// 반 공지 리스트 조회
	List<NoticeVO> selectNoticeClassList(Criteria cri, int syclassNo);
	
	// 공지 총 수
	int selectNoticeCount(Criteria cri, int syclassNo);

}
