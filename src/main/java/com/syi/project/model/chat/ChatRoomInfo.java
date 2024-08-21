package com.syi.project.model.chat;

import java.util.Date;

import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.Field;

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
	private Date regDateTime;

	
}
