package com.syi.project.service.chat;

import java.util.ArrayList;
import java.util.List;

import com.syi.project.model.Criteria;
import com.syi.project.model.EnrollVO;
import com.syi.project.model.chat.ChatRoomVO;
import com.syi.project.model.member.MemberVO;
import com.syi.project.model.syclass.SyclassVO;

public interface ChatRoomService {
	int createChatRoom(ChatRoomVO chatroom);
	List<EnrollVO> selectClassMemberList(int adminNo);//관리자 조회
	List<EnrollVO> selectEnrollList(int chatRoomMemberNo);
	int updateChatRoomStatus(int chatRoomNo);
	int selectCountOneRoomList(ChatRoomVO chatroom);
	List<SyclassVO> selectAdminClassList(int adminNo);
	List<ChatRoomVO> selectChatRoomList(Criteria cri, MemberVO loginMember);
	ChatRoomVO getAdminNoAndMemberNoByChatRoomNo(int chatRoomNo);
	
}