package mapper;

import java.sql.Date;
import java.text.ParseException;
import java.text.SimpleDateFormat;

import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.syi.project.mapper.club.ClubMapper;
import com.syi.project.model.Criteria;
import com.syi.project.model.club.ClubVO;
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
public class ClubMapperTests {
	private static final Logger log = LoggerFactory.getLogger(ClubMapperTests.class);
	
	@Autowired
	private ClubMapper mapper;
	
	//리스트테스트
//	@Test
//	public void testGetList() {
//		List list = mapper.getList();
//		
//		for(Object a:list) {
//			log.info(""+a);
//		}
//	}

	//등록
//	@Test
//	public void testEnroll() {
	 // 날짜 문자열
    //String dateString = "2024-08-09";

    // 문자열을 Date 객체로 변환
//    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
//    Date studyDate = null;
//    try {
//        studyDate = dateFormat.parse(dateString);
//    } catch (ParseException e) {
//        e.printStackTrace();
//    }
    
//		ClubVO club = new ClubVO();
//		club.setJoin("person");
//		club.setStudyDate(studyDate);
//		club.setContent("test");
//		mapper.enroll(club);
//	}
	
	//리스트 페이징
//	@Test
//	public void testGetListPaging() {
//		Criteria cri = new Criteria();
//		List list = mapper.getListPaging(cri);
//		list.forEach(club -> log.info(""+club));
//	}
//	
	
	//조회
//	@Test
//	public void testGetPage() {
//		int clubNo = 3;
//		
//		log.info(""+mapper.getPage(clubNo));
//	}
	
	//수정
//	@Test
//	public void testModify() {
//		
//		 // 날짜 문자열
//        String dateString = "2024-08-05";
//
//        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
//        Date sqlDate = null;
//        try {
//        	
//        	//문자열 java.util.Date로 변환
//        	java.util.Date utilDate = dateFormat.parse(dateString);
//        	
//        	//java.util.Date를 java.sql.Date로 변환
//        	sqlDate = new java.sql.Date(utilDate.getTime());
//        	
//        } catch (ParseException e) {
//            e.printStackTrace();
//        }
//        
//		ClubVO club = new ClubVO();
//		club.setClubNo(1);
//		club.setJoin("김영희, 홍길동");
//		club.setStudyDate(sqlDate);
//		club.setContent("test");
//		
//		int result = mapper.modify(club);
//		log.info("result : "+result);
//	}
	
	//게시판 목록(페이징 적용)
	@Test
	public void testGetListPaging() {
		Criteria cri = new Criteria();
		Integer classNo=3;
		
		List<ClubVO> list = mapper.getListPaging(cri, classNo);
		System.out.println(list);
		list.forEach(board -> log.info("" + board));
	}
}
