package com.syi.project.service.chat;

import java.time.Duration;
import java.time.Instant;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.data.domain.Sort;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.data.mongodb.core.query.Update;
import org.springframework.stereotype.Service;

import com.mongodb.client.result.UpdateResult;
import com.syi.project.mapper.chat.MessageRepository;
import com.syi.project.model.chat.ChatMessageDTO;
import com.syi.project.model.chat.ChatRoomVO;
import com.syi.project.model.member.MemberVO;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class MessageServiceImpl implements MessageService {

	private MongoTemplate mongoTemplate;

	private final MessageRepository messageRepository;
	
	private final ChatRoomService chatService;


	public MessageServiceImpl(MongoTemplate mongoTemplate, MessageRepository messageRepository,
			ChatRoomService chatService) {
		super();
		this.mongoTemplate = mongoTemplate;
		this.messageRepository = messageRepository;
		this.chatService = chatService;
	}

	@Override
	public ChatMessageDTO createMessage(ChatMessageDTO message) {
		return messageRepository.insert(message);
	}

	@Override
	public List<ChatMessageDTO> getAllMessage() {
		return messageRepository.findAll();
	}



	// 채팅방 누르면 나오는 메시지 리스트
	@Override
	public List<ChatMessageDTO> getMessagesByChatRoomNo(int chatRoomNo) {
		return messageRepository.findByChatRoomNo(chatRoomNo);
	}

	// 안 읽은 메시지 개수 세기 : 받은 사람의 읽지 않은 메시지의 개수를 셈
	@Override
	public Long getUnReadMessageCountByChatRoomNoAndReceiverNo(int chatRoomNo, int receiverNo) {
		log.info("chatRoomNo : " + chatRoomNo + "receiverNo : " + receiverNo);

		Query query = new Query();
		query.addCriteria(Criteria.where("chatRoomNo").is(chatRoomNo));
		query.addCriteria(Criteria.where("receiverNo").is(receiverNo));
		query.addCriteria(Criteria.where("isRead").is(false));

		long count = mongoTemplate.count(query, ChatMessageDTO.class);

		// Long count = messageRepository.countUnreadMessages(chatRoomNo, receiverNo);
		log.info("읽지 않은 메시지의 개수 : " + count);

		return count;
	}

	@Override
	public void updateIsReadtoTrue(int chatRoomNo, int receiverNo) {
		Query query = new Query();
		query.addCriteria(Criteria.where("chatRoomNo").is(chatRoomNo));
		query.addCriteria(Criteria.where("receiverNo").is(receiverNo));
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
	public ChatMessageDTO getLatestMessagesByChatRoom(int chatRoomNo) {
		log.info("chatRoomNo : " + chatRoomNo);

		Query query = new Query();
		query.addCriteria(Criteria.where("chatRoomNo").is(chatRoomNo)); // 채팅방 번호로 필터링
		query.fields().include("message").include("regDateTime");// 필요한 필드만 지정
		query.with(Sort.by(Sort.Order.desc("regDateTime"))); // 시간 역순으로 정렬
		query.limit(1); // 첫 번째 문서만 가져오기

		log.info("query는 " + query.toString());

		ChatMessageDTO result = new ChatMessageDTO();
		try {
			result = mongoTemplate.findOne(query, ChatMessageDTO.class);

			log.info("result = " + result);

		} catch (NullPointerException e) {
			log.info("마지막 메시지가 없음(메시지를 한 적이 없음)");
			e.getStackTrace();
		}

		return result;
	}

	@Override
	public Integer getUnReadRoomCount(HttpSession session) {
		log.info("안 읽은 메시지 조회 후 헤더 아이콘 바뀜");

		Integer unreadRoomCount = 0;
		MemberVO loginMember = new MemberVO();
		try {
			loginMember = (MemberVO) session.getAttribute("loginMember");
			List<ChatRoomVO> roomList = chatService.getChatRoomList(null, loginMember);
			for (ChatRoomVO chatRoom : roomList) {
				Long unReadCount = getUnReadMessageCountByChatRoomNoAndReceiverNo(
						chatRoom.getChatRoomNo(), loginMember.getMemberNo());
				if (unReadCount > 0)
					unreadRoomCount++;
			}
			session.setAttribute("unreadRoomCount", unreadRoomCount);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return unreadRoomCount;
	}

	//날짜 데이터 전환하는 작업
	@Override
	public String getMessageTimeFormat(String messageTime) {
		
		log.info("진입 : 날짜 형식을 포맷한 후 반환 작업");
		// 시간 데이터 문자열(UTC)을 instant 형식으로 변환
		Instant instant = Instant.parse(messageTime);

		// 지역과 포맷형식을 오후 08:10 이와 같게 바꿈
		DateTimeFormatter formatter;

		Instant now = Instant.now();// 현재 날짜시간
		Duration duration = Duration.between(instant, now);// 현재와 메시지 보낸 시간과의 차이

		// 메시지 보낸 시간이 현재보다 하루가 안 지났으면 오후 00:00 로 표시,하루가 지나면 '어제'라고 표시, 하루보다 더 지났으면 년-월-일
		// 로 표시
		if (duration.toDays() < 1) {// 하루가 안 지났다면
			formatter = DateTimeFormatter.ofPattern("a hh:mm").withZone(ZoneId.of("Asia/Seoul"));
			messageTime = formatter.format(instant);

		} else if (duration.toDays() >= 1 && duration.toDays() < 2) {// 하루와 이틀 사이
			messageTime = "어제";
		} else {
			formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd").withZone(ZoneId.of("Asia/Seoul"));
			messageTime = formatter.format(instant);
		}
		
		return messageTime;
	}

	@Override
	public List<ChatMessageDTO> getRegDateTimeFormatFromMessageList(List<ChatMessageDTO> messageList) {
		for (ChatMessageDTO message : messageList) {
			String messageTime = message.getRegDateTime();

			// 시간 데이터 문자열(UTC)을 instant 형식으로 변환
			Instant instant = Instant.parse(messageTime);

			// 지역과 포맷형식을 오후 08:10 이와 같게 바꿈
			DateTimeFormatter formatter = DateTimeFormatter.ofPattern("a hh:mm(yyyy-MM-dd)")
					.withZone(ZoneId.of("Asia/Seoul"));

			messageTime = formatter.format(instant);

			message.setRegDateTime(messageTime);
		}
		
		
		return messageList;
	}
	
	
	
	
	
	
	

	
	
	/*
	 * @Override public void deleteMessageById(String id) {
	 * messageRepository.deleteById(id); }
	 */
}
