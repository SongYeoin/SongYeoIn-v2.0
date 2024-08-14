package com.syi.project.mapper.chat;

import java.util.List;

import com.syi.project.model.EnrollVO;
import com.syi.project.model.chat.ChatRoomVO;
import com.syi.project.model.member.MemberVO;
import com.syi.project.model.syclass.SyclassVO;


public interface ChatRoomMapper {
	
	// 채팅방 정보를 업데이트하는 메소드 (sessionIds 포함)
	//void updateChatRoomSessions(int i, String sessionIds);
	
	// 채팅방 정보를 가져오는 메소드
    ChatRoomVO SelectChatRoomByNo(String chatRoomNo);
	
    // 채팅방 개설하는 메소드
    int insertChatRoom(ChatRoomVO chatroom);

    //자기가 속한 채팅방 전체 조회
	//List<ChatRoomVO> selectChatRoomList(int chatRoomMemberNo);

	List<EnrollVO> selectEnrollList(int chatRoomMemberNo);

	int selectAdminNoByClassNo(int classNo);
	
	int updateChatRoomStatus(int chatRoomNo);
	

	List<ChatRoomVO> selectChatRoomList(MemberVO loginMember);

	List<EnrollVO> selectClassMemberList(int adminNo);

	int selectCountOneRoomList(ChatRoomVO chatroom);
	
	List<SyclassVO> selectAdminClassList(int adminNo);
	
}