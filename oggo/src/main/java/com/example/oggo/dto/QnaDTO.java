package com.example.oggo.dto;

import java.sql.Date;

import lombok.Data;

@Data
public class QnaDTO {
	private int qna_id;
	private String user_id;
	private String title;
	private String content;
	private String answer;
	private String is_answered; // 'T' or 'F'
	private int views;
	private Date created_at;
	private Date answered_at;
}
