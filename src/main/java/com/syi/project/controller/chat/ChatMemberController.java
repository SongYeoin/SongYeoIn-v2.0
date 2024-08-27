package com.syi.project.controller.chat;

import java.util.ArrayList;
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
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.fasterxml.jackson.core.JsonProcessingException;
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

	private final ChatRoomService chatService;
	private final MessageService messageService;

	@GetMapping("/main")
	public void memberChatListGET(HttpServletRequest request, Model model) {
		HttpSession session = request.getSession();
		MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");

		// 채팅방 목록 조회
		List<ChatRoomVO> roomList = new ArrayList<ChatRoomVO>();
		try {
			roomList = chatService.getChatRoomList(null, loginMember);
		} catch (Exception e) {
			e.printStackTrace();
		}

		// 실제 보여지는 채팅방 목록 정보
		List<ChatRoomInfo> chatRoomInfos = new ArrayList<>();

		// 채팅방 별로 안 읽은 메시지의 개수가 0이상 인 것을 카운트 한다.
		Long unReadCount = 0L;
		for (ChatRoomVO chatRoom : roomList) {
			String chatRoomName = chatRoom.getMember().getMemberName();
			int chatRoomNo = chatRoom.getChatRoomNo();

			// 마지막 메시지 내용, 시간
			ChatMessageDTO chatMessage = new ChatMessageDTO();

			// 일대일 대화이기 때문에 receiverNo는 수강생이 보낼때는 관리자, 관리자가 보낼때는 학생으로 정해져있음
			int receiverNo = 0;
			try {
				chatMessage = messageService.getLatestMessagesByChatRoom(chatRoomNo);

				// 안 읽은 메시지 조회할 때는 나한테 온 메시지를 조회하는 거니까 recevierNo가 나여야함
				receiverNo = loginMember.getMemberNo();
			} catch (NullPointerException e) {
				e.getStackTrace();
			}

			// *안 읽은 메시지 개수 총 몇개인지*
			try {
				unReadCount = messageService.getUnReadMessageCountByChatRoomNoAndReceiverNo(chatRoomNo, receiverNo);
				log.info("읽지 않은 메시지의 개수 : " + unReadCount);
			} catch (Exception e) {
				e.printStackTrace();
			}

			String messageContent = null;
			String messageTime = null;
			if (chatMessage != null) {
				messageContent = chatMessage.getMessage();
				messageTime = messageService.getMessageTimeFormat(chatMessage.getRegDateTime());
			}

			// 채팅방 정보를 전달할 때의 receiverNo는 메시지를 보낼때 데이터를 저장할 receiverNo니까
			// 내가 보내는 메시지는 상대방 번호여야 한다. 그러므로 여기서 receiverNo를 상대방으로 바꿔준다.
			receiverNo = chatRoom.getAdminNo();// 학생이면 관리자
			chatRoomInfos.add(
					new ChatRoomInfo(chatRoomNo, chatRoomName, receiverNo, unReadCount, messageContent, messageTime));

		}

		// 세션에 헤더 표시를 위해 세션 덮어씌우는 작업
		messageService.getUnReadRoomCount(session);

		// 수강 목록 조회
		if ("ROLE_MEMBER".equals(loginMember.getMemberRole())) {
			List<EnrollVO> enrollList = chatService.getEnrollList(loginMember.getMemberNo());
			Set<Integer> countOneSet = chatService.getCountOneChatRoomSet(enrollList, loginMember.getMemberNo());
			// 채팅방 리스트
			model.addAttribute("chatRoomInfos", chatRoomInfos);
			model.addAttribute("countOneSet", countOneSet);
			model.addAttribute("enrollList", enrollList);

		}

	}

	@GetMapping("/chats/{chatRoomNo}")
	@ResponseBody
	@Transactional
	public List<ChatMessageDTO> memberChatAJAXGET(HttpServletRequest request, @PathVariable int chatRoomNo)
			throws JsonProcessingException {
		log.info("ajax 호출 메소드 : 하나의 채팅방을 누름");

		HttpSession session = request.getSession();
		MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
		int receiverNo = loginMember.getMemberNo();

		messageService.updateIsReadtoTrue(chatRoomNo, receiverNo);
		List<ChatMessageDTO> messageList = messageService.getMessagesByChatRoomNo(chatRoomNo);
		log.info(messageList.toString());

		messageList = messageService.getRegDateTimeFormatFromMessageList(messageList);

		messageService.getUnReadRoomCount(session);

		return messageList;
	}

	@PostMapping("/createroom")
	@Transactional
	public String memberCreateRoomPOST(HttpServletRequest request, ChatRoomVO chatroom, RedirectAttributes rttr) {
		HttpSession session = request.getSession();
		MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");

		int memberNo = loginMember.getMemberNo();
		chatroom.setMemberNo(memberNo);

		int result = chatService.createChatRoom(chatroom);

		if (result > 0) {
			// 만들었음
			rttr.addFlashAttribute("result", 1);
		} else {// 이미 채팅방이 존재-> 만들지 않음
			rttr.addFlashAttribute("result", 0);
		}
		return "redirect:/member/chatroom/main";
	}

	@GetMapping("/delete/{chatRoomNo}")
	@Transactional
	public String memberDeleteRoomGET(@PathVariable int chatRoomNo) {
		chatService.updateChatRoomStatus(chatRoomNo);
		return "redirect:/member/chatroom/main";
	}

}
