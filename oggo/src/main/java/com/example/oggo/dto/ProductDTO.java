package com.example.oggo.dto;

import lombok.Data;

@Data
public class ProductDTO {
	private String product_id;
	private String title;
	private String description;
	private String region;
	private int price;
	private String start_date;
	private String end_date;
	private int total_seats;
	private int min_seats;
	private int left_seats;
	private String image_url;
	private String created_at;
	private int views;
	private String tag;
	private String status;
}
