package com.syi.project.service.chat;

import java.util.ArrayList;
import java.util.List;

import com.syi.project.model.Criteria;
import com.syi.project.model.EnrollVO;
import com.syi.project.model.chat.ChatRoomVO;
import com.syi.project.model.member.MemberVO;
import com.syi.project.model.syclass.SyclassVO;

public interface ChatRoomService {

	//----------------------------
	//List<ChatRoomVO> selectChatRoomList(int chatRoomMemberNo, String memberRole);
	void createChatRoom(ChatRoomVO chatroom);
	ChatRoomVO SelectChatRoomByNo(String chatRoomNo);
	void updateChatRoomSessions(ChatRoomVO chatRoom);
	
	int selectAdminNoByClassNo(int classNo);
	
	
	
	List<ChatRoomVO> selectChatRoomList(Integer classNo,Criteria cri,MemberVO loginMember);
	List<EnrollVO> selectClassMemberList(int adminNo);//관리자 조회
	List<EnrollVO> selectEnrollList(int chatRoomMemberNo);
	int updateChatRoomStatus(int chatRoomNo);
	int selectCountOneRoomList(ChatRoomVO chatroom);
	List<SyclassVO> selectAdminClassList(int adminNo);
	
	/*
	 * int insertChatRoom(ChatRoomVO chatRoom);
	 * 
	 * List<ChatRoomVO> selectChatRoomList(int chatRoomMemberNo);
	 * 
	 * List<EnrollVO> selectEnrollListByMemberNo(int chatRoomMemberNo);
	 * 
	 * SyclassVO selectClassByClassNo(int classNo);
	 * 
	 * int selectCountByMemberNoAndAdminNo(ChatRoomVO chatRoom);
	 */
	//-----------------------------
	/*
	 * <T> void sendMessage(WebSocketSession session, T message);
	 * 
	 * ChatRoomVO findRoomById(String chatRoomNo);
	 */
	//-------------------------------------
	/*
	 * List<ChatRoomVO> findAllChatRoom();
	 * 
	 * 
	 * ChatRoomVO createChatRoom(String chatRoomName);
	 * 
	 * String addUser(String chatRoomNo, String sender);
	 * 
	 * String getUserName(ChatRoomVO chatRoom);
	 * 
	 * ArrayList<String> getUserList(String chatRoomNo);
	 */

	
}