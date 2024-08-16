package com.syi.project.service.syclass;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.syi.project.mapper.syclass.SyclassMapper;
import com.syi.project.model.syclass.SyclassVO;

@Service
public class SyclassService {
	
	@Autowired
	SyclassMapper syclassMapper;

	/* 반 등록하기 */
	public int classEnroll(SyclassVO syclass) {
		return syclassMapper.classEnroll(syclass);
	}

	/* 반 목록 조회 */
	public List<SyclassVO> getClassList() {
		return syclassMapper.getClassList();
	}
	
	/* 반 상세 조회 */
	public SyclassVO getClassDetail(int classNo) {
		return syclassMapper.getClassDetail(classNo);
	}

	/* 반 수정하기 */
	public int updateClass(SyclassVO syclass) {
		return syclassMapper.updateClass(syclass);
	}

	/* 반 삭제하기 */
	public int deleteClass(SyclassVO syclass) {
		return syclassMapper.deleteClass(syclass);
	}

}
