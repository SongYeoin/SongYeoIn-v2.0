package com.syi.project.service.chat;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Sort;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.data.mongodb.core.query.Update;
import org.springframework.stereotype.Service;

import com.syi.project.mapper.chat.MessageRepository;
import com.syi.project.model.chat.ChatMessageDTO;

@Service
public class MessageServiceImpl implements MessageService {

	 @Autowired
	 private MongoTemplate mongoTemplate;

	private final MessageRepository messageRepository;

	@Autowired
	public MessageServiceImpl(MessageRepository messageRepository) {
		this.messageRepository = messageRepository;
	}

	@Override
	public ChatMessageDTO createMessage(ChatMessageDTO message) {
		return messageRepository.insert(message);
	}

	@Override
	public List<ChatMessageDTO> getAllMessage() {
		return messageRepository.findAll();
	}

	@Override
	public ChatMessageDTO getMessageOne(String id) {
		return messageRepository.findById(id).orElse(null);
	}

	@Override
	public void deleteMessageById(String id) {
		messageRepository.deleteById(id);
	}

	@Override
	public List<ChatMessageDTO> getMessagesByChatRoomNo(String chatRoomNo) {
		return messageRepository.findByChatRoomNo(chatRoomNo);
	}

	@Override
	public void updateIsReadtoTrue(String chatRoomNo) {
		Query query = new Query();
        query.addCriteria(Criteria.where("chatRoomNo").is(chatRoomNo));
        Update update = new Update();
        update.set("isRead", true);
        mongoTemplate.updateFirst(query, update, ChatMessageDTO.class);
		//return messageRepository.updateIsReadtoTrue(chatRoomNo);
	}

	@Override
	public Map<String, ChatMessageDTO> getLatestMessagesByChatRoom() {
		// 모든 채팅방 ID를 가져오는 쿼리
        Query distinctChatRoomQuery = new Query();
        distinctChatRoomQuery.fields().include("chatRoomNo");
        List<String> chatRoomNos = mongoTemplate.findDistinct(distinctChatRoomQuery, "chatRoomNo", "messages", String.class, String.class);
        //chatRoomNo의 필드 값을 messages 컬렉션에서 리스트형태로 반환한다. 이때 String 값으로 가지고 온다.

        // 각 채팅방 ID에 대해 최신 메시지를 가져오기
        return chatRoomNos.stream().collect(Collectors.toMap(
        		chatRoomNo -> chatRoomNo,
        		chatRoomNo -> {
                Query query = new Query();
                query.addCriteria(Criteria.where("chatRoomNo").is(chatRoomNo)); // 채팅방 번호로 필터링
                query.with(Sort.by(Sort.Order.desc("regDateTime"))); // 시간 역순으로 정렬
                query.limit(1); // 첫 번째 문서만 가져오기
                return mongoTemplate.findOne(query, ChatMessageDTO.class);
            }
        ));
	}
	

}
