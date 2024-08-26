package com.syi.project.mapper.chat;

import java.util.List;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;
import org.springframework.stereotype.Repository;

import com.syi.project.model.chat.ChatMessageDTO;

@Repository
public interface MessageRepository extends MongoRepository<ChatMessageDTO, String>{

	//long countByChatRoomNoAndReceiverNoAndIsRead(String chatRoomNo, String receiverNo, boolean isRead);
	
	//List<ChatMessageDTO> findByChatRoomNoAndReceiverNoAndIsRead(String chatRoomNo, String receiverNo, boolean isRead);
	
	List<ChatMessageDTO> findByChatRoomNo(int chatRoomNo);

	/*
	 * @Query("{ 'chatRoomNo': ?0, 'receiverNo': ?1, 'isRead': false }") Long
	 * countUnreadMessages(int chatRoomNo, int receiverNo);
	 */

	//int updateIsReadtoTrue(String chatRoomNo);

}
