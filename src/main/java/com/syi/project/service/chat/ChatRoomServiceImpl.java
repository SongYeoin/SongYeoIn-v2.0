package com.syi.project.service.chat;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.syi.project.mapper.chat.ChatRoomMapper;
import com.syi.project.model.chat.ChatRoomVO;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RequiredArgsConstructor
@Service
public class ChatRoomServiceImpl implements ChatRoomService {
	
	private final ChatRoomMapper chatRoomMapper;

	// 채팅방 번호로 채팅방 찾기
	@Override
	public ChatRoomVO SelectChatRoomByNo(String chatRoomNo) {
		return chatRoomMapper.SelectChatRoomByNo(chatRoomNo);
	}

	// 멤버 세션 아이디 추가하기
	@Transactional
	public void updateChatRoomSessions(ChatRoomVO chatRoomVO) {
		chatRoomMapper.updateChatRoomSessions(chatRoomVO.getChatRoomNo(), chatRoomVO.getSessionIds());
	}

	// 채팅방 개설
	@Override
	public void createChatRoom(String name) {
		chatRoomMapper.insertChatRoom(name);
	}

	// 채팅방 목록 조회
	@Override
	public List<ChatRoomVO> selectChatRoomList(int chatRoomMemberNo) {
		return chatRoomMapper.selectChatRoomList(chatRoomMemberNo);
	}


}