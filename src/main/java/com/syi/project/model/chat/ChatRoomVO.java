package com.syi.project.model.chat;

import com.syi.project.model.member.MemberVO;

import lombok.Data;

@Data
public class ChatRoomVO {
	// 채팅방 넘버
	private int chatRoomNo;
	private int adminNo;
	private int memberNo;//수강생

	private MemberVO member;

}