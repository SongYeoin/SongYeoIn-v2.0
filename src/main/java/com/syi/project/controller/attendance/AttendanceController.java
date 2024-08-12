package com.syi.project.controller.attendance;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.syi.project.service.attendance.AttendanceService;

import lombok.extern.log4j.Log4j2;

@Controller
@RequestMapping("/member")
@Log4j2
public class AttendanceController {

	@Autowired
	AttendanceService attendanceService;
	
	/* 출석 등록 페이지로 이동 */
	@GetMapping("/attendance/enroll")
	public void attendanceEnrollGET() throws Exception{
		log.info("출석 등록 페이지 이동");
	}
}
