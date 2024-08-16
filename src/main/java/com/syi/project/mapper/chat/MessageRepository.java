package com.syi.project.mapper.chat;

import java.util.List;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import com.syi.project.model.chat.ChatMessageDTO;

@Repository
public interface MessageRepository extends MongoRepository<ChatMessageDTO, String>{

	List<ChatMessageDTO> findByChatRoomNo(String chatRoomNo);

}
