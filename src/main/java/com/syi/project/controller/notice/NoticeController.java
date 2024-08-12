package com.syi.project.controller.notice;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.syi.project.model.Criteria;
import com.syi.project.model.PageDTO;
import com.syi.project.model.notice.NoticeVO;
import com.syi.project.model.syclass.SyclassVO;
import com.syi.project.service.notice.NoticeService;

@Controller
@RequestMapping("admin/class/notice")
public class NoticeController {

	private static final Logger logger = LoggerFactory.getLogger(NoticeController.class);

	@Autowired
	private NoticeService noticeService;

	// 공지사항 조회
	@GetMapping("list")
	public String noticeList(Criteria cri, Model model, HttpSession session) throws Exception {
		logger.info("공지사항 조회 페이지");

		SyclassVO syclass = (SyclassVO) session.getAttribute("syclass");
		int syclassNo = syclass.getClassNo();
		
		// 전체 공지 조회
		List<NoticeVO> noticeList = noticeService.selectNoticeList(cri);
		model.addAttribute("noticeList", noticeList);

		// 반 공지 조회
		List<NoticeVO> noticeClassList = noticeService.selectNoticeClassList(cri, syclassNo);
		model.addAttribute("noticeClassList", noticeClassList);

		int total = noticeService.selectNoticeCount(cri, syclassNo);
		PageDTO pageMaker = new PageDTO(cri, total);
		model.addAttribute("pageMaker", pageMaker);
		return "admin/notice/list";
	}

}
