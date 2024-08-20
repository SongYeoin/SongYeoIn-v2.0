package com.syi.project.controller.journal;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.syi.project.model.Criteria;
import com.syi.project.model.EnrollVO;
import com.syi.project.model.PageDTO;
import com.syi.project.model.journal.EduScheduleVO;
import com.syi.project.model.member.MemberVO;
import com.syi.project.model.syclass.SyclassVO;
import com.syi.project.service.enroll.EnrollService;
import com.syi.project.service.journal.EduScheduleService;
import com.syi.project.service.journal.EduScheduleServiceImpl;
import com.syi.project.service.syclass.SyclassService;

@Controller
@RequestMapping("/journal")
public class EduScheduleController {
    
    private static final Logger logger = LoggerFactory.getLogger(EduScheduleServiceImpl.class);
    
    @Autowired
    private EduScheduleService eduScheduleService;
    
    @Autowired
    private EnrollService enrollService;
    
    @Autowired
    private SyclassService syclassService;
    
    // 사용자 수강중 반 가져오기?
    @GetMapping("/userClasses")
    @ResponseBody
    public List<SyclassVO> getUserClasses(HttpSession session) {
        MemberVO member = (MemberVO) session.getAttribute("loginMember");
        if (member == null) {
            logger.warn("세션에 사용자 정보가 없습니다.");
            return null;
        }
        logger.info("사용자의 수강 중인 반 목록 조회 요청: 회원 번호={}", member.getMemberNo());
        return eduScheduleService.getUserClasses(member.getMemberNo());
    }
    
    
    // 일정 리스트 조회
    @GetMapping("scheduleList")
    public String scheduleList(Criteria cri, Model model, HttpSession session, @RequestParam(value = "classNo", required = false) Integer classNo) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) {
            // 로그인되지 않은 경우 로그인 페이지로 리다이렉트
            return "redirect:/member/login";
        }
        int memberNo = loginMember.getMemberNo();
        
     // 클래스 번호가 제공되지 않았다면 세션에서 가져오거나 기본값 설정
        if (classNo == null) {
            classNo = (Integer) session.getAttribute("selectedClassNo");
            if (classNo == null) {
                classNo = enrollService.selectClassNo(memberNo);
                if (classNo == null) {
                    // 기본 클래스 번호를 설정하거나 에러 페이지로 리다이렉트
                    classNo = 0; // 또는 적절한 기본값
                    // return "error";
                }
            }
        }
        session.setAttribute("selectedClassNo", classNo);
        
        boolean isAdmin = "ROLE_ADMIN".equals(loginMember.getMemberRole());
        //Integer classNo;

        if (isAdmin) {
            SyclassVO syclass = (SyclassVO) session.getAttribute("syclass");
            if (syclass == null) {
                return "redirect:/admin/class/getClassList"; // 관리자가 반을 선택하지 않았다면 반 목록 페이지로 리다이렉트
            }
            classNo = syclass.getClassNo();
        } else {
            classNo = (Integer) session.getAttribute("selectedClassNo");
            if (classNo == null) {
                classNo = enrollService.selectClassNo(loginMember.getMemberNo());
                if (classNo == null || classNo == 0) {
                    return "redirect:/noClass"; // 사용자가 등록된 클래스가 없는 경우
                }
                session.setAttribute("selectedClassNo", classNo);
            }
        }

        List<EduScheduleVO> scheduleList = eduScheduleService.scheduleList(cri, classNo);
        model.addAttribute("scheduleList", scheduleList);
        
        List<EnrollVO> classList = enrollService.selectEnrollList(memberNo);
        model.addAttribute("classList", classList);
        
        int total = eduScheduleService.scheduleGetTotal(cri, classNo);
        model.addAttribute("pageMaker", new PageDTO(cri, total));
        
        List<EduScheduleVO> scheduleAllList = eduScheduleService.scheduleAllList(classNo);
        model.addAttribute("scheduleAllList", scheduleAllList);
        
        model.addAttribute("selectedClassNo", classNo);
        model.addAttribute("isAdmin", isAdmin);
        
        return isAdmin ? "journal/scheduleList" : "journal/scheduleList";
    }
    
    // 캘린더용? 이건뭐냐,
    @GetMapping("getScheduleForClass")
    @ResponseBody
    public List<Map<String, Object>> getScheduleForClass(@RequestParam("classNo") int classNo) {
        List<EduScheduleVO> schedules = eduScheduleService.scheduleAllList(classNo);
        List<Map<String, Object>> events = new ArrayList<>();
        for (EduScheduleVO schedule : schedules) {
            Map<String, Object> event = new HashMap<>();
            event.put("title", schedule.getScheduleTitle());
            event.put("start", schedule.getScheduleDate());
            event.put("url", "/journal/scheduleDetail?scheduleNo=" + schedule.getScheduleNo());
            events.add(event);
        }
        return events;
    }
    
    // 일정 상세
    @GetMapping("scheduleDetail")
    public String scheduleDetail(@RequestParam("scheduleNo") int scheduleNo, Model model, HttpSession session) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) {
            return "redirect:/login";
        }

        boolean isAdmin = "ROLE_ADMIN".equals(loginMember.getMemberRole());
        EduScheduleVO schedule = eduScheduleService.scheduleDetail(scheduleNo);
        model.addAttribute("scheduleDetail", schedule);
        model.addAttribute("isAdmin", isAdmin);

        return isAdmin ? "journal/scheduleDetail" : "journal/scheduleDetail";
    }

    // 일정 등록
    @GetMapping("admin/scheduleCreate")
    public String showCreateScheduleForm(Model model, HttpSession session) {
    	MemberVO member = (MemberVO) session.getAttribute("loginMember");
    	if (member == null || !"ROLE_ADMIN".equals(member.getMemberRole())) {
    		return "redirect:/login";
    	}
    	SyclassVO syclass = (SyclassVO) session.getAttribute("syclass");
    	if (syclass == null) {
    		return "redirect:/admin/class/getClassList";
    	}
    	model.addAttribute("syclass", syclass);
    	return "journal/scheduleCreate";
    }
    
    // 일정 등록 처리
    @PostMapping("scheduleCreate")
    public String scheduleCreate(EduScheduleVO schedule, HttpSession session, RedirectAttributes rttr) {
    	MemberVO member = (MemberVO) session.getAttribute("loginMember");
    	if (member == null || !"ROLE_ADMIN".equals(member.getMemberRole())) {
    		return "redirect:/login";
    	}
    	eduScheduleService.scheduleCreate(schedule);
    	rttr.addFlashAttribute("message", "일정이 성공적으로 등록되었습니다.");
    	return "redirect:/journal/scheduleList";
    }
    


    // 일정 수정
    @GetMapping("admin/scheduleUpdate")
    public String showUpdateScheduleForm(@RequestParam("scheduleNo") int scheduleNo, Model model, HttpSession session) {
        MemberVO member = (MemberVO) session.getAttribute("loginMember");
        if (member == null || !"ROLE_ADMIN".equals(member.getMemberRole())) {
            return "redirect:/login";
        }
        EduScheduleVO schedule = eduScheduleService.scheduleDetail(scheduleNo);
        model.addAttribute("schedule", schedule);
        return "journal/scheduleUpdate";
    }
    
    // 일정 수정 처리
    @PostMapping("scheduleUpdate")
    public String scheduleUpdate(EduScheduleVO schedule, HttpSession session, RedirectAttributes rttr) {
        MemberVO member = (MemberVO) session.getAttribute("loginMember");
        if (member == null || !"ROLE_ADMIN".equals(member.getMemberRole())) {
            return "redirect:/login";
        }
        
        
        eduScheduleService.scheduleUpdate(schedule);
        rttr.addFlashAttribute("message", "일정이 성공적으로 수정되었습니다.");
        return "redirect:/journal/scheduleList";
    }
    
    // 일정 삭제
    @PostMapping("admin/scheduleDelete")
    public String scheduleDelete(@RequestParam("scheduleNo") int scheduleNo, HttpSession session, RedirectAttributes rttr) {
        MemberVO member = (MemberVO) session.getAttribute("loginMember");
        if (member == null || !"ROLE_ADMIN".equals(member.getMemberRole())) {
            return "redirect:/login";
        }
        eduScheduleService.scheduleDelete(scheduleNo);
        rttr.addFlashAttribute("message", "일정이 성공적으로 삭제되었습니다.");
        return "redirect:/journal/scheduleList";
    }
}