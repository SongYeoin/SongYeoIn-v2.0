package com.syi.project.model.journal;

import java.sql.Date;

import com.syi.project.model.member.MemberVO;
import com.syi.project.model.syclass.SyclassVO;

import lombok.Data;

@Data
public class JournalVO {

	private int journalNo; // 일지 번호

	private Date journalWriteDate; // 일지 작성일자
	
	private Date journalRegDate; // 일지 등록일자

	private Date journalModify; // 일지 수정일자
	
	private String journalTitle; // 일지 제목
	
	private String fileName; // 파일 이름
	
	private int memberNo; // 멤버 번호	 저장 위한 필드

    private int classNo; // 반 번호 저장 위한 필드
    
    private MemberVO member; // 수강생 정보 (MemberVO 타입)

    private SyclassVO syclass; // 반 정보 (SyclassVO 타입)
}