package com.syi.project.service.chat;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Sort;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.data.mongodb.core.query.Update;
import org.springframework.stereotype.Service;

import com.mongodb.client.result.UpdateResult;
import com.syi.project.mapper.chat.MessageRepository;
import com.syi.project.model.chat.ChatMessageDTO;
import com.syi.project.model.chat.ChatRoomInfo;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class MessageServiceImpl implements MessageService {

	private MongoTemplate mongoTemplate;

	private final MessageRepository messageRepository;

	public MessageServiceImpl(MongoTemplate mongoTemplate, MessageRepository messageRepository) {
		super();
		this.mongoTemplate = mongoTemplate;
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

	// 채팅방 누르면 나오는 메시지 리스트
	@Override
	public List<ChatMessageDTO> getMessagesByChatRoomNo(String chatRoomNo) {
		return messageRepository.findByChatRoomNo(chatRoomNo);
	}

	// 안 읽은 메시지 개수 세기 : 받은 사람의 읽지 않은 메시지의 개수를 셈
	@Override
	public long getUnReadMessageCountByChatRoomNoAndReceiverNo(String chatRoomNo,  String receiverNo) {
		Query query = new Query();
        query.addCriteria(Criteria.where("chatRoomNo").is(chatRoomNo));
        query.addCriteria(Criteria.where("receiverId").is(receiverNo));
        query.addCriteria(Criteria.where("isRead").is(false));
		
		long count = mongoTemplate.count(query,ChatMessageDTO.class);
		log.info("읽지 않은 메시지의 개수 : "+count);
		
		return count;
	}

	/*
	 * // 읽지 않은 메시지 개수를 세는 메서드 public long countUnreadMessages(String chatRoomNo,
	 * String receiverId) { return
	 * chatMessageRepository.countByChatRoomNoAndReceiverIdAndIsRead(chatRoomNo,
	 * receiverId, false); }
	 * 
	 * // 메시지를 읽음 상태로 업데이트하는 메서드 public void markMessagesAsRead(String chatRoomNo,
	 * String receiverId) { List<ChatMessageDTO> messages =
	 * chatMessageRepository.findByChatRoomNoAndReceiverIdAndIsRead(chatRoomNo,
	 * receiverId, false); for (ChatMessageDTO message : messages) {
	 * message.setIsRead(true); chatMessageRepository.save(message); } }
	 */
	
	
	
	@Override
	public void updateIsReadtoTrue(String chatRoomNo, String receiverNo) {
		Query query = new Query();
        query.addCriteria(Criteria.where("chatRoomNo").is(chatRoomNo));
        query.addCriteria(Criteria.where("receiverId").is(receiverNo));
        query.addCriteria(Criteria.where("isRead").is(false));

        Update update = new Update();
        update.set("isRead", true);
		UpdateResult result = mongoTemplate.updateMulti(query, update, ChatMessageDTO.class);

		if (result.getMatchedCount() == 0) {
			System.out.println("Document가 일치하지 않음");
		}
		if (result.getModifiedCount() == 0) {
			System.out.println("Document 일치하지만 없데이트 되지 않음");
		}
	}

	@Override
	public ChatMessageDTO getLatestMessagesByChatRoom(String chatRoomNo) {
		log.info("chatRoomNo : " + chatRoomNo);

		Query query = new Query();
		query.addCriteria(Criteria.where("chatRoomNo").is(chatRoomNo)); // 채팅방 번호로 필터링
		query.fields().include("message").include("regDateTime").include("receiverNo");// 필요한 필드만 지정
		query.with(Sort.by(Sort.Order.desc("regDateTime"))); // 시간 역순으로 정렬
		query.limit(1); // 첫 번째 문서만 가져오기

		log.info("query는 " + query.toString());

		ChatMessageDTO result = mongoTemplate.findOne(query, ChatMessageDTO.class);

		log.info("result = " + result);

		return result;
	}

}
