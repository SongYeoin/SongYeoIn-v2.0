package com.syi.project.model.chat;

import com.syi.project.model.member.MemberVO;

import lombok.Data;

@Data
public class ChatRoomVO {
	// 채팅방 넘버
	private int chatRoomNo;
	private String chatRoomName;
	private int adminNo;
	private int memberNo;

	private MemberVO member;

}