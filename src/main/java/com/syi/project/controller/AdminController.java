package com.syi.project.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/admin")
public class AdminController {
	
	private static final Logger logger = LoggerFactory.getLogger(AdminController.class);
	
	//관리자 메인 페이지 이동
	@GetMapping("/main")
	public void adminMainGET() throws Exception{
		logger.info("관리자 페이지 이동");
	}

}
