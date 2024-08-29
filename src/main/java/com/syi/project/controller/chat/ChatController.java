package com.syi.project.controller.chat;

import java.io.IOException;
import java.time.Instant;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;

import javax.websocket.EndpointConfig;
import javax.websocket.OnClose;
import javax.websocket.OnError;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;

import org.springframework.stereotype.Controller;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.syi.project.config.WebSocketConfig;
import com.syi.project.model.chat.ChatMessageDTO;
import com.syi.project.model.member.MemberVO;
import com.syi.project.service.chat.ChatRoomService;
import com.syi.project.service.chat.MessageService;

import lombok.extern.slf4j.Slf4j;

@Controller
@ServerEndpoint(value = "/ws", configurator = WebSocketConfig.class)
@Slf4j
public class ChatController {

	private static final ObjectMapper objectMapper = new ObjectMapper();

	private MessageService messageService;
	private ChatRoomService chatRoomService;

	// 현재 채팅방에 속한 사람들을 알기 위한 Set
	// 구독한 사람들(session)이니까 메시지를 모두 보내줘야 한다.
	// 현재는 한 채팅방의 두 명의 멤버만 들어오기 때문에 순서와 키 값이 중요하지 않다.
	// set은 중복을 허락하지 않으니까 같은 session이 여러번 등록되는 걸 방지한다.
	// private static Set<Session> sessions = new HashSet<>();
	private static Map<String, Session> sessions = new ConcurrentHashMap<>();

	// 소켓 연결 확인 메소드
	@OnOpen
	public void onOpen(Session session, EndpointConfig config) {
		sessions.put(session.getId(), session);
		log.info("새로운 연결: " + session.getId());
		this.messageService = (MessageService) config.getUserProperties().get("messageService");
	}

	// jsp에서 메시지를 보낼때 채팅방 정보도 같이 줘야한다.
	@OnMessage
	public void onMessage(Session session, String message) throws IOException {

		log.info("Received message from " + session.getId() + ": " + message);

		ChatMessageDTO chatMessage = new ChatMessageDTO();
		// JSON으로 오는 정보를 ChatMessageDTO에 맞게 매핑해서 값을 넣어줌
		// type과 채팅방 번호,메시지
		try {
			System.out.println("Received message from " + session.getId() + ": " + message);
			chatMessage = objectMapper.readValue(message, ChatMessageDTO.class);
			System.out.println("Parsed ChatMessageDTO: " + chatMessage);

			// WebSocketSession에서 Http 세션 속성 가지고 오기
			MemberVO loginMember = (MemberVO) session.getUserProperties().get("loginMember");

			System.out.println("loginMember : " + loginMember);

			if (loginMember == null) {
				log.error("로그인 상태가 아님");
				return;
			}

			chatMessage.setId(UUID.randomUUID().toString());
			// 메시지 MongoDB에 저장
			chatMessage.setMemberNo(loginMember.getMemberNo());
			System.out.println("멤버넘버 설정 : " + chatMessage.getMemberNo());
			chatMessage.setMemberName(loginMember.getMemberName());
			System.out.println("멤버이름 설정 : " + chatMessage.getMemberName());

			// 현재날짜를 문자열로 표시해서 저장함
			Instant instantNow = Instant.now();// 기본적으로 UTC 기준임
			chatMessage.setRegDateTime(instantNow.toString());

			// 읽지 않음 표시
			chatMessage.setRead(false);

			System.out.println("최종 chatMessage : " + chatMessage);

			ChatMessageDTO resultMessage = new ChatMessageDTO();
			/// 문제지점=>webconfig 수정하고 springContext 만들었음
			try {
				System.out.println("messageService: " + messageService); // null일 수 있음

				resultMessage = messageService.createMessage(chatMessage);
				System.out.println("resultMessage: " + resultMessage);
			} catch (NullPointerException e) {
				e.printStackTrace();
				// 추가적인 디버깅 정보 출력
				System.err.println("NullPointerException at createMessage: " + e.getMessage());
			}

			// 날짜 변환 후 내보내기
			DateTimeFormatter formatter = DateTimeFormatter.ofPattern("a hh:mm(yyyy-MM-dd)")
					.withZone(ZoneId.of("Asia/Seoul"));
			chatMessage.setRegDateTime(formatter.format(instantNow));

			String updatedJson = objectMapper.writeValueAsString(chatMessage);
			System.out.println("updatedJson : " + updatedJson);

			// 구독한 사람들에게 메시지 보내주기(broadcast)
			broadcast(updatedJson, resultMessage.getChatRoomNo(), resultMessage.getReceiverNo());

		} catch (JsonProcessingException e) {
			e.printStackTrace();
		} catch (NullPointerException e) {
			System.err.println("NullPointerException occurred: " + e.getMessage());
		} catch (Exception e) {
			System.err.println("Exception occurred: " + e.getMessage());
		}

	}

	private void broadcast(String message, int chatRoomNo, int receiverNo) throws IOException {
		log.info("현재 채팅방의 들어와 있는 사람의 수 : " + sessions.size());

		for (Session session : sessions.values()) {
			if (session.isOpen()) {
				session.getBasicRemote().sendText(message);
			}
			if(sessions.size()==2) {
				messageService.updateIsReadtoTrue(chatRoomNo, receiverNo);
			}
		}

	}

	@OnClose
	public void onClose(Session session) {
		log.info("Connection closed: " + session.getId());
		sessions.remove(session.getId());// 웹소켓이 닫히면 Map에서 제거
		log.info("and removed from the map");
		// WebSocket 연결이 닫힐 때 수행할 작업
	}

	@OnError
	public void onError(Session session, Throwable throwable) {
		log.error("Error in session: " + session.getId(), throwable);
		// 에러 처리 작업
	}

}