package com.syi.project.model.chat;

import java.io.Serializable;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.Field;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Document(collection = "messages")
@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class ChatMessageDTO{
	@Id
	private String id;	// 메시지 아이디 값

	public enum MessageType {
		ENTER, TALK, LEAVE;
	}

	private MessageType type;	// 메시지의 유형

	@Field(name = "chatRoomNO")
	private String chatRoomNo;	//메시지가 속한 채팅방 넘버

	@Field("name = memberNo")
	private String memberNo;// 메시지 보낸 사람
	
	@Field("name = memberName")
	private String memberName;	//메새지 보낸 사람 이름

	@Field(name = "message")
	private String message;	// 메시지

	@Field(name = "regDateTime")
	private String regDateTime; // 메시지 발송 시간
	
}
