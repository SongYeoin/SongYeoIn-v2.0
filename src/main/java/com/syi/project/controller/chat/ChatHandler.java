package com.syi.project.controller.chat;

import java.io.IOException;
import java.util.HashSet;
import java.util.Set;

import javax.websocket.OnClose;
import javax.websocket.OnError;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;

import org.springframework.stereotype.Component;
import org.springframework.web.socket.TextMessage;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.syi.project.config.WebSocketConfig;
import com.syi.project.model.chat.ChatMessageDTO;
import com.syi.project.model.chat.ChatRoomVO;
import com.syi.project.model.member.MemberVO;
import com.syi.project.service.chat.ChatRoomService;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;

@Component
@RequiredArgsConstructor
@ServerEndpoint(value="/chat", configurator = WebSocketConfig.class)
@Log4j2
public class ChatHandler {
	private final ObjectMapper objectMapper;
    private final ChatRoomService chatService;	
	
    // 현재 채팅방에 속한 사람들을 알기 위한 Set
	// 현재는 한 채팅방의 두 명의 멤버만 들어오기 때문에 순서와 키 값이 중요하지 않다.
    private static Set<Session> sessions = new HashSet<>();
    
    // 소켓 연결 확인 메소드
    @OnOpen
    public void onOpen(Session session) {
        log.info("{} 연결됨", session.getId());
        sessions.add(session);
    }
    
    
    @OnMessage
    public void onMessage(String message, Session session) throws IOException {
        log.info("payload : " + message);
        
        //JSON으로 오는 정보를 ChatMessageDTO에 맞게 매핑해서 값을 넣어줌
        ChatMessageDTO chatMessage = objectMapper.readValue(message, ChatMessageDTO.class);
        
        //WebSocketSession에서 Http 세션 속성 가지고 오기
        MemberVO loginMember = (MemberVO) session.getUserProperties().get("loginMember");
        if (loginMember == null) {
            log.error("로그인 상태가 아님");
            return;
        }
        
        //-----이미 채팅방이 개설되었다는 전제하에 코드가 작성됨----
        //채팅방 정보를 불러옴
        ChatRoomVO room = chatService.SelectChatRoomByNo(chatMessage.getChatRoomNo());
        if (room == null) {
            log.error("채팅방을 찾을 수 없음");
            return;
        }
        
        if (chatMessage.getType().equals(ChatMessageDTO.MessageType.ENTER)) {
            room.addSession(session);
            chatMessage.setMessage(loginMember.getMemberName() + "님이 입장했습니다.");
            sendToEachSocket(room.getChatRoomUserSessions(), new TextMessage(objectMapper.writeValueAsString(chatMessage)));
        } else {
            sendToEachSocket(room.getChatRoomUserSessions(), new TextMessage(message));
        }
        
        
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
    }
    private  void sendToEachSocket(Set<Session> sessions, TextMessage message){
        sessions.parallelStream().forEach( roomSession -> {
            try {
                roomSession.getBasicRemote().sendText(message.getPayload());
            } catch (IOException e) {
            	 log.error("메시지 보내기 실패", e);
            }
        });
    }
   
    
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
