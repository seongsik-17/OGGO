package com.example.oggo.dto;

import lombok.Data;

@Data
public class ReviewListDTO {

	private int review_id;
	private String title;
	private String user_id;
	private String content;
	private String travel_title;
	private String is_public;
}
