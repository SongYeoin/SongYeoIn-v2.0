package com.syi.project.controller.chat;

import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.syi.project.model.Criteria;
import com.syi.project.model.EnrollVO;
import com.syi.project.model.chat.ChatMessageDTO;
import com.syi.project.model.chat.ChatRoomVO;
import com.syi.project.model.member.MemberVO;
import com.syi.project.model.syclass.SyclassVO;
import com.syi.project.service.chat.ChatRoomService;
import com.syi.project.service.chat.MessageService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RequiredArgsConstructor
@Controller
@RequestMapping("/admin/chatroom")
public class ChatAdminController {

	private final ChatRoomService chatService;
	private final MessageService messageService;
	
    @GetMapping("/main")
    public void adminChatListGET(HttpServletRequest request,Model model){
    	HttpSession session = request.getSession();
    	MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
    	
    	//채팅방 목록 조회
    	List<ChatRoomVO> roomList = chatService.selectChatRoomList(null,null,loginMember);
    	
    	
    	Set<Integer> countOneSet = new HashSet<Integer>();
    	
    	// 담당 과목 조회
    	if("ROLE_ADMIN".equals(loginMember.getMemberRole())){//관리자일 때
    		List<EnrollVO> classList = chatService.selectClassMemberList(loginMember.getMemberNo());
    		for (EnrollVO classVO : classList) {
    			log.info(classVO.toString());
    			ChatRoomVO chatroom = new ChatRoomVO();
    			chatroom.setAdminNo(loginMember.getMemberNo());
    			chatroom.setMemberNo(classVO.getMemberNo());
    			int count = chatService.selectCountOneRoomList(chatroom);
    			if(count>0) {//채팅방이 있다면
    				countOneSet.add(classVO.getMemberNo());
    			}
    		}
    		
    		List<SyclassVO> adminClassList = chatService.selectAdminClassList(loginMember.getMemberNo());
    		//마지막 메시지 내용, 시간, 총 몇개
        	Map<String, ChatMessageDTO> lastMessageList = messageService.getLatestMessagesByChatRoom();
    		
        	model.addAttribute("roomList",roomList);
    		model.addAttribute("countOneSet", countOneSet);
    		model.addAttribute("classList", classList);
    		model.addAttribute("adminClassList", adminClassList);
    		model.addAttribute("lastMessageList",lastMessageList);
    	}
    }
    
    @PostMapping("/search")
    @ResponseBody
    public Map<String, Object> adminSerachChatRoomPost(@RequestBody Map<String, Object> data, HttpServletRequest request) throws JsonProcessingException{
    	
    	log.info("ajax로 search 메소드 진입------------------------------");
    	log.info(data.toString());
    	
    	
    	//로그인한 멤버 번호와 멤버 역할, 필터링 조건 memberName, classNo를 가지고 가야함
    	HttpSession session = request.getSession();
    	MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
    	
    	Integer classNo = null;
	    if (data.get("classNo") != null && !((String) data.get("classNo")).isEmpty()) {
	        try {
	            classNo = Integer.parseInt((String) data.get("classNo"));
	        } catch (NumberFormatException e) {
	            log.error("Invalid classNo format", e);
	        }
	    }

    	    
    	String searchName = null;
    	if (data.get("memberName") != null && !((String) data.get("memberName")).isEmpty()) {
	        try {
	        	searchName =(String) data.get("memberName");
	        } catch (Exception e) {
	            log.error("Invalid memberName format", e);
	        }
	    }
    	    
    	    // Criteria 객체 생성 및 memberName 설정
			/*
			 * Criteria criteria = new Criteria(); if (data.get("memberName") != null) {
			 * //criteria.setMemberName((String) data.get("memberName")); }
			 */
    	    
    	    
    	    
    	    
    	//Integer classNo =  Integer.parseInt((String) data.get("classNo"));
    	log.info((String) data.get("classNo"));
    	log.info((String) data.get("memberName"));
    	
    	//Criteria criteria = new Criteria();
    	//criteria.setMemberName((String) data.get("memberName"));
    	
    	List<ChatRoomVO> filterChatRoomList = chatService.selectChatRoomList(classNo,searchName,loginMember);
    	log.info("필터 처리되서 넘어오는 채팅방 리스트 >>>>>>>>" + filterChatRoomList.toString());
    	
    	//마지막 메시지 내용, 시간, 총 몇개
    	Map<String, ChatMessageDTO> lastMessageList = messageService.getLatestMessagesByChatRoom();
    	
    	
    	Map<String, Object> returnData = new HashMap<String, Object>();
    	
    	returnData.put("filterChatRoomList", filterChatRoomList);
    	returnData.put("lastMessageList", lastMessageList);
    	
    	return returnData;
    }
    
    
    @PostMapping("/createroom")
    public String adminCreateRoomPOST(HttpServletRequest request,int memberNo,Model model) {
    	HttpSession session = request.getSession();
    	MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
    	
    	int adminNo = loginMember.getMemberNo();
    	ChatRoomVO chatroom = new ChatRoomVO();
    	chatroom.setMemberNo(memberNo);
    	chatroom.setAdminNo(adminNo);
    	
    	chatService.createChatRoom(chatroom);
    	return "redirect:/admin/chatroom/main";
    }

    
    @GetMapping("/delete/{chatRoomNo}")
    public String adminDeleteRoomGET(@PathVariable int chatRoomNo) {
    	chatService.updateChatRoomStatus(chatRoomNo);
    	return "redirect:/admin/chatroom/main";
    }
    
    
    
    //------------------------------------------------------
    
	/*
	 * @GetMapping("member/chatroom/chatroomone") public String chatRoom(Model
	 * model, @RequestParam String roomId){ ChatRoomVO room =
	 * chatService.SelectChatRoomByNo(roomId); model.addAttribute("room",room);
	 * return "chat/chatroom"; }
	 */

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
