package com.syi.project.model.chat;

import java.util.HashSet;
import java.util.Set;
import java.util.stream.Collectors;

import javax.websocket.Session;

import com.syi.project.model.member.MemberVO;
import com.syi.project.model.syclass.SyclassVO;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;

@Data
public class ChatRoomVO {
	// 채팅방 넘버
	private int chatRoomNo;
	private int adminNo;
	private int memberNo;

	private MemberVO member;

	// 채팅방에 속한 사람들
	 private Set<Session> chatRoomUserSessions = new HashSet<>();

	/* private SyclassVO syClass; */

	// DB에 세션 정보를 저장하기 위해 사용될 필드 (세션 ID 목록을 문자열로 저장)
	 private String sessionIds;


	public void addSession(Session session) {
		chatRoomUserSessions.add(session);
		sessionIds = chatRoomUserSessions.stream().map(Session::getId).collect(Collectors.joining(","));
	}

	private Set<String> parseSessionIdsToSet() {
		if (sessionIds == null || sessionIds.isEmpty()) {
			return new HashSet<>();
		}
		return new HashSet<>(Set.of(sessionIds.split(",")));
	}

	/*
	 * public ChatRoomVO(String chatRoomNo, String chatRoomName) { this.chatRoomNo =
	 * chatRoomNo; this.chatRoomName = chatRoomName; }
	 */
	/*
	 * public ChatRoomVO(int memberNo, int adminNo) { this.memberNo = memberNo;
	 * this.adminNo = adminNo; }
	 * 
	 * 
	 * public ChatRoomVO(int chatRoomNo, int adminNo, int memberNo, String
	 * sessionIds) { this.chatRoomNo = chatRoomNo; this.adminNo = adminNo;
	 * this.memberNo = memberNo; this.sessionIds = sessionIds; }
	 */
}