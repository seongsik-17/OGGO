package com.example.oggo.dto;

import lombok.Data;

@Data
public class UserDetailDTO {
	private String user_id;
	private String name;
	private String phone;
	private int reservation_id;
	private String reservation_date;
	private int num_people;
	
}
