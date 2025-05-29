package com.example.oggo.dto;

import lombok.Data;

@Data
public class ReservationDTO {
	private int reservation_id;
	private String user_id;
	private String product_id;
	private String reservation_date;
	private int num_people;
	private int total_price;
	private String status;
}
