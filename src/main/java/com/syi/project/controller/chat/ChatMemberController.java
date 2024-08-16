package com.syi.project.controller.chat;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.syi.project.model.EnrollVO;
import com.syi.project.model.chat.ChatMessageDTO;
import com.syi.project.model.chat.ChatRoomVO;
import com.syi.project.model.member.MemberVO;
import com.syi.project.service.chat.ChatRoomService;
import com.syi.project.service.chat.MessageService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RequiredArgsConstructor
@Controller
@RequestMapping("/member/chatroom")
public class ChatMemberController {

	private ObjectMapper objectMapper = new ObjectMapper();
	
	private final ChatRoomService chatService;
	
	private final MessageService messageService;
	
    @GetMapping("/main")
    public void memberChatListGET(HttpServletRequest request,Model model){
    	HttpSession session = request.getSession();
    	MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
    	
    	//채팅방 목록 조회
    	List<ChatRoomVO> roomList = chatService.selectChatRoomList(null,null,loginMember);
    	model.addAttribute("roomList",roomList);
    	
    	
    	Set<Integer> countOneSet = new HashSet<Integer>();
    	
    	// 수강 목록 조회
    	if("ROLE_MEMBER".equals(loginMember.getMemberRole())) {
    		List<EnrollVO> enrollList = chatService.selectEnrollList(loginMember.getMemberNo());
    		for (EnrollVO enroll : enrollList) {
    			log.info(enroll.toString());
    			ChatRoomVO chatroom = new ChatRoomVO();
    			chatroom.setAdminNo(enroll.getSyclass().getAdminNo());
    			chatroom.setMemberNo(loginMember.getMemberNo());
    			int count = chatService.selectCountOneRoomList(chatroom);
    			if(count>0) {//채팅방이 있다면
    				countOneSet.add(enroll.getSyclass().getAdminNo());
    			}
    		}
    		model.addAttribute("countOneSet", countOneSet);
    		model.addAttribute("enrollList", enrollList);
    	}
    }
    
    @GetMapping("/chats/{chatRoomNo}")
    @ResponseBody
    public List<ChatMessageDTO> memberChatAJAXGET(@PathVariable String chatRoomNo) throws JsonProcessingException {
    	log.info("ajax로 매핑되어 온 메소드에 진입함");
    	List<ChatMessageDTO> messageList = messageService.getMessagesByChatRoomNo(chatRoomNo);
    	log.info(messageList.toString());
    	return messageList;
    }
    
    
    @PostMapping("/createroom")
    public String memberCreateRoomPOST(HttpServletRequest request,int adminNO,Model model) {
    	HttpSession session = request.getSession();
    	MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
    	
    	int memberNo = loginMember.getMemberNo();
    	ChatRoomVO chatroom = new ChatRoomVO();
    	chatroom.setMemberNo(memberNo);
    	chatroom.setAdminNo(adminNO);
    	
        chatService.createChatRoom(chatroom);
        return "redirect:/member/chatroom/main";
    }
    
    @GetMapping("/delete/{chatRoomNo}")
    public String memberDeleteRoomGET(@PathVariable int chatRoomNo) {
    	chatService.updateChatRoomStatus(chatRoomNo);
    	return "redirect:/member/chatroom/main";
    }
    
}
