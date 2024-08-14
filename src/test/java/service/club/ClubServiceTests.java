package service.club;


import org.junit.Test;
import org.junit.runner.RunWith;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.syi.project.service.club.ClubService;

import mapper.ClubMapperTests;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
public class ClubServiceTests {

	private static final Logger log = LoggerFactory.getLogger(ClubServiceTests.class);
	
	@Autowired
	private ClubService service;
	
	//리스트 테스트
//	@Test
//	public void testGetList() {
//		service.getList().forEach(club -> log.info(""+club));
//	}
	
	//조회
	@Test
	public void testGetPage() {
		int clubNo = 3;
		log.info(""+service.getPage(clubNo));
	}
	
}
