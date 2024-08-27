package com.syi.project.service.chat;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
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
	public int createChatRoom(ChatRoomVO chatroom) {
		// 이미 만들어진 채팅방이 있는지 확인하기
		int result = chatRoomMapper.selectCountOneRoomList(chatroom);
		if (result > 0) {
			// 이미 채팅방 존재
			return 0;
		} else {
			// 없으니까 생성
			return chatRoomMapper.insertChatRoom(chatroom);
		}

	}

	@Override
	public List<EnrollVO> getEnrollList(int chatRoomMemberNo) {
		return chatRoomMapper.selectEnrollList(chatRoomMemberNo);
	}

	@Override
	public List<ChatRoomVO> getChatRoomList(Criteria cri, MemberVO loginMember) {
		return chatRoomMapper.selectChatRoomList(cri, loginMember);
	}

	@Override
	public List<EnrollVO> getClassMemberList(int adminNo) {
		return chatRoomMapper.selectClassMemberList(adminNo);
	}

	@Override
	public int updateChatRoomStatus(int chatRoomNo) {
		return chatRoomMapper.updateChatRoomStatus(chatRoomNo);
	}

	@Override
	public int getCountOneRoomList(ChatRoomVO chatroom) {
		return chatRoomMapper.selectCountOneRoomList(chatroom);
	}

	@Override
	public List<SyclassVO> getAdminClassList(int adminNo) {
		return chatRoomMapper.selectAdminClassList(adminNo);
	}

	@Override
	public ChatRoomVO getAdminNoAndMemberNoByChatRoomNo(int chatRoomNo) {
		System.out.println("서비스에서 찍힌 chatRoomNo : " + chatRoomNo);

		ChatRoomVO chatroom = chatRoomMapper.selectAdminNoAndMemberNoByChatRoomNo(chatRoomNo);
		if (chatroom == null) {
			System.out.println("서비스에서 찍힌 chatroom 정보 없음 null!!!!!!!");
		} else {
			System.out.println("서비스에서 찍힌 chatRoom 정보 : " + chatroom);
		}
		return chatroom;
	}

	@Override
	public Set<Integer> getCountOneChatRoomSet(List<EnrollVO> enrollList, int memberNo) {
		Set<Integer> countOneSet = new HashSet<Integer>();
		for (EnrollVO enroll : enrollList) {
			log.info(enroll.toString());
			ChatRoomVO chatroom = new ChatRoomVO();
			chatroom.setAdminNo(enroll.getSyclass().getAdminNo());
			chatroom.setMemberNo(memberNo);
			int count = getCountOneRoomList(chatroom);
			if (count > 0) {// 채팅방이 있다면
				countOneSet.add(enroll.getSyclass().getAdminNo());
			}
		}

		return countOneSet;
	}

	@Override
	public Set<Integer> getCountOneChatRoomSetAdmin(List<EnrollVO> classMemberList, int memberNo) {
		Set<Integer> countOneSet = new HashSet<Integer>();
		for (EnrollVO classVO : classMemberList) {
			log.info(classVO.toString());
			ChatRoomVO chatroom = new ChatRoomVO();
			chatroom.setAdminNo(memberNo);
			chatroom.setMemberNo(classVO.getMemberNo());
			int count = getCountOneRoomList(chatroom);
			if (count > 0) {// 채팅방이 있다면
				countOneSet.add(classVO.getMemberNo());
			}
		}
		return countOneSet;
	}

}