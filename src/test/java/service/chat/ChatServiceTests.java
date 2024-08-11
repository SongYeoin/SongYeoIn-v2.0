package service.chat;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.syi.project.model.chat.ChatRoomVO;
import com.syi.project.service.chat.ChatRoomService;
import com.syi.project.service.member.MemberService;

import service.member.MemberServiceTests;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
public class ChatServiceTests {

    private static final Logger log = LoggerFactory.getLogger(MemberServiceTests.class);

    @Autowired
    private ChatRoomService chatRoomService;
    
    @Test
    public void createChatRoom() {
    	String name = "~~이의 방";
    	chatRoomService.createChatRoom(name);
    }
    
}
