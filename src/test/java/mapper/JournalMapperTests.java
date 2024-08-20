package mapper;


import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.syi.project.mapper.journal.EduScheduleMapper;
import com.syi.project.mapper.journal.JournalMapper;
import com.syi.project.model.Criteria;
import com.syi.project.model.journal.EduScheduleVO;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
public class JournalMapperTests {
	
	@Autowired
	private JournalMapper journalmapper; // 매퍼 인터페이스 의존성 주입
	
	@Autowired
	private EduScheduleMapper eduScheduleMapper;
	
	
	
	@Test
    public void testScheduleList() throws Exception {
        // 페이징을 위한 Criteria 객체 생성: 현재 페이지 1, 페이지당 10개 항목
        Criteria cri = new Criteria(1, 10);
//        int classNo = 1; // 테스트를 위한 클래스 번호 설정

        // eduScheduleMapper를 통해 일정 목록 조회
        List<EduScheduleVO> list = eduScheduleMapper.scheduleList(cri);

        // 조회된 일정들을 출력
        if (list.isEmpty()) {
            System.out.println("조회된 일정이 없습니다.");
        } else {
            list.forEach(schedule -> System.out.println("Schedule: " + schedule));
        }
    }
	
//	@Test
//	public void scheduleAllList() throws Exception{
//		
//		List<EduScheduleVO> list = eduScheduleMapper.scheduleAllList();
//		
//		for (int i = 0; i < list.size(); i++) {
//			System.out.println("list  --  >> " + i + "................." + list.get(i));
//		}
//	}

}
