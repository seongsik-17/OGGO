package com.example.oggo.dto;

import lombok.Data;

@Data
public class MyReservationDTO {
	private String product_id;
	private String title;
	private String region;
	private String start_date;
	private String end_date;
	private String status;
	private int review_written;
}
