package com.syi.project.model.chat;

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
public class ChatMessageDTO {
	@Field(name = "chatRoomNo")
	private String chatRoomNo; // 메시지가 속한 채팅방 넘버

	@Field(name = "memberNo")
	private String memberNo;// 메시지 보낸 사람

	@Field(name = "memberName")
	private String memberName; // 메새지 보낸 사람 이름

	@Field(name = "message")
	private String message; // 메시지

	@Field(name = "regDateTime")
	private String regDateTime; // 메시지 발송 시간
	
	@Field(name="isRead")
	private boolean isRead;//상대방이 읽었나

}
