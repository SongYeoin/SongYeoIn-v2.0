package com.syi.project.model.chat;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.Field;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Document(collection = "messages")
@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class ChatMessageDTO {
	/*
	 * public enum MessageType { ENTER, TALK, LEAVE; }
	 * 
	 * private MessageType type; // 메시지의 유형
	 */
	@Field(name = "chatRoomNo")
	@JsonProperty("chatRoomNo")
	private String chatRoomNo; // 메시지가 속한 채팅방 넘버

	@Field(name = "memberNo")
	@JsonProperty("memberNo")
	private String memberNo;// 메시지 보낸 사람

	@Field(name = "memberName")
	@JsonProperty("memberName")
	private String memberName; // 메새지 보낸 사람 이름

	@Field(name = "message")
	@JsonProperty("message")
	private String message; // 메시지

	@Field(name = "regDateTime")
	//@JsonProperty("regDateTime")
	//@JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
	private String regDateTime; // 메시지 발송 시간
	
	@Field(name="isRead")
	private boolean isRead;//상대방이 읽었냐

}
