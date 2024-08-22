package com.syi.project.controller.chat;

import java.time.Duration;
import java.time.Instant;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
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
import com.syi.project.model.chat.ChatRoomInfo;
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
	public void adminChatListGET(HttpServletRequest request, Model model) {
		HttpSession session = request.getSession();
		MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");

		// 채팅방 목록 조회
		List<ChatRoomVO> roomList = chatService.selectChatRoomList(null, loginMember);
		// 실제 보여지는 채팅방 목록 정보
		List<ChatRoomInfo> chatRoomInfos = new ArrayList<>();

		for (ChatRoomVO chatRoom : roomList) {
			String chatRoomName = chatRoom.getChatRoomName();
			String chatRoomNo = chatRoom.getChatRoomNo() + "";

			// 마지막 메시지 내용, 시간, *안 읽은 메시지 개수 총 몇개인지*
			ChatRoomInfo chatRoomInfo = messageService.getLatestMessagesByChatRoom(chatRoomNo);

			String messageContent = null;
			String messageTime = null;
			if (chatRoomInfo != null) {
				messageContent = chatRoomInfo.getMessage();
				messageTime = chatRoomInfo.getRegDateTime();

				// 시간 데이터 문자열(UTC)을 instant 형식으로 변환
				Instant instant = Instant.parse(messageTime);
				
				// 지역과 포맷형식을 오후 08:10 이와 같게 바꿈
				DateTimeFormatter formatter;
				
				
				Instant now = Instant.now();//현재 날짜시간
				Duration duration = Duration.between(instant, now);//현재와 메시지 보낸 시간과의 차이
				
				// 메시지 보낸 시간이 현재보다 하루가 안 지났으면 오후 00:00 로 표시,하루가 지나면 '어제'라고 표시, 하루보다 더 지났으면 년-월-일 로 표시
				if(duration.toDays() < 1) {//하루가 안 지났다면
					formatter = DateTimeFormatter.ofPattern("a hh:mm").withZone(ZoneId.of("Asia/Seoul"));
					messageTime = formatter.format(instant);
					
				}else if(duration.toDays() >= 1 && duration.toDays() < 2) {//하루와 이틀 사이
					messageTime="어제";
				}else {
					formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd").withZone(ZoneId.of("Asia/Seoul"));
					messageTime = formatter.format(instant);
				}

				
			}
			// 채팅방 정보와 최근 메시지 정보를 객체로 생성
			chatRoomInfos.add(new ChatRoomInfo(chatRoomNo, chatRoomName, messageContent, messageTime));

		}

		Set<Integer> countOneSet = new HashSet<Integer>();

		// 담당 과목 조회
		if ("ROLE_ADMIN".equals(loginMember.getMemberRole())) {// 관리자일 때
			List<EnrollVO> classMemberList = chatService.selectClassMemberList(loginMember.getMemberNo());
			for (EnrollVO classVO : classMemberList) {
				log.info(classVO.toString());
				ChatRoomVO chatroom = new ChatRoomVO();
				chatroom.setAdminNo(loginMember.getMemberNo());
				chatroom.setMemberNo(classVO.getMemberNo());
				int count = chatService.selectCountOneRoomList(chatroom);
				if (count > 0) {// 채팅방이 있다면
					countOneSet.add(classVO.getMemberNo());
				}
			}

			List<SyclassVO> adminClassList = chatService.selectAdminClassList(loginMember.getMemberNo());

			// 채팅방 리스트
			model.addAttribute("chatRoomInfos", chatRoomInfos);

			// 이미 채팅방이 만들어진 사람들의 set
			model.addAttribute("countOneSet", countOneSet);

			// 담당자가 맡은 반의 수강생 이름이 포함된 리스트(모달창)
			model.addAttribute("classList", classMemberList);
			
			// 담당자가 맡은 반 리스트(select box)
			model.addAttribute("adminClassList", adminClassList);

		}
	}

	@PostMapping("/search")
	@ResponseBody
	public List<ChatRoomInfo> adminSerachChatRoomPost(@RequestBody Criteria cri, HttpServletRequest request)
			throws JsonProcessingException {

		log.info("ajax로 search 메소드 진입------------------------------");

		// 로그인한 멤버 번호와 멤버 역할, 필터링 조건 memberName, classNo를 가지고 가야함
		HttpSession session = request.getSession();
		MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");

		log.info("classNo : " + cri.getClassNo());
		log.info("memberName : " + cri.getMemberName());



		// classNo, memberName처리됨
		List<ChatRoomVO> filterChatRoomList = chatService.selectChatRoomList(cri, loginMember);
		log.info("필터 처리되서 넘어오는 채팅방 리스트 >>>>>>>>" + filterChatRoomList.toString());

		// 실제 보여지는 채팅방 목록 정보
		List<ChatRoomInfo> chatRoomInfos = new ArrayList<>();

		for (ChatRoomVO chatRoom : filterChatRoomList) {
			String chatRoomName = chatRoom.getChatRoomName();
			String chatRoomNo = chatRoom.getChatRoomNo() + "";

			// 마지막 메시지 내용, 시간, *안 읽은 메시지 개수 총 몇개인지*
			ChatRoomInfo chatRoomInfo = messageService.getLatestMessagesByChatRoom(chatRoomNo);

			String messageContent = null;
			String messageTime = null;
			if (chatRoomInfo != null) {
				messageContent = chatRoomInfo.getMessage();
				messageTime = chatRoomInfo.getRegDateTime();

				// 시간 데이터 문자열(UTC)을 instant 형식으로 변환
				Instant instant = Instant.parse(messageTime);
				
				// 지역과 포맷형식을 오후 08:10 이와 같게 바꿈
				DateTimeFormatter formatter;
				
				
				Instant now = Instant.now();//현재 날짜시간
				Duration duration = Duration.between(instant, now);//현재와 메시지 보낸 시간과의 차이
				
				// 메시지 보낸 시간이 현재보다 하루가 안 지났으면 오후 00:00 로 표시,하루가 지나면 '어제'라고 표시, 하루보다 더 지났으면 년-월-일 로 표시
				if(duration.toDays() < 1) {//하루가 안 지났다면
					formatter = DateTimeFormatter.ofPattern("a hh:mm").withZone(ZoneId.of("Asia/Seoul"));
					messageTime = formatter.format(instant);
					
				}else if(duration.toDays() >= 1 && duration.toDays() < 2) {//하루와 이틀 사이
					messageTime="어제";
				}else {
					formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd").withZone(ZoneId.of("Asia/Seoul"));
					messageTime = formatter.format(instant);
				}

			}
			// 채팅방 정보와 최근 메시지 정보를 객체로 생성
			chatRoomInfos.add(new ChatRoomInfo(chatRoomNo, chatRoomName, messageContent, messageTime));

		}

		log.info(chatRoomInfos.toString());

		return chatRoomInfos;

	}
	
	@GetMapping("/chats/{chatRoomNo}")
    @ResponseBody
    public List<ChatMessageDTO> memberChatAJAXGET(@PathVariable String chatRoomNo) throws JsonProcessingException {
    	log.info("ajax로 매핑되어 온 메소드에 진입함");
    	messageService.updateIsReadtoTrue(chatRoomNo);
    	List<ChatMessageDTO> messageList = messageService.getMessagesByChatRoomNo(chatRoomNo);
    	log.info(messageList.toString());
    	
    	for(ChatMessageDTO message: messageList) {
    		String messageTime = message.getRegDateTime();
    		
    		// 시간 데이터 문자열(UTC)을 instant 형식으로 변환
			Instant instant = Instant.parse(messageTime);
			
			// 지역과 포맷형식을 오후 08:10 이와 같게 바꿈
			DateTimeFormatter formatter = DateTimeFormatter.ofPattern("a hh:mm(yyyy-MM-dd)").withZone(ZoneId.of("Asia/Seoul"));
			
			messageTime = formatter.format(instant);
			
			message.setRegDateTime(messageTime);
    	}
    	
    	return messageList;
	}
	

	@PostMapping("/createroom")
	@Transactional
	public String adminCreateRoomPOST(HttpServletRequest request, ChatRoomVO chatroom, Model model) {
		HttpSession session = request.getSession();
		MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
		
		log.info("채팅방 이름이 될 이름 : "+chatroom.getChatRoomName());

		int adminNo = loginMember.getMemberNo();
		//ChatRoomVO chatroom = new ChatRoomVO();
		//chatroom.setMemberNo(memberNo);
		chatroom.setAdminNo(adminNo);
		//chatroom.setChatRoomName(chatRoomName);

		chatService.createChatRoom(chatroom);
		return "redirect:/admin/chatroom/main";
	}

	@GetMapping("/delete/{chatRoomNo}")
	public String adminDeleteRoomGET(@PathVariable int chatRoomNo) {
		chatService.updateChatRoomStatus(chatRoomNo);
		return "redirect:/admin/chatroom/main";
	}

	// ------------------------------------------------------

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
