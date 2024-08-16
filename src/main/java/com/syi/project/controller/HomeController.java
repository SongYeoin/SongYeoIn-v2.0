package com.syi.project.controller;

import java.text.DateFormat;
import java.util.Date;
import java.util.Locale;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class HomeController {

	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);

	// 통합 메인 페이지
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home(Locale locale, Model model) {
		logger.info("Welcome home! The client locale is {}.", locale);
		Date date = new Date();
		DateFormat dateFormat = DateFormat.getDateTimeInstance(DateFormat.LONG, DateFormat.LONG, locale);
		String formattedDate = dateFormat.format(date);
		model.addAttribute("serverTime", formattedDate);
		return "index";
	}

	// 수강생 메인 페이지 이동
	@GetMapping("/member/main")
	public void mainPageGET() {
		logger.info("메인 페이지 진입");
	}

	/*
	 * // 관리자 메인 페이지 이동
	 * 
	 * @GetMapping("/admin/main") public String adminMainGET() throws Exception {
	 * logger.info("관리자 페이지 이동"); return "admin/member/list"; }
	 */

}
