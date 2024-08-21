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

	// 채팅방 개설
	@Override
	public void createChatRoom(ChatRoomVO chatroom) {
		chatRoomMapper.insertChatRoom(chatroom);
	}

	@Override
	public List<EnrollVO> selectEnrollList(int chatRoomMemberNo) {
		return chatRoomMapper.selectEnrollList(chatRoomMemberNo);
	}

	@Override
	public List<ChatRoomVO> selectChatRoomList(Criteria cri,MemberVO loginMember) {
		return chatRoomMapper.selectChatRoomList(cri,loginMember);
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


}