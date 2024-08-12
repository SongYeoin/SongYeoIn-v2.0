package mapper.chat;

import org.junit.Before;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.web.socket.client.WebSocketClient;
import org.springframework.web.socket.client.standard.StandardWebSocketClient;

import com.syi.project.model.chat.ChatMessageDTO;
import com.syi.project.service.chat.ChatRoomService;

@RunWith(SpringJUnit4ClassRunner.class)
public class ChatRoomMapperTests {

	@Autowired
	private ChatRoomService chatService;

	
	/*
	 * @Test public void selectEnrollListByMemberNo() { List<EnrollVO> enroll =
	 * chatService.selectEnrollListByMemberNo(1); System.out.println(enroll); }
	 */
	
	/*
	 * @Test public void selectCountByMemberNoAndAdminNo() { ChatRoomVO chatRoom =
	 * new ChatRoomVO(); chatRoom.setChatRoomMemberNo(1);
	 * chatRoom.setChatRoomAdminNo(7);
	 * System.out.println(chatService.selectCountByMemberNoAndAdminNo(chatRoom)); }
	 */
	
	/*
	 * @Test public void insertChatRoom() { ChatRoomVO chatRoomVO = new
	 * ChatRoomVO(); chatRoomVO.setChatRoomMemberNo(3);
	 * chatRoomVO.setChatRoomAdminNo(8); chatService.insertChatRoom(chatRoomVO); }
	 */
	
	
}