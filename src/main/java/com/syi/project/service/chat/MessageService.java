package com.syi.project.service.chat;

import java.util.List;

import com.syi.project.model.chat.ChatMessageDTO;

public interface MessageService {
	
	public ChatMessageDTO createMessage(ChatMessageDTO message);
	public List<ChatMessageDTO> getAllMessage();
	public ChatMessageDTO getMessageOne(String id);
	public void deleteMessageById(String id);
	public List<ChatMessageDTO> getMessagesByChatRoomNo(String chatRoomNo);
	

}
