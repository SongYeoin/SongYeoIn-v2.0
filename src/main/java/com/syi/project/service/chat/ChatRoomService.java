package com.syi.project.service.chat;

import java.util.List;

import com.syi.project.model.chat.ChatRoomVO;

public interface ChatRoomService {
	
	List<ChatRoomVO> selectChatRoomList(int chatRoomMemberNo);
	void createChatRoom(String name);
	ChatRoomVO SelectChatRoomByNo(String chatRoomNo);
	void updateChatRoomSessions(ChatRoomVO chatRoom);
}