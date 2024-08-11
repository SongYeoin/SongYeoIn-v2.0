package com.syi.project.controller.chat;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.syi.project.model.chat.ChatRoomVO;
import com.syi.project.model.member.MemberVO;
import com.syi.project.service.chat.ChatRoomService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@RestController // @Controller와 @ResponseBody의 조합, 컨트롤러 클래스가 JSON이나 XML 형태로 응답을 반환하도록 한다,// RESTful 웹 서비스를 쉽게 구현
@Slf4j
@RequiredArgsConstructor
@RequestMapping("/chatroom")
public class ChatController {
	private static final Logger logger = LoggerFactory.getLogger(ChatController.class);
	private final ChatRoomService chatService;
	

    @PostMapping("/createRoom")
    public String createRoom(Model model, String name) {
        chatService.createChatRoom(name);
        return "chat/chatRoom";
    }
}