package service.chat;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.syi.project.model.chat.ChatRoomVO;
import com.syi.project.model.member.MemberVO;
import com.syi.project.service.chat.ChatRoomService;
import com.syi.project.service.member.MemberService;

import service.member.MemberServiceTests;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
public class ChatServiceTests {

	private static final Logger log = LoggerFactory.getLogger(MemberServiceTests.class);

	@Autowired
	private ChatRoomService chatRoomService;

	/*
	 * @Test public void createChatRoom() { int adminNo = 4; int memberNo = 1;
	 * ChatRoomVO chatroom = new ChatRoomVO(memberNo, adminNo);
	 * chatRoomService.createChatRoom(chatroom); }
	 */

	/*
	 * @Test public void selectEnrollList() { int chatRoomMemberNo = 1;
	 * chatRoomService.selectEnrollList(chatRoomMemberNo); }
	 */
	@Test
	public void selectClassMemberList() {
		int adminNo = 4;
		chatRoomService.selectClassMemberList(adminNo);
	}

	/*
	 * @Test public void selectClassList() { int chatRoomMemberNo = 4;
	 * chatRoomService.selectClassList(chatRoomMemberNo); }
	 */

	/*
	 * @Test public void selectChatRoomList() { //학생일 떄
	 * 
	 * MemberVO member = new MemberVO(); member.setMemberNo(1);
	 * member.setMemberRole("ROLE_MEMBER");
	 * 
	 * 
	 * //관리자일 때 MemberVO member = new MemberVO(); member.setMemberNo(4);
	 * member.setMemberRole("ROLE_ADMIN");
	 * chatRoomService.selectChatRoomList(member); }
	 */
	/*
	 * @Test public void selectAdminNoByClassNo() { int classNo = 21;
	 * chatRoomService.selectAdminNoByClassNo(classNo); }
	 */

}
