package service.journal;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.syi.project.model.member.MemberVO;
import com.syi.project.service.journal.EduScheduleService;
import com.syi.project.service.member.MemberService;

import service.member.MemberServiceTests;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
public class EduScheduleServiceTests {

	private static final Logger log = LoggerFactory.getLogger(MemberServiceTests.class);

	@Autowired
	private EduScheduleService eduScheduleService;

	

}
