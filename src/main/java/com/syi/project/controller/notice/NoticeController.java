package com.syi.project.controller.notice;

import java.io.File;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.UUID;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.util.UriUtils;

import com.syi.project.model.Criteria;
import com.syi.project.model.PageDTO;
import com.syi.project.model.member.MemberVO;
import com.syi.project.model.notice.NoticeFileVO;
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
		
		List<NoticeVO> noticeList = noticeService.selectNoticeList(cri, syclassNo);
		model.addAttribute("noticeList", noticeList);
		
		int total = noticeService.selectNoticeTotal(cri, syclassNo);
		PageDTO pageMaker = new PageDTO(cri, total);
		model.addAttribute("pageMaker", pageMaker);
		return "admin/notice/list";
	}

	// 공지사항 상세 조회
	@GetMapping("detail")
	public String noticeDetail(int noticeNo, Model model) {
		logger.info("상세 조회");
		NoticeVO notice = noticeService.selectNoticeDetail(noticeNo);
		model.addAttribute("notice", notice);
		List<NoticeFileVO> fileList = noticeService.selectNoticeFiles(noticeNo);
		model.addAttribute("fileList", fileList);
		return "admin/notice/detail";
	}

	@GetMapping("/download")
	public ResponseEntity<Resource> downloadAttachment(@RequestParam("fileNo") int fileNo) {
		NoticeFileVO file = noticeService.selectNoticeFile(fileNo);
		String filePath = file.getFilePath();
		Path path = Paths.get("C:\\upload\\temp" + filePath);
		Resource resource = new FileSystemResource(path);

		if (!resource.exists()) {
			return ResponseEntity.notFound().build();
		}

		// 원본 파일 이름과 인코딩된 파일 이름을 설정
		String originalFilename = file.getFileOriginalName();
		String encodedFilename = UriUtils.encodePathSegment(originalFilename, StandardCharsets.UTF_8);

		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.APPLICATION_OCTET_STREAM);
		headers.setContentDispositionFormData("attachment", encodedFilename);

		return new ResponseEntity<>(resource, headers, HttpStatus.OK);
	}

	// 공지사항 등록 페이지
	@GetMapping("enroll")
	public String noticeEnroll() {
		logger.info("공지사항 등록 페이지");
		return "admin/notice/enroll";
	}

	// 공지사항 등록
	@PostMapping("enroll")
	public String noticeEnroll(NoticeVO noticeVO, @RequestParam("files") List<MultipartFile> files,
			@RequestParam(value = "allNotice", required = false, defaultValue = "false") boolean isAllNotice,
			HttpSession session, RedirectAttributes rttr) throws IOException {
		logger.info("공지사항 등록");

		MemberVO member = (MemberVO) session.getAttribute("loginMember");
		int noticeMemberNo = member.getMemberNo();
		noticeVO.setNoticeMemberNo(noticeMemberNo);

		if (!isAllNotice) {
			SyclassVO syclass = (SyclassVO) session.getAttribute("syclass");
			int syclassNo = syclass.getClassNo();
			noticeVO.setNoticeClassNo(syclassNo);
		}

		int noticeNo = noticeService.insertNotice(noticeVO);
		logger.info("공지사항 번호 : " + noticeNo);

		if (noticeNo <= 0) {
			rttr.addFlashAttribute("message", "공지사항 등록에 실패하였습니다.");
			return "redirect:/admin/class/notice/enroll";
		}

		// 업로드된 파일 처리
		for (MultipartFile file : files) {
			if (!file.isEmpty()) { // 파일이 비어있지 않은 경우
				// 파일의 원본 이름을 안전하게 처리
				String fileOriginalName = StringUtils.cleanPath(file.getOriginalFilename());

				// UUID를 생성하여 파일 이름에 추가
				String uniqueId = UUID.randomUUID().toString();
				String fileSavedName = uniqueId + "_" + fileOriginalName;

				// 파일을 저장할 경로를 설정
				String filePath = "/" + fileSavedName;

				// 파일을 저장할 위치를 지정하는 File 객체를 생성
				File destinationFile = new File(filePath);

				// MultipartFile 객체를 사용하여 파일을 지정한 경로에 저장
				file.transferTo(destinationFile);
				logger.info("파일 저장 경로 : " + filePath);

				// 파일 정보 설정
				NoticeFileVO noticeFileVO = new NoticeFileVO();
				noticeFileVO.setFileOriginalName(fileOriginalName); // 원본 파일 이름
				noticeFileVO.setFileSavedName(fileSavedName); 		// 저장된 파일 이름
				noticeFileVO.setFileType(file.getContentType()); 	// 파일 타입
				noticeFileVO.setFileSize(file.getSize()); 			// 파일 크기
				noticeFileVO.setFilePath(filePath); 				// 파일 저장 경로
				noticeFileVO.setFileNoticeNo(noticeNo); 			// 공지사항 번호

				int fileResult = noticeService.insertNoticeFile(noticeFileVO);
				if (fileResult <= 0) {
					rttr.addFlashAttribute("message", "파일 등록에 실패했습니다.");
					return "redirect:/admin/class/notice/enroll";
				}
			}
		}

		rttr.addFlashAttribute("message", "공지사항이 등록되었습니다.");
		return "redirect:/admin/class/notice/list";
	}

	// 공지사항 수정 페이지
	@GetMapping("modify")
	public String noticeModify(int noticeNo, Model model) {
		logger.info("공지사항 수정 페이지");
		NoticeVO notice = noticeService.selectNoticeDetail(noticeNo);
		model.addAttribute("notice", notice);

		List<NoticeFileVO> fileList = noticeService.selectNoticeFiles(noticeNo);
		model.addAttribute("fileList", fileList);
		return "admin/notice/modify";
	}

	// 공지사항 수정
	@PostMapping("modify")
	public String noticeModify(NoticeVO notice, @RequestParam("files") List<MultipartFile> files,
			@RequestParam(value = "deleteFileNos", required = false) List<Integer> deleteFileNos, HttpSession session,
			RedirectAttributes rttr) throws IOException {

		logger.info("공지사항 수정");

		int result = noticeService.updateNotice(notice);
		if (result <= 0) {
			rttr.addFlashAttribute("message", "공지사항 수정에 실패하였습니다.");
			return "redirect:/admin/class/notice/modify?noticeNo=" + notice.getNoticeNo();
		}

		// 삭제할 파일이 있는 경우 처리
		if (deleteFileNos != null && !deleteFileNos.isEmpty()) {
			for (int fileNo : deleteFileNos) {
				NoticeFileVO file = noticeService.selectNoticeFile(fileNo);
				String filePath = file.getFilePath();
				File fileToDelete = new File("C:\\upload\\temp" + filePath);
				if (fileToDelete.exists()) {
					if (fileToDelete.delete()) {
						logger.info("Deleted file: " + filePath);
					} else {
						logger.error("Failed to delete file: " + filePath);
					}
				}
				noticeService.deleteNotcieFile(fileNo); 
			}
		}

		// 업로드된 파일 처리
		for (MultipartFile file : files) {
			if (!file.isEmpty()) {
				String fileOriginalName = StringUtils.cleanPath(file.getOriginalFilename());
				String uniqueId = UUID.randomUUID().toString();
				String fileSavedName = uniqueId + "_" + fileOriginalName;
				String filePath = "/" + fileSavedName;

				File destinationFile = new File("C:\\upload\\temp" + filePath);
				file.transferTo(destinationFile);
				logger.info("File saved: " + filePath);

				NoticeFileVO noticeFileVO = new NoticeFileVO();
				noticeFileVO.setFileOriginalName(fileOriginalName);
				noticeFileVO.setFileSavedName(fileSavedName);
				noticeFileVO.setFileType(file.getContentType());
				noticeFileVO.setFileSize(file.getSize());
				noticeFileVO.setFilePath(filePath);
				noticeFileVO.setFileNoticeNo(notice.getNoticeNo());

				int fileResult = noticeService.insertNoticeFile(noticeFileVO);
				if (fileResult <= 0) {
					rttr.addFlashAttribute("message", "파일 등록에 실패했습니다.");
					return "redirect:/admin/class/notice/modify?noticeNo=" + notice.getNoticeNo();
				}
			}
		}

		rttr.addFlashAttribute("message", "공지사항이 수정되었습니다.");
		return "redirect:/admin/class/notice/detail?noticeNo=" + notice.getNoticeNo();
	}

	// 공지사항 삭제
	@PostMapping("delete")
	@ResponseBody
	public String noticeDelete(int noticeNo) {
		logger.info("공지사항 삭제");

		List<NoticeFileVO> fileList = noticeService.selectNoticeFiles(noticeNo);

		// 파일 삭제
		for (NoticeFileVO file : fileList) {
			String filePath = file.getFilePath();
			File fileToDelete = new File("C:\\upload\\temp" + filePath);

			if (fileToDelete.exists()) {
				if (fileToDelete.delete()) {
					logger.info("Deleted file: " + filePath);
				} else {
					logger.error("Failed to delete file: " + filePath);
				}
			}
			int fileDeleteResult = noticeService.deleteNoticeFiles(noticeNo);
			if (fileDeleteResult <= 0) {
				return "fail";
			}
		}

		int result = noticeService.deleteNotice(noticeNo);
		return result > 0 ? "success" : "fail";
	}
}