package com.syi.project.model.chat;

import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.Field;

import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Document(collection = "messages")
public class ChatRoomInfo {

    private String chatRoomNo;
    private String chatRoomName;
    private Long UnReadCount;
    
    
    // 마지막 메시지와 시간
	@Field(name = "message")
    private String message;
    
	@Field(name = "regDateTime")
	private String regDateTime;
	

	
}
