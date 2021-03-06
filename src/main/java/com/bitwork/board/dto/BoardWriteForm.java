package com.bitwork.board.dto;

import lombok.AllArgsConstructor;

import lombok.NoArgsConstructor;

import lombok.Setter;

import lombok.Getter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class BoardWriteForm {
	
	private String memberId;
	private Integer status;
	private String subject;
	private String content;
	private String fileName;
	private String oriName;
}
