package com.syi.project.controller.chat;

import java.time.Duration;
import java.time.Instant;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.syi.project.model.EnrollVO;
import com.syi.project.model.chat.ChatMessageDTO;
import com.syi.project.model.chat.ChatRoomInfo;
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
	public void memberChatListGET(HttpServletRequest request, Model model) {
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

				Instant now = Instant.now();// 현재 날짜시간
				Duration duration = Duration.between(instant, now);// 현재와 메시지 보낸 시간과의 차이

				// 메시지 보낸 시간이 현재보다 하루가 안 지났으면 오후 00:00 로 표시,하루가 지나면 '어제'라고 표시, 하루보다 더 지났으면 년-월-일
				// 로 표시
				if (duration.toDays() < 1) {// 하루가 안 지났다면
					formatter = DateTimeFormatter.ofPattern("a hh:mm").withZone(ZoneId.of("Asia/Seoul"));
					messageTime = formatter.format(instant);

				} else if (duration.toDays() >= 1 && duration.toDays() < 2) {// 하루와 이틀 사이
					messageTime = "어제";
				} else {
					formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd").withZone(ZoneId.of("Asia/Seoul"));
					messageTime = formatter.format(instant);
				}

			}
			// 채팅방 정보와 최근 메시지 정보를 객체로 생성
			chatRoomInfos.add(new ChatRoomInfo(chatRoomNo, chatRoomName, messageContent, messageTime));

		}

		Set<Integer> countOneSet = new HashSet<Integer>();

		// 수강 목록 조회
		if ("ROLE_MEMBER".equals(loginMember.getMemberRole())) {
			List<EnrollVO> enrollList = chatService.selectEnrollList(loginMember.getMemberNo());
			for (EnrollVO enroll : enrollList) {
				log.info(enroll.toString());
				ChatRoomVO chatroom = new ChatRoomVO();
				chatroom.setAdminNo(enroll.getSyclass().getAdminNo());
				chatroom.setMemberNo(loginMember.getMemberNo());
				int count = chatService.selectCountOneRoomList(chatroom);
				if (count > 0) {// 채팅방이 있다면
					countOneSet.add(enroll.getSyclass().getAdminNo());
				}
			}

			// 채팅방 리스트
			model.addAttribute("chatRoomInfos", chatRoomInfos);
			model.addAttribute("countOneSet", countOneSet);
			model.addAttribute("enrollList", enrollList);
		}
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
	public String memberCreateRoomPOST(HttpServletRequest request, int adminNO, String chatRoomName ,Model model) {
		HttpSession session = request.getSession();
		MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");

		int memberNo = loginMember.getMemberNo();
		ChatRoomVO chatroom = new ChatRoomVO();
		chatroom.setMemberNo(memberNo);
		chatroom.setAdminNo(adminNO);
		chatroom.setChatRoomName(chatRoomName);

		chatService.createChatRoom(chatroom);
		return "redirect:/member/chatroom/main";
	}

	@GetMapping("/delete/{chatRoomNo}")
	public String memberDeleteRoomGET(@PathVariable int chatRoomNo) {
		chatService.updateChatRoomStatus(chatRoomNo);
		return "redirect:/member/chatroom/main";
	}

}
