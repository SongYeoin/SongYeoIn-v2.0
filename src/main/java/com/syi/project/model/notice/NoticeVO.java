package com.syi.project.model.notice;

import java.sql.Date;
import java.util.List;

import com.syi.project.model.member.MemberVO;
import com.syi.project.model.syclass.SyclassVO;

import lombok.Data;

@Data
public class NoticeVO {
	
	private int noticeNo;
	private String noticeTitle;
	private String noticeContent;
	private Date noticeRegDate;
	private Date noticeModifyDate;
	private int noticeCount;
	private String noticeStatus;
	private int noticeClassNo;
	private int noticeMemberNo;
	private boolean hasFiles;
	private SyclassVO syclass;
	private MemberVO member;
	private List<NoticeFileVO> fileList;
	
}
