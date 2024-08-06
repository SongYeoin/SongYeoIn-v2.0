package com.syi.project.controller.journal;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.syi.project.model.journal.JournalFileVO;
import com.syi.project.model.journal.JournalVO;
import com.syi.project.service.journal.JournalService;

@Controller
@RequestMapping("/journal")
public class JournalController {

    private static final Logger logger = LoggerFactory.getLogger(JournalController.class);

    @Autowired
    private JournalService journalService;

    // 파일 저장 경로
    private static final String UPLOAD_DIR = "uploads/";

    /* 일지 메인 페이지 접속 */
    @GetMapping("journalMain")
    public void journalMainGET() {
        logger.info("교육일지 메인 페이지 접속");
    }

    /* 일지 등록 페이지 접속 */
    @RequestMapping(value = "journalEnroll", method = RequestMethod.GET)
    public void journalEnrollGET() throws Exception {
        logger.info("교육일지 등록 페이지 접속");
    }

    /* 일지 등록 */
    @PostMapping("journalEnroll.do")
    public String journalEnrollPOST(JournalVO journal, @RequestParam("uploadFile") MultipartFile[] files, RedirectAttributes rttr) throws Exception {
        logger.info("journalEnroll : " + journal);

        // Process files and prepare JournalFileVO list
        List<JournalFileVO> journalFiles = new ArrayList<>();
        for (MultipartFile file : files) {
            if (!file.isEmpty()) {
                String originalFileName = file.getOriginalFilename();
                String savedFileName = UUID.randomUUID().toString() + "_" + originalFileName;
                String filePath = UPLOAD_DIR + savedFileName;
                File targetFile = new File(filePath);

                try {
                    file.transferTo(targetFile); // Save file to disk
                } catch (IOException e) {
                    logger.error("파일 저장 중 오류 발생", e);
                    throw new IOException("파일 저장 중 오류 발생", e);
                }

                // Prepare file info for database
                JournalFileVO journalFile = new JournalFileVO();
                journalFile.setFileOriginalName(originalFileName);
                journalFile.setFileSavedName(savedFileName);
                journalFile.setFilePath(filePath);
                journalFile.setFileSize((int) file.getSize());
                journalFile.setFileType(file.getContentType());
                journalFile.setFileRegDate(new Date());
                journalFile.setJournalNo(journal.getJournalNo());

                journalFiles.add(journalFile);
            }
        }
        
        // Save journal entry and associated files
        journalService.journalEnroll(journal, journalFiles);

        rttr.addFlashAttribute("enroll_result", journal.getJournalTitle()); // 등록 성공 메시지(일지 제목)
        return "redirect:/journal/journalList"; // 등록 처리 후 이동할 url
    }

    /* 첨부파일 업로드 (예제) */
    @PostMapping("/uploadAjaxAction")
    public void uploadAjaxActionPOST(MultipartFile uploadFile) {
        logger.info("uploadAjaxActionPOST..................");

        logger.info("파일 이름 : " + uploadFile.getOriginalFilename());
        logger.info("파일 타입 : " + uploadFile.getContentType());
        logger.info("파일 크기 : " + uploadFile.getSize());
    }

    /* 일지 목록 페이지 접속 */
    @RequestMapping(value = "journalList", method = RequestMethod.GET)
    public String journalListGET() throws Exception {
        logger.info("교육일지 목록 페이지 접속");
        return "journal/journalList"; // view 이름 반환 (jsp 경로)
    }

    /* 일지 상세 페이지 접속 */
    @RequestMapping(value = "journalDetail", method = RequestMethod.GET)
    public String journalDetailGET() throws Exception {
        logger.info("교육일지 상세 페이지 접속");
        return "journal/journalDetail"; // view 이름 반환 (jsp 경로)
    }

    /* 일지 수정 페이지 접속 */
    @RequestMapping(value = "journalModify", method = RequestMethod.GET)
    public String journalModifylGET() throws Exception {
        logger.info("교육일지 수정 페이지 접속");
        return "journal/journalModify"; // view 이름 반환 (jsp 경로)
    }

    /* 교육일정 관리 페이지 접속 */
    @PostMapping("eduScheduleManage")
    public String eduScheduleManagePOST() {
        logger.info("교육일정 관리 페이지 접속");
        return "journal/eduScheduleManage"; // view 이름 반환 (jsp 경로)
    }

    /* 교육일정 관리 페이지 접근을 위해 GET 요청 처리 */
    @GetMapping("eduScheduleManage")
    public String eduScheduleManageGET() {
        logger.info("교육일정 관리 페이지 GET 요청");
        return "redirect:/journal/eduScheduleManage"; // POST 요청을 처리하는 페이지로 리디렉션
    }
}
