package com.syi.project.controller.chat;

import java.io.IOException;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.util.Date;
import java.util.Map;
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
import com.syi.project.service.chat.MessageService;

import lombok.extern.log4j.Log4j2;

@Controller
@ServerEndpoint(value = "/ws", configurator = WebSocketConfig.class)
@Log4j2
public class ChatController {

	private static final ObjectMapper objectMapper = new ObjectMapper();

	/*
	 * public ChatController() {
	 * this.objectMapper.configure(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS,
	 * false); // ISO-8601 형식으로 날짜 직렬화 }
	 */

	private MessageService messageService;

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

			// 메시지 MongoDB에 저장
			chatMessage.setMemberNo(loginMember.getMemberNo() + "");
			System.out.println("멤버넘버 설정 : " + chatMessage.getMemberNo());
			chatMessage.setMemberName(loginMember.getMemberName());
			System.out.println("멤버이름 설정 : " + chatMessage.getMemberName());
			/*
			 * chatMessage.setType(MessageType.TALK); System.out.println("타입 설정 : " +
			 * chatMessage.getType());
			 */

			/*
			 * 
			 * 
			 * // 원하는 포맷으로 DateTimeFormatter를 생성합니다. DateTimeFormatter formatter =
			 * DateTimeFormatter.ofPattern("yyyy년 MM월 dd일 HH시 mm분 ss초(SSS)");
			 * 
			 * // 포맷을 사용하여 현재 날짜와 시간을 문자열로 변환합니다. String formattedDateTime =
			 * now.format(formatter);
			 */
			
			/*
			 * // 현재 날짜와 시간을 가져옵니다. LocalDateTime now = LocalDateTime.now();
			 * 
			 * // LocalDateTime을 ZonedDateTime으로 변환 (UTC 시간대 사용) ZonedDateTime zonedDateTime
			 * = now.atZone(ZoneId.of("UTC"));
			 * 
			 * // ZonedDateTime을 Instant로 변환 Instant instant = zonedDateTime.toInstant();
			 * 
			 * // Instant를 Date로 변환 Date isoDate = Date.from(instant);
			 */
			Instant instantNow = Instant.now();
			Date dateFromInstant = Date.from(instantNow);

			
			chatMessage.setRegDateTime(dateFromInstant);
			
			//읽지 않음 표시
			chatMessage.setRead(false);

			System.out.println("최종 chatMessage : " + chatMessage);

			/// 문제지점=>webconfig 수정하고 springContext 만들었음
			try {
				System.out.println("messageService: " + messageService); // null일 수 있음

				ChatMessageDTO resultMessage = messageService.createMessage(chatMessage);
				System.out.println("resultMessage: " + resultMessage);
			} catch (NullPointerException e) {
				e.printStackTrace();
				// 추가적인 디버깅 정보 출력
				System.err.println("NullPointerException at createMessage: " + e.getMessage());
			}

			String updatedJson = objectMapper.writeValueAsString(chatMessage);
			System.out.println("updatedJson : " + updatedJson);

			// 구독한 사람들에게 메시지 보내주기(broadcast)
			broadcast(updatedJson);

		} catch (JsonProcessingException e) {
			e.printStackTrace();
		} catch (NullPointerException e) {
			System.err.println("NullPointerException occurred: " + e.getMessage());
		} catch (Exception e) {
			System.err.println("Exception occurred: " + e.getMessage());
		}

		// -----이미 채팅방이 개설되었다는 전제하에 코드가 작성됨----
		// 채팅방 정보를 불러옴
		/*
		 * ChatRoomVO room =
		 * chatService.SelectChatRoomByNo(chatMessage.getChatRoomNo()); if (room ==
		 * null) { log.error("채팅방을 찾을 수 없음"); return; }
		 */

	}

	private void broadcast(String message) throws IOException {
		/*
		 * sessions.values().parallelStream() .filter(Session::isOpen) // 세션이 열린 상태인지 확인
		 * .forEach(session -> { try { session.getBasicRemote().sendText(message); }
		 * catch (IOException e) { e.printStackTrace(); // 예외 처리 } });
		 */

		for (Session session : sessions.values()) {
			if (session.isOpen()) {
				session.getBasicRemote().sendText(message);
			}
		}

	}

	/*
	 * private void sendToEachSocket(Set<Session> sessions, String message) {
	 * sessions.parallelStream().forEach(roomSession -> { try {
	 * roomSession.getBasicRemote().sendText(message); } catch (IOException e) {
	 * log.error("메시지 보내기 실패", e); } }); }
	 */
	/*
	 * room.addSession(session); // 데이터베이스에 채팅방 업데이트
	 * chatService.updateChatRoomSessions(room);
	 * 
	 * //Set<WebSocketSession> sessions = room.getChatRoomUserSessions(); //방에 있는 현재
	 * 사용자 한명이 WebsocketSession if
	 * (chatMessage.getType().equals(ChatMessageDTO.MessageType.ENTER)) { //사용자가 방에
	 * 입장하면 Enter chatMessage.setMessage(loginMember.getMemberName() +
	 * "님이 입장했습니다."); sendToEachSocket(room.getChatRoomUserSessions(),new
	 * TextMessage(objectMapper.writeValueAsString(chatMessage)) ); }else {
	 * sendToEachSocket(room.getChatRoomUserSessions(),new TextMessage(message) );
	 * //입장 아닐 때는 클라이언트로부터 온 메세지 그대로 전달. }
	 */

	@OnClose
	public void onClose(Session session) {
		log.info("Connection closed: " + session.getId());
		// WebSocket 연결이 닫힐 때 수행할 작업
	}

	@OnError
	public void onError(Session session, Throwable throwable) {
		log.error("Error in session: " + session.getId(), throwable);
		// 에러 처리 작업
	}

}