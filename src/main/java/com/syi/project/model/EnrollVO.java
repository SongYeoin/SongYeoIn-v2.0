package com.syi.project.model;

import com.syi.project.model.member.MemberVO;
import com.syi.project.model.syclass.SyclassVO;

import lombok.Data;

@Data
public class EnrollVO {

	private int enrollNo;
	private int classNo;
	private int memberNo;
	private SyclassVO syclass;
	private MemberVO member;
}