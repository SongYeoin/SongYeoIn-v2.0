package com.syi.project.controller.notice;

import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

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

		// 전체 공지 조회
		List<NoticeVO> noticeList = noticeService.selectNoticeList(cri);
		model.addAttribute("noticeList", noticeList);

		// 반 공지 조회
		List<NoticeVO> noticeClassList = noticeService.selectNoticeClassList(cri, syclassNo);
		model.addAttribute("noticeClassList", noticeClassList);

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

	// 첨부파일 다운로드
    @GetMapping("/download")
    public void downloadFile(@RequestParam("fileNo") int fileNo, HttpServletRequest request, HttpServletResponse response) throws IOException {
        NoticeFileVO file = noticeService.selectNoticeFile(fileNo);
        File downloadFile = new File(file.getFilePath(), file.getFileSavedName());
        response.setContentType(file.getFileType());
        response.setContentLength((int) file.getFileSize());
        response.setHeader("Content-Disposition", "attachment;filename=\"" + file.getFileOriginalName() + "\"");
        org.apache.commons.io.FileUtils.copyFile(downloadFile, response.getOutputStream());
    }
    /*
    @GetMapping("/download")
    public void downloadFile(@RequestParam("fileNo") int fileNo, HttpServletRequest request, HttpServletResponse response) throws IOException {
        NoticeFileVO file = noticeService.selectNoticeFile(fileNo);
        File downloadFile = new File(file.getFilePath(), file.getFileSavedName());

        // 파일이 존재하지 않는 경우
        if (!downloadFile.exists()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "File not found");
            return;
        }

        response.setContentType(file.getFileType());
        response.setContentLength((int) file.getFileSize());

        // 파일 이름 인코딩 처리
        String encodedFileName;
        try {
            encodedFileName = URLEncoder.encode(file.getFileOriginalName(), StandardCharsets.UTF_8.toString())
                .replaceAll("\\+", "%20"); // 공백을 %20으로 변환
        } catch (UnsupportedEncodingException e) {
            throw new IOException("Encoding not supported", e);
        }

        response.setHeader("Content-Disposition", "attachment; filename=\"" + encodedFileName + "\"");

        // 파일 전송
        org.apache.commons.io.FileUtils.copyFile(downloadFile, response.getOutputStream());
    }
    */

    /*
    @GetMapping("/download")
    public void downloadFile(@RequestParam("fileNo") int fileNo, HttpServletRequest request, HttpServletResponse response) throws IOException {
        // 1. 파일 정보를 데이터베이스에서 조회
        NoticeFileVO file = noticeService.selectNoticeFile(fileNo);
        if (file == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "File not found");
            return;
        }

        // 2. 파일 객체 생성
        File downloadFile = new File(file.getFilePath(), file.getFileSavedName());
        if (!downloadFile.exists()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "File not found");
            return;
        }

        // 3. 응답 헤더 설정
        response.setContentType(file.getFileType());
        response.setContentLength((int) file.getFileSize());

        // 파일 이름 인코딩 처리
        String encodedFileName = URLEncoder.encode(file.getFileOriginalName(), StandardCharsets.UTF_8.toString())
            .replaceAll("\\+", "%20");

        response.setHeader("Content-Disposition", "attachment; filename=\"" + encodedFileName + "\"");

        // 4. 파일을 응답 스트림에 복사하여 다운로드
        FileUtils.copyFile(downloadFile, response.getOutputStream());
    }
    */

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

		// 공지사항을 데이터베이스에 저장하고, 생성된 공지사항의 ID를 반환합니다.
		int noticeNo = noticeService.insertNotice(noticeVO);
		logger.info("Inserted noticeNo: " + noticeNo);

		if (noticeNo <= 0) {
			rttr.addFlashAttribute("message", "공지사항 등록에 실패하였습니다.");
			return "redirect:/admin/class/notice/enroll";
		}

		// 업로드된 파일들을 처리합니다.
		for (MultipartFile file : files) {
			if (!file.isEmpty()) { // 파일이 비어있지 않은 경우만 처리합니다.
				// 파일의 원본 이름을 안전하게 처리합니다.
				String fileOriginalName = StringUtils.cleanPath(file.getOriginalFilename());

				// UUID를 생성하여 파일 이름에 추가
				String uniqueId = UUID.randomUUID().toString();
				String fileSavedName = uniqueId + "_" + fileOriginalName;

				// 파일을 저장할 경로를 설정합니다.
				String filePath = "/" + fileSavedName;

				// 파일을 저장할 위치를 지정하는 File 객체를 생성합니다.
				File destinationFile = new File(filePath);

				// MultipartFile 객체를 사용하여 파일을 지정한 경로에 저장합니다.
				file.transferTo(destinationFile);
				logger.info("File saved: " + filePath);

				// 파일 정보를 담기 위한 NoticeFileVO 객체를 생성합니다.
				NoticeFileVO noticeFileVO = new NoticeFileVO();
				noticeFileVO.setFileOriginalName(fileOriginalName); // 원본 파일 이름
				noticeFileVO.setFileSavedName(fileSavedName); // 저장된 파일 이름 (원본과 같음)
				noticeFileVO.setFileType(file.getContentType()); // 파일 타입 (예: image/jpeg)
				noticeFileVO.setFileSize(file.getSize()); // 파일 크기
				noticeFileVO.setFilePath(filePath); // 파일 저장 경로
				noticeFileVO.setFileNoticeNo(noticeNo); // 공지사항 ID

				// NoticeFileVO 객체를 사용하여 파일 정보를 데이터베이스에 저장합니다.
				int fileResult = noticeService.insertNoticeFile(noticeFileVO);
				if (fileResult <= 0) {
					rttr.addFlashAttribute("message", "파일 등록에 실패했습니다.");
					return "redirect:/admin/class/notice/enroll";
				}
			}
		}

		// 공지사항이 성공적으로 등록되었음을 사용자에게 알리는 메시지를 설정합니다.
		rttr.addFlashAttribute("message", "공지사항이 등록되었습니다.");

		// 공지사항 목록 페이지로 리다이렉트합니다.
		return "redirect:/admin/class/notice/list";
	}

	// 공지사항 수정

	// 공지사항 삭제
	@PostMapping("delete")
	@ResponseBody
	public String noticeDelete(int noticeNo) {
		logger.info("공지사항 삭제");

		int result = noticeService.deleteNotice(noticeNo);
		return result > 0 ? "success" : "fail";
	}
}
