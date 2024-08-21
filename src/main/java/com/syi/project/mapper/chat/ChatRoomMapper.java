package com.syi.project.mapper.chat;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.syi.project.model.Criteria;
import com.syi.project.model.EnrollVO;
import com.syi.project.model.chat.ChatRoomVO;
import com.syi.project.model.member.MemberVO;
import com.syi.project.model.syclass.SyclassVO;


public interface ChatRoomMapper {
	
	int insertChatRoom(ChatRoomVO chatroom);
	int selectCountOneRoomList(ChatRoomVO chatroom);
	List<SyclassVO> selectAdminClassList(int adminNo);
	List<EnrollVO> selectClassMemberList(int adminNo);
	List<EnrollVO> selectEnrollList(int chatRoomMemberNo);
	int updateChatRoomStatus(int chatRoomNo);
	List<ChatRoomVO> selectChatRoomList(@Param("cri") Criteria cri,@Param("loginMember")MemberVO loginMember);
}