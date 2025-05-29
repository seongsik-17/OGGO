package com.example.oggo.dto;

import lombok.Data;

@Data
public class UserDTO {
	private String user_id;
	private String password;
	private String salt;
	private String name;
	private String email;
	private String phone;
	private String birth_date;
	private String gender;
	private String address;
	private String join_date;
	private String role;
	private String lastLogin;
	private String mbti;
	private String personalities;
	private String drinking_level;
}
