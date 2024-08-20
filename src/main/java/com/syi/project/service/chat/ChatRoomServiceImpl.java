package com.syi.project.service.chat;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.UUID;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.syi.project.mapper.chat.ChatRoomMapper;
import com.syi.project.model.Criteria;
import com.syi.project.model.EnrollVO;
import com.syi.project.model.chat.ChatRoomVO;
import com.syi.project.model.member.MemberVO;
import com.syi.project.model.syclass.SyclassVO;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RequiredArgsConstructor
@Service
public class ChatRoomServiceImpl implements ChatRoomService {
	private final ChatRoomMapper chatRoomMapper;

	/*
	 * @Override public List<ChatRoomVO> findAllChatRoom() { List<ChatRoomVO>
	 * chatRooms = new ArrayList<>(chatRoomMap.values());
	 * Collections.reverse(chatRooms);
	 * 
	 * return chatRooms; }
	 */

	// 채팅방 번호로 채팅방 찾기
	@Override
	public ChatRoomVO SelectChatRoomByNo(String chatRoomNo) {
		return chatRoomMapper.SelectChatRoomByNo(chatRoomNo);
	}

	/*
	 * // 멤버 세션 아이디 추가하기
	 * 
	 * @Transactional public void updateChatRoomSessions(ChatRoomVO chatRoomVO) {
	 * chatRoomMapper.updateChatRoomSessions(chatRoomVO.getChatRoomNo(),
	 * chatRoomVO.getSessionIds()); }
	 */

	// 채팅방 개설
	@Override
	public void createChatRoom(ChatRoomVO chatroom) {
		chatRoomMapper.insertChatRoom(chatroom);
	}

	// 채팅방 목록 조회
	/*
	 * @Override public List<ChatRoomVO> selectChatRoomList(int
	 * chatRoomMemberNo,String memberRole) { return
	 * chatRoomMapper.selectChatRoomList(chatRoomMemberNo, memberRole); }
	 */

	@Override
	public List<EnrollVO> selectEnrollList(int chatRoomMemberNo) {
		return chatRoomMapper.selectEnrollList(chatRoomMemberNo);
	}

	@Override
	public int selectAdminNoByClassNo(int classNo) {
		return chatRoomMapper.selectAdminNoByClassNo(classNo);
	}

	@Override
	public List<ChatRoomVO> selectChatRoomList(Integer classNo,String searchName,MemberVO loginMember) {
		return chatRoomMapper.selectChatRoomList(classNo,searchName,loginMember);
	}


	@Override
	public void updateChatRoomSessions(ChatRoomVO chatRoom) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public List<EnrollVO> selectClassMemberList(int adminNo) {
		return chatRoomMapper.selectClassMemberList(adminNo);
	}

	@Override
	public int updateChatRoomStatus(int chatRoomNo) {
		return chatRoomMapper.updateChatRoomStatus(chatRoomNo);
	}

	@Override
	public int selectCountOneRoomList(ChatRoomVO chatroom) {
		return chatRoomMapper.selectCountOneRoomList(chatroom);
	}

	@Override
	public List<SyclassVO> selectAdminClassList(int adminNo) {
		return chatRoomMapper.selectAdminClassList(adminNo);
	}

	/*
	 * // 채팅방에 유저 리스트에 유저 추가
	 * 
	 * @Override public String addUser(String chatRoomNo, String userName) {
	 * ChatRoomVO chatRoom = chatRoomMap.get(chatRoomNo); String userUUID =
	 * UUID.randomUUID().toString();
	 * 
	 * chatRoom.getUserList().put(userUUID, userName); return userUUID; }
	 * 
	 * // 채팅방 userName 조회
	 * 
	 * @Override public String getUserName(String chatRoomNo, String userUUID) {
	 * ChatRoomVO chatRoom = chatRoomMap.get(chatRoomNo); return
	 * chatRoom.getUserList().get(userUUID); }
	 * 
	 * // 채팅방 전체 userList 조회
	 * 
	 * @Override public ArrayList<String> getUserList(String chatRoomNo) {
	 * ArrayList<String> list = new ArrayList<String>(); ChatRoomVO chatRoom =
	 * chatRoomMap.get(chatRoomNo);
	 * 
	 * chatRoom.getUserList().forEach((key, value) -> list.add(value)); return list;
	 * }
	 */

	/*
	 * @Override public void plusUserCnt(String chatRoomNo) { ChatRoomVO chatRoom =
	 * chatRoomMap.get(chatRoomNo); chatRoom.set }
	 */

	/*
	 * //랜덤 아이디로 채팅방 번호 설정하기 String randomChatRoomNo = UUID.randomUUID().toString();
	 * 
	 * //생성자를 사용해서 채팅방 번호와 채팅방 이름을 설정한 후 빌드 시킨다. ChatRoomVO chatRoom =
	 * ChatRoomVO.builder() .chatRoomNo(randomChatRoomNo)
	 * .chatRoomName(chatRoomName) .build(); //만들어진 ChatRoomVO 객체를 Map에다가 넣는다.
	 * chatRooms.put(randomChatRoomNo, chatRoom); return chatRoom;
	 */
	// 메시지 보내기
	/*
	 * @Override public <T> void sendMessage(WebSocketSession session, T message) {
	 * 
	 * try { //object 형태를 JSON 형태로 바꿔줘야 한다.->Jackson 라이브러리 사용함(Gson보다 기능이 좀 더 풍부함,
	 * Gson은 단순하고 빠른 작업) session.sendMessage(new
	 * TextMessage(objectMapper.writeValueAsString(message))); }catch (IOException
	 * e) { log.error(e.getMessage(),e); } }
	 */

	/*
	 * // 채팅방 목록 조회
	 * 
	 * @Override public List<ChatRoomVO> selectChatRoomList(int chatRoomMemberNo) {
	 * return chatRoomMapper.selectChatRoomList(chatRoomMemberNo); }
	 * 
	 * @Override public List<EnrollVO> selectEnrollListByMemberNo(int
	 * chatRoomMemberNo) { return
	 * chatRoomMapper.selectEnrollListByMemberNo(chatRoomMemberNo); }
	 * 
	 * @Override public SyclassVO selectClassByClassNo(int classNo) { return
	 * chatRoomMapper.selectClassByClassNo(classNo); }
	 * 
	 * @Override public int selectCountByMemberNoAndAdminNo(ChatRoomVO chatRoom) {
	 * return chatRoomMapper.selectCountByMemberNoAndAdminNo(chatRoom); }
	 * 
	 * // 채팅방 정보 넣기
	 * 
	 * @Override public int insertChatRoom(ChatRoomVO chatRoom) { return
	 * chatRoomMapper.insertChatRoom(chatRoom); }
	 */

}