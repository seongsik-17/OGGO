package com.example.oggo.dto;

import lombok.Data;

@Data
public class ReviewDTO {
	private int review_id;	// 리뷰id(seq)
	private String user_id;		// 유저id
	private String product_id;	// 상품아이디
	private int rating;			// 후기점수
	private String title;		// 제목
	private String content;		// 내용
	private String created_at;	// 작성일
	private String updated_at;	// 수정일
	private String is_public;	// 공개여부
}