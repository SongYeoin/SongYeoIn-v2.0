package mapper.member;


import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.syi.project.mapper.member.MemberMapper;
import com.syi.project.model.member.MemberVO;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
public class MemberMapperTests {
	
	@Autowired
	private MemberMapper memberMapper;
	/*
	// 로그인
	@Test
	public void memberLogin() throws Exception {
		MemberVO member = new MemberVO();
		member.setMemberId("user01");
		member.setMemberPwd("user01@@");
		memberMapper.selectLoginMember(member);
				
		System.out.println("결과값 : " + memberMapper.selectLoginMember(member));
	}
	*/
	// 회원가입
	@Test
	public void memberInsert() throws Exception {
		MemberVO member = new MemberVO();
		member.setMemberId("test01");
		member.setMemberPwd("test01");
		member.setMemberName("test");
		member.setMemberBirthday("19990101");
		member.setMemberGender("F");
		member.setMemberPhone("010-1234-5678");
		member.setMemberEmail("test01@naver.com");
		member.setMemberAddress("01234");
		member.setMemberStreetAddress("test01");
		member.setMemberDetailAddress("test01");
		member.setMemberNickname("test01");
		memberMapper.insertMember(member);
	}
}
