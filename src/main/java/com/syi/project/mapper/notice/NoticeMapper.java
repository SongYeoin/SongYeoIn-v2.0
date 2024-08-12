package com.syi.project.mapper.notice;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.syi.project.model.Criteria;
import com.syi.project.model.notice.NoticeVO;

public interface NoticeMapper {
	
	// 전체 공지 리스트 조회
	List<NoticeVO> selectNoticeList(Criteria cri);
	
	// 반 공지 리스트 조회
    List<NoticeVO> selectNoticeClassList(@Param("cri") Criteria cri, @Param("syclassNo") int syclassNo);
    
    // 공지 총 수
    int selectNoticeCount(@Param("cri") Criteria cri, @Param("syclassNo") int syclassNo);

}
