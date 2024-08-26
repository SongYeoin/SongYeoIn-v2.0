package com.syi.project.service.chat;

import java.util.ArrayList;
import java.util.List;

import com.syi.project.model.Criteria;
import com.syi.project.model.EnrollVO;
import com.syi.project.model.chat.ChatRoomVO;
import com.syi.project.model.member.MemberVO;
import com.syi.project.model.syclass.SyclassVO;

public interface ChatRoomService {
	List<ChatRoomVO> getChatRoomList(Criteria cri, MemberVO loginMember);
	int createChatRoom(ChatRoomVO chatroom);
	List<EnrollVO> getClassMemberList(int adminNo);//관리자 조회
	List<EnrollVO> getEnrollList(int chatRoomMemberNo);
	int updateChatRoomStatus(int chatRoomNo);
	int getCountOneRoomList(ChatRoomVO chatroom);
	List<SyclassVO> getAdminClassList(int adminNo);
	ChatRoomVO getAdminNoAndMemberNoByChatRoomNo(int chatRoomNo);
	
}