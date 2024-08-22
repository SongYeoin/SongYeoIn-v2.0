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
    
	@Field(name = "message")
    private String message;
    
	@Field(name = "regDateTime")
	//@JsonFormat(pattern = "a HH:mm")
	private String regDateTime;

	
}
