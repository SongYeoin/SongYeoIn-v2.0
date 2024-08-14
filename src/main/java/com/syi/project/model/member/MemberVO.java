package com.syi.project.model.member;


import java.sql.Date;

import lombok.Data;

@Data
public class MemberVO {
	
	// 멤버 코드
	private int memberNo;
	
	// 멤버 아이디
	private String memberId;
	
	// 멤버 비밀번호
	private String memberPwd;
	
	// 멤버 이름
	private String memberName;
	
	// 멤버 생년월일
	private String memberBirthday;
	
	// 멤버 성별
	private String memberGender;
	
	// 멤버 전화번호
	private String memberPhone;
	
	// 멤버 이메일
	private String memberEmail;
	
	// 멤버 우편번호
	private String memberAddress;
	
	// 멤버 지번주소
	private String memberStreetAddress;
	
	// 멤버 상세주소
	private String memberDetailAddress;
	
	// 멤버 닉네임
	private String memberNickname;
	
	// 멤버 등록일
	private Date memberEnrollDate;
	
	// 멤버 승인 여부
	private String memberCheckStatus;
	
	// 멤버 상태(탈퇴관련)
	private String memberStatus;
	
	// 멤버 가입 유형
	private String memberSubType;
	
	// 멤버 역할
	private String memberRole;

}
