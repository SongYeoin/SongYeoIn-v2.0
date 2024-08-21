package com.syi.project.controller.chat;

import java.time.Instant;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.util.ArrayList;
import java.util.Date;
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
			Date messageTime = null;
			if (chatRoomInfo != null) {
				messageContent = chatRoomInfo.getMessage();
				messageTime = chatRoomInfo.getRegDateTime();

				// 원하는 로컬 시간대
				ZoneId localZoneId = ZoneId.of("Asia/Seoul");

				// 1. Date 객체를 Instant로 변환
				Instant instant = messageTime.toInstant();

				// 2. Instant를 ZonedDateTime으로 변환 (로컬 시간대 적용)
				ZonedDateTime zonedDateTime = instant.atZone(localZoneId);

				// 3. ZonedDateTime을 다시 Instant로 변환
				Instant newInstant = zonedDateTime.toInstant();

				// 4. Instant를 Date 객체로 변환
				messageTime = Date.from(newInstant);

			}
			// 채팅방 정보와 최근 메시지 정보를 객체로 생성
			chatRoomInfos.add(new ChatRoomInfo(chatRoomNo, chatRoomName, messageContent, messageTime));

		}

		Set<Integer> countOneSet = new HashSet<Integer>();

		// 담당 과목 조회
		if ("ROLE_ADMIN".equals(loginMember.getMemberRole())) {// 관리자일 때
			List<EnrollVO> classList = chatService.selectClassMemberList(loginMember.getMemberNo());
			for (EnrollVO classVO : classList) {
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

			// 마지막 메시지 내용, 시간, 총 몇개
			// Map<String, ChatMessageDTO> lastMessageList =
			// messageService.getLatestMessagesByChatRoom();

			// 채팅방 리스트
			// model.addAttribute("roomList", roomList);
			model.addAttribute("chatRoomInfos", chatRoomInfos);

			// 이미 채팅방이 만들어진 사람들의 set
			model.addAttribute("countOneSet", countOneSet);

			// 담당자가 맡은 반 리스트(모달창에)
			model.addAttribute("classList", classList);

			// 담당자가 맡은 반의 수강생 이름이 포함된 리스트
			model.addAttribute("adminClassList", adminClassList);

			// 마지막 메시지 리스트
			// model.addAttribute("lastMessageList",lastMessageList);
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

		/*
		 * Integer classNo = null; if (data.get("classNo") != null && !((String)
		 * data.get("classNo")).isEmpty()) { try { classNo = Integer.parseInt((String)
		 * data.get("classNo")); } catch (NumberFormatException e) {
		 * log.error("Invalid classNo format", e); } }
		 * 
		 * String searchName = null; if (data.get("memberName") != null && !((String)
		 * data.get("memberName")).isEmpty()) { try { searchName = (String)
		 * data.get("memberName"); } catch (Exception e) {
		 * log.error("Invalid memberName format", e); } }
		 */

		// Integer classNo = Integer.parseInt((String) data.get("classNo"));
		/*
		 * log.info((String) data.get("classNo")); log.info((String)
		 * data.get("memberName"));
		 */

		// classNo, memberName처리됨
		List<ChatRoomVO> filterChatRoomList = chatService.selectChatRoomList(cri, loginMember);
		log.info("필터 처리되서 넘어오는 채팅방 리스트 >>>>>>>>" + filterChatRoomList.toString());

		// Map<String, ChatMessageDTO> lastMessageMap = new HashMap<String,
		// ChatMessageDTO>();

		// 실제 보여지는 채팅방 목록 정보
		List<ChatRoomInfo> chatRoomInfos = new ArrayList<>();

		for (ChatRoomVO chatRoom : filterChatRoomList) {
			String chatRoomName = chatRoom.getChatRoomName();
			String chatRoomNo = chatRoom.getChatRoomNo() + "";

			// 마지막 메시지 내용, 시간, *안 읽은 메시지 개수 총 몇개인지*
			ChatRoomInfo chatRoomInfo = messageService.getLatestMessagesByChatRoom(chatRoomNo);

			String messageContent = null;
			Date messageTime = null;
			if (chatRoomInfo != null) {
				messageContent = chatRoomInfo.getMessage();
				messageTime = chatRoomInfo.getRegDateTime();

				// 원하는 로컬 시간대
				ZoneId localZoneId = ZoneId.of("Asia/Seoul");

				// 1. Date 객체를 Instant로 변환
				Instant instant = messageTime.toInstant();

				// 2. Instant를 ZonedDateTime으로 변환 (로컬 시간대 적용)
				ZonedDateTime zonedDateTime = instant.atZone(localZoneId);

				// 3. ZonedDateTime을 다시 Instant로 변환
				Instant newInstant = zonedDateTime.toInstant();

				// 4. Instant를 Date 객체로 변환
				messageTime = Date.from(newInstant);

			}
			// 채팅방 정보와 최근 메시지 정보를 객체로 생성
			chatRoomInfos.add(new ChatRoomInfo(chatRoomNo, chatRoomName, messageContent, messageTime));

		}

		log.info(chatRoomInfos.toString());

		return chatRoomInfos;

	}

	/*
	 * Map<String, Object> returnData = new HashMap<String, Object>();
	 * 
	 * returnData.put("filterChatRoomList", filterChatRoomList);
	 * returnData.put("lastMessageList", lastMessageList);
	 * 
	 * return returnData; }
	 */

	@PostMapping("/createroom")
	@Transactional
	public String adminCreateRoomPOST(HttpServletRequest request, int memberNo, Model model) {
		HttpSession session = request.getSession();
		MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");

		int adminNo = loginMember.getMemberNo();
		String memberName = loginMember.getMemberName();
		ChatRoomVO chatroom = new ChatRoomVO();
		chatroom.setMemberNo(memberNo);
		chatroom.setAdminNo(adminNo);
		chatroom.setChatRoomName(memberName);

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
