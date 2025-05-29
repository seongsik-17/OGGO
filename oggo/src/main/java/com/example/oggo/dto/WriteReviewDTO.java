package com.example.oggo.dto;

import lombok.Data;

@Data
public class WriteReviewDTO {
	private String user_id;
	private String product_id;
	private String product_title;
	private int rating;
	private String title;
	private String content;
	private String is_public;
}
