package com.syi.project.controller.syclass;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.syi.project.model.syclass.SyclassVO;
import com.syi.project.service.syclass.SyclassService;

import lombok.extern.log4j.Log4j2;

@Controller
@RequestMapping("/admin")
@Log4j2
public class SyclassController {
	
	@Autowired
	SyclassService syclassService;
	
	/* 반 등록 페이지 이동 */
	@GetMapping("/class/enroll")
	public void classEnrollGET() throws Exception{
		log.info("반 등록 페이지 이동");
	}
	
	/* 반 조회 페이지 이동 */
	@GetMapping("/class/getClassList")
	public void getClassListGET(Model model) throws Exception{
		log.info("반 목록 조회 페이지 이동");
		
		List<SyclassVO> classList = syclassService.getClassList();
		
		if (!classList.isEmpty()) model.addAttribute("classList", classList);
		else model.addAttribute("listCheck", "empty");
		
	}
	
	/* 반 상세 페이지 이동 */
	@GetMapping("/class/update")
	public void getClassDetailGET(Integer classNo, Model model) throws Exception{
		log.info("반 상세 페이지 이동");
		
		SyclassVO syclassVO = syclassService.getClassDetail(classNo);
		
		model.addAttribute("classDtail", syclassVO);

	}
	
	/* 반 별 홈 페이지 이동 */
	@GetMapping("/class/main")
	public void classMainGET(HttpServletRequest request, Integer classNo, Model model) throws Exception{
		log.info("반 별 홈 페이지 이동");
		
		// classNo 으로 syclass 객체 조회
		SyclassVO syclass = syclassService.getClassDetail(classNo);
		
		// 조회한 syclass 객체 세션에 저장
		HttpSession session = request.getSession();
		session.setAttribute("syclass", syclass);
	}
	
	/* 반 등록하기 */
	@PostMapping("/class/enroll")
	public String classEnrollPOST(SyclassVO syclass, RedirectAttributes rttr) throws Exception{
		log.info("반 등록하기 시작");
		String result;
		
		if (syclassService.classEnroll(syclass) > 0) result = "success";
		else result = "fail";
		
		rttr.addFlashAttribute("enroll_result", result);
		
		return "redirect:/admin/class/enroll";
	}
	
	/* 반 정보 수정하기 */
	@PostMapping("/class/update")
	@ResponseBody
	public String classUpdatePOST(SyclassVO syclass) throws Exception{
		log.info("반 수정하기 시작");
		
		try {
            int updatedRows = syclassService.updateClass(syclass);
            return updatedRows > 0 ? "success" : "fail";
            
        } catch (Exception e) {
            return "fail";
        }
	}
	
	/* 반 정보 삭제하기 */
	@PostMapping("/class/delete")
	@ResponseBody
	public String classDeletePOST(SyclassVO syclass) throws Exception{
		
		try {
			int deleteResult = syclassService.deleteClass(syclass);
			return deleteResult > 0 ? "success" : "fail";
			
		} catch (Exception e) {
			return "fail";
		}
	}
	

}
