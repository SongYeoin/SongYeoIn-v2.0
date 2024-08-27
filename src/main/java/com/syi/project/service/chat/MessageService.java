package com.syi.project.service.chat;

import java.util.List;

import javax.servlet.http.HttpSession;

import com.syi.project.model.chat.ChatMessageDTO;

public interface MessageService {
	
	public ChatMessageDTO createMessage(ChatMessageDTO message);
	public List<ChatMessageDTO> getAllMessage();
	//public void deleteMessageById(String id);
	// 채팅방 누르면 나오는 메시지 리스트
	public List<ChatMessageDTO> getMessagesByChatRoomNo(int chatRoomNo);
	public void updateIsReadtoTrue(int chatRoomNo, int receiverNo);
	public ChatMessageDTO getLatestMessagesByChatRoom(int chatRoomNo);
	public Long getUnReadMessageCountByChatRoomNoAndReceiverNo(int chatRoomNo, int receiverNo);
	public Integer getUnReadRoomCount(HttpSession session);
	
	//날짜 데이터 전환하는 작업
	public String getMessageTimeFormat(String messageTime);
	public List<ChatMessageDTO> getRegDateTimeFormatFromMessageList(List<ChatMessageDTO> messageList);
	

}
