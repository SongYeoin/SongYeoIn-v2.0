package mapper.chat;

import java.util.Date;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.syi.project.model.chat.ChatMessageDTO;
import com.syi.project.service.chat.MessageService;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
public class MessageRepositoryTests {
	
	@Autowired
	private MessageService messageService;
	

	
	
	
	/*
	 * @Test public void createMessage() { MessageDTO message = new MessageDTO();
	 * 
	 * message.setContent("메시지 전달내용을 적었습니다."); message.setTimeStamp(new Date());
	 * message.setType("text");
	 * 
	 * 
	 * messageService.createMessage(message);}
	 */
	 
	 
	
	
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
