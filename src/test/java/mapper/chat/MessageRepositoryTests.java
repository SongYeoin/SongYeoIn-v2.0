package mapper.chat;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.syi.project.controller.chat.ChatAdminController;
import com.syi.project.service.chat.MessageService;

import lombok.extern.log4j.Log4j;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
public class MessageRepositoryTests {

	@Autowired
	private MessageService messageService;

	/*
	 * @Test public void createMessage() { ChatMessageDTO message = new
	 * ChatMessageDTO();
	 * 
	 * message.setChatRoomNo("17"); message.setMemberName("나얌");
	 * message.setMemberNo("1"); message.setMessage("하이염");
	 * message.setRegDateTime("2024년 08월 13일 16시 04분 20초(797)");
	 * 
	 * messageService.createMessage(message); }
	 */
	@Test
	public void createMessage() {
		log.info("마지막 메시지와 시간" + messageService.getLatestMessagesByChatRoom(43));
	}

	/*
	 * @Test public void getAllMessage() { List<MessageVO> list =
	 * messageService.getAllMessage(); for (int i = 0; i < list.size(); i++) {
	 * System.out.println(list.get(i)); } }
	 */

	/*
	 * @Test public void getMessageOne() { String id = "1";
	 * System.out.println(messageService.getMessageOne(id)); }
	 */

	/*
	 * @Test public void deleteMessageById() { String id = "1";
	 * messageService.deleteMessageById(id); }
	 */

}
