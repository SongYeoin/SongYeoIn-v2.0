package com.syi.project.controller.chat;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.syi.project.model.EnrollVO;
import com.syi.project.model.chat.ChatRoomVO;
import com.syi.project.model.member.MemberVO;
import com.syi.project.model.syclass.SyclassVO;
import com.syi.project.service.chat.ChatRoomService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RequiredArgsConstructor
@Controller
@RequestMapping("/member/chatroom")
public class ChatMemberController {

	private final ChatRoomService chatService;
	
    @GetMapping("/main")
    public void memberChatListGET(HttpServletRequest request,Model model){
    	HttpSession session = request.getSession();
    	MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
    	
    	//채팅방 목록 조회
    	List<ChatRoomVO> roomList = chatService.selectChatRoomList(loginMember);
    	model.addAttribute("roomList",roomList);
    	
    	// 수강 목록 조회/담당 과목 조회
    	if("ROLE_MEMBER".equals(loginMember.getMemberRole())) {
    		List<EnrollVO> enrollList = chatService.selectEnrollList(loginMember.getMemberNo());
    		for (EnrollVO enroll : enrollList) {
    			log.info(enroll.toString());
    		}
    		model.addAttribute("enrollList", enrollList);
    	}
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
    
//------------------------------------    
    @GetMapping("/chatroomone")
    public String chatRoom(Model model, @RequestParam String roomId){
        ChatRoomVO room = chatService.SelectChatRoomByNo(roomId);
        model.addAttribute("room",room);
        return "chat/chatroom";
    }

	/*
	 * @Autowired private SimpMessagingTemplate simpMessagingTemplate; // private
	 * SimpMessageSendingOperations template; private final ChatService chatService;
	 */
	/*
	 * @MessageMapping("/chat/send") //@SendTo public void sendMsg(@Payload
	 * Map<String,Object> data) { simpMessagingTemplate.convertAndSend("/topic/1",
	 * data); }
	 * 
	 * @MessageMapping("/enterUser") public void enterUser(@Payload MessageDTO
	 * message, SimpMessageHeaderAccessor headerAccessor) { //
	 * chatService.plusUserCnt(message.getChatRoomNo()); //String userUUID =
	 * chatService.addUser(message.getChatRoomNo(), message.getSender());
	 * 
	 * String userUUID = "1";
	 * 
	 * headerAccessor.getSessionAttributes().put("userUUID", userUUID);
	 * headerAccessor.getSessionAttributes().put("chatRoomNo",
	 * message.getChatRoomNo());
	 * 
	 * message.setMessage(message.getSender() + " 님 입장");
	 * template.convertAndSend("/sub/chat/room/" + message.getChatRoomNo(),
	 * message);
	 * 
	 * }
	 * 
	 * @MessageMapping("/sendMessage")//sendMessage public void sendMessage(@Payload
	 * MessageDTO message) { log.info("CHAT {}", message);
	 * message.setMessage(message.getMessage());
	 * template.convertAndSend("/sub/chat/room/" + message.getChatRoomNo(),
	 * message); }
	 */

	/*
	 * @SubscribeMapping("/topic/messages") public void
	 * handleSubscription(Message<?> message) { SimpMessageHeaderAccessor accessor =
	 * SimpMessageHeaderAccessor.wrap(message); String sessionId =
	 * accessor.getSessionId();
	 * logger.info("Client subscribed to /topic/messages. Session ID: " +
	 * sessionId); }
	 * 
	 * @MessageMapping("/chat")
	 * 
	 * @SendTo("/topic/messages") public MessageDTO send(MessageDTO message) throws
	 * Exception { System.out.println("서버에 메시지가 도착했습니다: " + message.getMessage());
	 * return message; }
	 */

	/*
	 * @MessageMapping("/chat") //@SendTo("/topic/messages") public void send()
	 * throws Exception {
	 * 
	 * MessageDTO message = new MessageDTO(); message.setMessage("Hello, World!");
	 * message.setSender("Alice"); message.setType(MessageDTO.MessageType.CHAT);
	 * logger.info("Message received: " + message.getMessage());
	 * 
	 * simpMessagingTemplate.convertAndSend("/topic/messages", message); }
	 */

	/*
	 * @MessageMapping("/chat/message") public void enter(MessageDTO message) {
	 * 
	 * if (message.getType().equals(MessageDTO.MessageType.ENTER)) {
	 * message.setMessage(message.getSender() + "님이 입장하였습니다."); }
	 * template.convertAndSend("/topic/chat/room/" + message.getChatRoomNo(),
	 * message);
	 * 
	 * }
	 */

	/*
	 * 
	 * 
	 * 
	 * 
	 * public MessageController(MessageService messageService) { this.messageService
	 * = messageService; }
	 * 
	 * @PostMapping public MessageDTO createMessage(@RequestBody MessageDTO message)
	 * { return messageService.createMessage(message); }
	 * 
	 * @GetMapping public List<MessageDTO> getAllMessage() { return
	 * messageService.getAllMessage(); }
	 * 
	 * @GetMapping("/{id}") public MessageDTO getMessageOne(@PathVariable String id)
	 * { return messageService.getMessageOne(id); }
	 * 
	 * @DeleteMapping("/{id}") public void deleteMessageById(@PathVariable String
	 * id) { messageService.deleteMessageById(id); }
	 */
}
