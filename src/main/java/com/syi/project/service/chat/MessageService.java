package com.syi.project.service.chat;

import java.util.List;
import java.util.Map;

import com.syi.project.model.chat.ChatMessageDTO;
import com.syi.project.model.chat.ChatRoomInfo;

public interface MessageService {
	
	public ChatMessageDTO createMessage(ChatMessageDTO message);
	public List<ChatMessageDTO> getAllMessage();
	//public void deleteMessageById(String id);
	// 채팅방 누르면 나오는 메시지 리스트
	public List<ChatMessageDTO> getMessagesByChatRoomNo(int chatRoomNo);
	public void updateIsReadtoTrue(int chatRoomNo, int receiverNo);
	public ChatMessageDTO getLatestMessagesByChatRoom(int chatRoomNo);
	public Long getUnReadMessageCountByChatRoomNoAndReceiverNo(int chatRoomNo, int receiverNo);
	

}
