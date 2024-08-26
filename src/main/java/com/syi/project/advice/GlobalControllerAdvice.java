package com.syi.project.advice;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

import com.syi.project.model.chat.ChatRoomVO;
import com.syi.project.model.member.MemberVO;
import com.syi.project.service.chat.ChatRoomService;
import com.syi.project.service.chat.MessageService;

@ControllerAdvice
public class GlobalControllerAdvice {

	private ChatRoomService chatService;
	private MessageService messageService;

	public GlobalControllerAdvice(ChatRoomService chatService, MessageService messageService) {
		this.chatService = chatService;
		this.messageService = messageService;
	}
	
    @ModelAttribute("unReadRoomCount")
    public Integer populateUnreadRoomCount(HttpSession session) {
    	
    	Integer unreadRoomCount = 0;
    	MemberVO loginMember = new MemberVO();
    	try {
    		loginMember = (MemberVO) session.getAttribute("loginMember");
			List<ChatRoomVO> roomList = chatService.getChatRoomList(null, loginMember);
			for (ChatRoomVO chatRoom : roomList) {
				Long unReadCount = messageService.getUnReadMessageCountByChatRoomNoAndReceiverNo(
						chatRoom.getChatRoomNo(), loginMember.getMemberNo());
				if (unReadCount > 0)
					unreadRoomCount++;
			}
			session.setAttribute("unreadRoomCount", unreadRoomCount);
		} catch (Exception e) {
			e.printStackTrace();
		}

        return unreadRoomCount;
    }
}
