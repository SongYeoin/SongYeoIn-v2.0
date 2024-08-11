package com.syi.project.mapper.chat;

import java.util.List;

import com.syi.project.model.chat.ChatRoomVO;

public interface ChatRoomMapper {

	// 채팅방 정보를 업데이트하는 메소드 (sessionIds 포함)
	void updateChatRoomSessions(String chatRoomNo, String sessionIds);

	// 채팅방 정보를 가져오는 메소드
	ChatRoomVO SelectChatRoomByNo(String chatRoomNo);

	// 채팅방 개설하는 메소드
	int insertChatRoom(String name);

	// 자기가 속한 채팅방 전체 조회
	List<ChatRoomVO> selectChatRoomList(int chatRoomMemberNo);

}